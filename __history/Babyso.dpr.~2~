program Babyso;

{ Reduce EXE size by disabling as much of RTTI as possible (delphi 2009/2010) }
{$IF CompilerVersion >= 21.0}
  {$WEAKLINKRTTI ON}
  {$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}

uses
  Forms,
  RegExpr in 'src\RegExpr.pas',
  uAbout in 'src\uAbout.pas' {AboutBox},
  uFunc in 'src\uFunc.pas',
  uHelp in 'src\uHelp.pas' {twHelp},
  uImp in 'src\uImp.pas' {dlgImp},
  uMain in 'src\uMain.pas' {fmMain},
  uProxy in 'src\uProxy.pas',
  uSE in 'src\uSE.pas' {dlgSE},
  uSEObj in 'src\uSEObj.pas',
  uSet in 'src\uSet.pas' {dlgSet},
  MSXML2_TLB in 'src\MSXML2_TLB.pas',
  uXML in 'src\uXML.pas',
  uSEO in 'src\uSEO.pas',
  uSubmit in 'src\uSubmit.pas' {dlgSubmit};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Babyso-’æ≥§–°÷˙ ÷';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
