unit uAbout;

interface

uses Classes, Forms, Controls, StdCtrls, ExtCtrls, RzLabel, Windows, SysUtils,
  Buttons, IdHTTP, Dialogs, ShellAPI, GIFImg;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Version: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    RzURLLabel1: TRzURLLabel;
    Label1: TLabel;
    RzURLLabel2: TRzURLLabel;
    ProgramIcon: TImage;
    RzURLLabel3: TRzURLLabel;
    Label2: TLabel;
    btnUpdate: TButton;
    lblVersion: TLabel;
    procedure btnUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function GetVersionFromWeb(aURL: string): string;
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

uses uFunc;

{$R *.dfm}

procedure TAboutBox.btnUpdateClick(Sender: TObject);
var
  s: string;
  v1, v2, v3, v4: Word;
  dwNewM, dwNewL, dwOldM, dwOldL: DWORD;
begin
  GetBuildInfo(v1, v2, v3, v4);
  s := Format('%d.%d.%d.%d',[v1, v2, v3, v4]);
  SeparateVerStr(s, dwOldM, dwOldL);

  s := GetVersionFromWeb('http://www.mysiteseo.net/soft/version.txt');
  SeparateVerStr(s, dwNewM, dwNewL);

  if IsExistNewVersion(dwNewM, dwNewL, dwOldM, dwOldL) then begin
    if MessageDlg('�����°汾���Ƿ�������', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes
      then ShellExecute(Application.Handle, nil, PChar('http://www.mysiteseo.net/download.html'), nil, nil, SW_SHOWNORMAL);
  end else begin
    MessageDlg('��ǰ�汾�Ѿ������°汾��', mtInformation, [mbOK], 0);
  end;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
var
  v1, v2, v3, v4: Word;
begin
  GetBuildInfo(v1, v2, v3, v4);
  lblVersion.Caption := Format('�ڲ��汾��%d.%d.%d.%d',[v1, v2, v3, v4]);
end;

function TAboutBox.GetVersionFromWeb(aURL: string): string;
var
  s: string;
  idHttp: TIdHttp;
  ProxyServer: string;
  ProxyPort: Integer;
begin
  GetProxyServer('http', ProxyServer, ProxyPort);

  idHttp := TidHttp.Create(Self);
  idHttp.HandleRedirects := True;
  if ProxyServer <> '' then begin
    idHttp.ProxyParams.ProxyServer := ProxyServer;
    idHttp.ProxyParams.ProxyPort := ProxyPort;
  end;
  try
    s := idHttp.Get(aURL);
  finally
    idHttp.Free;
  end;

  Result := s;
end;

end.

