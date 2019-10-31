unit JSon.Controller;

interface

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  Data.DBXJSONReflect,
  JSon.VO;

type
  TJsonController = class(TPersistent)
  private
    { private declarations }
    class var FInstance: TJsonController;
    constructor CreatePrivate;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    class function GetInstance: TJsonController;
    class function JSONToObject(json: TJSONObject): TJsonVO;
  published
    { published declarations }
  end;

implementation

{ TJsonController }

constructor TJsonController.Create;
begin
   raise Exception.Create('Para obter uma instância utilize T...GetInstance !');
end;

constructor TJsonController.CreatePrivate;
begin
  inherited Create;
end;

class function TJsonController.GetInstance: TJsonController;
begin
  if not Assigned(FInstance) then
    FInstance := TJsonController.CreatePrivate;

  Result := FInstance;
end;

class function TJsonController.JSONToObject(json: TJSONObject): TJsonVO;
var
  vRetornoJSON : TJsonVO;
begin
  try
    vRetornoJSON := TJsonVO.Create;

    vRetornoJSON.logradouro  := JSON.Get('logradouro').JsonValue.Value;
    vRetornoJSON.cep         := JSON.Get('cep').JsonValue.Value;
    vRetornoJSON.localidade  := JSON.Get('localidade').JsonValue.Value;
    vRetornoJSON.bairro      := JSON.Get('bairro').JsonValue.Value;
    vRetornoJSON.uf          := JSON.Get('uf').JsonValue.Value;
    vRetornoJSON.complemento := JSON.Get('complemento').JsonValue.Value;
    vRetornoJSON.ibge        := JSON.Get('ibge').JsonValue.Value;
    vRetornoJSON.unidade     := JSON.Get('unidade').JsonValue.Value;
    vRetornoJSON.gia         := JSON.Get('gia').JsonValue.Value;
  finally
    Result := vRetornoJSON;
  end;
end;

end.
