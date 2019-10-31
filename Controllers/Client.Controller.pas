unit Client.Controller;

interface

uses
  System.Classes,
  System.SysUtils,
  Client.VO;

type
  TClientController = class(TPersistent)
  private
    { private declarations }
    class var FInstance: TClientController;
    constructor CreatePrivate;

    class function StrToEnumerado(out ok: boolean; const s: string; const AString: array of string; const AEnumerados: array of variant): variant;
    class function EnumeradoToStr(const t: variant; const AString: array of string; const AEnumerados: array of variant): variant;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    class function GetInstance: TClientController;

    class function StateToStr(const t: TState): string;
    class function StrToTState(out ok: boolean; const s: string): TState;
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
//Método retirado o ACBr
class function TClientController.EnumeradoToStr(const t: variant; const AString: array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := '';
  for i := Low(AEnumerados) to High(AEnumerados) do
    if t = AEnumerados[i] then
      result := AString[i];
end;

class function TClientController.GetInstance: TClientController;
begin
  if not Assigned(FInstance) then
    FInstance := TClientController.CreatePrivate;

  Result := FInstance;
end;
//Método retirado o ACBr
class function TClientController.StrToEnumerado(out ok: boolean; const s: string; const AString: array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := -1;
  for i := Low(AString) to High(AString) do
    if AnsiSameText(s, AString[i]) then
      result := AEnumerados[i];
  ok := result <> -1;
  if not ok then
    result := AEnumerados[0];
end;

class function TClientController.StrToTState(out ok: boolean; const s: string): TState;
begin
  Result := StrToEnumerado(ok, s, ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'],
                                  [stAC, stAL, stAP, stAM, stBA, stCE, stDF, stES, stGO, stMA, stMT, stMS, stMG, stPA, stPB, stPR, stPE, stPI, stRJ, stRN, stRS, stRO, stRR, stSC, stSP, stSE, stTO]);
end;

class function TClientController.StateToStr(const t: TState): string;
begin
  Result := EnumeradoToStr(t, ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'],
                              [stAC, stAL, stAP, stAM, stBA, stCE, stDF, stES, stGO, stMA, stMT, stMS, stMG, stPA, stPB, stPR, stPE, stPI, stRJ, stRN, stRS, stRO, stRR, stSC, stSP, stSE, stTO]);
end;

end.
