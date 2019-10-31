unit XML.Controller;

interface

uses
  System.Classes,
  System.SysUtils,
  Client.VO,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.XMLDoc,
  FMX.Forms, Client.Controller, FMX.Dialogs;

type
  TXMLController = class(TPersistent)
  private
    { private declarations }
    class var FInstance: TXMLController;
    constructor CreatePrivate;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    class function GetInstance: TXMLController;

    class function ObjectToXML(pObj : TClientVO): string;
  published
    { published declarations }
  end;

implementation

{ TXMLController }

constructor TXMLController.Create;
begin
  raise Exception.Create('Para obter uma instância utilize T...GetInstance !');
end;

constructor TXMLController.CreatePrivate;
begin
  inherited Create;
end;

class function TXMLController.GetInstance: TXMLController;
begin
  if not Assigned(FInstance) then
    FInstance := TXMLController.CreatePrivate;

  Result := FInstance;
end;

class function TXMLController.ObjectToXML(pObj: TClientVO): string;
var
  Raiz, Nome, Identidade, CPF,
  Telefone, Email, Cep,
  Logradouro, Numero, Bairro, Complemento,
  UF, Cidade, Pais : IXMLNode;
  XMLRetorno : TXMLDocument;
begin
  XMLRetorno := TXMLDocument.Create(nil);

  XMLRetorno.FileName := '';
  XMLRetorno.XML.Text := '';
  XMLRetorno.Active := False;
  XMLRetorno.Active := True;
  XMLRetorno.Version := '1.0';
  XMLRetorno.Encoding := 'UTF-8';

  Raiz := XMLRetorno.AddChild('CLIENTE');

  Nome := XMLRetorno.CreateNode('NOME', ntAttribute);
  Nome.Text := pObj.Nome;
  Raiz.AttributeNodes.Add(Nome);

  Identidade := XMLRetorno.CreateNode('IDENTIDADE', ntAttribute);
  Identidade.Text := IntToStr(pObj.Identidade);
  Raiz.AttributeNodes.Add(Identidade);

  CPF := XMLRetorno.CreateNode('CPF', ntAttribute);
  CPF.Text := IntToStr(pObj.CPF);
  Raiz.AttributeNodes.Add(CPF);

  Telefone := XMLRetorno.CreateNode('TELEFONE', ntAttribute);
  Telefone.Text := pObj.Telefone;
  Raiz.AttributeNodes.Add(Telefone);

  Email := XMLRetorno.CreateNode('EMAIL', ntAttribute);
  Email.Text := pObj.Email;
  Raiz.AttributeNodes.Add(Email);

  Cep := XMLRetorno.CreateNode('CEP', ntAttribute);
  Cep.Text := IntToStr(pObj.Endereco.Cep);
  Raiz.AttributeNodes.Add(Cep);

  Logradouro := XMLRetorno.CreateNode('LOGRADOURO', ntAttribute);
  Logradouro.Text := pObj.Endereco.Logradouro;
  Raiz.AttributeNodes.Add(Logradouro);

  Numero := XMLRetorno.CreateNode('NUMERO', ntAttribute);
  Numero.Text := pObj.Endereco.Numero;
  Raiz.AttributeNodes.Add(Numero);

  Complemento := XMLRetorno.CreateNode('COMPLEMENTO', ntAttribute);
  Complemento.Text := pObj.Endereco.Complemento;
  Raiz.AttributeNodes.Add(Complemento);

  Bairro := XMLRetorno.CreateNode('BAIRRO', ntAttribute);
  Bairro.Text := pObj.Endereco.Bairro;
  Raiz.AttributeNodes.Add(Bairro);

  Cidade := XMLRetorno.CreateNode('CIDADE', ntAttribute);
  Cidade.Text := pObj.Endereco.Cidade;
  Raiz.AttributeNodes.Add(Cidade);

  Pais := XMLRetorno.CreateNode('PAIS', ntAttribute);
  Pais.Text := pObj.Endereco.Pais;
  Raiz.AttributeNodes.Add(Pais);

  UF := XMLRetorno.CreateNode('UF', ntAttribute);
  UF.Text := TClientController.GetInstance.StateToStr(pObj.Endereco.Estado);
  Raiz.AttributeNodes.Add(UF);

  XMLRetorno.SaveToXML(Result);
  XMLRetorno.SaveToFile(GetCurrentDir + '\Cliente.xml');
end;

end.
