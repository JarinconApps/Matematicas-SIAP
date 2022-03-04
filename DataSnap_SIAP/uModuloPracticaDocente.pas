unit uModuloPracticaDocente;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Stan.Intf, dialogs,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, System.NetEncoding, FireDAC.Comp.Client,
  uModuloDatos, Utilidades, uMd5, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient,
  IdSMTPBase, IdSMTP, IdMessage, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type
  TmoduloPracticaDocente = class(TDataModule)
    toMD5: TMD5;
    SMTP: TIdSMTP;
    Data: TIdMessage;
    SSL: TIdSSLIOHandlerSocketOpenSSL;
  private
    { Private declarations }
  public
    function putEstudiantePeriodo(estudiante: TJSONObject): TJSONObject;
    function getPeriodos: TJSONObject;
    function buscarEstudiante(documento, periodo: string): TJSONObject;
    function subirArchivo(archivo, nombre: string): boolean;
    function putEstudiante(estudiante: TJSONObject): TJSONObject;
    function postEstudiante(estudiante: TJSONObject): TJSONObject;
    function getEstudiantes: TJSONObject;
    function deleteEstudiante(IdEstudiante: string): TJSONObject;
    function enviarCorreo(datos: TJSONObject): TJSONObject;
    function getEstadisticasPeriodo(IdPeriodo: string): TJSONObject;
    function postCartaPermiso(datos: TJSONObject): TJSONObject;
    function putCartaPermiso(datos: TJSONObject): TJSONObject;
    function getCartasPermisoByPeriodo(IdPeriodo: string): TJSONObject;
    function getCartaPermiso(IdCarta: string): TJSONObject;
    function deleteCartaPermiso(IdCarta: string): TJSONObject;
    function getEstudiantesByPeriodo(IdPeriodo: string): TJSONObject;
    function postEstudianteCarta(datos: TJSONObject): TJSONObject;
    function deleteEstudianteCarta(IdEstudianteCarta: string): TJSONObject;
    function getEstudiantesBySecretaria(IdPeriodo: string): TJSONObject;
    function getSecretarias: TJSONObject;
    function putEstudianteCarta(datos: TJSONObject): TJSONObject;
  end;

var
  moduloPracticaDocente: TmoduloPracticaDocente;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

function TmoduloPracticaDocente.buscarEstudiante(documento, periodo: string)
  : TJSONObject;
var
  Query: TFDQuery;
  estudiante: TJSONObject;
  IdEstudiante: string;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Siap_Estudiantes WHERE Documento=' + #39 +
      documento + #39;
    Query.Open;

    estudiante := TJSONObject.Create;

    IdEstudiante := Query.FieldByName('IdEstudiante').AsString;
    estudiante.AddPair('IdEstudiante', IdEstudiante);
    estudiante.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
    estudiante.AddPair('Documento', Query.FieldByName('Documento').AsString);
    estudiante.AddPair('Correo', Query.FieldByName('Correo').AsString);
    estudiante.AddPair('Telefono', Query.FieldByName('Telefono').AsString);
    estudiante.AddPair('TipoDocumento', Query.FieldByName('TipoDocumento')
      .AsString);
    estudiante.AddPair('Genero', Query.FieldByName('Genero').AsString);
    estudiante.AddPair('Direccion', Query.FieldByName('Direccion').AsString);
    estudiante.AddPair('Municipio', Query.FieldByName('Municipio').AsString);
    estudiante.AddPair('Semestre', Query.FieldByName('Semestre').AsString);
    estudiante.AddPair('Eps', Query.FieldByName('Eps').AsString);
    estudiante.AddPair('EstadoCivil', Query.FieldByName('EstadoCivil')
      .AsString);
    estudiante.AddPair('Codigo', '');

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Siap_Practica_Docente WHERE IdPeriodo=' +
      #39 + periodo + #39 + ' AND IdEstudiante=' + #39 + IdEstudiante + #39;
    Query.Open;

    if Query.RecordCount = 1 then
    begin
      estudiante.AddPair('IdRegistro', Query.FieldByName('IdRegistro')
        .AsString);
      estudiante.AddPair('IdPeriodo', Query.FieldByName('IdPeriodo').AsString);
      estudiante.AddPair('EspacioAcademico',
        Query.FieldByName('EspacioAcademico').AsString);

      estudiante.AddPair('AntecedentesDisciplinarios',
        Query.FieldByName('docAntDis').AsString);
      estudiante.AddPair('AntecedentesJudiciales',
        Query.FieldByName('docAntJud').AsString);
      estudiante.AddPair('AntecedentesFiscales', Query.FieldByName('docAntFis')
        .AsString);
      estudiante.AddPair('MedidasCorrectivas', Query.FieldByName('docMedCor')
        .AsString);
      estudiante.AddPair('DocumentoIdentidad', Query.FieldByName('docIdentidad')
        .AsString);
      estudiante.AddPair('CertificadoEPS', Query.FieldByName('docEPS')
        .AsString);
    end
    else
    begin
      estudiante.AddPair('IdRegistro', '');
      estudiante.AddPair('IdPeriodo', '');
      estudiante.AddPair('EspacioAcademico', '');
      estudiante.AddPair('AntecedentesDisciplinarios', '');
      estudiante.AddPair('AntecedentesJudiciales', '');
      estudiante.AddPair('AntecedentesFiscales', '');
      estudiante.AddPair('MedidasCorrectivas', '');
      estudiante.AddPair('DocumentoIdentidad', '');
      estudiante.AddPair('CertificadoEPS', '');
    end;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'El estudiante se obtuvo correctamente');
    result.AddPair(JSON_OBJECT, estudiante);

  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.postCartaPermiso(datos: TJSONObject)
  : TJSONObject;
var
  Query: TFDQuery;
  IdCarta: string;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'INSERT INTO siap_carta_autorizacion_practica (';
    Query.SQL.Add('IdCarta, ');
    Query.SQL.Add('Rector, ');
    Query.SQL.Add('Institucion, ');
    Query.SQL.Add('Ciudad, ');
    Query.SQL.Add('Fecha, ');
    Query.SQL.Add('IdSecretaria, ');
    Query.SQL.Add('IdPeriodo) VALUES (');
    Query.SQL.Add(':IdCarta, ');
    Query.SQL.Add(':Rector, ');
    Query.SQL.Add(':Institucion, ');
    Query.SQL.Add(':Ciudad, ');
    Query.SQL.Add(':Fecha, ');
    Query.SQL.Add(':IdSecretaria, ');
    Query.SQL.Add(':IdPeriodo)');

    IdCarta := moduloDatos.generarID;
    Query.Params.ParamByName('IdCarta').Value := IdCarta;
    Query.Params.ParamByName('Rector').Value := datos.GetValue('Rector').Value;
    Query.Params.ParamByName('Institucion').Value :=
      datos.GetValue('Institucion').Value;
    Query.Params.ParamByName('Ciudad').Value := datos.GetValue('Ciudad').Value;
    Query.Params.ParamByName('Fecha').Value := datos.GetValue('Fecha').Value;
    Query.Params.ParamByName('IdSecretaria').Value :=
      datos.GetValue('IdSecretaria').Value;
    Query.Params.ParamByName('IdPeriodo').Value :=
      datos.GetValue('IdPeriodo').Value;

    Query.ExecSQL;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'La carta se creó correctamente');
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.postEstudiante(estudiante: TJSONObject)
  : TJSONObject;
var
  Query: TFDQuery;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'INSERT INTO Siap_Estudiantes (';
    Query.SQL.Add('IdEstudiante, ');
    Query.SQL.Add('Nombre, ');
    Query.SQL.Add('Documento, ');
    Query.SQL.Add('Correo, ');
    Query.SQL.Add('Telefono, ');
    Query.SQL.Add('TipoDocumento, ');
    Query.SQL.Add('Genero, ');
    Query.SQL.Add('Direccion, ');
    Query.SQL.Add('Municipio, ');
    Query.SQL.Add('Semestre, ');
    Query.SQL.Add('Eps, ');
    Query.SQL.Add('EstadoCivil) VALUES (');
    Query.SQL.Add(':IdEstudiante, ');
    Query.SQL.Add(':Nombre, ');
    Query.SQL.Add(':Documento, ');
    Query.SQL.Add(':Correo, ');
    Query.SQL.Add(':Telefono, ');
    Query.SQL.Add(':TipoDocumento, ');
    Query.SQL.Add(':Genero, ');
    Query.SQL.Add(':Direccion, ');
    Query.SQL.Add(':Municipio, ');
    Query.SQL.Add(':Semestre, ');
    Query.SQL.Add(':Eps, ');
    Query.SQL.Add(':EstadoCivil)');

    Query.Params.ParamByName('IdEstudiante').Value := moduloDatos.generarID;

    Query.Params.ParamByName('Nombre').Value :=
      estudiante.GetValue('Nombre').Value;

    Query.Params.ParamByName('Correo').Value :=
      estudiante.GetValue('Correo').Value;

    Query.Params.ParamByName('Documento').Value :=
      estudiante.GetValue('Documento').Value;

    Query.Params.ParamByName('Municipio').Value :=
      estudiante.GetValue('Municipio').Value;

    Query.Params.ParamByName('Telefono').Value :=
      estudiante.GetValue('Telefono').Value;

    Query.Params.ParamByName('TipoDocumento').Value :=
      estudiante.GetValue('TipoDocumento').Value;

    Query.Params.ParamByName('Genero').Value :=
      estudiante.GetValue('Genero').Value;

    Query.Params.ParamByName('Direccion').Value :=
      estudiante.GetValue('Direccion').Value;

    Query.Params.ParamByName('Semestre').Value :=
      estudiante.GetValue('Semestre').Value;

    Query.Params.ParamByName('Eps').Value := estudiante.GetValue('Eps').Value;

    Query.Params.ParamByName('EstadoCivil').Value :=
      estudiante.GetValue('EstadoCivil').Value;

    Query.ExecSQL;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'El estudiante se creo correctamente');
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.postEstudianteCarta(datos: TJSONObject)
  : TJSONObject;
var
  Query: TFDQuery;
  IdEstudianteCarta: string;
  estudiante: TJSONObject;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'INSERT INTO siap_estudiantes_carta (';
    Query.SQL.Add('IdEstudianteCarta, ');
    Query.SQL.Add('IdCarta, ');
    Query.SQL.Add('Horario, ');
    Query.SQL.Add('Grado, ');
    Query.SQL.Add('IdEstudiante) VALUES (');
    Query.SQL.Add(':IdEstudianteCarta, ');
    Query.SQL.Add(':IdCarta, ');
    Query.SQL.Add(':Horario, ');
    Query.SQL.Add(':Grado, ');
    Query.SQL.Add(':IdEstudiante)');

    IdEstudianteCarta := moduloDatos.generarID;
    Query.Params.ParamByName('IdEstudianteCarta').Value := IdEstudianteCarta;
    Query.Params.ParamByName('IdCarta').Value :=
      datos.GetValue('IdCarta').Value;
    Query.Params.ParamByName('IdEstudiante').Value :=
      datos.GetValue('IdEstudiante').Value;
    Query.Params.ParamByName('Horario').Value :=
      datos.GetValue('Horario').Value;
    Query.Params.ParamByName('Grado').Value := datos.GetValue('Grado').Value;

    Query.ExecSQL;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Siap_Estudiantes_Carta as ec' +
      ' INNER JOIN Siap_Estudiantes as est ON ec.IdEstudiante = est.IdEstudiante '
      + 'WHERE ec.IdEstudianteCarta=' + #39 + IdEstudianteCarta + #39;
    Query.Open;

    estudiante := TJSONObject.Create;
    estudiante.AddPair('IdEstudianteCarta',
      Query.FieldByName('IdEstudianteCarta').AsString);
    estudiante.AddPair('IdEstudiante', Query.FieldByName('IdEstudiante')
      .AsString);
    estudiante.AddPair('IdCarta', Query.FieldByName('IdCarta').AsString);
    estudiante.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
    estudiante.AddPair('Documento', Query.FieldByName('Documento').AsString);
    estudiante.AddPair('Correo', Query.FieldByName('Correo').AsString);
    estudiante.AddPair('Horario', Query.FieldByName('Horario').AsString);
    estudiante.AddPair('Grado', Query.FieldByName('Grado').AsString);

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'El estudiante se asigno correctamente');
    result.AddPair(JSON_OBJECT, estudiante);
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.putCartaPermiso(datos: TJSONObject)
  : TJSONObject;
var
  Query: TFDQuery;
  IdCarta: string;
begin
  try
    result := TJSONObject.Create;

    IdCarta := datos.GetValue('IdCarta').Value;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'UPDATE siap_carta_autorizacion_practica SET ';
    Query.SQL.Add('Rector=:Rector, ');
    Query.SQL.Add('Institucion=:Institucion, ');
    Query.SQL.Add('Ciudad=:Ciudad, ');
    Query.SQL.Add('IdSecretaria=:IdSecretaria, ');
    Query.SQL.Add('Fecha=:Fecha WHERE IdCarta=' + #39 + IdCarta + #39);

    Query.Params.ParamByName('Rector').Value := datos.GetValue('Rector').Value;
    Query.Params.ParamByName('Institucion').Value :=
      datos.GetValue('Institucion').Value;
    Query.Params.ParamByName('Ciudad').Value := datos.GetValue('Ciudad').Value;
    Query.Params.ParamByName('Fecha').Value := datos.GetValue('Fecha').Value;
    Query.Params.ParamByName('IdSecretaria').Value :=
      datos.GetValue('IdSecretaria').Value;

    Query.ExecSQL;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'La carta se actualizó correctamente');
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.putEstudiante(estudiante: TJSONObject)
  : TJSONObject;
var
  Query: TFDQuery;
  IdEstudiante: string;
begin
  try
    result := TJSONObject.Create;

    IdEstudiante := estudiante.GetValue('IdEstudiante').Value;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'UPDATE Siap_Estudiantes SET ';
    Query.SQL.Add('Correo=:Correo, ');
    Query.SQL.Add('Documento=:Documento, ');
    Query.SQL.Add('Eps=:Eps, ');
    Query.SQL.Add('EstadoCivil=:EstadoCivil, ');
    Query.SQL.Add('Genero=:Genero, ');
    Query.SQL.Add('Municipio=:Municipio, ');
    Query.SQL.Add('Nombre=:Nombre, ');
    Query.SQL.Add('Semestre=:Semestre, ');
    Query.SQL.Add('Telefono=:Telefono, ');
    Query.SQL.Add('TipoDocumento=:TipoDocumento WHERE IdEstudiante=' + #39 +
      IdEstudiante + #39);

    Query.Params.ParamByName('Correo').Value :=
      estudiante.GetValue('Correo').Value;

    Query.Params.ParamByName('Documento').Value :=
      estudiante.GetValue('Documento').Value;

    Query.Params.ParamByName('Eps').Value := estudiante.GetValue('Eps').Value;

    Query.Params.ParamByName('EstadoCivil').Value :=
      estudiante.GetValue('EstadoCivil').Value;

    Query.Params.ParamByName('Nombre').Value :=
      estudiante.GetValue('Nombre').Value;

    Query.Params.ParamByName('Genero').Value :=
      estudiante.GetValue('Genero').Value;

    Query.Params.ParamByName('Municipio').Value :=
      estudiante.GetValue('Municipio').Value;

    Query.Params.ParamByName('Semestre').Value :=
      estudiante.GetValue('Semestre').Value;

    Query.Params.ParamByName('Telefono').Value :=
      estudiante.GetValue('Telefono').Value;

    Query.Params.ParamByName('TipoDocumento').Value :=
      estudiante.GetValue('TipoDocumento').Value;

    Query.ExecSQL;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'El estudiante se actualizó correctamente');
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.putEstudianteCarta(datos: TJSONObject)
  : TJSONObject;
var
  Query: TFDQuery;
  IdEstudianteCarta: string;
  estudiante: TJSONObject;
begin
  try
    result := TJSONObject.Create;

    IdEstudianteCarta := datos.GetValue('IdEstudianteCarta').Value;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'UPDATE siap_estudiantes_carta SET ';
    Query.SQL.Add('Horario=:Horario, ');
    Query.SQL.Add('Grado=:Grado WHERE IdEstudianteCarta=' + #39 +
      IdEstudianteCarta + #39);

    Query.Params.ParamByName('Horario').Value :=
      datos.GetValue('Horario').Value;
    Query.Params.ParamByName('Grado').Value := datos.GetValue('Grado').Value;

    Query.ExecSQL;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Siap_Estudiantes_Carta as ec' +
      ' INNER JOIN Siap_Estudiantes as est ON ec.IdEstudiante = est.IdEstudiante '
      + 'WHERE ec.IdEstudianteCarta=' + #39 + IdEstudianteCarta + #39;
    Query.Open;

    estudiante := TJSONObject.Create;
    estudiante.AddPair('IdEstudianteCarta',
      Query.FieldByName('IdEstudianteCarta').AsString);
    estudiante.AddPair('IdEstudiante', Query.FieldByName('IdEstudiante')
      .AsString);
    estudiante.AddPair('IdCarta', Query.FieldByName('IdCarta').AsString);
    estudiante.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
    estudiante.AddPair('Documento', Query.FieldByName('Documento').AsString);
    estudiante.AddPair('Correo', Query.FieldByName('Correo').AsString);
    estudiante.AddPair('Horario', Query.FieldByName('Horario').AsString);
    estudiante.AddPair('Grado', Query.FieldByName('Grado').AsString);

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'El estudiante se actualizó correctamente');
    result.AddPair(JSON_OBJECT, estudiante);
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.deleteCartaPermiso(IdCarta: string)
  : TJSONObject;
var
  Query: TFDQuery;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text :=
      'DELETE FROM siap_carta_autorizacion_practica WHERE IdCarta=' + #39 +
      IdCarta + #39;
    Query.ExecSQL;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'La carta se eliminó correctamente');
  except
    on E: Exception do
    begin
      if E.Message.IndexOf('viola la llave foránea') >= 0 then
        result.AddPair(JSON_RESPONSE,
          'No se puede eliminar porque tiene estudiantes asociados')
      else
        result.AddPair(JSON_RESPONSE, E.Message);

      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.deleteEstudiante(IdEstudiante: string)
  : TJSONObject;
var
  Query: TFDQuery;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'DELETE FROM Siap_Estudiantes WHERE IdEstudiante=' + #39 +
      IdEstudiante + #39;
    Query.ExecSQL;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'El estudiante se eliminó correctamente');
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.deleteEstudianteCarta(IdEstudianteCarta: string)
  : TJSONObject;
var
  Query: TFDQuery;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text :=
      'DELETE FROM siap_estudiantes_carta WHERE IdEstudianteCarta=' + #39 +
      IdEstudianteCarta + #39;
    Query.ExecSQL;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'El estudiante se eliminó correctamente');
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.enviarCorreo(datos: TJSONObject): TJSONObject;
var
  JSON, Correo: TJSONObject;
  Html: TStringList;
  asunto, sCorreos, mensaje: string;
  Correos: TJSONArray;
  i: Integer;
begin
  JSON := TJSONObject.Create;
  try
    asunto := datos.GetValue('Asunto').Value;
    mensaje := datos.GetValue('Mensaje').Value;

    Correos := TJSONArray.Create;
    sCorreos := datos.GetValue('Correos').Value;
    Correos := TJSONObject.ParseJSONValue(sCorreos) as TJSONArray;

    for i := 1 to Correos.Count do
    begin
      Correo := TJSONObject.Create;
      Correo := TJSONObject.ParseJSONValue(Correos.Get(i - 1).ToString)
        as TJSONObject;

      Html := TStringList.Create;
      Html.Add('<!doctype html>');
      Html.Add('<html lang="es">');
      Html.Add('  <head>');
      Html.Add('    <meta charset="utf-8">');
      Html.Add('');
      Html.Add('    <title>Prácticas Pedagógicas - Licenciatura en Matemáticas</title>');
      Html.Add('  </head>');
      Html.Add('  <body>');

      Html.Add('<div style="border: 2px; border-style: outset; border-radius: 30px; margin: 100px; box-shadow: 2px 2px 2px 1px rgba(0, 0, 0, 0.2)">');
      Html.Add('');
      Html.Add('    <h1 style="margin: 10px; padding: 10px; color: green; font-size: 32px">Prácticas Pedagógicas - Licenciatura en Matemáticas</h1>');
      Html.Add('  <hr>');
      Html.Add('');
      Html.Add('    <div style="margin: 10px; padding: 10px; font-size: 24px;">');
      Html.Add('      <p>Cordial Saludo,</p>');
      Html.Add('      <p>' + Correo.GetValue('Nombre').Value + '</p>');
      Html.Add('       ' + mensaje);
      Html.Add('      <p style="color: #730DED; font-style: italic;">Atentamente, Julián Andrés Rincón Penagos. Magister en Ciencias de la Educación. Coordinador de Prácticas Pedagógicas del Programa</p>');
      Html.Add('    </div>');
      Html.Add('');
      Html.Add('</div>');

      Html.Add('  </body>');
      Html.Add('</html>');

      Data.Subject := asunto;

      Data.From.Text := 'Prácticas Pedagógicas';
      Data.From.Address := 'jarincon@uniquindio.edu.co';
      Data.ContentType := 'text/html';
      Data.CharSet := 'UTF-8';
      Data.Body.Assign(Html);

      Data.Recipients.EMailAddresses := Correo.GetValue('Correo').Value;

      try
        SMTP.Connect;
        SMTP.Authenticate;
        SMTP.Send(Data);
      finally
        SMTP.Disconnect(True);
        JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
        JSON.AddPair(JSON_RESPONSE, 'El correo se envío correctamente');
      end;
    end;

  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_RESPONSE, E.Message);
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    end;
  end;

  result := JSON;
end;

function TmoduloPracticaDocente.getCartaPermiso(IdCarta: string): TJSONObject;
var
  Query, QEstudiantes: TFDQuery;
  i: Integer;
  Carta, estudiante: TJSONObject;
  Estudiantes: TJSONArray;
  j: Integer;
begin
  try
    result := TJSONObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    QEstudiantes := TFDQuery.Create(nil);
    QEstudiantes.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_carta_autorizacion_practica WHERE ' +
      'IdCarta=' + #39 + IdCarta + #39;
    Query.Open;

    Carta := TJSONObject.Create;
    Carta.AddPair('IdCarta', Query.FieldByName('IdCarta').AsString);
    Carta.AddPair('Rector', Query.FieldByName('Rector').AsString);
    Carta.AddPair('Institucion', Query.FieldByName('Institucion').AsString);
    Carta.AddPair('Ciudad', Query.FieldByName('Ciudad').AsString);
    Carta.AddPair('Fecha', Query.FieldByName('Fecha').AsString);
    Carta.AddPair('IdPeriodo', Query.FieldByName('IdPeriodo').AsString);

    QEstudiantes.Close;
    QEstudiantes.SQL.Text := 'SELECT * FROM Siap_Estudiantes_Carta as ec' +
      ' INNER JOIN Siap_Estudiantes as est ON ec.IdEstudiante = est.IdEstudiante'
      + ' WHERE IdCarta=' + #39 + Query.FieldByName('IdCarta').AsString + #39;
    QEstudiantes.Open;
    QEstudiantes.First;

    Estudiantes := TJSONArray.Create;
    for j := 1 to QEstudiantes.RecordCount do
    begin
      estudiante := TJSONObject.Create;
      estudiante.AddPair('IdEstudianteCarta',
        QEstudiantes.FieldByName('IdEstudianteCarta').AsString);
      estudiante.AddPair('IdEstudiante',
        QEstudiantes.FieldByName('IdEstudiante').AsString);
      estudiante.AddPair('IdCarta', QEstudiantes.FieldByName('IdCarta')
        .AsString);
      estudiante.AddPair('Nombre', QEstudiantes.FieldByName('Nombre').AsString);
      estudiante.AddPair('Documento', QEstudiantes.FieldByName('Documento')
        .AsString);
      estudiante.AddPair('Correo', QEstudiantes.FieldByName('Correo').AsString);
      estudiante.AddPair('Genero', QEstudiantes.FieldByName('Genero').AsString);
      estudiante.AddPair('Horario', QEstudiantes.FieldByName('Horario')
        .AsString);
      estudiante.AddPair('Grado', QEstudiantes.FieldByName('Grado').AsString);

      Estudiantes.AddElement(estudiante);
      QEstudiantes.Next;
    end;

    Carta.AddPair('Estudiantes', Estudiantes);

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'La Carta se obtuvó correctamente');
    result.AddPair(JSON_OBJECT, Carta);

  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.getCartasPermisoByPeriodo(IdPeriodo: string)
  : TJSONObject;
var
  Query, QEstudiantes: TFDQuery;
  i: Integer;
  Carta, estudiante: TJSONObject;
  Cartas, Estudiantes: TJSONArray;
  j: Integer;
begin
  try
    result := TJSONObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    QEstudiantes := TFDQuery.Create(nil);
    QEstudiantes.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Siap_Carta_Autorizacion_Practica as cap ' +
      'INNER JOIN Siap_Secretarias_Practica as sp ON ' +
      'cap.IdSecretaria = sp.IdSecretaria WHERE' + ' cap.IdPeriodo=' + #39 +
      IdPeriodo + #39;
    Query.Open;

    Cartas := TJSONArray.Create;
    for i := 1 to Query.RecordCount do
    begin
      Carta := TJSONObject.Create;
      Carta.AddPair('IdCarta', Query.FieldByName('IdCarta').AsString);
      Carta.AddPair('Rector', Query.FieldByName('Rector').AsString);
      Carta.AddPair('Institucion', Query.FieldByName('Institucion').AsString);
      Carta.AddPair('Ciudad', Query.FieldByName('Ciudad').AsString);
      Carta.AddPair('Fecha', Query.FieldByName('Fecha').AsString);
      Carta.AddPair('Secretaria', Query.FieldByName('Secretaria').AsString);
      Carta.AddPair('IdPeriodo', Query.FieldByName('IdPeriodo').AsString);

      QEstudiantes.Close;
      QEstudiantes.SQL.Text := 'SELECT * FROM Siap_Estudiantes_Carta as ec' +
        ' INNER JOIN Siap_Estudiantes as est ON ec.IdEstudiante = est.IdEstudiante'
        + ' WHERE IdCarta=' + #39 + Query.FieldByName('IdCarta').AsString + #39;
      QEstudiantes.Open;
      QEstudiantes.First;

      Estudiantes := TJSONArray.Create;
      for j := 1 to QEstudiantes.RecordCount do
      begin
        estudiante := TJSONObject.Create;
        estudiante.AddPair('IdEstudianteCarta',
          QEstudiantes.FieldByName('IdEstudianteCarta').AsString);
        estudiante.AddPair('IdEstudiante',
          QEstudiantes.FieldByName('IdEstudiante').AsString);
        estudiante.AddPair('IdCarta', QEstudiantes.FieldByName('IdCarta')
          .AsString);
        estudiante.AddPair('Nombre', QEstudiantes.FieldByName('Nombre')
          .AsString);
        estudiante.AddPair('Documento', QEstudiantes.FieldByName('Documento')
          .AsString);
        estudiante.AddPair('Correo', QEstudiantes.FieldByName('Correo')
          .AsString);
        estudiante.AddPair('Grado', QEstudiantes.FieldByName('Grado').AsString);
        estudiante.AddPair('Horario', QEstudiantes.FieldByName('Horario')
          .AsString);

        Estudiantes.AddElement(estudiante);
        QEstudiantes.Next;
      end;

      Carta.AddPair('Estudiantes', Estudiantes);
      Cartas.AddElement(Carta);
      Query.Next;
    end;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'Las Cartas se obtuvieron correctamente');
    result.AddPair(JSON_RESULTS, Cartas);

  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
  QEstudiantes.Free;
end;

function TmoduloPracticaDocente.getEstadisticasPeriodo(IdPeriodo: string)
  : TJSONObject;
var
  Query: TFDQuery;
  i: Integer;
  estudiante: TJSONObject;
  Estudiantes: TJSONArray;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Siap_Practica_Docente as pd INNER JOIN ' +
      'Siap_Estudiantes as est ON pd.IdEstudiante = est.IdEstudiante WHERE' +
      ' pd.IdPeriodo=' + #39 + IdPeriodo + #39;
    Query.Open;
    Query.First;

    Estudiantes := TJSONArray.Create;

    for i := 1 to Query.RecordCount do
    begin
      estudiante := TJSONObject.Create;
      estudiante.AddPair('IdRegistro', Query.FieldByName('IdRegistro')
        .AsString);
      estudiante.AddPair('IdPeriodo', Query.FieldByName('IdPeriodo').AsString);
      estudiante.AddPair('IdEstudiante', Query.FieldByName('IdEstudiante')
        .AsString);
      estudiante.AddPair('EspacioAcademico',
        Query.FieldByName('EspacioAcademico').AsString);
      estudiante.AddPair('DocAntDis', Query.FieldByName('DocAntDis').AsString);
      estudiante.AddPair('DocAntJud', Query.FieldByName('DocAntJud').AsString);
      estudiante.AddPair('DocAntFis', Query.FieldByName('DocAntFis').AsString);
      estudiante.AddPair('DocMedCor', Query.FieldByName('DocMedCor').AsString);
      estudiante.AddPair('DocIdentidad', Query.FieldByName('DocIdentidad')
        .AsString);
      estudiante.AddPair('DocEps', Query.FieldByName('DocEps').AsString);
      estudiante.AddPair('IdEstudiante', Query.FieldByName('IdEstudiante')
        .AsString);
      estudiante.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
      estudiante.AddPair('Documento', Query.FieldByName('Documento').AsString);
      estudiante.AddPair('Correo', Query.FieldByName('Correo').AsString);
      estudiante.AddPair('Telefono', Query.FieldByName('Telefono').AsString);
      estudiante.AddPair('TipoDocumento', Query.FieldByName('TipoDocumento')
        .AsString);
      estudiante.AddPair('Genero', Query.FieldByName('Genero').AsString);
      estudiante.AddPair('Direccion', Query.FieldByName('Direccion').AsString);
      estudiante.AddPair('Municipio', Query.FieldByName('Municipio').AsString);
      estudiante.AddPair('Semestre', Query.FieldByName('Semestre').AsString);
      estudiante.AddPair('Eps', Query.FieldByName('Eps').AsString);
      estudiante.AddPair('EstadoCivil', Query.FieldByName('EstadoCivil')
        .AsString);

      Estudiantes.AddElement(estudiante);
      Query.Next;
    end;

    result.AddPair(JSON_RESULTS, Estudiantes);
    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE,
      'Los estudiantes se obtuvieron correctamente');

  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.getEstudiantes: TJSONObject;
var
  Query: TFDQuery;
  i: Integer;
  estudiante: TJSONObject;
  Estudiantes: TJSONArray;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Siap_Estudiantes ORDER BY Nombre';
    Query.Open;
    Query.First;

    Estudiantes := TJSONArray.Create;

    for i := 1 to Query.RecordCount do
    begin
      estudiante := TJSONObject.Create;
      estudiante.AddPair('IdEstudiante', Query.FieldByName('IdEstudiante')
        .AsString);
      estudiante.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
      estudiante.AddPair('Correo', Query.FieldByName('Correo').AsString);
      estudiante.AddPair('Documento', Query.FieldByName('Documento').AsString);
      estudiante.AddPair('Telefono', Query.FieldByName('Telefono').AsString);
      estudiante.AddPair('TipoDocumento', Query.FieldByName('TipoDocumento')
        .AsString);
      estudiante.AddPair('Genero', Query.FieldByName('Genero').AsString);
      estudiante.AddPair('Direccion', Query.FieldByName('Direccion').AsString);
      estudiante.AddPair('Municipio', Query.FieldByName('Municipio').AsString);
      estudiante.AddPair('Semestre', Query.FieldByName('Semestre').AsString);
      estudiante.AddPair('Eps', Query.FieldByName('Eps').AsString);
      estudiante.AddPair('EstadoCivil', Query.FieldByName('EstadoCivil')
        .AsString);

      Estudiantes.AddElement(estudiante);
      Query.Next;
    end;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE,
      'La lista de estudiantes se obtuvo correctamente');
    result.AddPair(JSON_RESULTS, Estudiantes);
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.getEstudiantesByPeriodo(IdPeriodo: string)
  : TJSONObject;
var
  Query: TFDQuery;
  i: Integer;
  estudiante: TJSONObject;
  Estudiantes: TJSONArray;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Siap_Practica_Docente as pd INNER JOIN' +
      ' Siap_Estudiantes as est ON pd.IdEstudiante = est.IdEstudiante WHERE ' +
      'pd.IdPeriodo=' + #39 + IdPeriodo + #39 + ' ORDER BY est.Nombre';
    Query.Open;
    Query.First;

    Estudiantes := TJSONArray.Create;

    for i := 1 to Query.RecordCount do
    begin
      estudiante := TJSONObject.Create;
      estudiante.AddPair('IdEstudiante', Query.FieldByName('IdEstudiante')
        .AsString);
      estudiante.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
      estudiante.AddPair('Correo', Query.FieldByName('Correo').AsString);
      estudiante.AddPair('Documento', Query.FieldByName('Documento').AsString);

      Estudiantes.AddElement(estudiante);
      Query.Next;
    end;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE,
      'La lista de estudiantes se obtuvo correctamente');
    result.AddPair(JSON_RESULTS, Estudiantes);
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.getEstudiantesBySecretaria(IdPeriodo: string)
  : TJSONObject;
var
  Query, QSecretarias: TFDQuery;
  i: Integer;
  IdSecretaria: string;
  Secretarias, Estudiantes: TJSONArray;
  estudiante, secretaria: TJSONObject;
  s: Integer;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;

    QSecretarias := TFDQuery.Create(nil);
    QSecretarias.Connection := moduloDatos.Conexion;
    QSecretarias.Close;

    QSecretarias.SQL.Text := 'SELECT * FROM Siap_Secretarias_Practica ORDER' +
      ' BY Secretaria';
    QSecretarias.Open;
    QSecretarias.First;

    Secretarias := TJSONArray.Create;

    for s := 1 to QSecretarias.RecordCount do
    begin

      // Leer los estudiantes de la secretaria departamental
      secretaria := TJSONObject.Create;
      secretaria.AddPair('IdSecretaria',
        QSecretarias.FieldByName('IdSecretaria').AsString);
      secretaria.AddPair('Secretaria', QSecretarias.FieldByName('Secretaria')
        .AsString);
      IdSecretaria := QSecretarias.FieldByName('IdSecretaria').AsString;

      Query.SQL.Text := 'SELECT Nombre,Documento,Correo,Horario,Grado,Rector,' +
        'Institucion,Ciudad FROM Siap_Carta_Autorizacion_Practica as cap' +
        ' INNER JOIN Siap_Estudiantes_Carta as ec ON cap.IdCarta = ec.IdCarta' +
        ' INNER JOIN Siap_Estudiantes as est ON ec.IdEstudiante = est.IdEstudiante'
        + ' WHERE cap.IdSecretaria=' + #39 + IdSecretaria + #39 +
        ' AND cap.IdPeriodo=' + #39 + IdPeriodo + #39 + ' ORDER BY Institucion';
      Query.Open;
      Query.First;

      Estudiantes := TJSONArray.Create;
      for i := 1 to Query.RecordCount do
      begin
        estudiante := TJSONObject.Create;
        estudiante.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
        estudiante.AddPair('Documento', Query.FieldByName('Documento')
          .AsString);
        estudiante.AddPair('Correo', Query.FieldByName('Correo').AsString);
        estudiante.AddPair('Horario', Query.FieldByName('Horario').AsString);
        estudiante.AddPair('Grado', Query.FieldByName('Grado').AsString);
        estudiante.AddPair('Rector', Query.FieldByName('Rector').AsString);
        estudiante.AddPair('Institucion', Query.FieldByName('Institucion')
          .AsString);
        estudiante.AddPair('Ciudad', Query.FieldByName('Ciudad').AsString);

        Estudiantes.AddElement(estudiante);
        Query.Next;
      end;

      secretaria.AddPair('Estudiantes', Estudiantes);
      Secretarias.AddElement(secretaria);
      QSecretarias.Next;
    end;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'El informe se creo correctamente');
    result.AddPair(JSON_RESULTS, Secretarias);

  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.getPeriodos: TJSONObject;
var
  i: Integer;
  Periodos: TJSONArray;
  periodo: TJSONObject;
  Query: TFDQuery;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Siap_Periodos';
    Query.Open;
    Query.First;

    Periodos := TJSONArray.Create;

    for i := 1 to Query.RecordCount do
    begin
      periodo := TJSONObject.Create;
      periodo.AddPair('IdPeriodo', Query.FieldByName('IdPeriodo').AsString);
      periodo.AddPair('Periodo', Query.FieldByName('Periodo').AsString);

      Periodos.AddElement(periodo);
      Query.Next;
    end;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE, 'Los periodos se obtuvieron correctamente');
    result.AddPair(JSON_RESULTS, Periodos);

  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.getSecretarias: TJSONObject;
var
  Query: TFDQuery;
  i: Integer;
  secretaria: TJSONObject;
  Secretarias: TJSONArray;
begin
  try
    result := TJSONObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.SQL.Text := 'SELECT * FROM Siap_Secretarias_Practica';
    Query.Open;
    Query.First;

    Secretarias := TJSONArray.Create;
    for i := 1 to Query.RecordCount do
    begin
      secretaria := TJSONObject.Create;
      secretaria.AddPair('IdSecretaria', Query.FieldByName('IdSecretaria')
        .AsString);
      secretaria.AddPair('Secretaria', Query.FieldByName('Secretaria')
        .AsString);

      Secretarias.AddElement(secretaria);
      Query.Next;
    end;

    result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    result.AddPair(JSON_RESPONSE,
      'Las secretarias se obtuvieron correctamente');
    result.AddPair(JSON_RESULTS, Secretarias);
  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.putEstudiantePeriodo(estudiante: TJSONObject)
  : TJSONObject;
var
  Query: TFDQuery;
  IdEstudiante, Codigo, IdRegistro, docAntDis, docAntJud, docAntFis, docMedCor,
    docIdenti, docEps, documento, periodo: string;
begin
  try
    result := TJSONObject.Create;

    IdEstudiante := estudiante.GetValue('IdEstudiante').Value;
    Codigo := estudiante.GetValue('Codigo').Value;

    if IdEstudiante = Codigo then
    begin

      Query := TFDQuery.Create(nil);
      Query.Connection := moduloDatos.Conexion;
      Query.Close;
      Query.SQL.Text := 'UPDATE Siap_Estudiantes SET ';
      Query.SQL.Add('Documento=:Documento, ');
      Query.SQL.Add('Nombre=:Nombre, ');
      Query.SQL.Add('Correo=:Correo, ');
      Query.SQL.Add('Telefono=:Telefono, ');
      Query.SQL.Add('TipoDocumento=:TipoDocumento, ');
      Query.SQL.Add('Genero=:Genero, ');
      Query.SQL.Add('Direccion=:Direccion, ');
      Query.SQL.Add('Municipio=:Municipio, ');
      Query.SQL.Add('Semestre=:Semestre, ');
      Query.SQL.Add('Eps=:Eps, ');
      Query.SQL.Add('EstadoCivil=:EstadoCivil WHERE IdEstudiante=' + #39 +
        IdEstudiante + #39);

      documento := estudiante.GetValue('Documento').Value;
      Query.Params.ParamByName('Documento').Value := documento;

      Query.Params.ParamByName('Nombre').Value :=
        estudiante.GetValue('Nombre').Value;

      Query.Params.ParamByName('Correo').Value :=
        estudiante.GetValue('Correo').Value;

      Query.Params.ParamByName('Telefono').Value :=
        estudiante.GetValue('Telefono').Value;

      Query.Params.ParamByName('TipoDocumento').Value :=
        estudiante.GetValue('TipoDocumento').Value;

      Query.Params.ParamByName('Genero').Value :=
        estudiante.GetValue('Genero').Value;

      Query.Params.ParamByName('Direccion').Value :=
        estudiante.GetValue('Direccion').Value;

      Query.Params.ParamByName('Municipio').Value :=
        estudiante.GetValue('Municipio').Value;

      Query.Params.ParamByName('Semestre').Value :=
        estudiante.GetValue('Semestre').Value;

      Query.Params.ParamByName('Eps').Value := estudiante.GetValue('Eps').Value;

      Query.Params.ParamByName('EstadoCivil').Value :=
        estudiante.GetValue('EstadoCivil').Value;

      Query.ExecSQL;

      // ShowMessage('Actualizó al estudiante');

      { Guardar los archivos en el servidor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
      periodo := estudiante.GetValue('Periodo').Value;

      Query.Close;
      Query.SQL.Text := 'SELECT * FROM Siap_Practica_Docente WHERE IdPeriodo=' +
        #39 + periodo + #39 + ' AND IdEstudiante=' + #39 + IdEstudiante + #39;
      Query.Open;

      // Si no existe el registro para el periodo se crea
      if Query.RecordCount = 0 then
      begin
        Query.Close;
        Query.SQL.Text := 'INSERT INTO Siap_Practica_Docente ' +
          '(IdRegistro,IdPeriodo,IdEstudiante,EspacioAcademico) VALUES' +
          ' (:IdRegistro,:IdPeriodo,:IdEstudiante,:EspacioAcademico)';

        Query.Params.ParamByName('IdRegistro').Value := moduloDatos.generarID;
        Query.Params.ParamByName('IdPeriodo').Value := periodo;
        Query.Params.ParamByName('IdEstudiante').Value := IdEstudiante;
        Query.Params.ParamByName('EspacioAcademico').Value :=
          estudiante.GetValue('EspacioAcademico').Value;

        Query.ExecSQL;
      end;

      // Se abre de nuevo la consulta para realizar las validaciones
      Query.Close;
      Query.SQL.Text := 'SELECT * FROM Siap_Practica_Docente WHERE IdPeriodo=' +
        #39 + periodo + #39 + ' AND IdEstudiante=' + #39 + IdEstudiante + #39;
      Query.Open;
      IdRegistro := Query.FieldByName('IdRegistro').Value;

      // ShowMessage('El registro de la prática docente es: ' + IdRegistro);

      // Antecedentes Disciplinarios
      docAntDis := estudiante.GetValue('AntecedentesDisciplinarios').Value;
      if (docAntDis <> '') and (docAntDis <> Query.FieldByName('docAntDis')
        .Value) then
        subirArchivo(docAntDis, 'Antecedentes_Displinarios_' + documento
          + '.pdf');

      // Antecedentes Judiciales
      docAntJud := estudiante.GetValue('AntecedentesJudiciales').Value;
      if (docAntJud <> '') and (docAntJud <> Query.FieldByName('docAntJud')
        .Value) then
        subirArchivo(docAntJud, 'Antecedentes_Judiciales_' + documento
          + '.pdf');

      // Antecedentes Fiscales
      docAntFis := estudiante.GetValue('AntecedentesFiscales').Value;
      if (docAntFis <> '') and (docAntFis <> Query.FieldByName('docAntFis')
        .Value) then
        subirArchivo(docAntFis, 'Antecedentes_Fiscales_' + documento + '.pdf');

      // Medidas Correctivas
      docMedCor := estudiante.GetValue('MedidasCorrectivas').Value;
      if (docMedCor <> '') and (docMedCor <> Query.FieldByName('docMedCor')
        .Value) then
        subirArchivo(docMedCor, 'Medidas_Correctivas_' + documento + '.pdf');

      // Documento de Identidad
      docIdenti := estudiante.GetValue('DocumentoIdentidad').Value;
      if (docIdenti <> '') and (docIdenti <> Query.FieldByName('docIdentidad')
        .Value) then
        subirArchivo(docIdenti, 'Documento_Identidad_' + documento + '.pdf');

      // Certificado EPS
      docEps := estudiante.GetValue('CertificadoEPS').Value;
      if (docEps <> '') or (docEps <> Query.FieldByName('docEPS').Value) then
        subirArchivo(docEps, 'Certificado_EPS_' + documento + '.pdf');

      // Guardar el registro en la base de datos: Se guardan los archivos en MD5
      Query.Close;
      Query.SQL.Text := 'UPDATE Siap_Practica_Docente SET ';
      Query.SQL.Add('EspacioAcademico=:EspacioAcademico, ');
      Query.SQL.Add('docAntDis=:docAntDis, ');
      Query.SQL.Add('docAntJud=:docAntJud, ');
      Query.SQL.Add('docAntFis=:docAntFis, ');
      Query.SQL.Add('docMedCor=:docMedCor, ');
      Query.SQL.Add('docIdentidad=:docIdentidad, ');
      Query.SQL.Add('docEPS=:docEPS ');
      Query.SQL.Add(' WHERE IdRegistro=' + #39 + IdRegistro + #39);

      Query.Params.ParamByName('EspacioAcademico').Value :=
        estudiante.GetValue('EspacioAcademico').Value;

      if docAntDis <> '' then
        Query.Params.ParamByName('docAntDis').Value :=
          moduloDatos.toMD5(docAntDis)
      else
        Query.Params.ParamByName('docAntDis').Value := docAntDis;

      if docAntJud <> '' then
        Query.Params.ParamByName('docAntJud').Value :=
          moduloDatos.toMD5(docAntJud)
      else
        Query.Params.ParamByName('docAntJud').Value := docAntJud;

      if docAntFis <> '' then
        Query.Params.ParamByName('docAntFis').Value :=
          moduloDatos.toMD5(docAntFis)
      else
        Query.Params.ParamByName('docAntFis').Value := docAntFis;

      if docMedCor <> '' then
        Query.Params.ParamByName('docMedCor').Value :=
          moduloDatos.toMD5(docMedCor)
      else
        Query.Params.ParamByName('docMedCor').Value := docMedCor;

      if docIdenti <> '' then
        Query.Params.ParamByName('docIdentidad').Value :=
          moduloDatos.toMD5(docIdenti)
      else
        Query.Params.ParamByName('docIdentidad').Value := docIdenti;

      if docEps <> '' then
        Query.Params.ParamByName('docEps').Value := moduloDatos.toMD5(docEps)
      else
        Query.Params.ParamByName('docEps').Value := docEps;

      Query.ExecSQL;

      result.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      result.AddPair(JSON_RESPONSE, 'Los datos se guardaron correctamente');
    end
    else
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, 'El código de inscripción es incorrecto');
    end;

  except
    on E: Exception do
    begin
      result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      result.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Query.Free;
end;

function TmoduloPracticaDocente.subirArchivo(archivo, nombre: string): boolean;
var
  archivoJson, base64, nombreArchivo, rutaLocal: string;
  archivoEntrada, archivoSalida: TMemoryStream;
  p: Integer;
begin
  try

    { Se obtienen los datos del archivo JSON }
    archivoJson := archivo;

    { Se crean los recursos de Memoria }
    archivoEntrada := TMemoryStream.Create;
    archivoSalida := TMemoryStream.Create;
    p := pos('base64', archivoJson);
    base64 := Copy(archivoJson, p + 7, length(archivoJson));
    archivoEntrada.LoadFromStream(TStringStream.Create(base64));

    { Se decodifica la información del Base64 }
    TNetEncoding.base64.Decode(archivoEntrada, archivoSalida);
    nombreArchivo := nombre;

    { Ruta Local del Archivo - Guardar Archivo en el Servidor }
    rutaLocal := ExtractFilePath(ParamStr(0)) + '\DocumentosPractica';
    if not DirectoryExists(rutaLocal) then
      CreateDir(rutaLocal);

    archivoSalida.SaveToFile(rutaLocal + '\' + nombre);

  except
    on E: Exception do
    begin
      result := false;
    end;
  end;
end;

end.
