unit uImp;

interface

uses SysUtils, Classes, Forms, Controls, StdCtrls,
  ExtCtrls, Dialogs, DB, ADODB, ComCtrls, MSXML2_TLB;

type
  TdlgImp = class(TForm)
    btImp: TButton;
    btClose: TButton;
    Bevel1: TBevel;
    odOpen: TOpenDialog;
    btOpen: TButton;
    lblPath: TLabel;
    adoc: TADOConnection;
    lblState: TLabel;
    Memo1: TMemo;
    adoq: TADOQuery;
    cbbType: TComboBox;
    Label3: TLabel;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btImpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ImpKBS();
    procedure ImpSeoHelp();
    procedure goSQL(aSQL: string; aType: integer);
    procedure ImportSite(aSite: string);
  public
    { Public declarations }
  end;

var
  dlgImp: TdlgImp;
  sMdb: string;

implementation

uses uMain, uFunc;

{$R *.dfm}

procedure TdlgImp.btCloseClick(Sender: TObject);
begin
  if adoc.Connected then adoc.Close;
end;

procedure TdlgImp.btImpClick(Sender: TObject);
begin
  if cbbType.ItemIndex = 0 then ImpKBS
  else ImpSeoHelp;

  lblPath.Caption := '路径：';
  lblState.Caption := '状态：已关闭';
  btImp.Enabled := False;
end;

procedure TdlgImp.btOpenClick(Sender: TObject);
begin
  if adoc.Connected then adoc.Close;

  if odOpen.Execute then begin
    sMdb := odOpen.FileName;

    adoc.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
      + sMdb +';Persist Security Info=False';
    adoc.Connected := True;

    lblPath.Caption := '路径：' + ExtractFilePath(sMdb);
    lblState.Caption := '状态：已连接';
    btImp.Enabled := True;
  end;
end;

procedure TdlgImp.FormCreate(Sender: TObject);
begin
  cbbType.ItemIndex := 0;
end;

procedure TdlgImp.goSQL(aSQL: string; aType: integer);
begin
  adoq.Close;
  adoq.SQL.Clear;
  adoq.SQL.Text := aSQL;
  if aType = 0 then adoq.Open else adoq.ExecSQL;
end;

procedure TdlgImp.ImpKBS;
var
  i: integer;
  node: TTreeNode;
  slSite: TStringList;
begin
  goSQL('select distinct site from data', 0);
  slSite := TStringList.Create;
  try
    while not adoq.Eof do begin
      slSite.Append(adoq.FieldByName('site').AsString);
      adoq.Next;
    end;
    for i := 0 to slSite.Count - 1 do begin
      ImportSite(slSite.Strings[i]);
      node := fmMain.rztSite.Items.AddChild(fmMain.rztSite.Items[0], slSite.Strings[i]);
      node.ImageIndex := 5;
      node.SelectedIndex := 5;
      fmMain.AddSiteToXml(slSite.Strings[i]);
      Memo1.Lines.Add('[' + slSite.Strings[i] + ']数据导入完毕！')
    end;
  finally
    slSite.Free;
  end;
end;

procedure TdlgImp.ImportSite(aSite: string);
var
  slData: TStringList;
begin
  goSQL('select * from data where site = ''' + aSite + ''' order by riqi', 0);
  slData := TStringList.Create;
  try
    while not adoq.Eof do begin
      if adoq.FieldByName('google').AsInteger > 0 then
        slData.Append(FormatDateTime('yyyy-mm-dd_hh:mm:ss', adoq.FieldByName('riqi').AsDateTime)
          + '|Google|' + adoq.FieldByName('google').AsString);
      if adoq.FieldByName('baidu').AsInteger > 0 then
        slData.Append(FormatDateTime('yyyy-mm-dd_hh:mm:ss', adoq.FieldByName('riqi').AsDateTime)
          + '|百度|' + adoq.FieldByName('baidu').AsString);
      if adoq.FieldByName('yahoo').AsInteger > 0 then
        slData.Append(FormatDateTime('yyyy-mm-dd_hh:mm:ss', adoq.FieldByName('riqi').AsDateTime)
          + '|雅虎|' + adoq.FieldByName('yahoo').AsString);
      adoq.Next;
    end;
    slData.SaveToFile(ExtractFilePath(Application.ExeName)
      + 'data\' + 'S_' + aSite + '.dat');
  finally
    slData.Free;
  end;
end;

procedure TdlgImp.ImpSeoHelp;
var
  xmlDoc: IXMLDOMDocument2;
  xmlRoot, xmlNode: IXMLDOMNode;
  xmlElm: IXMLDOMElement;
begin
  xmlDoc := CoDOMDocument40.Create;

  goSQL('select * from promote', 0);
  try
    xmlDoc.load(CurrentPath + 'submit.xml');
    while not adoq.Eof do begin
      xmlNode := xmlDoc.createNode(1, 'URL', '');
      xmlNode.text := adoq.FieldByName('entry').AsString;

      xmlElm := xmlNode as IXMLDOMElement;
      xmlElm.setAttribute('Name', adoq.FieldByName('name').AsString);
      xmlElm.setAttribute('Type', adoq.FieldByName('type').AsString);
//      xmlElm.setAttribute('Count', '0');

      xmlRoot := xmlDoc.selectSingleNode('SubmitSites');
      xmlRoot.appendChild(xmlNode);
      Memo1.Lines.Add('[' + adoq.FieldByName('name').AsString + ']数据导入完毕！');

      adoq.Next;
    end;
    xmlDoc.save(CurrentPath + 'submit.xml');
  finally
    xmlDoc := nil;
  end;
end;

end.
