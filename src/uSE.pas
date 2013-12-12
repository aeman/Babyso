unit uSE;

interface

uses
  Variants, Classes, Controls, Forms, SysUtils, Dialogs, IdHTTP, RegExpr,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, ActnList, OleCtrls, SHDocVw,
  MSHTML, CheckLst, Graphics, XMLIntf, XMLDoc, uFunc, msxmldom,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StrUtils, 
  uSEO, xmldom, GIFImg;

type
  TOperSet = (osNew, osFix, osDel);
  TDirecSet = (dsForward, dsBackward);

  TdlgSE = class(TForm)
    bbPrior: TBitBtn;
    bbNext: TBitBtn;
    bbOk: TBitBtn;
    pcSet: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    rgOper: TRadioGroup;
    ActionList1: TActionList;
    actNext: TAction;
    actPrior: TAction;
    Bevel2: TBevel;
    lblSEName: TLabel;
    edtSEName: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtSEURL: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    wbSite: TWebBrowser;
    btnGenExpr: TButton;
    edtSiteExpr: TEdit;
    edtSiteURL: TEdit;
    Label9: TLabel;
    actMatch: TAction;
    actFinish: TAction;
    Label15: TLabel;
    btnHelp: TBitBtn;
    TabSheet6: TTabSheet;
    cbbSEName: TComboBox;
    xmlSE: TXMLDocument;
    idSE: TIdHTTP;
    TabSheet7: TTabSheet;
    bvl1: TBevel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    edtSeoPages: TEdit;
    ud1: TUpDown;
    edtSeoCharset: TEdit;
    edtSeoTarget: TEdit;
    edtSeoName: TEdit;
    edtSeoSiteURL: TEdit;
    edtSeoSiteExpr: TEdit;
    edtSeoKeyURL: TEdit;
    edtSeoKeyExpr: TEdit;
    Label2: TLabel;
    lblResult: TLabel;
    Label1: TLabel;
    Label21: TLabel;
    edtKeyExpr: TEdit;
    mmoKeyCode: TMemo;
    btnMatch: TButton;
    lbLinks: TListBox;
    lbl10: TLabel;
    lbl11: TLabel;
    pnl1: TPanel;
    wbKey: TWebBrowser;
    clbSiteEm: TCheckListBox;
    edtKeyURL: TEdit;
    lbl12: TLabel;
    mmoSiteCode: TMemo;
    lbl13: TLabel;
    lbl14: TLabel;
    edtSiteExpr2: TEdit;
    lblMatched: TLabel;
    btnSiteMatch: TButton;
    imgPhrase: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtSeoLinkURL: TEdit;
    edtSeoLinkExpr: TEdit;
    procedure actPriorExecute(Sender: TObject);
    procedure actNextExecute(Sender: TObject);
    procedure actPriorUpdate(Sender: TObject);
    procedure actNextUpdate(Sender: TObject);
    procedure btnGenExprClick(Sender: TObject);
    procedure actMatchExecute(Sender: TObject);
    procedure actMatchUpdate(Sender: TObject);
    procedure actFinishUpdate(Sender: TObject);
    procedure Step1(Sender: TObject);
    procedure Step2(Sender: TObject);
    procedure Step3(Sender: TObject);
    procedure Step4(Sender: TObject);
    procedure Step5(Sender: TObject);
    procedure Step6(Sender: TObject);
    procedure Step7(Sender: TObject);
    procedure rgOperClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure wbKeyNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnHelpClick(Sender: TObject);
    procedure cbbSENameChange(Sender: TObject);
    procedure wbSiteNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure btnSiteMatchClick(Sender: TObject);
    procedure actFinishExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetMatchResult(aCount: integer);
    function SaveSeToXml(aSeo: TSEO): Boolean;
    function CheckValidStep(aStep: Integer): Boolean;
    function CheckStep1: Boolean;
    function CheckStep2: Boolean;
    function CheckStep3: Boolean;
    function CheckStep4: Boolean;
    function CheckStep5: Boolean;
    function CheckStep6: Boolean;
    function CheckStep7: Boolean;
  public
    { Public declarations }

  end;

var
  dlgSE: TdlgSE;

implementation

uses uHelp;

const LastStep = 7;

var
  seo: TSEO;
  iCurStep: integer = 1;
  CurDirect: TDirecSet = dsForward;
  CurOper: TOperSet = osNew;
  sOld, sNow: string;
  sl1, sl2, slDiff: TStringList;

{$R *.dfm}

procedure TdlgSE.actFinishExecute(Sender: TObject);
begin
  seo.FName := edtSeoName.Text;
  seo.FTarget := edtSeoTarget.Text;
  seo.FCharSet := edtSeoCharSet.Text;
  seo.FSiteUrl := edtSeoSiteURL.Text;
  seo.FSiteExpr := edtSeoSiteExpr.Text;
  seo.FLinkUrl := edtSeoLinkURL.Text;
  seo.FLinkExpr := edtSeoLinkExpr.Text;
  seo.FKeyUrl := edtSeoKeyURL.Text;
  seo.FKeyExpr := edtSeoKeyExpr.Text;
  seo.FKeyPages := StrToInt(edtSeoPages.Text);

  if not CheckStep7 then Exit;
  if SaveSeToXml(seo) then ModalResult := mrOk;
end;

procedure TdlgSE.actFinishUpdate(Sender: TObject);
begin
  actFinish.Enabled := (pcSet.ActivePageIndex = LastStep-1);
end;

procedure TdlgSE.actMatchExecute(Sender: TObject);
var
  s, sCode: string;
  rReg: TRegExpr;
  slLink: TStringList;
begin
  sCode := mmoKeyCode.Text;
  rReg := TRegExpr.Create;
  slLink := TStringList.Create;
  try
    rReg.Expression := edtKeyExpr.Text;
    if rReg.Exec(sCode) then
    repeat
      s := rReg.Match[0];
      if slLink.IndexOf(s) < 0 then  slLink.Add(s);
    until not rReg.ExecNext;

    lbLinks.Items.Assign(slLink);
    SetMatchResult(lbLinks.Items.Count);
  finally
    rReg.Free;
    slLink.Free;
  end;
end;

procedure TdlgSE.actMatchUpdate(Sender: TObject);
begin
  actMatch.Enabled := (Length(mmoSiteCode.Lines.Text) > 0)
end;

procedure TdlgSE.actNextExecute(Sender: TObject);
begin
  if not CheckValidStep(pcSet.ActivePageIndex + 1) then Exit;

  Inc(iCurStep);
  CurDirect := dsForward;
  pcSet.ActivePageIndex := iCurStep - 1;
end;

procedure TdlgSE.actNextUpdate(Sender: TObject);
begin
  actNext.Enabled := not (iCurStep = LastStep);
end;

procedure TdlgSE.actPriorExecute(Sender: TObject);
begin
  Dec(iCurStep);
  CurDirect := dsBackward;
  pcSet.ActivePageIndex := iCurStep - 1;
end;

procedure TdlgSE.actPriorUpdate(Sender: TObject);
begin
  actPrior.Enabled := not (iCurStep = 1);
end;

procedure TdlgSE.btnGenExprClick(Sender: TObject);
var
  sSelText: string;
  htmlDoc: IHtmlDocument2;
  htmlTxt: IHtmlTxtRange;
begin
  htmlDoc := wbSite.Document as IHtmlDocument2;
  htmlTxt := htmlDoc.Selection.CreateRange as IHtmlTxtRange;
  sSelText := htmlTxt.htmlText;

  if Length(sSelText) = 0 then begin
    MessageDlg('请用鼠标选择网页收录的短句！', mtInformation, [mbOk], 0);
  end else begin
    edtSiteExpr.Text := GenExprFromPhrase(sSelText);

    edtSeoCharset.Text := UpperCase(htmlDoc.charset);
    edtSeoSiteURL.Text := GenSiteExprFromUrl(edtSiteUrl.Text, 'www.sohu.com');
    edtSeoSiteExpr.Text := GenExprFromPhrase(sSelText);
  end;
end;

procedure TdlgSE.btnHelpClick(Sender: TObject);
var
  twHelp: TtwHelp;
begin
  twHelp := TtwHelp.Create(Self);
  twHelp.Show;
end;

procedure TdlgSE.btnSiteMatchClick(Sender: TObject);
var
  s: string;
  rReg: TRegExpr;
begin
  if mmoSiteCode.Text = '' then Exit;

  rReg := TRegExpr.Create;
  try
    rReg.Expression := edtSiteExpr2.Text;
    if rReg.Exec(mmoSiteCode.Text) then begin
      lblMatched.Caption := '匹配结果：' + rReg.Match[0];
      lblMatched.Font.Color := clGreen;
      edtSeoSiteExpr.Text := edtSiteExpr2.Text;
      s := mmoSiteCode.Text;
      mmoSiteCode.SetFocus;
      mmoSiteCode.SelStart := PosEx(rReg.Match[0], s, 1) - Length(rReg.Match[0])*2 - 10;
      mmoSiteCode.SelLength := Length(rReg.Match[0]);
    end else begin
      lblMatched.Caption := '匹配结果：未找到';
      lblMatched.Font.Color := clRed;
    end;
  finally
    rReg.Free;
  end;

end;

procedure TdlgSE.cbbSENameChange(Sender: TObject);
var
  i: Integer;
begin
  i := cbbSEName.ItemIndex;
  edtSEURL.Text := (TSeo(SeoList[i]).FTarget);
  edtSiteExpr.Text := (TSeo(SeoList[i]).FSiteExpr);
  edtSiteExpr2.Text := (TSeo(SeoList[i]).FSiteExpr);
  edtKeyExpr.Text := (TSeo(SeoList[i]).FKeyExpr);

  edtSeoName.Text := (TSeo(SeoList[i]).FName);
  edtSeoTarget.Text := (TSeo(SeoList[i]).FTarget);
  edtSeoCharset.Text := (TSeo(SeoList[i]).FCharSet);
  edtSeoSiteURL.Text := (TSeo(SeoList[i]).FSiteUrl);
  edtSeoSiteExpr.Text := (TSeo(SeoList[i]).FSiteExpr);
  edtSeoLinkURL.Text := (TSeo(SeoList[i]).FLinkUrl);
  edtSeoLinkExpr.Text := (TSeo(SeoList[i]).FLinkExpr);
  edtSeoKeyURL.Text := (TSeo(SeoList[i]).FKeyUrl);
  edtSeoKeyExpr.Text := (TSeo(SeoList[i]).FKeyExpr);
  edtSeoPages.Text := IntToStr(TSeo(SeoList[i]).FKeyPages);
end;

function TdlgSE.CheckStep1: Boolean;
begin
  if (CurOper = osFix) and (cbbSEName.Items.Count = 0) then begin
    MessageDlg('当前系统没有引擎可修改', mtConfirmation, [mbOK], 0);
    Result := False;
    Exit;
  end;
  Result := True;
end;

function TdlgSE.CheckStep2: Boolean;
var
  i: Integer;
begin
  if (CurOper = osNew) and (Length(edtSEName.Text) = 0) then begin
    MessageDlg('请输入搜索引擎名称！', mtConfirmation, [mbOK], 0);
    edtSEName.SetFocus;
    Result := False;
    Exit;
  end;

  if Length(edtSEURL.Text) = 0 then begin
    MessageDlg('请输入搜索引擎地址！', mtConfirmation, [mbOK], 0);
    edtSEURL.SetFocus;
    Result := False;
    Exit;
  end;

  if (CurOper = osNew) then
    for i := 0 to SeoList.Count - 1 do begin
      if edtSEURL.Text = TSeo(SeoList[i]).FTarget then begin
        MessageDlg('已经有这个搜索引擎了！', mtConfirmation, [mbOK], 0);
        edtSEURL.SetFocus;
        edtSEURL.SelectAll;
        Result := False;
        Exit;
      end;
    end;
    
  Result := True;
end;

function TdlgSE.CheckStep3: Boolean;
begin
  if Length(edtSiteExpr.Text) = 0 then begin
    MessageDlg('请点击“表达式”按钮，生成站点查询的表达式！', mtConfirmation, [mbOK], 0);
    edtSiteExpr.SetFocus;
    Result := False;
    Exit;
  end;

  Result := True;
end;

function TdlgSE.CheckStep4: Boolean;
begin
  if Length(edtSiteExpr2.Text) = 0 then begin
    MessageDlg('请输入正确的表达式，进行匹配！', mtConfirmation, [mbOK], 0);
    edtSiteExpr2.SetFocus;
    Result := False;
    Exit;
  end;

  if lblMatched.Font.Color <> clGreen then begin
    MessageDlg('匹配结果不正确，请修改表达式重新匹配！', mtConfirmation, [mbOK], 0);
    Result := False;
    Exit;
  end;

  Result := True;
end;

function TdlgSE.CheckStep5: Boolean;
var
  i, iCount: Integer;
begin
  iCount := 0;
  for i := 0 to clbSiteEm.Items.Count - 1 do begin
    if clbSiteEm.Checked[i] then Inc(iCount);
  end;

  if iCount = 0 then begin
    MessageDlg('没有找到变化因子，请重新查询！', mtConfirmation, [mbOK], 0);
    Result := False;
    Exit;
  end;

  Result := True;
end;

function TdlgSE.CheckStep6: Boolean;
begin
  if lblResult.Font.Color <> clGreen then begin
    if MessageDlg('匹配结果不正确，是否强行通过？', mtConfirmation,
      [mbYes, mbNo], 0, mbYes) = mrNo
    then begin
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;

function TdlgSE.CheckStep7: Boolean;
begin
  if Length(edtSeoSiteURL.Text) = 0 then begin
    MessageDlg('请输入网页收录URL！', mtConfirmation, [mbOK], 0);
    edtSeoSiteURL.SetFocus;
    Result := False;
    Exit;
  end;
  if Length(edtSeoSiteExpr.Text) = 0 then begin
    MessageDlg('请输入网页收录表达式！', mtConfirmation, [mbOK], 0);
    edtSeoSiteExpr.SetFocus;
    Result := False;
    Exit;
  end;
  if Length(edtSeoKeyURL.Text) = 0 then begin
    MessageDlg('请输入关键词查询URL！', mtConfirmation, [mbOK], 0);
    edtSeoKeyExpr.SetFocus;
    Result := False;
    Exit;
  end;
  if Length(edtSeoKeyExpr.Text) = 0 then begin
    MessageDlg('请输入关键词查询表达式！', mtConfirmation, [mbOK], 0);
    Result := False;
    Exit;
  end;

  Result := True;
end;

function TdlgSE.CheckValidStep(aStep: Integer): Boolean;
var
  b: Boolean;
begin
  b := True;
  case aStep of
    1: b := CheckStep1;
    2: b := CheckStep2;
    3: b := CheckStep3;
    4: b := CheckStep4;
    5: b := CheckStep5;
    6: b := CheckStep6;
  end;
  Result := b;
end;

procedure TdlgSE.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  seo.Free;
  sl1.Free;
  sl2.Free;
  slDiff.Free;
end;

procedure TdlgSE.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  seo := TSeo.Create;
  sl1 := TStringList.Create;
  sl2 := TStringList.Create;
  slDiff := TStringList.Create;

  for i := 0 to SeoList.Count - 1 do cbbSEName.Items.Add(TSeo(SeoList[i]).FName);
end;

procedure TdlgSE.FormShow(Sender: TObject);
begin
  pcSet.ActivePageIndex := 0;
  iCurStep := 1;
  CurDirect := dsForward;
  CurOper := osNew;
end;

procedure TdlgSE.rgOperClick(Sender: TObject);
begin
  CurOper := TOperSet(rgOper.ItemIndex);
end;

function TdlgSE.SaveSeToXml(aSeo: TSeo): Boolean;
var
  i, iPos: Integer;
  xmlRoot, xmlNode, xmlSite, xmlKey: IXMLNode;
begin
  iPos := -1;

  xmlSE.LoadFromFile(CurrentPath + 'se.xml');
  xmlSE.Active := True;
  xmlRoot := xmlSE.DocumentElement;

  for i := 0 to xmlRoot.ChildNodes.Count - 1 do begin
    xmlSite := xmlRoot.ChildNodes.Nodes[i];
    if xmlSite.Attributes['Target'] = aSeo.FTarget then begin
      iPos := i;
      xmlRoot.ChildNodes.Delete(i);
      break;
    end;
  end;

  xmlNode := xmlRoot.AddChild('Serach', iPos);
  xmlNode.Attributes['Target'] := aSeo.FTarget;

  xmlSite := xmlNode.AddChild('name');
  xmlSite.NodeValue := aSeo.FName;
  xmlSite := xmlNode.AddChild('charset');
  xmlSite.NodeValue := aSeo.FCharSet;

  xmlSite := xmlNode.AddChild('site');
  xmlKey := xmlSite.AddChild('url');
  xmlKey.NodeValue := aSeo.FSiteUrl;
  xmlKey := xmlSite.AddChild('regexpr');
  xmlKey.NodeValue := aSeo.FSiteExpr;

  xmlSite := xmlNode.AddChild('link');
  xmlKey := xmlSite.AddChild('url');
  xmlKey.NodeValue := aSeo.FLinkUrl;
  xmlKey := xmlSite.AddChild('regexpr');
  xmlKey.NodeValue := aSeo.FLinkExpr;

  xmlSite := xmlNode.AddChild('keyword');
  xmlKey := xmlSite.AddChild('url');
  xmlKey.NodeValue := aSeo.FKeyUrl;
  xmlKey := xmlSite.AddChild('regexpr');
  xmlKey.NodeValue := aSeo.FKeyExpr;
  xmlKey := xmlSite.AddChild('page');
  xmlKey.NodeValue := aSeo.FKeyPages;

  xmlSE.SaveToFile(CurrentPath + 'se.xml');
  xmlSE.Active := False;

  Result := True;
end;

procedure TdlgSE.SetMatchResult(aCount: integer);
begin
  if aCount = 10 then begin
    lblResult.Caption := '匹配结果：' + IntToStr(aCount) + '个';
    lblResult.Font.Color := clGreen;
    edtSeoKeyExpr.Text := edtKeyExpr.Text;
  end else if aCount <> 10 then begin
    lblResult.Caption := '匹配结果：' + IntToStr(aCount) + '个';
    lblResult.Font.Color := clRed;
  end;
end;

procedure TdlgSE.Step1(Sender: TObject);
begin
//
end;

procedure TdlgSE.Step2(Sender: TObject);
begin
  if (CurOper = osFix) then begin
    lblSEName.Caption := '选择引擎名称';
    cbbSEName.Visible := True;
    cbbSEName.Top := edtSEName.Top;
    cbbSEName.Left := edtSEName.Left;
  end else begin
    lblSEName.Caption := '输入引擎名称';
    cbbSEName.Visible := False;
  end;

  if (CurOper = osFix) and (CurDirect = dsForward) then begin
    cbbSEName.ItemIndex := 0;
    cbbSEName.OnChange(Sender);
  end else if (CurOper = osNew) and (CurDirect = dsForward) then
    edtSEURL.Text := '';
end;

procedure TdlgSE.Step3(Sender: TObject);
var
  URL: OleVariant;
begin
  if Length(edtSEURL.Text) = 0 then Exit;

  if (CurDirect = dsForward) and (CurOper = osNew)  then begin
    edtSiteExpr.Text := '';
    edtSiteExpr2.Text := '';
    URL := edtSEURL.Text;
    wbSite.Navigate2(URL);
    edtSeoName.Text := edtSEName.Text;
    edtSeoTarget.Text := edtSEURL.Text;
  end else if (CurDirect = dsForward) and (CurOper = osFix) then begin
    URL := StringReplace(edtSeoSiteURL.Text, '{$SITE}', 'www.sohu.com', [rfReplaceAll]);
    wbSite.Navigate2(URL);
  end;
end;

procedure TdlgSE.Step4(Sender: TObject);
var
  s: string;
  ProxyServer: string;
  ProxyPort: Integer;
begin
  if (CurDirect = dsBackward) or (Length(edtSEURL.Text) = 0) then Exit;

  mmoSiteCode.Lines.Clear;
  edtSiteExpr2.Text := edtSiteExpr.Text;
  lblMatched.Caption := '匹配结果：未匹配';
  lblMatched.Font.Color := clBlack;

  GetProxyServer('http', ProxyServer, ProxyPort);

  idSE.ConnectTimeout := 30000;
  idSE.ReadTimeout := 60000;
  if gProxy.Active then begin
    idSE.ProxyParams.ProxyServer := ProxyServer;
    idSE.ProxyParams.ProxyPort := ProxyPort;
  end;

  s := idSE.Get(edtSiteURL.Text);
  if edtSeoCharset.Text = 'UTF-8' then mmoSiteCode.Text := Utf8ToAnsi(s)
  else mmoSiteCode.Text := s;
end;

procedure TdlgSE.Step5(Sender: TObject);
var
  s, sUrl: string;
  URL: OleVariant;
begin
  if Length(edtSEURL.Text) = 0 then Exit;

  if (CurDirect = dsForward) then clbSiteEm.Items.Clear;

  if (CurDirect = dsForward) and (CurOper = osNew) then begin
    URL := edtSEURL.Text;
    wbKey.Navigate2(URL);
  end else if (CurDirect = dsForward) and (CurOper = osFix) then begin
    s := FormatKeyword('足球', edtSeoCharset.Text);
    sUrl := StringReplace(edtSeoKeyURL.Text, '{$KEYWORD}', s, [rfReplaceAll]);
    sUrl := StringReplace(sUrl, '{$COUNT}', '0', [rfReplaceAll]);
    sUrl := StringReplace(sUrl, '{$INDEX}', '1', [rfReplaceAll]);
    URL := sUrl;
    wbKey.Navigate2(URL);
  end;
end;

procedure TdlgSE.Step6(Sender: TObject);
var
  i: Integer;
  s, sUrl, sCode: string;
  sl: TStringList;
  ProxyServer: string;
  ProxyPort: Integer;
begin
  if (CurDirect = dsBackward) or (Length(edtSEURL.Text) = 0) then Exit;

  lblResult.Caption := '匹配结果：0个';
  lblResult.Font.Color := clBlack;

  s := FormatKeyword('足球', edtSeoCharset.Text);

  sl := TStringList.Create;
  try
    for i := 0 to clbSiteEm.Count - 1 do
      if clbSiteEm.Checked[i] then sl.Add(clbSiteEm.Items.Strings[i]);

    sUrl := GenKeyExprFromUrl(edtKeyUrl.Text, s, sl);
    edtSeoKeyURL.Text := sUrl;
  finally
    sl.Free;
  end;

  mmoKeyCode.Lines.Clear;

  GetProxyServer('http', ProxyServer, ProxyPort);

  idSE.ConnectTimeout := 30000;
  idSE.ReadTimeout := 60000;
  if gProxy.Active then begin
    idSE.ProxyParams.ProxyServer := ProxyServer;
    idSE.ProxyParams.ProxyPort := ProxyPort;
  end;

  sUrl := StringReplace(sUrl, '{$KEYWORD}', s, [rfReplaceAll]);
  sUrl := StringReplace(sUrl, '{$COUNT}', '0', [rfReplaceAll]);
  sUrl := StringReplace(sUrl, '{$INDEX}', '1', [rfReplaceAll]);

  sCode := idSE.Get(sUrl);
  if edtSeoCharset.Text = 'UTF-8' then sCode := Utf8ToAnsi(sCode);
  mmoKeyCode.Lines.Add(sCode);

//  idHttp取的源码和webBrowser不一样
//  if Assigned(wbKey.Document) then begin
//    meCode.Lines.Add(IHtmlDocument2(wbKey.Document).Body.innerHTML);
//  end;
end;

procedure TdlgSE.Step7(Sender: TObject);
begin
  edtSeoKeyExpr.Text := edtKeyExpr.Text;

  //自动复制site命令配置到link
  edtSeoLinkURL.Text := StringReplace(edtSeoSiteURL.Text, 'site', 'link', [rfReplaceAll]);
  edtSeoLinkExpr.Text := edtSeoSiteExpr.Text;
end;

procedure TdlgSE.wbKeyNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  i: Integer;
  htmlDoc: IHtmlDocument2;
begin
  htmlDoc := wbKey.Document as IHtmlDocument2;
  edtKeyUrl.Text := htmlDoc.url;

  sOld := sNow;
  sNow := htmlDoc.url;
  if sOld = sNow then Exit;//yodao垃圾！！！

  GetElementFromUrl(sl1, sOld);
  GetElementFromUrl(sl2, sNow);
  DiffAnalyser(TStrings(sl1), TStrings(sl2), TStrings(slDiff));

  //如果链接中存在字符集设置，予以保留，以免查询出现乱码，例如雅虎
  for i := 0 to sl2.Count - 1 do begin
    if Pos(edtSeoCharset.Text, UpperCase(sl2.Strings[i])) > 0 then
      slDiff.Add(sl2.Strings[i]);
  end;

  clbSiteEm.Items.Assign(slDiff);
  for i := 0 to clbSiteEm.Count - 1 do clbSiteEm.Checked[i] := True;
end;

procedure TdlgSE.wbSiteNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  htmlDoc: IHtmlDocument2;
begin
  htmlDoc := wbSite.Document as IHtmlDocument2;
  edtSiteUrl.Text := htmlDoc.url;
end;

end.
