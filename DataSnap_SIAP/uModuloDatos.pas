unit uModuloDatos;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, uMd5, Utilidades, uTAttribute, uTCRUDModel;

type
  TmoduloDatos = class(TDataModule)
    Conexion: TFDConnection;
    Encriptador: TMD5;
  private
    FtokenServidor: string;

    procedure settokenServidor(const Value: string);
  public
    function postLoginUsuario(usuario: TJSONObject): TJSONObject;
    function generarNuevoToken: string;

    property tokenServidor: string read FtokenServidor write settokenServidor;
  end;

var
  moduloDatos: TmoduloDatos;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

function TmoduloDatos.generarNuevoToken: string;
begin
  FtokenServidor := generarToken;
  Result := FtokenServidor;
end;

function TmoduloDatos.postLoginUsuario(usuario: TJSONObject): TJSONObject;
var
  QUsuario: TFDQuery;
  JsonLogin, JsonUsuario: TJSONObject;
  Cedula: string;
  Contra1, Contra2: string;
begin
  try
    JsonLogin := TJSONObject.create;

    QUsuario := TFDQuery.create(nil);
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
        JsonUsuario := TJSONObject.create;
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

  Result := JsonLogin;
  QUsuario.Free;
end;

procedure TmoduloDatos.settokenServidor(const Value: string);
begin
  FtokenServidor := Value;
end;

end.
