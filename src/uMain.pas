unit uMain;

interface

uses
  SysUtils, Variants, Classes, Controls, Forms, MSXML2_TLB, Dialogs,
  StdCtrls, CheckLst, ComCtrls, RzTreeVw, Menus, ActnList,
  ExtCtrls, TeEngine, Chart, Series, Buttons, Grids, StrUtils,
  ImgList, msxmldom, ToolWin, TeeProcs, AppEvnts, uSEO;

type
  TfmMain = class(TForm)
    ImageList: TImageList;
    pmTree: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    Panel2: TPanel;
    Panel3: TPanel;
    clbEng: TCheckListBox;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Panel5: TPanel;
    cbAllSe: TCheckBox;
    Splitter2: TSplitter;
    ActionList1: TActionList;
    actNewSite: TAction;
    actNewKey: TAction;
    actDel: TAction;
    actEdit: TAction;
    actImp: TAction;
    actSet: TAction;
    actClose: TAction;
    actGet: TAction;
    Panel1: TPanel;
    pnTitle: TPanel;
    chart: TChart;
    seLines: TLineSeries;
    Splitter3: TSplitter;
    status: TStatusBar;
    ToolButton6: TToolButton;
    BigImage: TImageList;
    sbDel: TSpeedButton;
    sbNewKey: TSpeedButton;
    sbNewSite: TSpeedButton;
    sbEdit: TSpeedButton;
    pmChart: TPopupMenu;
    grid: TStringGrid;
    ToolButton2: TToolButton;
    actAbout: TAction;
    ToolButton7: TToolButton;
    Timer1: TTimer;
    actReg: TAction;
    ToolButton8: TToolButton;
    pmGrid: TPopupMenu;
    actDelRow: TAction;
    N6: TMenuItem;
    actGC: TAction;
    N7: TMenuItem;
    N8: TMenuItem;
    AppEvents: TApplicationEvents;
    rbSite: TRadioButton;
    rbLink: TRadioButton;
    actSubmit: TAction;
    ToolButton9: TToolButton;
    N9: TMenuItem;
    N10: TMenuItem;
    SaveDialog: TSaveDialog;
    rztSite: TRzCheckTree;
    procedure cbAllSeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure actNewSiteExecute(Sender: TObject);
    procedure actNewKeyExecute(Sender: TObject);
    procedure actDelExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure rztSiteEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure actImpExecute(Sender: TObject);
    procedure actSetExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actGetExecute(Sender: TObject);
    procedure SeSetClick(Sender: TObject);
    procedure pmTreePopup(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure actRegExecute(Sender: TObject);
    procedure rztSiteStateChange(Sender: TObject; Node: TTreeNode;
      NewState: TRzCheckState);
    procedure rztSiteChange(Sender: TObject; Node: TTreeNode);
    procedure rztSiteEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure actDelRowExecute(Sender: TObject);
    procedure actGCExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AppEventsException(Sender: TObject; E: Exception);
    procedure rbSiteClick(Sender: TObject);
    procedure rbLinkClick(Sender: TObject);
    procedure actSubmitExecute(Sender: TObject);
    procedure N9Click(Sender: TObject);
  private
    { Private declarations }
    xmlDoc: IXMLDOMDocument2;
    procedure LoadXmlConfig;
    procedure GridInitSet;
    procedure AddKeyToXml(aSite: string; aKeyword: string);
    procedure DelSiteFromXml(aSite: string);
    procedure DelKeyFromXml(aSite: string; aKeyword: string);
    procedure SearchSite(aSite: string; aBeginTime: string; aType: TSeoType; aFile: string);
    procedure SearchKeyword(aSite: string; aKeyword: string; aBeginTime: string; aFile: string);
    procedure ShowSiteLine(aIdxSE: integer);
    procedure CreateDataFile(aFileName: string);
    procedure ShowHisData(aFile: string);
    procedure EditSiteInXml(aOldSite, aNewSite: string);
    procedure EditKeyInXml(aSite, aOldKey, aNewKey: string);
    function CheckDupNode(aNode: TTreeNode; aText: string): boolean;
    function CheckValidText(aNode: TTreeNode; aText: string): boolean;
  public
    { Public declarations }
    procedure AddSiteToXml(aSite: string);
  end;

var
  fmMain: TfmMain;

implementation

uses uFunc, uSEObj, uSet, uAbout, uImp, uProxy, uSE, uXML, uSubmit;

{$R *.dfm}

procedure TfmMain.SeSetClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to pmChart.Items.Count - 1 do pmChart.Items[i].Checked := False;
  (Sender as TMenuItem).Checked := True;
  CurrentSE := (Sender as TMenuItem).Tag;
  ShowSiteLine(CurrentSE);
end;

procedure TfmMain.actAboutExecute(Sender: TObject);
var
  dlg: TAboutBox;
begin
  dlg := TAboutBox.Create(Application);
  dlg.ShowModal;
end;

procedure TfmMain.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.actDelExecute(Sender: TObject);
var
  sStr: string;
  node: TTreeNode;
begin
  node := rztSite.Selected;
  if node = rztSite.Items[0] then Exit;

  if node.Level = 1 then sStr := '�Ƿ�ɾ��վ�㡰 ' + node.Text + '�� ����ؼ��֣�'
  else sStr := '�Ƿ�ɾ���ؼ��֡� ' + node.Text + ' ����';

  if MessageDlg(sStr, mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then begin
    if node.Level = 1 then DelSiteFromXml(node.Text)
    else DelKeyFromXml(node.Parent.Text, node.Text);
    node.Delete;
  end;
end;

procedure TfmMain.actDelRowExecute(Sender: TObject);
var
  i: integer;
  sTime, sDataFile: string;
  slData: TStringList;
begin
  //ɾ����ǰ�вɼ����������
  if grid.Cells[1, grid.Row] = '' then Exit;
  sTime := grid.Cells[1, grid.Row];

  {
  if MessageDlg('�Ƿ�ɾ����ǰ�����ݣ�', mtConfirmation,
  		[mbYes, mbNo], 0, mbYes) = mrNo then Exit;
  }

  //��ʾվ��͹ؼ��ֵ���ʷ���ݺ�ͼ��
  if rztSite.Selected.Level = 1 then begin
    if rbSite.Checked then begin
      sDataFile := CurrentPath + 'data\' + 'S_' + rztSite.Selected.Text + '.dat';
    end else begin
      sDataFile := CurrentPath + 'data\' + 'L_' + rztSite.Selected.Text + '.dat';
    end;
  end else if rztSite.Selected.Level = 2 then begin
    sDataFile := CurrentPath + 'data\' + 'K_' + rztSite.Selected.Parent.Text + '_' + rztSite.Selected.Text + '.dat';
  end;

  slData := TStringList.Create;
  try
    slData.LoadFromFile(sDataFile);
    for i := slData.Count - 1 downto 0 do begin
      if LeftStr(slData[i], 19) = sTime then slData.Delete(i);
    end;
    slData.SaveToFile(sDataFile);
  finally
    slData.Free;
  end;

  if not FileExists(sDataFile) then Exit;
  ShowHisData(sDataFile);
  ShowSiteLine(CurrentSE);
end;

procedure TfmMain.actEditExecute(Sender: TObject);
begin
  if rztSite.Selected = rztSite.Items[0] then Exit;

  rztSite.Selected.EditText;
end;

procedure TfmMain.actGCExecute(Sender: TObject);
var
  i: integer;
  sDataFile: string;
  slData, slLine: TStringList;
begin
  //�����������
  if grid.Cells[1, grid.Row] = '' then Exit;

  if rztSite.Selected.Level = 1 then begin
    if rbSite.Checked then begin
      sDataFile := CurrentPath + 'data\' + 'S_' + rztSite.Selected.Text + '.dat';
    end else begin
      sDataFile := CurrentPath + 'data\' + 'L_' + rztSite.Selected.Text + '.dat';
    end;
  end else if rztSite.Selected.Level = 2 then begin
    sDataFile := CurrentPath + 'data\' + 'K_' + rztSite.Selected.Parent.Text + '_' + rztSite.Selected.Text + '.dat';
  end;

  slData := TStringList.Create;
  slLine := TStringList.Create;
  try
    slData.LoadFromFile(sDataFile);
    for i := slData.Count - 1 downto 0 do begin
      slLine.Clear;
      slLine.Delimiter := '|';
      slLine.DelimitedText := slData[i];
      if slLine[2] = '0' then slData.Delete(i);
    end;
    slData.SaveToFile(sDataFile);
  finally
    slData.Free;
    slLine.Free;
  end;

  if not FileExists(sDataFile) then Exit;
  ShowHisData(sDataFile);
  ShowSiteLine(CurrentSE);
end;

procedure TfmMain.actGetExecute(Sender: TObject);
var
  i, iCount: integer;
  treeNode: TTreeNode;
  sBeginTime: string;
begin
  //ȫ�����ݲɼ�������վ��͹ؼ���
  if not GetOnlineStatus then begin
    MessageDlg('ϵͳû���������޷��������ݣ�', mtError, [mbOk], 0);
    Exit;
  end;

  iCount := 0;
  for i := 0 to clbEng.Count - 1 do begin
    if clbEng.Checked[i] then Inc(iCount);
  end;

  if iCount = 0 then begin
    MessageDlg('������ѡ��һ���������棡', mtInformation, [mbOk], 0);
    Exit;
  end;

  SeoCount := 0;      //�̼߳���������

  Timer1.Enabled := True;
  sBeginTime := FormatDateTime('yyyy-mm-dd_hh:mm:ss', Now);

  for i := 1 to rztSite.Items.Count -1 do begin
    treeNode := rztSite.Items[i];
    if rztSite.ItemState[i] = csChecked then begin
      if treeNode.Level = 1 then begin
        //������ҳ��¼��
        SearchSite(treeNode.Text, sBeginTime, stSite,
          CurrentPath + 'data\' + 'S_' + treeNode.Text + '.dat');
        //��������������
        SearchSite(treeNode.Text, sBeginTime, stLink,
          CurrentPath + 'data\' + 'L_' + treeNode.Text + '.dat');
      end else if treeNode.Level = 2 then
        //�����ؼ�������
        SearchKeyword(treeNode.Parent.Text, treeNode.Text, sBeginTime,
          CurrentPath + 'data\' + 'K_' + treeNode.Parent.Text + '_' + treeNode.Text + '.dat');
    end;
  end;
end;

procedure TfmMain.actNewKeyExecute(Sender: TObject);
var
  node: TTreeNode;
begin
  if rztSite.Selected = rztSite.Items[0] then Exit;

  if rztSite.Selected.Level = 1 then
    node := rztSite.Items.AddChild(rztSite.Selected, 'New Keyword')
  else
    node := rztSite.Items.Add(rztSite.Selected, 'New Keyword');

  node.ImageIndex := 9;
  node.SelectedIndex := 9;
  node.Selected := True;
  node.EditText;
end;

procedure TfmMain.actNewSiteExecute(Sender: TObject);
var
  node: TTreeNode;
begin
  node := rztSite.Items.AddChild(rztSite.Items[0], 'New Site');
  node.ImageIndex := 5;
  node.SelectedIndex := 5;
  node.Selected := True;
  node.EditText;
end;

procedure TfmMain.actRegExecute(Sender: TObject);
var
  dlgSE: TdlgSE;
begin
  dlgSE := TdlgSE.Create(Application);
  dlgSE.ShowModal;
end;

procedure TfmMain.actImpExecute(Sender: TObject);
var
  dlgImp: TdlgImp;
begin
  dlgImp := TdlgImp.Create(Application);
  dlgImp.ShowModal;
end;

procedure TfmMain.actSetExecute(Sender: TObject);
var
  dlgSet: TdlgSet;
begin
  dlgSet := TdlgSet.Create(Application);
  dlgSet.ShowModal;
end;

procedure TfmMain.actSubmitExecute(Sender: TObject);
var
  dlgSubmit: TdlgSubmit;
begin
  dlgSubmit := TdlgSubmit.Create(Application);
  dlgSubmit.ShowModal;
end;

procedure TfmMain.AddKeyToXml(aSite, aKeyword: string);
var
  xmlRoot, xmlSite, xmlNode: IXMLDOMNode;
  i: integer;
begin
  xmlDoc.load(CurrentPath + 'site.xml');

  xmlNode := xmlDoc.createNode(1, 'keyword', '');
  xmlNode.text := aKeyword;

  xmlRoot := xmlDoc.selectSingleNode('WebSites');
  for i := 0 to xmlRoot.childNodes.length - 1 do begin
    xmlSite := xmlRoot.childNodes.item[i];
    if xmlSite.attributes[0].text = aSite then begin
      xmlSite.appendChild(xmlNode);
      break;
    end;
  end;

  xmlDoc.save(CurrentPath + 'site.xml');
end;

procedure TfmMain.AddSiteToXml(aSite: string);
var
  xmlRoot, xmlNode: IXMLDOMNode;
  xmlElm: IXMLDOMElement;
begin
  xmlDoc.load(CurrentPath + 'site.xml');

  xmlNode := xmlDoc.createNode(1, 'Site', '');
  xmlElm := xmlNode as IXMLDOMElement;
  xmlElm.setAttribute('Target', aSite);

  xmlRoot := xmlDoc.selectSingleNode('WebSites');
  xmlRoot.appendChild(xmlNode);
  xmlDoc.save(CurrentPath + 'site.xml');
end;

procedure TfmMain.AppEventsException(Sender: TObject; E: Exception);
begin
  if E is EXMLError then
    with xmlDoc.parseError do begin
      MessageDlg(Format('�����ĵ�"%s"ʱ��"%s"����0x%x�Ŵ����ڵ�%d��%d���ַ�(ȫ�ĵ�%d���ַ�)'#13#10'�����ı�: %s'#13#10#13#10'��ʾ��Ϣ: %s',
      [url, reason, errorCode, line, linepos, filepos + 1, srcText, E.Message]), mtError, [mbAbort], 0);
    end else Application.ShowException(E);
end;

procedure TfmMain.DelKeyFromXml(aSite, aKeyword: string);
var
  xmlRoot, xmlSite, xmlKey: IXMLDOMNode;
  i, j: integer;
begin
  xmlDoc.load(CurrentPath + 'site.xml');
  xmlRoot := xmlDoc.selectSingleNode('WebSites');

  for i := 0 to xmlRoot.childNodes.length - 1 do begin
    xmlSite := xmlRoot.childNodes.item[i];
    if xmlSite.attributes[0].text = aSite then begin
      for j := 0 to xmlSite.childNodes.length - 1 do begin
        xmlKey := xmlSite.childNodes.item[j];
        if xmlKey.text = aKeyword then begin
          xmlSite.removeChild(xmlKey);
          break;
        end;
      end;
    end;
  end;

  xmlDoc.save(CurrentPath + 'site.xml');
end;

procedure TfmMain.DelSiteFromXml(aSite: string);
var
  xmlRoot, xmlSite: IXMLDOMNode;
  xmlElm: IXMLDOMElement;
  i: integer;
begin
  xmlDoc.load(CurrentPath + 'site.xml');
  xmlRoot := xmlDoc.selectSingleNode('WebSites');

  for i := 0 to xmlRoot.childNodes.length - 1 do begin
    xmlSite := xmlRoot.childNodes.item[i];
    xmlElm := xmlSite as IXMLDOMElement;
    if xmlElm.getAttribute('Target') = aSite then begin
      xmlRoot.removeChild(xmlSite);
      break;
    end;
  end;

  xmlDoc.save(CurrentPath + 'site.xml');
end;

procedure TfmMain.EditKeyInXml(aSite, aOldKey, aNewKey: string);
var
  xmlRoot, xmlSite, xmlNode: IXMLDOMNode;
  xmlElm: IXMLDOMElement;
  i, j: integer;
begin
  xmlDoc.load(CurrentPath + 'site.xml');
  xmlRoot := xmlDoc.selectSingleNode('WebSites');

  for i := 0 to xmlRoot.childNodes.length - 1 do begin
    xmlSite := xmlRoot.childNodes.item[i];
    xmlElm := xmlSite as IXMLDOMElement;
    if xmlElm.getAttribute('Target') = aSite then begin
      for j := 0 to xmlSite.childNodes.length - 1 do begin
        xmlNode := xmlSite.childNodes.item[i];
        if xmlNode.text = aOldKey then begin
          xmlNode.text := aNewKey;
          break;
        end;
      end;
    end;
  end;

  xmlDoc.save(CurrentPath + 'site.xml');
end;

procedure TfmMain.EditSiteInXml(aOldSite, aNewSite: string);
var
  xmlRoot, xmlSite, xmlKey: IXMLDOMNode;
  xmlElm: IXMLDOMElement;
  i, j: integer;
begin
  xmlDoc.load(CurrentPath + 'site.xml');
  xmlRoot := xmlDoc.selectSingleNode('WebSites');

  for i := 0 to xmlRoot.childNodes.length - 1 do begin
    xmlSite := xmlRoot.childNodes.item[i];
    xmlElm := xmlSite as IXMLDOMElement;
    if xmlElm.getAttribute('Target') = aOldSite then begin
      xmlElm.setAttribute('Target', aNewSite);
      for j := 0 to xmlSite.childNodes.length - 1 do begin
        xmlKey := xmlSite.childNodes.item[i];
        CreateDataFile('K_' + aNewSite + '_' + xmlKey.text + '.dat');
      end;
      break;
    end;
  end;

  xmlDoc.save(CurrentPath + 'site.xml');
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  if Assigned(SeoList) then
    for i := 0 to SeoList.Count - 1 do TSeo(SeoList[i]).Free;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  if not IsClassRegistered(CLASS_DOMDocument40) then
  begin
    MessageDlg('�ļ�msxml4.dllδע�ᣬ���΢����վ��װ��', mtError, [mbAbort], 0);
    sbNewSite.OnClick := nil;
    actReg.Enabled := False;
    Abort;
  end;

  try
    xmlDoc := CoDOMDocument40.Create;
  except
    Abort;
  end;

  gProxy := TProxy.Create;

  CurrentPath := ExtractFilePath(Application.ExeName);
  LoadXmlConfig;
  GridInitSet;
  rztSite.Items[0].Expanded := True;

  LoadProxy(gProxy);

  if not GetOnlineStatus then
    status.Panels[0].Text := '����״̬';

//  adBar.Navigate('http://www.51snap.net/51snaplink.php');
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  xmlDoc := nil;
end;

procedure TfmMain.GridInitSet;
var
  i: integer;
begin
  grid.ColCount := clbEng.Items.Count + 2;
  grid.ColWidths[0] := 30;
  grid.ColWidths[1] := 150;
  grid.Cells[0,0] := 'No.';
  grid.Cells[1,0] := '����';

  for i := 0 to clbEng.Items.Count - 1 do begin
    grid.Cells[i+2,0] := clbEng.Items.Strings[i];
  end;
end;

procedure TfmMain.LoadXmlConfig;
var
  xmlRoot, xmlNode: IXMLDOMNode;
  i, j: Integer;
  seo: TSeo;
  treeRoot, treeNode, keyNode: TTreeNode;
  menu: TMenuItem;
begin
  SeoList := TList.Create;

  //������������
  if not xmlDoc.load(CurrentPath + 'se.xml') then
    raise EXMLLoadError.CreateFmt('���������ظ��ĵ����ֹ��޸ģ�', [CurrentPath + 'se.xml']);

  xmlRoot := xmlDoc.selectSingleNode('SearchEngines');

  for i := 0 to xmlRoot.childNodes.length - 1 do
  begin
    seo := TSeo.Create;
    xmlNode := xmlRoot.childNodes.item[i];
    seo.FName := xmlNode.selectSingleNode('name').text;
    seo.FTarget := xmlNode.attributes[0].text;
    seo.FCharSet := xmlNode.selectSingleNode('charset').text;
    seo.FSiteUrl := xmlNode.selectSingleNode('site').selectSingleNode('url').text;
    seo.FSiteExpr := xmlNode.selectSingleNode('site').selectSingleNode('regexpr').text;
    seo.FLinkUrl := xmlNode.selectSingleNode('link').selectSingleNode('url').text;
    seo.FLinkExpr := xmlNode.selectSingleNode('link').selectSingleNode('regexpr').text;
    seo.FKeyUrl := xmlNode.selectSingleNode('keyword').selectSingleNode('url').text;
    seo.FKeyExpr := xmlNode.selectSingleNode('keyword').selectSingleNode('regexpr').text;
    seo.FKeyPages := StrToInt(xmlNode.selectSingleNode('keyword').selectSingleNode('page').text);
    SeoList.Add(Pointer(seo));

    //��̬���ͼ���Ҽ��˵�
    menu := TMenuItem.Create(self);
    menu.Caption := '��ʾ' + xmlNode.selectSingleNode('name').text + '����';
    menu.Tag := i;
    menu.OnClick := SeSetClick;
    pmChart.Items.Add(menu);
    pmChart.Items[2].Checked := True;
  end;

  for i := 0 to SeoList.Count - 1 do begin
    clbEng.Items.Add(TSeo(SeoList[i]).FName);
  end;

  //������վ��Ϣ
  xmlDoc.load(CurrentPath + 'site.xml');

  xmlRoot := xmlDoc.selectSingleNode('WebSites');

  treeRoot := rztSite.Items.Add(nil, 'ȫ��վ��');
  treeRoot.ImageIndex := 4;
  treeRoot.SelectedIndex := 4;

  for i := 0 to xmlRoot.childNodes.length - 1 do
  begin
    xmlNode := xmlRoot.childNodes.item[i];
    treeNode := rztSite.Items.AddChild(treeRoot, xmlNode.attributes[0].text);
    treeNode.ImageIndex := 5;
    treeNode.SelectedIndex := 5;
    for j := 0 to xmlNode.childNodes.length - 1 do begin
      keyNode := rztSite.Items.AddChild(treeNode, xmlNode.childNodes.item[j].text);
      keyNode.ImageIndex := 9;
      keyNode.SelectedIndex := 9;
    end;
  end;
end;

procedure TfmMain.N9Click(Sender: TObject);
begin
  if SaveDialog.Execute() then chart.SaveToBitmapFile(SaveDialog.FileName);// .SaveToBitmapFile('a.bmp');
end;

procedure TfmMain.pmTreePopup(Sender: TObject);
begin
  actNewKey.Enabled := not (rztSite.Selected.Level = 0);
  actEdit.Enabled := not (rztSite.Selected.Level = 0);
  actDel.Enabled := not (rztSite.Selected.Level = 0);
end;

procedure TfmMain.rbLinkClick(Sender: TObject);
begin
  rbSite.Checked := False;
  rztSite.OnChange(Sender, rztSite.Selected);
end;

procedure TfmMain.rbSiteClick(Sender: TObject);
begin
  rbLink.Checked := False;
  rztSite.OnChange(Sender, rztSite.Selected);
end;

procedure TfmMain.rztSiteChange(Sender: TObject; Node: TTreeNode);
var
  j: Integer;
  sDataFile: string;
begin
  //ȡ��ǰ�ڵ㣬��༭��ڵ�Ƚ�
  CurrentNode := Node.Text;

  //����speedbutton��ť״̬
  sbNewKey.Enabled := not (rztSite.Selected.Level = 0);
  sbEdit.Enabled := not (rztSite.Selected.Level = 0);
  sbDel.Enabled := not (rztSite.Selected.Level = 0);

  //���ڵ㲻��ʾ����
  if Node.Level = 0 then Exit;

  //��ʾվ��͹ؼ��ֵ���ʷ���ݺ�ͼ��
  if rztSite.Selected.Level = 1 then begin
    if rbSite.Checked then begin
      pnTitle.Caption := '[' + rztSite.Selected.Text + ']����ҳ��¼��';
      sDataFile := CurrentPath + 'data\' + 'S_' + rztSite.Selected.Text + '.dat';
    end else begin
      pnTitle.Caption := '[' + rztSite.Selected.Text + ']����վ������';
      sDataFile := CurrentPath + 'data\' + 'L_' + rztSite.Selected.Text + '.dat';
    end;
  end else if rztSite.Selected.Level = 2 then begin
    pnTitle.Caption := '[' + rztSite.Selected.Parent.Text + ']��[' + rztSite.Selected.Text + ']�Ĺؼ�������';
    sDataFile := CurrentPath + 'data\' + 'K_' + rztSite.Selected.Parent.Text + '_' + rztSite.Selected.Text + '.dat';
  end;

  if not FileExists(sDataFile) then begin
    grid.RowCount := 2;
    for j := 0 to grid.ColCount - 1 do grid.Cells[j, 1] := '';
    Exit;
  end;

  ShowHisData(sDataFile);
  ShowSiteLine(CurrentSE);
end;

procedure TfmMain.rztSiteEdited(Sender: TObject; Node: TTreeNode; var S: string);
begin
  //���ڵ��ı��Ƿ���Ϲ淶
  if not CheckValidText(Node, S) then begin
    MessageDlg('[' + S + ']����������Ҫ��', mtError, [mbOk], 0);
    S := CurrentNode;
    Exit;
  end;

  //���Դ����ϲ����ظ��ڵ㣬����
  if CheckDupNode(Node, S) then begin
    MessageDlg('�Ѿ�����[' + S + ']��', mtError, [mbOk], 0);
    S := CurrentNode;
    Exit;
  end;

  //���ݽڵ�level���д���
  if Node.Level = 1 then begin
    if CurrentNode = 'New Site' then AddSiteToXml(S) else EditSiteInXml(CurrentNode, S);
    CreateDataFile('S_' + S + '.dat');
    CreateDataFile('L_' + S + '.dat');    
  end else if Node.Level = 2 then begin
    if CurrentNode = 'New Keyword' then AddKeyToXml(Node.Parent.Text, S) else
      EditKeyInXml(Node.Parent.Text, CurrentNode, S);
    CreateDataFile('K_' + Node.Parent.Text + '_' + S + '.dat');
  end;
end;

procedure TfmMain.rztSiteEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  if Node.Level = 0 then AllowEdit := False;
end;

procedure TfmMain.rztSiteStateChange(Sender: TObject; Node: TTreeNode;
  NewState: TRzCheckState);
var
  child: TTreeNode;
begin
  if Node.HasChildren then begin
    child := Node.getFirstChild;
    rztSite.ChangeNodeCheckState(child, NewState);
    while child <> nil do begin
      child := child.getNextSibling;
    	if child <> nil then rztSite.ChangeNodeCheckState(child, NewState);
    end;
  end;
end;

procedure TfmMain.SearchKeyword(aSite: string; aKeyword: string; aBeginTime: string; aFile: string);
var
  i: integer;
  SEOs: array of TSEObj;
begin
  SetLength(SEOs, SeoList.Count);
  for i := 0 to Length(SEOs) - 1 do begin
    if not clbEng.Checked[i] then continue;

    SEOs[i] := TSEObj.Create(TSeo(SeoList[i]).FName);
    SEOs[i].Proxy := gProxy;
    SEOs[i].CharSet := TSeo(SeoList[i]).FCharSet;
    SEOs[i].Url := TSeo(SeoList[i]).FKeyUrl;
    SEOs[i].Site := aSite;
    SEOs[i].Keyword := aKeyword;
    SEOs[i].PageCount := TSeo(SeoList[i]).FKeyPages;
    SEOs[i].RegExpr := TSeo(SeoList[i]).FKeyExpr;
    SEOs[i].SearchType := stKeyword;
    SEOs[i].BeginTime := aBeginTime;
    SEOs[i].Content := status;
    SEOs[i].DataFile := aFile;
    SEOs[i].Resume;
  end;
end;

procedure TfmMain.SearchSite(aSite: string; aBeginTime: string; aType: TSeoType; aFile: string);
var
  i: integer;
  seo: TSEObj;
begin
  for i := 0 to SeoList.Count - 1 do begin
    if not clbEng.Checked[i] then continue;

    seo := TSEObj.Create(TSeo(SeoList[i]).FName);
    seo.Proxy := gProxy;
    seo.CharSet := TSeo(SeoList[i]).FCharSet;
    if aType = stSite then begin
      seo.Url := TSeo(SeoList[i]).FSiteUrl;
      seo.RegExpr := TSeo(SeoList[i]).FSiteExpr;
    end else if aType = stLink then begin
      seo.Url := TSeo(SeoList[i]).FLinkUrl;
      seo.RegExpr := TSeo(SeoList[i]).FLinkExpr;
    end;
    seo.Site := aSite;
    seo.SearchType := stSite; //����һ����������
    seo.BeginTime := aBeginTime;
    seo.Content := status;
    seo.DataFile := aFile;
    seo.Resume;
  end;
end;

procedure TfmMain.ShowHisData(aFile: string);
var
  i, j, iCol, iRow, iDataCount: integer;
  slData, slLine, slNodup, slEng: TStringList;
begin
  slData := TStringList.Create;
  slLine := TStringList.Create;
  slNodup := TStringList.Create;
  slEng := TStringList.Create;
  try
    slData.LoadFromFile(aFile);
    if slData.Count = 0 then begin
      grid.RowCount := 2;
      for j := 0 to grid.ColCount - 1 do grid.Cells[j, 1] := '';
      Exit;
    end;

    //�������ظ������б�
    iDataCount := slData.Count;
    for i := 0 to slData.Count - 1 do begin
      slLine.Clear;
      slLine.Delimiter := '|';
      slLine.DelimitedText := slData[iDataCount - 1 - i];
      if slNodup.IndexOf(slLine[0]) < 0 then slNodup.Append(slLine[0]);
    end;

    //���������б�
    slEng.Assign(clbEng.Items);

    //��ʾ���ظ�����
    grid.RowCount := slNodup.Count + 1;
    for i := 0 to slNodup.Count - 1 do begin
      grid.Cells[0, i+1] := IntToStr(i+1);
      grid.Cells[1, i+1] := slNodup[i];
      for j := 2 to grid.ColCount - 1 do grid.Cells[j, i+1] := '';
    end;

    //�����������
    iDataCount := slData.Count;
    for i := 0 to slData.Count - 1 do begin
      slLine.Clear;
      slLine.Delimiter := '|';
      slLine.DelimitedText := slData.Strings[iDataCount - 1 - i];
      iRow := slNodup.IndexOf(slLine.Strings[0]);
      iCol := slEng.IndexOf(slLine.Strings[1]);
      grid.Cells[iCol+2, iRow+1] := slLine.Strings[2];
    end;
  finally
    slData.Free;
    slLine.Free;
    slNodup.Free;
    slEng.Free;
  end;
end;

procedure TfmMain.ShowSiteLine(aIdxSE: integer);
var
  i, iQuan: integer;
  sDate: string;
begin
  chart.Title.Text.CommaText := '[' + rztSite.Selected.Text + ']��['
    + clbEng.Items.Strings[aIdxSE] + ']��ʷ����';
  seLines.Clear;
  for i := 0 to grid.RowCount - 2 do begin
    if grid.Cells[aIdxSE+2, i+1] = '' then continue;
    sDate := StringReplace(grid.Cells[1, i+1], '_', ' ', [rfReplaceAll]);
    iQuan := StrToInt(grid.Cells[aIdxSE+2, i+1]);
    seLines.AddXY(StrToDateTime(sDate), iQuan, sDate);
  end;
end;

procedure TfmMain.Timer1Timer(Sender: TObject);
begin
  rztSite.OnChange(Sender, rztSite.Selected);
  Timer1.Enabled := False;
end;

procedure TfmMain.cbAllSeClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to clbEng.Count - 1 do clbEng.Checked[i] := cbAllSe.Checked;
end;

function TfmMain.CheckDupNode(aNode: TTreeNode; aText: string): boolean;
var
  tn: TTreeNode;
begin
  tn := aNode.getPrevSibling;
  while (tn <> nil) do begin
    if tn.Text = aText then begin
      Result := True;
      Exit;
    end;
    tn := tn.getPrevSibling;
  end;

  tn := aNode.getNextSibling;
  while (tn <> nil) do begin
    if tn.Text = aText then begin
      Result := True;
      Exit;
    end;
    tn := tn.getNextSibling;
  end;
  Result := False;
end;

function TfmMain.CheckValidText(aNode: TTreeNode; aText: string): boolean;
begin
  Result := False;
  if (aNode.Level = 1) and ValidSite(aText) then Result := True;
  if (aNode.Level = 2) and ValidKey(aText) then Result := True;
end;

procedure TfmMain.CreateDataFile(aFileName: string);
var
  txtFile: TextFile;
begin
  if not DirectoryExists(CurrentPath + 'data') then
    CreateDir(CurrentPath + 'data');

  if not FileExists(CurrentPath + 'data\' + aFileName) then begin
    AssignFile(txtFile, CurrentPath + 'data\' + aFileName);
    Rewrite(txtFile);
    CloseFile(txtFile);
  end;
end;

end.
