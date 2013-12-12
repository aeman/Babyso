unit uFunc;

interface

uses
  Classes, SysUtils, WinInet, Windows, IniFiles, Registry, RegExpr, uProxy;

var
  CurrentPath: string;  //系统当前路径，带“\”号
  CurrentNode: string;  //系统当前选中的节点
  CurrentSE: integer;   //当前使用的搜索引擎

  SeoList: TList;       //搜索引擎列表
  gProxy: TProxy;     //搜索引擎代理
  SeoCount: integer;    //本次启动的搜索线程数量

function IsDigit(ch: char): boolean;
function IsExprChar(ch: char): boolean;
function ExtNum(aStr: string): string;
function CheckValidNum(aStr: string): Boolean;
function Dewww(aSite: string): string;
function KeyToGB2312(const aKey: string): string;
function KeyToUTF8(const aKey: string): string;
function FormatKeyword(aKey: string; aCharSet: string): string;
function GetProxyInformation: string;
procedure GetProxyServer(protocol: string; var ProxyServer: string;
  var ProxyPort: Integer);
function CheckNetConnected: boolean;
function CheckOffLine: boolean;
function GetOnlineStatus : boolean;
function IsClassRegistered(GUID: TGUID): Boolean;
function ValidSite(aSite: string): boolean;
function ValidKey(aKey: string): boolean;
procedure GetElementFromUrl(var slEm: TStringList; aUrl: string);
function GenSiteExprFromUrl(aUrl:string; aSite: string): string;
function GenExprFromPhrase(aPhrase: string): string;
function GenKeyExprFromUrl(aUrl: string; aKey: string; var aDiff: TStringList): string;
function FormatPageCount(aElm: string): string;
function EncodeXmlChar(aStr: string): string;
function DecodeXmlChar(aStr: string): string;
function EnCodeRegChar(aStr: string): string;
procedure DiffAnalyser(var sl1: TStrings; var sl2: TStrings; var slDiff: TStrings);
//function SaveSeToXml(aSeo: TSeo): Boolean;
procedure LoadProxy(proxy: TProxy);
procedure GetBuildInfo(var V1, V2, V3, V4: Word);
function IsExistNewVersion(aNewM, aNewL, aOldM, aOldL: DWORD):Boolean;
procedure SeparateVerStr(s: string; var aNewM, aNewL: DWORD);

implementation

function ExtNum(aStr: string): string;
var
  i: Integer;
  stemp : string;
begin
  i := 0;
  while i < length(aStr) + 1 do begin
    if IsDigit(aStr[i]) then stemp := stemp + aStr[i];
    inc(i);
  end;
  Result := stemp;
end;

function CheckValidNum(aStr: string): Boolean;
var
  i: Integer;
  b: Boolean;
begin
  i := 1;
  b := True;
  while i < length(aStr) + 1 do begin
    if not IsDigit(aStr[i]) then begin
      b := False;
      Break;
    end;
    inc(i);
  end;

  Result := b;
end;

function IsDigit(ch: char): boolean;
begin
  Result := ch in ['0'..'9'];
end;

function IsExprChar(ch: char): boolean;
begin
  Result := ch in ['0'..'9', ',', '.'];
end;

function Dewww(aSite: string): string;
var
  s: string;
begin
  s := Copy(aSite, 1, 4);
  if s = 'www.' then Delete(aSite, 1, 4);
  Result := aSite;
end;

function KeyToGB2312(const aKey: string): string;
var
  i: Integer;
begin
  for i := 1 to Length(aKey) do
    Result := Result + '%' + IntToHex(Byte(aKey[i]), 2);
end;

function KeyToUTF8(const aKey: string): string;
var
 Utf8: string;
 i: Integer;
 B: Byte;
begin
 Result := '';
 {AnsiToUtf8是现成的Delphi支持的RTL函数}
 Utf8:= AnsiToUtf8(aKey);
 for i := 1 to Length(Utf8) do begin
   B := Ord(Utf8[i]);
   Result := Result + Format('%%%X', [B]);
 end;
end;

function FormatKeyword(aKey, aCharSet: string): string;
begin
  if aCharSet = 'UTF-8' then Result := KeyToUTF8(aKey)
  else if aCharSet = 'GB2312' then Result := KeyToGB2312(aKey)
  else Result := aKey;
end;

function GetProxyInformation: string;
var
  ProxyInfo: PInternetProxyInfo;
  Len: LongWord;
begin
  Result := '';
  Len := 4096;
  GetMem(ProxyInfo, Len);
  try
    if InternetQueryOption(nil, INTERNET_OPTION_PROXY, ProxyInfo, Len) then
    if ProxyInfo^.dwAccessType = INTERNET_OPEN_TYPE_PROXY then begin
      Result := ProxyInfo^.lpszProxy
    end;
  finally
    FreeMem(ProxyInfo);
  end;
end;

procedure GetProxyServer(protocol: string; var ProxyServer: string;
  var ProxyPort: Integer);
var
  i: Integer;
  proxyinfo: string;
begin
  ProxyServer := '';
  ProxyPort := 0;

  proxyinfo := GetProxyInformation;
  if proxyinfo = '' then Exit;

  protocol := protocol + '=';

  i := Pos(protocol, proxyinfo);
  if i > 0 then begin
    Delete(proxyinfo, 1, i + Length(protocol));
    i := Pos(';', ProxyServer);
    if i > 0 then proxyinfo := Copy(proxyinfo, 1, i - 1);
  end;

  i := Pos(':', proxyinfo);
  if i > 0 then begin
    ProxyPort := StrToIntDef(Copy(proxyinfo, i + 1, Length(proxyinfo) - i), 0);
    ProxyServer := Copy(proxyinfo, 1, i - 1)
  end;
end;

function CheckNetConnected: boolean;
begin
  Result := InternetCheckConnection('http://www.goole.cn/', 1, 0);
end;

function CheckOffLine: boolean;
var
 ConnectState: DWORD;
 StateSize: DWORD;
begin
  ConnectState := 0;
  StateSize:= SizeOf(ConnectState);
  Result:= False;

  if InternetQueryOption(nil, INTERNET_OPTION_CONNECTED_STATE, @ConnectState, StateSize) then
    if (ConnectState and INTERNET_STATE_DISCONNECTED) <> 2 then Result:= True;
end;

function GetOnlineStatus : Boolean;
var
  ConTypes : Integer;
begin
 ConTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN + INTERNET_CONNECTION_PROXY;
 Result := InternetGetConnectedState(@ConTypes, 0);
end;

function IsClassRegistered(GUID: TGUID): Boolean;
var 
  ClassID: string;
begin
  with TRegistry.Create do
  try
    ClassID := GUIDToString(GUID);
    RootKey := HKEY_CLASSES_ROOT;

    Result := OpenKey('\CLSID\' + ClassID, False);
  finally
    Free;
  end;
end;

function ValidSite(aSite: string): boolean;
begin
  Result := ExecRegExpr('[www.|][a-zA-Z\s\d\.\_\-\=\%].[com|net|org|cn|biz|info]', aSite);
end;

function ValidKey(aKey: string): boolean;
begin
  Result := not ExecRegExpr('[\\\/\:\?\*\"\<\>\|]', aKey);
end;

procedure GetElementFromUrl(var slEm: TStringList; aUrl: string);
var
  sEmStr: string;
begin
  sEmStr := Copy(aUrl, Pos('?', aUrl)+1);
  slEm.Delimiter := '&';
  slEm.DelimitedText := sEmStr;
end;

function GenSiteExprFromUrl(aUrl:string; aSite: string): string;
var
  i: Integer;
  sHttp: string;
  slEm: TStringList;
begin
  sHttp := Copy(aUrl, 1, Pos('?', aUrl));

  slEm := TStringList.Create;
  try
    GetElementFromUrl(slEm, aUrl);
    for i := 0 to slEm.Count - 1 do
      if Pos(aSite, slEm.Strings[i]) > 0 then begin
        sHttp := sHttp + slEm.Strings[i];
        Break;
      end;
    sHttp := StringReplace(sHttp, aSite, '{$SITE}', [rfReplaceAll]);
  finally
    slEm.Free;
  end;

  Result := sHttp;
end;

function GenKeyExprFromUrl(aUrl: string; aKey: string; var aDiff: TStringList): string;
var
  i: Integer;
  s, sHttp: string;
  slEm: TStringList;
begin
  sHttp := Copy(aUrl, 1, Pos('?', aUrl));

  slEm := TStringList.Create;
  try
    GetElementFromUrl(slEm, aUrl);
    for i := 0 to slEm.Count - 1 do
      if Pos(aKey, slEm.Strings[i]) > 0 then begin
        s := StringReplace(slEm.Strings[i], aKey, '{$KEYWORD}', [rfReplaceAll]);
        sHttp := sHttp + s + '&';
        Break;
      end;

    for i := 0 to aDiff.Count - 1 do begin
      s := FormatPageCount(aDiff.Strings[i]);
      sHttp := sHttp + s;
      if i < aDiff.Count - 1 then sHttp := sHttp + '&';
    end;
  finally
    slEm.Free;
  end;

  Result := sHttp;
end;

function FormatPageCount(aElm: string): string;
var
  s, sNum: string;
begin
  if (Pos('UTF-8', UpperCase(aElm)) > 0) or (Pos('GB2312', UpperCase(aElm)) > 0) then begin
    s := aElm;
  end else begin
    sNum := ExtNum(aElm);
    if StrToInt(sNum) >= 10 then
      s := StringReplace(aElm, sNum, '{$COUNT}', [rfReplaceAll])
    else
      s := StringReplace(aElm, sNum, '{$INDEX}', [rfReplaceAll]);
  end;

  Result := s;
end;

function GenExprFromPhrase(aPhrase: string): string;
var
  i: Integer;
  stemp: string;
  slMark: TStringList;
  IsPriorDigit: Boolean;
begin
  i := 0;
  IsPriorDigit := False;
  slMark := TStringList.Create;

  //获取字符串中所有的数字组合
  while i < Length(aPhrase) do begin
    if IsExprChar(aPhrase[i]) then begin
    	stemp := stemp + aPhrase[i];      
    end else begin
    	if IsPriorDigit then begin
    		slMark.Add(stemp);
    		stemp := '';
    	end;
    end;

    IsPriorDigit := IsExprChar(aPhrase[i]);
    inc(i);
  end;

  aPhrase := EnCodeRegChar(aPhrase);
  for i := 0 to slMark.Count - 1 do begin
    aPhrase := StringReplace(aPhrase, slMark.Strings[i], '+[\d\,\.]+', [rfReplaceAll]);
  end;
  slMark.Free;

  Result := aPhrase;
end;

function EncodeXmlChar(aStr: string): string;
begin
  aStr := StringReplace(aStr, '&', '&amp;', [rfReplaceAll]);
  aStr := StringReplace(aStr, '<', '&lt;', [rfReplaceAll]);
  aStr := StringReplace(aStr, '>', '&gt;', [rfReplaceAll]);
  Result := aStr;
end;

function DecodeXmlChar(aStr: string): string;
begin
  aStr := StringReplace(aStr, '&amp;', '&', [rfReplaceAll]);
  aStr := StringReplace(aStr, '&lt;', '<', [rfReplaceAll]);
  aStr := StringReplace(aStr, '&gt;', '>', [rfReplaceAll]);
  Result := aStr;
end;

function EnCodeRegChar(aStr: string): string;
begin
  aStr := StringReplace(aStr, ' ', '\s', [rfReplaceAll]);
  aStr := StringReplace(aStr, '/', '\/', [rfReplaceAll]);
  Result := aStr;
end;

procedure DiffAnalyser(var sl1: TStrings; var sl2: TStrings; var slDiff: TStrings);
var
  i: Integer;
begin
  slDiff.Clear;
  for i := 0 to sl1.Count - 1 do begin
    if i > sl2.Count then Break;
    if sl1.Strings[i] <> sl2.Strings[i] then slDiff.Add(sl1.Strings[i]);
  end;
end;

{
function SaveSeToXml(aSeo: TSeo): Boolean;
var
  xmlDoc: TXMLDocument;
  xmlRoot, xmlNode, xmlSite, xmlKey: IXMLNode;
begin
  xmlDoc := TXMLDocument.Create(nil);
  try
    xmlDoc.LoadFromFile(CurrentPath + 'se.xml');
    xmlDoc.Active := True;
    xmlRoot := xmlDoc.DocumentElement;

    xmlNode := xmlRoot.AddChild('Serach');
    xmlNode.Attributes['Target'] := aSeo.FTarget;

    xmlSite := xmlNode.AddChild('name');
    xmlSite.NodeValue := aSeo.FName;
    xmlSite := xmlNode.AddChild('charset');
    xmlSite.NodeValue := aSeo.FCharSet;

    xmlSite := xmlNode.AddChild('site');
    xmlKey := xmlSite.AddChild('url');
    xmlKey.NodeValue := aSeo.FSiteUrl;
    xmlKey := xmlSite.AddChild('regexpr');
    xmlKey.NodeValue := aSeo.FSiteUrl;

    xmlSite := xmlNode.AddChild('keyword');
    xmlKey := xmlSite.AddChild('url');
    xmlKey.NodeValue := aSeo.FKeyUrl;
    xmlKey := xmlSite.AddChild('regexpr');
    xmlKey.NodeValue := aSeo.FKeyExpr;
    xmlKey := xmlSite.AddChild('page');
    xmlKey.NodeValue := aSeo.FPages;

    xmlDoc.SaveToFile(CurrentPath + 'se.xml');
    xmlDoc.Active := False;
  finally
    xmlDoc.Free;
  end;

  Result := True;
end;
}

procedure LoadProxy(proxy: TProxy);
var
  myIni: TIniFile;
begin
  myIni := TIniFile.Create(CurrentPath+'Babyso.ini');
  proxy.Active := (myIni.ReadInteger('Proxy', 'Active', 0) <> 0);
  proxy.IpAddr := myIni.ReadString('Proxy', 'Server', '');
  proxy.Port := myIni.ReadInteger('Proxy', 'Port', 0);
  proxy.User := myIni.ReadString('Proxy', 'User', '');
  proxy.Password := myIni.ReadString('Proxy', 'Password', '');
  myIni.Free;
end;

procedure GetBuildInfo(var V1, V2, V3, V4: Word);
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do begin
    V1 := dwFileVersionMS shr 16;
    V2 := dwFileVersionMS and $FFFF;
    V3 := dwFileVersionLS shr 16;
    V4 := dwFileVersionLS and $FFFF;
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

function IsExistNewVersion(aNewM, aNewL, aOldM, aOldL: DWORD):Boolean;
begin
  if aNewM = aOldM then Result := (aNewL > aOldL)
  else Result := (aNewM > aOldM);
end;

procedure SeparateVerStr(s: string; var aNewM, aNewL: DWORD);
const
  Separator = '.';
var
  p:WORD;
  v1,v2,v3,v4:WORD;
begin
  if Length(s) = 0 then Exit;

  p:=pos(Separator, s);
  v1:=StrToInt(copy(s,1,p-1));
  Delete(s,1,p);
  p:=Pos(Separator,s);
  v2:=StrToInt(copy(s,1,p-1));
  Delete(s,1,p);
  p:=Pos(Separator,s);
  v3:=StrToInt(copy(s,1,p-1));
  Delete(s,1,p);
  v4:=StrToInt(s);

  aNewM := v1*$10000+v2;
  aNewL := v3*$10000+v4;
end;

end.


