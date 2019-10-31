unit UFMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Client.VO,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, System.RegularExpressions,
  Winapi.Windows, FMX.ListBox, REST.Types, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.Rtti, System.Bindings.Outputs, Data.Bind.Components, REST.Client,
  Data.Bind.ObjectScope, System.JSON, System.Generics.Collections, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, XML.Controller, IdMessage, IdBaseComponent, IdText,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP, IdServerIOHandler, IdSSL, IdSSLOpenSSL,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdAttachmentFile;

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
    btnConsultaCEP: TButton;
    edtEndEstado: TComboBox;
    RESTRequest: TRESTRequest;
    RESTClient: TRESTClient;
    RESTResponse: TRESTResponse;
    BindingsList: TBindingsList;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    IdServerIOHandlerSSLOpenSSL: TIdServerIOHandlerSSLOpenSSL;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
    procedure btnNovoClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnConsultaCEPClick(Sender: TObject);
    procedure edtEndCEPKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
    vCliente  : TClientVO;
    vEndereco : TAddressVO;
    vListaCliente : TObjectList<TClientVO>;

    procedure LimparControles;
    procedure LimpaEstanciaObjeto;

    procedure ValidarNumeros(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure ValidarEmail(Sender: TObject);
    procedure ValidarControles;
    procedure PreencherObjeto;
    procedure EnviarEmail;
  public
    { Public declarations }
  end;

var
  FMenu: TFMenu;

implementation

{$R *.fmx}

uses Client.Controller, JSon.Controller, JSon.VO;

procedure TFMenu.btnNovoClick(Sender: TObject);
begin
  LimparControles;
  LimpaEstanciaObjeto;
end;

procedure TFMenu.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFMenu.btnSalvarClick(Sender: TObject);
begin
  ValidarControles;
  PreencherObjeto;
  EnviarEmail;
end;

procedure TFMenu.edtEndCEPKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if key = 13 then
    btnConsultaCEPClick(Sender);
end;

procedure TFMenu.EnviarEmail;
var
  vXML : string;
  TextoMsg: TidText;
begin
  try
    vXML := TXMLController.GetInstance.ObjectToXML(vCliente);

    IdSMTP.ConnectTimeout := 10000;
    IdSMTP.ReadTimeout    := 10000;

    IdMessage.Clear;
    IdMessage.CharSet := 'iso-8859-1';
    IdMessage.Encoding := MeMIME;
    IdMessage.ContentType := 'multipart/related' ;
    IdMessage.subject := 'Assunto';

    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode   := sslmClient;

    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    IdSMTP.UseTLS := utUseImplicitTLS;
    IdSMTP.AuthType := satDefault;
    IdSMTP.Port := 465;
    IdSMTP.Host := 'smtp.gmail.com';
    IdSMTP.Username := InputBox('Digite seu Email (gmail)', 'Email: ', '');// 'usuario@gmail.com';
    IdSMTP.Password := InputBox('Digite sua senha', 'Senha: ', '');

    IdMessage.From.Address := InputBox('Email do remetente', 'Email: ', '');
    IdMessage.From.Name    := InputBox('Nome do remetente', 'Nome: ', '');
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := 'adrianogalvao@agbtecnologia.com.br';
    IdMessage.Subject := InputBox('Assunto do email', 'Assunto: ', '');;
    IdMessage.Encoding := meMIME;

    TextoMsg := TIdText.Create(IdMessage.MessageParts);
    TextoMsg.Body.Add(vXML);
    TextoMsg.ContentType := 'text/plain; charset=iso-8859-1';

    TIdAttachmentFile.Create(IdMessage.MessageParts, GetCurrentDir + '\Cliente.xml');

    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        ShowMessage('Erro na conexão ou autenticação: ' + E.Message);
        Exit;
      end;
    end;

    try
      IdSMTP.Send(IdMessage);
      ShowMessage('Mensagem enviada com sucesso!');
    except
      On E:Exception do
      begin
        ShowMessage('Erro ao enviar a mensagem: ' + E.Message);
      end;
    end;
  finally
    UnLoadOpenSSLLibrary;
  end;
end;

procedure TFMenu.btnConsultaCEPClick(Sender: TObject);
  procedure ResetRESTConnection;
  begin
    RESTClient.ResetToDefaults;
    RESTRequest.ResetToDefaults;
    RESTResponse.ResetToDefaults;
  end;

var
  vJSONVO : TJsonVO;
  vJSON   : TJSONObject;
  vOk     : Boolean;
begin
  try
    ResetRESTConnection;
    RESTClient.BaseURL   := 'https://viacep.com.br/ws/';
    RESTRequest.Resource := edtEndCEP.Text + '/json/';
    RESTRequest.Method   := TRESTRequestMethod.rmGET;
    RESTRequest.Execute;

    vJSON := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(RESTResponse.Content),0) as TJSONObject;

    vJSONVO := TJsonVO.Create;
    vJSONVO := TJsonController.GetInstance.JSONToObject(vJSON);

    edtEndLogradouro.Text  := vJSONVO.logradouro;
    edtEndComplemento.Text := vJSONVO.complemento;
    edtEndBairro.Text      := vJSONVO.bairro;
    edtEndCidade.Text      := vJSONVO.localidade;
    edtEndEstado.ItemIndex := Integer(TClientController.GetInstance.StrToTState(vOk, vJSONVO.uf));
  finally
    FreeAndNil(vJSONVO);
    FreeAndNil(vJSON);
  end;
end;

procedure TFMenu.FormCreate(Sender: TObject);
begin
  edtCliCPF.OnKeyDown        := ValidarNumeros;
  edtCliTelefone.OnKeyDown   := ValidarNumeros;
  edtEndCEP.OnKeyDown        := ValidarNumeros;
  edtEndNumero.OnKeyDown     := ValidarNumeros;
  edtCliIdentidade.OnKeyDown := ValidarNumeros;
  edtCliEmail.OnExit         := ValidarEmail;

  LimparControles;
  LimpaEstanciaObjeto;

  vListaCliente := TObjectList<TClientVO>.Create;
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
  edtEndEstado.ItemIndex := -1;
  edtEndPais.Text        := '';
end;

procedure TFMenu.PreencherObjeto;
var
  vOk : Boolean;
begin
  try
    vCliente.Nome       := edtCliNome.Text;
    vCliente.Identidade := StrToInt(edtCliIdentidade.Text);
    vCliente.CPF        := StrToInt64(edtCliCPF.Text);
    vCliente.Telefone   := edtCliTelefone.Text;
    vCliente.Email      := edtCliEmail.Text;

    vEndereco.Cep         := StrToInt(edtEndCEP.Text);
    vEndereco.Logradouro  := edtEndLogradouro.Text;
    vEndereco.Numero      := edtEndNumero.Text;
    vEndereco.Complemento := edtEndComplemento.Text;
    vEndereco.Bairro      := edtEndBairro.Text;
    vEndereco.Cidade      := edtEndCidade.Text;
    vEndereco.Estado      := TClientController.GetInstance.StrToTState(vOk, edtEndEstado.Items[edtEndEstado.ItemIndex]);
    vEndereco.Pais        := edtEndPais.Text;

    vCliente.Endereco := vEndereco;

    vListaCliente.Add(vCliente);
  except
    on e : exception do
    begin
      raise Exception.Create('Erro ao preencher objeto.' + e.Message);
    end;
  end;
end;

procedure TFMenu.ValidarControles;
  procedure MensagemValidar(Sender : TObject);
  begin
    ShowMessage('O Campo não pode ser vazio: ' + TEdit(Sender).TextPrompt);
    Abort;
  end;
begin
  if edtCliNome.Text = '' then
    MensagemValidar(edtCliNome);

  if edtCliIdentidade.Text = '' then
    MensagemValidar(edtCliIdentidade);

  if edtCliCPF.Text = '' then
    MensagemValidar(edtCliCPF);

  if edtCliTelefone.Text = '' then
    MensagemValidar(edtCliTelefone);

  if edtCliEmail.Text = '' then
    MensagemValidar(edtCliEmail);

  if edtEndCEP.Text = '' then
    MensagemValidar(edtEndCEP);

  if edtEndLogradouro.Text = '' then
    MensagemValidar(edtEndLogradouro);

  if edtEndNumero.Text = '' then
    MensagemValidar(edtEndNumero);

  if edtEndComplemento.Text = '' then
    MensagemValidar(edtEndComplemento);

  if edtEndBairro.Text = '' then
    MensagemValidar(edtEndBairro);

  if edtEndCidade.Text = '' then
    MensagemValidar(edtEndCidade);

  if edtEndEstado.ItemIndex = -1 then
    ShowMessage('O Campo não pode ser vazio: Estado');

  if edtEndPais.Text = '' then
    MensagemValidar(edtEndPais);
end;

procedure TFMenu.ValidarEmail(Sender: TObject);
var
  RegEx: TRegEx;
begin
  if TEdit(Sender).Text <> '' then
  begin
    RegEx  := TRegex.Create('^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]*[a-zA-Z0-9]+$');
    if not RegEx.Match(TEdit(Sender).Text).Success then
    begin
      ShowMessage('Email inválido.');
      TEdit(Sender).Text := '';
      TEdit(Sender).SetFocus;
    end;
  end;
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
