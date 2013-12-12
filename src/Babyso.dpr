program Babyso;

uses
  Forms,
  RegExpr in 'RegExpr.pas',
  uAbout in 'uAbout.pas' {AboutBox},
  uFunc in 'uFunc.pas',
  uImp in 'uImp.pas' {dlgImp},
  uMain in 'uMain.pas' {fmMain},
  uProxy in 'uProxy.pas',
  uReg in 'uReg.pas' {dlgReg},
  uSEObj in 'uSEObj.pas',
  uSet in 'uSet.pas' {dlgSet},
  uSE in 'uSE.pas' {dlgSE},
  uHelp in 'uHelp.pas' {twHelp};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Babyso-’æ≥§–°÷˙ ÷';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TtwHelp, twHelp);
  Application.Run;
end.
