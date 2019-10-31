program InfoSis;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFMenu in 'UFMenu.pas' {FMenu},
  Client.VO in 'VOs\Client.VO.pas',
  Client.Controller in 'Controllers\Client.Controller.pas',
  JSon.VO in 'VOs\JSon.VO.pas',
  JSon.Controller in 'Controllers\JSon.Controller.pas',
  XML.Controller in 'Controllers\XML.Controller.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMenu, FMenu);
  Application.Run;
end.
