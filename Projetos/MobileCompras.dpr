program MobileCompras;

uses
  System.StartUpCopy,
  FMX.Forms,
  UCompras in 'UCompras.pas' {Form1},
  Loading in 'Loading.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
