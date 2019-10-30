program InfoSis;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFMenu in 'UFMenu.pas' {FMenu},
  Client.VO in 'VOs\Client.VO.pas',
  Client.Controller in 'Controllers\Client.Controller.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMenu, FMenu);
  Application.Run;
end.
