unit Client.Controller;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TClientController = class(TPersistent)
  private
    { private declarations }
    class var FInstance: TClientController;
    constructor CreatePrivate;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    class function GetInstance: TClientController;
  published
    { published declarations }
  end;

implementation

{ TClientController }

constructor TClientController.Create;
begin
   raise Exception.Create('Para obter uma instância utilize T...GetInstance !');
end;

constructor TClientController.CreatePrivate;
begin
  inherited Create;
end;

class function TClientController.GetInstance: TClientController;
begin
  if not Assigned(FInstance) then
    FInstance := TClientController.CreatePrivate;

  Result := FInstance;
end;

end.
