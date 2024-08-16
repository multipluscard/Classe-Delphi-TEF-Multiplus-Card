program projTEFMultiplus;

uses
  Vcl.Forms,
  uprinc in 'uprinc.pas' {frmprinc},
  uMultiplusTEF in 'classes\uMultiplusTEF.pas',
  tbotao in 'classes\tbotao.pas',
  uMultiplusTypes in 'classes\uMultiplusTypes.pas',
  uwebtefmp in 'classes\uwebtefmp.pas' {frmwebtef},
  uescpos in 'classes\uescpos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmprinc, frmprinc);
  Application.Run;
end.
