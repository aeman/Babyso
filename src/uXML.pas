unit uXML;

interface

uses
   MSXML,XMLDOM,SysUtils,Dialogs,ComObj;

type
  EXMLError              = class(Exception);
  EXMLLoadError          = class(EXMLError);
  EXMLSaveError          = class(EXMLError);
  EXMLParseError         = class(EXMLError);

  procedure   saveXMLWithFormat(doc,fileName:string);
  function   formatXMLNode(element:IXMLDOMNode;indent:integer):String;
  function   formatXMLDoc(doc:IXMLDOMDocument;indent:integer):String;

implementation

procedure   saveXMLWithFormat(doc:String;fileName:string);
  var
      saveXMLDOM:IXMLDOMDocument;
  begin
      saveXMLDOM:=CreateOleObject('MSXML.DOMDocument')   as   IXMLDOMDocument;
      saveXMLDom.loadXML(doc);
      saveXMLDOM.loadXML(formatXMLDoc(saveXMLDOM,1));
      saveXMLDOM.save(fileName);
  end;

  function   formatXMLDoc(doc:IXMLDOMDocument;indent:integer):String;
  var
      sRes:string;
      i:integer;
  begin
      sRes:='';
      for   i:=0   to   doc.childNodes.length-1   do
      begin
          sRes:=sRes+formatXMLNode(doc.childNodes.item[i],indent);
      end;
      result:='<?xml   version="1.0"   encoding="gb2312"?>'+sRes;
  end;

  function   formatXMLNode(element:IXMLDOMNode;indent:integer):String;
  var
      sBlank,sRes:string;
      i:integer;
  begin
      sBlank:='';
      for   i:=0   to   indent   do
          sBlank:=sBlank+'   ';
      if   (element.nodeType=ELEMENT_NODE)   and   (element.hasChildNodes)
          and   (element.childNodes.item[0].nodetype<>TEXT_NODE)   then
      begin
          sRes:=sBlank+'<'+element.NodeName;
          for   i:=0   to   element.attributes.length-1   do
              sRes:=sRes+'   '+element.attributes.item[i].nodeName
                  +'="'+element.attributes.item[i].text+'"';
          sRes:=sRes+'>'+#13;
          indent:=indent+1;
          for   i:=0   to   element.childNodes.length-1   do
              sRes:=sRes+formatXMLNode(element.childNodes.item[i],indent);
          sRes:=sRes+sBlank+'</'+element.NodeName+'>';
      end
      else   if   element.NodeType<>PROCESSING_INSTRUCTION_NODE then
          sRes:=sRes+sBlank+element.XML+#13;
      result:=sRes;
  end;

end.
