unit Client.VO;

interface

uses
  System.Classes;

type
  TAddressVO = class;

  TClientVO = class(TPersistent)
  private
    { private declarations }
    FNome: string;
    FIdentidade: Integer;
    FCPF: Integer;
    FTelefone: string;
    FEmail: string;
    FEndereco: TAddressVO;
    procedure SetNome(const Value: string);
    procedure SetIdentidade(const Value: Integer);
    procedure SetCPF(const Value: Integer);
    procedure SetTelefone(const Value: string);
    procedure SetEmail(const Value: string);
    procedure SetEndereco(const Value: TAddressVO);
  protected
    { protected declarations }
  public
    { public declarations }
    property Nome : string read FNome write SetNome;
    property Identidade : Integer read FIdentidade write SetIdentidade;
    property CPF : Integer read FCPF write SetCPF;
    property Telefone : string read FTelefone write SetTelefone;
    property Email : string read FEmail write SetEmail;
    property Endereco : TAddressVO read FEndereco write SetEndereco;
  published
    { published declarations }
  end;

  TState = (stAC, stAL, stAP, stAM, stBA, stCE, stDF, stES, stGO, stMA, stMT, stMS, stMG, stPA, stPB, stPR, stPE, stPI, stRJ, stRN, stRS, stRO, stRR, stSC, stSP, stSE, stTO);

  TAddressVO = class(TPersistent)
  private
    FCep: Integer;
    FLogradouro: string;
    FNumero: string;
    FComplemento: string;
    FBairro: string;
    FCidade: string;
    FEstado: TState;
    FPais: string;
    procedure SetCep(const Value: Integer);
    procedure SetLogradouro(const Value: string);
    procedure SetNumero(const Value: string);
    procedure SetComplemento(const Value: string);
    procedure SetBairro(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetEstado(const Value: TState);
    procedure SetPais(const Value: string);
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    property Cep : Integer read FCep write SetCep;
    property Logradouro : string read FLogradouro write SetLogradouro;
    property Numero : string read FNumero write SetNumero;
    property Complemento : string read FComplemento write SetComplemento;
    property Bairro : string read FBairro write SetBairro;
    property Cidade : string read FCidade write SetCidade;
    property Estado : TState read FEstado write SetEstado;
    property Pais : string read FPais write SetPais;
  published
    { published declarations }
  end;

implementation

{ TClientVO }

procedure TClientVO.SetCPF(const Value: Integer);
begin
  FCPF := Value;
end;

procedure TClientVO.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TClientVO.SetEndereco(const Value: TAddressVO);
begin
  FEndereco := Value;
end;

procedure TClientVO.SetIdentidade(const Value: Integer);
begin
  FIdentidade := Value;
end;

procedure TClientVO.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TClientVO.SetTelefone(const Value: string);
begin
  FTelefone := Value;
end;

{ TAddressVO }

procedure TAddressVO.SetBairro(const Value: string);
begin
  FBairro := Value;
end;

procedure TAddressVO.SetCep(const Value: Integer);
begin
  FCep := Value;
end;

procedure TAddressVO.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TAddressVO.SetComplemento(const Value: string);
begin
  FComplemento := Value;
end;

procedure TAddressVO.SetEstado(const Value: TState);
begin
  FEstado := Value;
end;

procedure TAddressVO.SetLogradouro(const Value: string);
begin
  FLogradouro := Value;
end;

procedure TAddressVO.SetNumero(const Value: string);
begin
  FNumero := Value;
end;

procedure TAddressVO.SetPais(const Value: string);
begin
  FPais := Value;
end;

end.
