unit uSubmit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, OleCtrls, SHDocVw, ExtCtrls, MSXML2_TLB, 
  ComCtrls;

type
  TdlgSubmit = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    wbSite: TWebBrowser;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    cbbType: TComboBox;
    lvURL: TListView;
    procedure FormCreate(Sender: TObject);
    procedure cbbTypeChange(Sender: TObject);
    procedure lvURLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgSubmit: TdlgSubmit;

implementation

uses uFunc, uMain;

{$R *.dfm}

procedure TdlgSubmit.cbbTypeChange(Sender: TObject);
var
  i: Integer;
  liItem: TListItem;
  xmlDoc: IXMLDOMDocument2;
  xmlRoot, xmlNode: IXMLDOMNode;
begin
  lvURL.Items.Clear;
  lvURL.Items.BeginUpdate;

  xmlDoc := CoDOMDocument40.Create;
  xmlDoc.load(CurrentPath + 'submit.xml');
  xmlRoot := xmlDoc.selectSingleNode('SubmitSites');

  for i := 0 to xmlRoot.childNodes.length - 1 do
  begin
    xmlNode := xmlRoot.childNodes.item[i];
    if xmlNode.attributes[1].text = cbbType.Items[cbbType.ItemIndex] then begin
      liItem := lvURL.Items.Add;
      liItem.ImageIndex := 5;
      liItem.Caption := xmlNode.attributes[0].text;
      liItem.SubItems.Add(xmlNode.text);
    end;
  end;

  lvURL.Items.EndUpdate;
end;

procedure TdlgSubmit.FormCreate(Sender: TObject);
begin
  cbbType.ItemIndex := 0;
  cbbType.OnChange(Self);
end;

procedure TdlgSubmit.lvURLClick(Sender: TObject);
begin
  Self.Caption := 'ÍøÕ¾Ìá½» - ' + lvURL.Selected.SubItems[0];
  if wbSite.Busy then wbSite.Stop;  
  wbSite.Navigate(lvURL.Selected.SubItems[0]);
end;

end.
