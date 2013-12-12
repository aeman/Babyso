参数说明：f文件名、s写入或读取的文件内容、hs文件头、b是否读写文件头
UTF-8文件写入函数
程序代码 程序代码
procedure SaveUTF(f:string;s:string;b:boolean=true);
var
  ms:TMemoryStream;
  hs:String;
begin
  if s='' then exit;
  ms:=TMemoryStream.Create;
  if b then begin
    hs:=#$EF#$BB#$BF;
    ms.Write(hs[1],3);
  end;
  s:=AnsiToUtf8(s);
  ms.Write(s[1],Length(s));
  ms.Position:=0;
  ms.SaveToFile(f);
  ms.Free;
end;

UtF-8文件读取函数
程序代码 程序代码
function LoadUTF(f:string;b:boolean=true):string;
var
  ms:TMemoryStream;
  s,hs:string;
begin
  Result:='';
  if not FileExists(f) then exit;
  ms:=TMemoryStream.Create;
  ms.LoadFromFile(f);
  if b then begin
    SetLength(hs,3);
    ms.Read(hs[1],3);
    if hs<>#$EF#$BB#$BF then begin ms.Free; exit; end;
    SetLength(s,ms.Size-3);
    ms.Read(s[1],ms.Size-3);
  end else begin
    SetLength(s,ms.Size);
    ms.Read(s[1],ms.Size);
  end;
  Result:=Utf8ToAnsi(s);
  ms.Free;
end;


Unicode文件写入函数
程序代码 程序代码
procedure SaveUnicode(f:string;s:string;b:boolean=true);
var
  ms:TMemoryStream;
  hs:string;
  ws:WideString;
begin
  if s='' then exit;
  ms:=TMemoryStream.Create;
  if b then begin
    hs:=#$FF#$FE;
    ms.Write(hs[1],2);
  end;
  ws:=WideString(s);
  ms.Write(ws[1],Length(ws)*2);
  ms.Position:=0;
  ms.SaveToFile(f);
  ms.Free;
end;

Unicode文件读取函数
程序代码 程序代码
function LoadUnicode(f:string;b:boolean=true):string;
var
  ms:TMemoryStream;
  hs:String;
  ws:WideString;
begin
  Result:='';
  if not FileExists(f) then exit;
  ms:=TMemoryStream.Create;
  ms.LoadFromFile(f);
  if b then begin
    SetLength(hs,2);
    ms.Read(hs[1],2);
    if hs<>#$FF#$FE then begin ms.Free; exit; end;
    SetLength(ws,(ms.Size-2) div 2);
    ms.Read(ws[1],ms.Size-2);
  end else begin
    SetLength(ws,ms.Size div 2);
    ms.Read(ws[1],ms.Size);
  end;
  Result:=AnsiString(ws);
  ms.Free;
end;

