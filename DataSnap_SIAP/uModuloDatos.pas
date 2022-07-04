unit uModuloDatos;

interface

uses
  System.SysUtils, System.Classes, dialogs, System.JSON, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, uMd5, Utilidades, uTAttribute, uTCRUDModel, inifiles,
  uModuloUtilidades, System.NetEncoding, IdHashMessageDigest, idHash, IdGlobal;

type
  TmoduloDatos = class(TDataModule)
    Conexion: TFDConnection;
    Encriptador: TMD5;
    procedure DataModuleCreate(Sender: TObject);
  private
    FtokenServidor: string;

    procedure settokenServidor(const Value: string);
  public
    function postLoginUsuario(usuario: TJSONObject): TJSONObject;
    function generarNuevoToken: string;
    function toMd5(texto: string): string;
    function SubirArchivo(archivo, nombre: string): boolean;
    function generarID: string;

    property tokenServidor: string read FtokenServidor write settokenServidor;
  end;

const
  JSON_STATUS = 'Status';
  JSON_RESPONSE = 'Response';
  JSON_RESULTS = 'Results';
  RESPONSE_CORRECTO = 'Correcto';
  RESPONSE_INCORRECTO = 'Incorrecto';
  JSON_OBJECT = 'Object';

var
  moduloDatos: TmoduloDatos;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TmoduloDatos.DataModuleCreate(Sender: TObject);
var
  FDDrivers: tinifile;
begin
  FDDrivers := tinifile.Create(ExtractFilePath(ParamStr(0)) + 'FDDrivers.ini');
  FDDrivers.WriteString('PG', 'VendorLib', ExtractFilePath(ParamStr(0)) +
    'lib\libpq.dll');
  FDDrivers.Free;

  Conexion.Connected := true;
end;

function TmoduloDatos.generarID: string;
var
  i: Integer;
  Base: string;
begin
  Base := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  result := '';

  for i := 1 to 8 do
  begin
    result := result + Codes64[Random(length(Base)) + 1];
  end;
  result := result + '-';
  for i := 1 to 4 do
  begin
    result := result + Codes64[Random(length(Base)) + 1];
  end;
  result := result + '-';
  for i := 1 to 4 do
  begin
    result := result + Codes64[Random(length(Base)) + 1];
  end;
  result := result + '-';
  for i := 1 to 12 do
  begin
    result := result + Codes64[Random(length(Base)) + 1];
  end;
end;

function TmoduloDatos.generarNuevoToken: string;
begin
  FtokenServidor := ModuloUtilidades.generarToken;
  result := FtokenServidor;
end;

function TmoduloDatos.postLoginUsuario(usuario: TJSONObject): TJSONObject;
var
  QUsuario: TFDQuery;
  JsonLogin, JsonUsuario: TJSONObject;
  Cedula: string;
  Contra1, Contra2: string;
begin
  try
    JsonLogin := TJSONObject.Create;

    QUsuario := TFDQuery.Create(nil);
    QUsuario.Connection := Conexion;

    Cedula := usuario.GetValue('cedula').Value;

    QUsuario.Close;
    QUsuario.SQL.Text := 'SELECT * FROM math_usuario WHERE cedula=' + #39 +
      Cedula + #39;
    QUsuario.Open;

    if QUsuario.RecordCount = 1 then
    begin
      Encriptador.Text := usuario.GetValue('contra').Value;
      Contra1 := Encriptador.MD5;
      Contra2 := QUsuario.FieldByName('contra').AsString;

      if Contra1 = Contra2 then
      begin
        JsonUsuario := TJSONObject.Create;
        JsonUsuario.AddPair('cedula', QUsuario.FieldByName('cedula').AsString);
        JsonUsuario.AddPair('correo', QUsuario.FieldByName('correo').AsString);
        JsonUsuario.AddPair('nombre', QUsuario.FieldByName('nombre').AsString);

        JsonLogin.AddPair('Usuario', JsonUsuario);
        JsonLogin.AddPair('Respuesta', 'Acceso-Correcto');
        JsonLogin.AddPair('Token', FtokenServidor);
      end
      else
        JsonLogin.AddPair('Respuesta', 'Acceso-Incorrecto');
    end
    else
      JsonLogin.AddPair('Respuesta', 'El usuario con Cédula [' + Cedula +
        '] no esta registrado en la plataforma SIAP')
  except
    On E: Exception do
    begin
      JsonLogin.AddPair('Error', E.Message);
    end;

  end;

  result := JsonLogin;
  QUsuario.Free;
end;

procedure TmoduloDatos.settokenServidor(const Value: string);
begin
  FtokenServidor := Value;
end;

function TmoduloDatos.SubirArchivo(archivo, nombre: string): boolean;
begin

end;

function TmoduloDatos.toMd5(texto: string): string;
var
  hashMessageDigest5: TIdHashMessageDigest5;
begin
  hashMessageDigest5 := nil;
  try
    hashMessageDigest5 := TIdHashMessageDigest5.Create;
    result := IdGlobal.IndyLowerCase(hashMessageDigest5.HashStringAsHex(texto));
  finally
    hashMessageDigest5.Free;
  end;
end;

end.
