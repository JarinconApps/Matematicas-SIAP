unit uFCertificados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, PReport, Vcl.ComCtrls,
  PdfDoc, uFDataSnapMatematicas;

type
  TFCertificados = class(TForm)
    paginaControl: TPageControl;
    TabParticipante: TTabSheet;
    ScrollBox1: TScrollBox;
    paginaCertificado: TPRPage;
    pn1: TPRLayoutPanel;
    img1: TPRImage;
    prNombre: TPRLabel;
    prCedula: TPRLabel;
    prTitulo: TPRText;
    Impresora: TPReport;
  private
    { Private declarations }
  public
    procedure iniciarDocumento(cedula: string);
    procedure agregarCertificado(nombre, cedula, titulo, tipo: string);
    procedure finalizarDocumento;
  end;

var
  FCertificados: TFCertificados;

implementation

{$R *.dfm}
{ TForm1 }

procedure TFCertificados.agregarCertificado(nombre, cedula, titulo,
  tipo: string);
begin
  prNombre.Caption := nombre;
  prCedula.Caption := 'con documento de Identificaci�n ' + cedula;

  if tipo = 'Participante' then
    prTitulo.Lines.Text :=
      'Particip� en el Workshop EMEM 2019, realizado en Armenia, Quind�o del 5 al 8 de Noviembre';

  if tipo = 'Poster' then
    prTitulo.Lines.Text := 'Particip� como ponente del P�ster "' + titulo +
      '", en el Workshop EMEM 2019, realizado en Armenia, Quind�o del 5 al 8 de Noviembre';

  if tipo = 'Stand' then
    prTitulo.Lines.Text := 'Particip� con un stand titulado "' + titulo +
      '", en el Workshop EMEM 2019, realizado en Armenia, Quind�o del 5 al 8 de Noviembre';

  if tipo = 'Taller' then
    prTitulo.Lines.Text := 'Particip� con un Taller titulado "' + titulo +
      '", en el Workshop EMEM 2019, realizado en Armenia, Quind�o del 5 al 8 de Noviembre';

  if tipo = 'Ponencia' then
    prTitulo.Lines.Text := 'Particip� con la ponencia titulada "' + titulo +
      '", en el Workshop EMEM 2019, realizado en Armenia, Quind�o del 5 al 8 de Noviembre';

  Impresora.Print(paginaCertificado);
end;

procedure TFCertificados.finalizarDocumento;
begin
  Impresora.EndDoc;
end;

procedure TFCertificados.iniciarDocumento(cedula: string);
begin
  Impresora.FileName := FDataSnapMatematicas.obtenerRutaCertificado + '\' +
    cedula + '.pdf';
  Impresora.BeginDoc;
end;

end.
