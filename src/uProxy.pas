unit uProxy;

interface

type
  TProxy = class(TObject)
  private
    FIpAddr: string;
    FPort: integer;
    FUser: string;
    FPassword: string;
    FActive: boolean;
    procedure SetActive(const Value: boolean);
    procedure SetIpAddr(const Value: string);
    procedure SetPort(const Value: integer);
    procedure SetPassword(const Value: string);
    procedure SetUser(const Value: string);
  public
    property Active: boolean read FActive write SetActive default False;
    property IpAddr: string read FIpAddr write SetIpAddr;
    property Port: integer read FPort write SetPort;
    property User: string read FUser write SetUser;
    property Password: string read FPassword write SetPassword;
    constructor Create();
  end;

implementation

{ TProxy }

constructor TProxy.Create();
begin
  inherited Create();
  FActive := False;
end;

procedure TProxy.SetActive(const Value: boolean);
begin
  FActive := Value;
  if not FActive then begin
    FIpAddr := '';
    FPort := 0;
  end;
end;

procedure TProxy.SetIpAddr(const Value: string);
begin
  FIpAddr := Value;
end;

procedure TProxy.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TProxy.SetPort(const Value: integer);
begin
  FPort := Value;
end;

procedure TProxy.SetUser(const Value: string);
begin
  FUser := Value;
end;

end.
