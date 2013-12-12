unit uSEObj;

interface

uses
  Classes, ComCtrls, IdHTTP, RegExpr, SysUtils, uProxy, uSEO;

type
  TSEObj = class(TThread)
  private
    FName: string;
    FCharSet: string;
    FUrl: string;
    FSeaType: TSeoType;
    FSite: string;
    FKeyword: string;
    FPageCount: integer;
    FBeginTime: string;
    FRegExpr: string;
    FResult: string;
    FResponse: TStatusBar;
    FDataFile: string;
    FProxy: TProxy;
    procedure SetUrl(const Value: string);
    procedure SetContent(const Value: TStatusBar);
    procedure SetRegExpr(const Value: string);
    procedure SetSeaType(const Value: TSeoType);
    procedure SetPageCount(const Value: integer);
    procedure SetKeyword(const Value: string);
    procedure SetSite(const Value: string);
    procedure SetDataFile(const Value: string);
    procedure SetBeginTime(const Value: string);
    procedure SetCharSet(const Value: string);
    procedure SetProxy(const Value: TProxy);
    function GetHttpContent(const aUrl: string; var aContent: string): Boolean;
  protected
    procedure Execute; override;
    procedure ShowStatus(Sender: TObject);
    procedure RankSite(aUrl: string; aSite: string);
    procedure RankKey(aUrl: string; aKey: string; aSite: string; aCount: integer);
    procedure SaveRankToFile(aStr: string);
  public
    property Name: string read FName;
    property CharSet: string read FCharSet write SetCharSet;
    property Url: string read FUrl write SetUrl;
    property SearchType: TSeoType read FSeaType write SetSeaType;
    property Site: string read FSite write SetSite;
    property Keyword: string read FKeyword write SetKeyword;
    property PageCount: integer read FPageCount write SetPageCount default 1;
    property BeginTime: string write SetBeginTime;
    property RegExpr: string read FRegExpr write SetRegExpr;
    property Content: TStatusBar write SetContent;
    property DataFile: string write SetDataFile;
    property Proxy: TProxy read FProxy write SetProxy;
    constructor Create(seoName: string);
  end;

implementation

uses uFunc;

{ TSEObj }

constructor TSEObj.Create(seoName: string);
begin
  inherited Create(True);
  Inc(SeoCount);    //线程计数器加1
  FName := seoName;
  OnTerminate := ShowStatus;
  FreeOnTerminate := True;
end;

procedure TSEObj.Execute;
begin
  inherited;

  if SearchType = stSite then begin
    RankSite(Url, Site);
  end
  else if SearchType = stKeyword then begin
    RankKey(Url, Keyword, Site, PageCount);
  end;

  //为了TStringList分割字段处理方便，日期用“_”连接
  SaveRankToFile(FBeginTime + '|' + Name + '|' + FResult);
end;

function TSEObj.GetHttpContent(const aUrl: string; var aContent: string): Boolean;
var
  idHttp: TIdHttp;
begin
  idHttp := TidHttp.Create(nil);
  try
    idHttp.HandleRedirects := True;
    idHttp.ConnectTimeout := 10000;
    idHttp.ReadTimeout := 30000;
    idHttp.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)';
    if Proxy.Active then begin
      idHttp.ProxyParams.ProxyServer := Proxy.IpAddr;
      idHttp.ProxyParams.ProxyPort := Proxy.Port;
      idHttp.ProxyParams.ProxyUsername := Proxy.User;
      idHttp.ProxyParams.ProxyPassword := Proxy.Password;
    end;
    aContent := idHttp.Get(aUrl);
  finally
    idHttp.Free;
  end;

  Result := True;
end;

procedure TSEObj.RankKey(aUrl: string; aKey: string; aSite:string; aCount: integer);
var
  i, j, iRank: integer;
  rReg: TRegExpr;
  s, sSite, sResponse, sFormatKey: string;
  slLink: TStringList;
begin
  iRank := 0;
  FResult := '0|0';
  sSite := Dewww(aSite);
  sFormatKey := FormatKeyword(aKey, FCharSet);

  rReg := TRegExpr.Create;
  slLink := TStringList.Create;
  try
    aUrl := StringReplace(aUrl, '{$KEYWORD}', sFormatKey, [rfReplaceALL]);
    for i := 0 to aCount - 1 do begin
      if iRank > 0 then break;
      
      s := StringReplace(aUrl, '{$COUNT}', IntToStr(i*10), [rfReplaceALL]);
      s := StringReplace(s, '{$INDEX}', IntToStr(i+1), [rfReplaceALL]);

      GetHttpContent(s, sResponse);
      if FCharSet = 'UTF-8' then sResponse := Utf8ToAnsi(sResponse);

      rReg.Expression := FRegExpr;
      if rReg.Exec(sResponse) then
      repeat
        s := rReg.Match[0];
        if slLink.IndexOf(s) < 0 then  slLink.Add(s);
      until not rReg.ExecNext;

      for j := 0 to slLink.Count - 1 do begin
        if Pos(sSite, slLink[j]) > 0 then begin
          iRank := j + 1;
          FResult := IntToStr(iRank) + '|' + IntToStr(i+1);
          break;
        end;
      end;
      //取消注释下面这句，表示在当前页的排名
      //slLink.Clear;
      Sleep(1000);
    end;
  finally
    rReg.Free;
    slLink.Free;
  end;
end;

procedure TSEObj.RankSite(aUrl: string; aSite: string);
var
  rReg: TRegExpr;
  sResponse: string;
begin
  aUrl := StringReplace(aUrl, '{$SITE}', aSite, [rfReplaceAll]);

  rReg := TRegExpr.Create;
  try
    GetHttpContent(aUrl, sResponse);
    if FCharSet = 'UTF-8' then sResponse := Utf8ToAnsi(sResponse);

    rReg.Expression := FRegExpr;
    if rReg.Exec(sResponse) then FResult := ExtNum(rReg.Match[0])
    else FResult := '0';
  finally
    rReg.Free;
  end;
end;

procedure TSEObj.SaveRankToFile(aStr: string);
var
  vd: TextFile;
begin
  AssignFile(vd, FDataFile);
  if not FileExists(FDataFile) then Rewrite(vd) else Append(vd);
  Writeln(vd, aStr);
  CloseFile(vd);
end;

procedure TSEObj.SetBeginTime(const Value: string);
begin
  FBeginTime := Value;
end;

procedure TSEObj.SetCharSet(const Value: string);
begin
  FCharSet := Value;
end;

procedure TSEObj.SetContent(const Value: TStatusBar);
begin
  FResponse := Value;
end;

procedure TSEObj.SetDataFile(const Value: string);
begin
  FDataFile := Value;
end;

procedure TSEObj.SetKeyword(const Value: string);
begin
  FKeyword := Value;
end;

procedure TSEObj.SetPageCount(const Value: integer);
begin
  FPageCount := Value;
end;

procedure TSEObj.SetProxy(const Value: TProxy);
begin
  FProxy := Value;
end;

procedure TSEObj.SetRegExpr(const Value: string);
begin
  FRegExpr := Value;
end;

procedure TSEObj.SetSeaType(const Value: TSeoType);
begin
  FSeaType := value;
end;

procedure TSEObj.SetSite(const Value: string);
begin
  FSite := Value;
end;

procedure TSEObj.SetUrl(const Value: string);
begin
  FUrl := value;
end;

procedure TSEObj.ShowStatus(Sender: TObject);
begin
  if SearchType = stSite then
    FResponse.Panels[0].Text := '查询线程[' + Site + '|' + Name + ']执行完毕！';
  if SearchType = stKeyword then
    FResponse.Panels[0].Text := '查询线程[' + Keyword + '|' + Site + '|' + Name + ']执行完毕！';

  Dec(SeoCount);    //线程计数器减1
  if SeoCount = 0 then begin
    FResponse.Panels[0].Text := '查询全部结束';
    Sleep(2000);
    if GetOnlineStatus then FResponse.Panels[0].Text := '在线状态'
    else FResponse.Panels[0].Text := '离线状态';
  end;
end;

end.
