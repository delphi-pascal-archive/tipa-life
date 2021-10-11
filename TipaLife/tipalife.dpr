program tipalife;

uses
  Forms,
  uSoldierC in 'uSoldierC.pas' {Form1},
  uSoldier in 'uSoldier.pas',
  uBoard in 'uBoard.pas',
  uEditProgram in 'uEditProgram.pas' {frmEditProgram};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmEditProgram, frmEditProgram);
  Application.Run;
end.
