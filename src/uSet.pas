unit uSet;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, Buttons, ExtCtrls, Dialogs, IniFiles;

type
  TdlgSet = class(TForm)
    edtServer: TEdit;
    edtPort: TEdit;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    rbNoProxy: TRadioButton;
    rbBrowProxy: TRadioButton;
    rbUserProxy: TRadioButton;
    Bevel1: TBevel;
    edtUser: TEdit;
    edtPassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure rbNoProxyClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgSet: TdlgSet;

implementation

uses uFunc;

var
  iActive: Integer;

{$R *.dfm}

procedure TdlgSet.btnOkClick(Sender: TObject);
var
  myIni: TIniFile;
  ProxyServer: string;
  ProxyPort: Integer;
begin
  if iActive = 2 then begin
    if (Length(edtServer.Text) = 0) or (Length(edtPort.Text) = 0)  then begin
      MessageDlg('请输入代理地址和端口！', mtConfirmation, [mbOk], 0);
      Exit;
    end;

    if not CheckValidNum(edtPort.Text) then begin
      MessageDlg('端口应为数字！', mtError, [mbOk], 0);
      edtPort.SelectAll;
      edtPort.SetFocus;
      Exit;
    end;
  end;

  myIni := TIniFile.Create(CurrentPath+'Babyso.ini');
  myIni.WriteInteger('Proxy', 'Active', iActive);

  if iActive = 0 then begin
    myIni.WriteString('Proxy', 'Server', '');
    myIni.WriteInteger('Proxy', 'Port', 0);
    myIni.WriteString('Proxy', 'User', '');
    myIni.WriteString('Proxy', 'Password', '');
  end else if iActive = 1 then begin
    GetProxyServer('http', ProxyServer, ProxyPort);
    myIni.WriteString('Proxy', 'Server', ProxyServer);
    myIni.WriteInteger('Proxy', 'Port', ProxyPort);
    myIni.WriteString('Proxy', 'User', '');
    myIni.WriteString('Proxy', 'Password', '');
  end else if iActive = 2 then begin
    myIni.WriteString('Proxy', 'Server', edtServer.Text);
    myIni.WriteInteger('Proxy', 'Port', StrToInt(edtPort.Text));
    myIni.WriteString('Proxy', 'User', edtUser.Text);
    myIni.WriteString('Proxy', 'Password', edtPassword.Text);
  end;

  myIni.Free;

	if not (iActive = 0) then begin
	  gProxy.Active := True;
	  gProxy.IpAddr := ProxyServer;
	  gProxy.Port := ProxyPort;
	  gProxy.User := edtUser.Text;
	  gProxy.Password := edtPassword.Text;
	end else begin
	  gProxy.Active := False;
	end;

  ModalResult := mrOk;
end;

procedure TdlgSet.FormCreate(Sender: TObject);
var
  myIni: TIniFile;
begin
  myIni := TIniFile.Create(CurrentPath+'Babyso.ini');
  iActive := myIni.ReadInteger('Proxy', 'Active', 0);

  if iActive = 0 then rbNoProxy.Checked := True
  else if iActive = 1 then rbBrowProxy.Checked := True
  else rbUserProxy.Checked := True;

  if iActive = 1 then begin
    edtServer.Text := myIni.ReadString('Proxy', 'Server', '');
    edtPort.Text := myIni.ReadString('Proxy', 'Port', '');
  end else if iActive = 2 then begin
    edtServer.Text := myIni.ReadString('Proxy', 'Server', '');
    edtPort.Text := myIni.ReadString('Proxy', 'Port', '');
    edtUser.Text := myIni.ReadString('Proxy', 'User', '');
    edtPassword.Text := myIni.ReadString('Proxy', 'Password', '');
  end;

  myIni.Free;
end;

procedure TdlgSet.rbNoProxyClick(Sender: TObject);
begin
  iActive := (Sender as TRadioButton).Tag;

  edtServer.Enabled := rbUserProxy.Checked;
  edtPort.Enabled := rbUserProxy.Checked;
  edtUser.Enabled := rbUserProxy.Checked;
  edtPassword.Enabled := rbUserProxy.Checked;

  if iActive = 2 then begin
    edtServer.Text := '';
    edtPort.Text := '';
    edtUser.Text := '';
    edtPassword.Text := '';
  end;
end;

end.
