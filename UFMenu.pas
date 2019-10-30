unit UFMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Client.VO,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

type
  TFMenu = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtCliNome: TEdit;
    edtCliIdentidade: TEdit;
    edtCliCPF: TEdit;
    edtCliTelefone: TEdit;
    edtCliEmail: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    gbEndereco: TGroupBox;
    edtEndCEP: TEdit;
    edtEndLogradouro: TEdit;
    edtEndNumero: TEdit;
    edtEndComplemento: TEdit;
    edtEndBairro: TEdit;
    edtEndCidade: TEdit;
    edtEndEstado: TEdit;
    edtEndPais: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Bairro: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Panel2: TPanel;
    btnNovo: TButton;
    btnSalvar: TButton;
    btnSair: TButton;
    Button1: TButton;
    procedure btnNovoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    vCliente  : TClientVO;
    vEndereco : TAddressVO;

    procedure LimparControles;
    procedure LimpaEstanciaObjeto;

    procedure ValidarNumeros(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  public
    { Public declarations }
  end;

var
  FMenu: TFMenu;

implementation

{$R *.fmx}

procedure TFMenu.btnNovoClick(Sender: TObject);
begin
  LimparControles;
  LimpaEstanciaObjeto;
end;

procedure TFMenu.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFMenu.FormCreate(Sender: TObject);
begin
  edtCliCPF.OnKeyDown      := ValidarNumeros;
  edtCliTelefone.OnKeyDown := ValidarNumeros;
  edtEndCEP.OnKeyDown      := ValidarNumeros;
  edtEndNumero.OnKeyDown   := ValidarNumeros;
end;

procedure TFMenu.LimpaEstanciaObjeto;
begin
  if Assigned(vCliente) then
  begin
    FreeAndNil(vCliente);
  end;

  if Assigned(vEndereco) then
  begin
    FreeAndNil(vEndereco);
  end;

  vCliente  := TClientVO.Create;
  vEndereco := TAddressVO.Create;
end;

procedure TFMenu.LimparControles;
begin
  edtCliNome.Text        := '';
  edtCliIdentidade.Text  := '';
  edtCliCPF.Text         := '';
  edtCliTelefone.Text    := '';
  edtCliEmail.Text       := '';
  edtEndCEP.Text         := '';
  edtEndLogradouro.Text  := '';
  edtEndNumero.Text      := '';
  edtEndComplemento.Text := '';
  edtEndBairro.Text      := '';
  edtEndCidade.Text      := '';
  edtEndEstado.Text      := '';
  edtEndPais.Text        := '';
end;

procedure TFMenu.ValidarNumeros(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if (KeyChar In ['A'..'Z', 'a'..'z', '@','!','#','$', '%','^',
              '&','`','~','*','(',')','-','_','=','+','|','/','<','>',
               '"',';',':','[',']','{','}']) then
  begin
    Key := 0;
    Abort;
  end;
end;

end.
