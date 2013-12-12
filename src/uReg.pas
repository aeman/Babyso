unit uReg;

interface

uses SysUtils, Classes, Forms, Controls, StdCtrls,
  ExtCtrls, IdHTTP, RegExpr, StrUtils, ComCtrls, Dialogs;

type
  TdlgReg = class(TForm)
    OKBtn: TButton;
    pgSet: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    meContent: TMemo;
    edUrl: TEdit;
    btGo: TButton;
    edRegExpr: TEdit;
    btMatch: TButton;
    edResult: TEdit;
    edUrlg: TEdit;
    btGen: TButton;
    edExprg: TEdit;
    edSite: TEdit;
    cbSeo: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel2: TBevel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edUrl2: TEdit;
    btGo2: TButton;
    edRegExpr2: TEdit;
    btMatch2: TButton;
    edExprg2: TEdit;
    edUrlg2: TEdit;
    btGen2: TButton;
    edResult2: TEdit;
    edKey: TEdit;
    cbSeo2: TComboBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    cbPage: TComboBox;
    Label15: TLabel;
    lbContent: TListBox;
    meContent2: TMemo;
    procedure btGoClick(Sender: TObject);
    procedure btMatchClick(Sender: TObject);
    procedure btGenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbSeoChange(Sender: TObject);
    procedure pgSetChange(Sender: TObject);
    procedure cbSeo2Change(Sender: TObject);
    procedure btGo2Click(Sender: TObject);
    procedure btMatch2Click(Sender: TObject);
    procedure btGen2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgReg: TdlgReg;

implementation

uses uFunc;

{$R *.dfm}

procedure TdlgReg.btGen2Click(Sender: TObject);
var
  sUrl, sRegExpr: string;
begin
  sUrl := StringReplace(edUrl2.Text, KeyToUTF8(edKey.Text), '{$KEYWORD}', [rfReplaceAll]);
  sUrl := StringReplace(sUrl, '&', '&amp;', [rfReplaceAll]);

  sRegExpr := StringReplace(edRegExpr2.Text, '<', '&lt;', [rfReplaceAll]);
  sRegExpr := StringReplace(sRegExpr, '>', '&gt;', [rfReplaceAll]);

  edUrlg2.Text := sUrl;
  edExprg2.Text := sRegExpr;
end;

procedure TdlgReg.btGenClick(Sender: TObject);
var
  sUrl, sRegExpr: string;
begin
  sUrl := StringReplace(edUrl.Text, edSite.Text, '{$SITE}', [rfReplaceAll]);
  sUrl := StringReplace(sUrl, '&', '&amp;', [rfReplaceAll]);

  sRegExpr := StringReplace(edRegExpr.Text, '<', '&lt;', [rfReplaceAll]);
  sRegExpr := StringReplace(sRegExpr, '>', '&gt;', [rfReplaceAll]);

  edUrlg.Text := sUrl;
  edExprg.Text := sRegExpr;
end;

procedure TdlgReg.btGo2Click(Sender: TObject);
var
  iPages: integer;
  s, sUrl: string;
  idHttp: TIdHttp;
begin
  if not GetOnlineStatus then begin
    MessageDlg('系统没有联网，无法搜索数据！', mtError, [mbOk], 0);
    Exit;
  end;

  meContent2.Lines.Clear;
  lbContent.Items.Clear;
  edResult2.Text := '';

  sUrl := edUrl2.Text;
  iPages := cbPage.ItemIndex;

  idHttp := TidHttp.Create(Self);
  idHttp.HandleRedirects := True;
  if gProxy.Active then begin
    idHttp.ProxyParams.ProxyServer := gProxy.IpAddr;
    idHttp.ProxyParams.ProxyPort := gProxy.Port;
  end;

  try
    sUrl := StringReplace(sUrl, '{$COUNT}', IntToStr(iPages*10), [rfReplaceAll]);
    s := idHttp.Get(sUrl);
    if PosEx(UTF_MARK, s) > 0 then meContent2.Text := Utf8ToAnsi(s)
    else meContent2.Text := s;
  finally
    idHttp.Free;
  end;
end;

procedure TdlgReg.btGoClick(Sender: TObject);
var
  s: string;
  idHttp: TIdHttp;
begin
  if not GetOnlineStatus then begin
    MessageDlg('系统没有联网，无法搜索数据！', mtError, [mbOk], 0);
    Exit;
  end;

  meContent.Lines.Clear;

  idHttp := TidHttp.Create(Self);
  idHttp.HandleRedirects := True;
  idHttp.ConnectTimeout := 10000;
  idHttp.ReadTimeout := 30000;
  idHttp.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)';
  if gProxy.Active then begin
    idHttp.ProxyParams.ProxyServer := gProxy.IpAddr;
    idHttp.ProxyParams.ProxyPort := gProxy.Port;
  end;

  try
    s := idHttp.Get(edUrl.Text);
    if PosEx(UTF_MARK, s) > 0 then meContent.Text := Utf8ToAnsi(s)
    else meContent.Text := s;;
  finally
    idHttp.Free;
  end;
end;

procedure TdlgReg.btMatch2Click(Sender: TObject);
var
  rReg: TRegExpr;
  slLink: TStringList;
begin
  rReg := TRegExpr.Create;
  slLink := TStringList.Create;
  try
    rReg.Expression := edRegExpr2.Text;
    if rReg.Exec(meContent2.Text) then
    repeat
      slLink.Add(rReg.Match[0]);
    until not rReg.ExecNext;

    lbContent.Items.Assign(slLink);
    edResult2.Text := IntToStr(slLink.Count);
  finally
    rReg.Free;
    slLink.Free;
  end;

  btGen2.Enabled := edResult2.Text <> '0';
end;

procedure TdlgReg.btMatchClick(Sender: TObject);
var
  s: string;
  rReg: TRegExpr;
begin
  if meContent.Text = '' then Exit;

  rReg := TRegExpr.Create;
  try
    rReg.Expression := edRegExpr.Text;
    if rReg.Exec(meContent.Text) then edResult.Text := rReg.Match[0]
    else edResult.Text := 'NoFound';
  finally
    rReg.Free;
  end;

  s := meContent.Text;
  meContent.SetFocus;
  meContent.SelStart := PosEx(edResult.Text, s, 1);
  meContent.SelLength := Length(edResult.Text);

  btGen.Enabled := edResult.Text <> 'NotFound';
end;

procedure TdlgReg.cbSeo2Change(Sender: TObject);
var
  i: integer;
  sUrl, sRegExpr, sFormatKey: string;
begin
  i := cbSeo2.ItemIndex;
  sUrl := (TSeo(SeoList[i]).FKeyUrl);
  sRegExpr := (TSeo(SeoList[i]).FKeyExpr);
  sFormatKey := FormatKeyword(edKey.Text, TSeo(SeoList[i]).FCharSet);

  sUrl := StringReplace(sUrl, '{$KEYWORD}', sFormatKey, [rfReplaceAll]);
  sUrl := StringReplace(sUrl, '&amp;', '&', [rfReplaceAll]);

  sRegExpr := StringReplace(sRegExpr, '&lt;', '<', [rfReplaceAll]);
  sRegExpr := StringReplace(sRegExpr, '&gt;', '>', [rfReplaceAll]);

	edUrl2.Text := sUrl;
	edRegExpr2.Text := sRegExpr;

  meContent2.Lines.Clear;
  lbContent.Items.Clear;
  edResult2.Text := '';
  edUrlg2.Text := '';
  edExprg2.Text := '';
  btGen2.Enabled := False;  
end;

procedure TdlgReg.cbSeoChange(Sender: TObject);
var
  i: integer;
  sUrl, sRegExpr: string;
begin
  i := cbSeo.ItemIndex;
  sUrl := (TSeo(SeoList[i]).FSiteUrl);
  sRegExpr := (TSeo(SeoList[i]).FSiteExpr);

  sUrl := StringReplace(sUrl, '{$SITE}', edSite.Text, [rfReplaceAll]);
  sUrl := StringReplace(sUrl, '&amp;', '&', [rfReplaceAll]);

  sRegExpr := StringReplace(sRegExpr, '&lt;', '<', [rfReplaceAll]);
  sRegExpr := StringReplace(sRegExpr, '&gt;', '>', [rfReplaceAll]);

	edUrl.Text := sUrl;
	edRegExpr.Text := sRegExpr;

  meContent.Lines.Clear;
  edResult.Text := '';
  edUrlg.Text := '';
  edExprg.Text := '';
  btGen.Enabled := False;
end;

procedure TdlgReg.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to SeoList.Count - 1 do begin
    cbSeo.Items.Add(TSeo(SeoList[i]).FName);
    cbSeo2.Items.Add(TSeo(SeoList[i]).FName);
  end;
  cbSeo.ItemIndex := 0;
  cbSeo.OnChange(Sender);
end;

procedure TdlgReg.pgSetChange(Sender: TObject);
begin
  if pgSet.ActivePageIndex = 1 then begin
    cbSeo2.ItemIndex := 0;
    cbSeo2.OnChange(Sender);
    cbPage.ItemIndex := 0;
  end;
end;

end.
