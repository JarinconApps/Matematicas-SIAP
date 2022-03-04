unit uModuloEventoEMEM;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Stan.Intf, dialogs,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uConstantes, uModuloDatos,
  Utilidades, uFVistaJSON;

type
  TmoduloEventoEMEM = class(TDataModule)
  private
    { Private declarations }
  public
    function getEventosEMEM: TJsonObject;
    function getEventoEMEM(Id: string): TJsonObject;
    function getEvento(IdEvento: string): TJsonObject;
    function getConferencias(IdEvento: string): TJsonObject;
    function getPonencias(IdEvento: string): TJsonObject;
    function getConferenciasPonenciasByModalidadEvento(IdModalidad, IdEvento,
      Tipo: string): TJSONArray;
    function getConferencista(IdConferencista: string): TJsonObject;
    function getBiografiaConferencista(IdConferencista: string): TJSONArray;
    function getCronograma(IdEvento: string): TJsonObject;
    function getHorasCronograma(IdDia: string): TJSONArray;
    function getPonenciasCronograma(IdEventoCronograma: string): TJSONArray;
    function getModalidadPonencia(IdModalidad: string): TJsonObject;
    function getContactoEvento(IdEvento: string): TJsonObject;
    function getOrganizador(IdOrganizador, IdEvento: string): TJsonObject;
    function getFuncionesOrganizador(IdOrganizador, IdEvento: string)
      : TJSONArray;
    function postParticipante(datos: TJsonObject): TJsonObject;
    function getTiposParticipacion: TJsonObject;
    function getParticipanteEvento(Documento, IdEvento: string): TJsonObject;
    function getParticipante(IdParticipante: string): TJsonObject;
    function getTipoParticipacion(IdTipoParticipacion: string): TJsonObject;
  end;

var
  moduloEventoEMEM: TmoduloEventoEMEM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

function TmoduloEventoEMEM.getBiografiaConferencista(IdConferencista: string)
  : TJSONArray;
var
  JSON, JsonBiografia: TJsonObject;
  Query: TFDQuery;
  Biografias: TJSONArray;
  i: Integer;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text :=
      'SELECT * FROM emem_biografia_conferencista WHERE IdConferencista=' + #39
      + IdConferencista + #39 + ' ORDER BY Orden';
    Query.Open;
    Query.First;

    Biografias := TJSONArray.Create;

    for i := 1 to Query.RecordCount do
    begin
      JsonBiografia := TJsonObject.Create;
      JsonBiografia.AddPair('IdBiografia', Query.FieldByName('IdBiografia')
        .AsString);
      JsonBiografia.AddPair('Biografia', Query.FieldByName('Biografia')
        .AsString);
      JsonBiografia.AddPair('Orden', Query.FieldByName('Orden').AsString);
      JsonBiografia.AddPair('IdConferencista',
        Query.FieldByName('IdConferencista').AsString);

      Biografias.AddElement(JsonBiografia);
      Query.Next;
    end;
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := Biografias;
  Query.Free;
end;

function TmoduloEventoEMEM.getConferencias(IdEvento: string): TJsonObject;
var
  JSON, jsonModalidad: TJsonObject;
  QModalidades: TFDQuery;
  Modalidades: TJSONArray;
  i: Integer;
  IdModalidad: string;
begin
  try
    JSON := TJsonObject.Create;
    QModalidades := TFDQuery.Create(nil);
    QModalidades.Connection := moduloDatos.Conexion;

    QModalidades.Close;
    QModalidades.SQL.Text :=
      'SELECT * FROM emem_modalidades ORDER BY Modalidad';
    QModalidades.Open;
    QModalidades.First;

    Modalidades := TJSONArray.Create;
    for i := 1 to QModalidades.RecordCount do
    begin
      jsonModalidad := TJsonObject.Create;

      IdModalidad := QModalidades.FieldByName('IdModalidad').AsString;
      jsonModalidad.AddPair('IdModalidad', IdModalidad);
      jsonModalidad.AddPair('Modalidad', QModalidades.FieldByName('Modalidad')
        .AsString);

      { Agregar las conferencias }
      jsonModalidad.AddPair('Conferencias',
        getConferenciasPonenciasByModalidadEvento(IdModalidad, IdEvento,
        'CONFERENCIA'));

      Modalidades.AddElement(jsonModalidad);
      QModalidades.Next;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE, 'Las conferencia se obtuvieron correctamente');
    JSON.AddPair(JSON_RESULTS, Modalidades);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  QModalidades.Free;
end;

function TmoduloEventoEMEM.getConferenciasPonenciasByModalidadEvento
  (IdModalidad, IdEvento, Tipo: string): TJSONArray;
var
  Query: TFDQuery;
  Conferencias: TJSONArray;
  JSON, JsonConferencia: TJsonObject;
  i: Integer;
  IdConferencista: string;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;

    Query.SQL.Text := 'SELECT * FROM emem_conferencias WHERE IdModalidad=' + #39
      + IdModalidad + #39 + ' AND IdEvento=' + #39 + IdEvento + #39 +
      ' AND Tipo=' + #39 + Tipo + #39;
    Query.Open;
    Query.First;

    Conferencias := TJSONArray.Create;

    for i := 1 to Query.RecordCount do
    begin
      JsonConferencia := TJsonObject.Create;
      JsonConferencia.AddPair('IdConferencia',
        Query.FieldByName('IdConferencia').AsString);
      JsonConferencia.AddPair('Titulo', Query.FieldByName('Titulo').AsString);

      IdConferencista := Query.FieldByName('IdConferencista').AsString;
      JsonConferencia.AddPair('IdConferencista', IdConferencista);
      JsonConferencia.AddPair('Conferencista',
        getConferencista(IdConferencista));
      JsonConferencia.AddPair('Resumen', Query.FieldByName('Resumen').AsString);
      JsonConferencia.AddPair('IdEvento', Query.FieldByName('IdEvento')
        .AsString);
      JsonConferencia.AddPair('IdModalidad', Query.FieldByName('IdModalidad')
        .AsString);

      Conferencias.AddElement(JsonConferencia);
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := Conferencias;
  Query.Free;
end;

function TmoduloEventoEMEM.getConferencista(IdConferencista: string)
  : TJsonObject;
var
  JSON: TJsonObject;
  Query: TFDQuery;
begin
  try
    JSON := TJsonObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM emen_conferencistas WHERE IdConferencista='
      + #39 + IdConferencista + #39;
    Query.Open;
    Query.First;

    JSON.AddPair('IdConferencista', IdConferencista);
    JSON.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
    JSON.AddPair('Correo', Query.FieldByName('Correo').AsString);
    JSON.AddPair('Institucion', Query.FieldByName('Institucion').AsString);

    JSON.AddPair('Biografia', getBiografiaConferencista(IdConferencista));

  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getContactoEvento(IdEvento: string): TJsonObject;
var
  JSON, jsonOrganizador: TJsonObject;
  Organizadores: TJSONArray;
  i: Integer;
  Query: TFDQuery;
  IdOrganizador: string;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM emen_evento_organizadores WHERE IdEvento='
      + #39 + IdEvento + #39 + ' ORDER BY Orden';
    Query.Open;
    Query.First;

    Organizadores := TJSONArray.Create;

    for i := 1 to Query.RecordCount do
    begin
      jsonOrganizador := TJsonObject.Create;

      jsonOrganizador.AddPair('IdEventoOrganizador',
        Query.FieldByName('IdEventoOrganizador').AsString);

      IdOrganizador := Query.FieldByName('IdOrganizador').AsString;
      jsonOrganizador.AddPair('IdOrganizador', IdOrganizador);
      jsonOrganizador.AddPair('Organizador', getOrganizador(IdOrganizador,
        IdEvento));

      jsonOrganizador.AddPair('IdEvento', Query.FieldByName('IdEvento')
        .AsString);
      jsonOrganizador.AddPair('Orden', Query.FieldByName('Orden').AsString);

      Organizadores.AddElement(jsonOrganizador);
      Query.Next;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE,
      'Los Organizadores se obtuvieron correctamente');
    JSON.AddPair(JSON_RESULTS, Organizadores);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getCronograma(IdEvento: string): TJsonObject;
var
  JSON, jsonDia: TJsonObject;
  Dias: TJSONArray;
  i: Integer;
  Query: TFDQuery;
  IdDia: string;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM emem_dias_cronograma WHERE IdEvento=' + #39
      + IdEvento + #39;
    Query.Open;
    Query.First;

    Dias := TJSONArray.Create;

    for i := 1 to Query.RecordCount do
    begin
      jsonDia := TJsonObject.Create;

      IdDia := Query.FieldByName('IdDia').AsString;
      jsonDia.AddPair('IdDia', IdDia);
      jsonDia.AddPair('Dia', Query.FieldByName('Dia').AsString);
      jsonDia.AddPair('IdEvento', Query.FieldByName('IdEvento').AsString);

      jsonDia.AddPair('Horas', getHorasCronograma(IdDia));

      Dias.AddElement(jsonDia);
      Query.Next;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE, 'El cronograma se obtuvo correctamente');
    JSON.AddPair(JSON_RESULTS, Dias);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getEvento(IdEvento: string): TJsonObject;
var
  JSON: TJsonObject;
  Query: TFDQuery;
  i: Integer;
begin
  try
    JSON := TJsonObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM EMEM_Eventos WHERE IdEvento=' + #39 +
      IdEvento + #39;
    Query.Open;
    Query.First;

    JSON.AddPair('IdEvento', Query.FieldByName('IdEvento').AsString);
    JSON.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
    JSON.AddPair('Fecha', Query.FieldByName('Fecha').AsString);
    JSON.AddPair('Dias', Query.FieldByName('Dias').AsString);
    JSON.AddPair('Visible', Query.FieldByName('Visible').AsString);
    JSON.AddPair('Descripcion', Query.FieldByName('Descripcion').AsString);
    JSON.AddPair('Titulo', Query.FieldByName('Titulo').AsString);
    JSON.AddPair('Modalidades', Query.FieldByName('Modalidades').AsString);

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE, 'Eventos obtenidos correctamente');

  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getEventoEMEM(Id: string): TJsonObject;
var
  JSON, JsonEvento: TJsonObject;
  Query: TFDQuery;
  i: Integer;
  Eventos: TJSONArray;
begin
  try
    JSON := TJsonObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM EMEM_Eventos WHERE IdEvento=' + #39
      + Id + #39;
    Query.Open;
    Query.First;

    Eventos := TJSONArray.Create;
    for i := 1 to Query.RecordCount do
    begin
      JsonEvento := TJsonObject.Create;
      JsonEvento.AddPair('IdEvento', Query.FieldByName('IdEvento').AsString);
      JsonEvento.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
      JsonEvento.AddPair('Fecha', Query.FieldByName('Fecha').AsString);
      JsonEvento.AddPair('Dias', Query.FieldByName('Dias').AsString);
      JsonEvento.AddPair('Visible', Query.FieldByName('Visible').AsString);
      JsonEvento.AddPair('Descripcion', Query.FieldByName('Descripcion')
        .AsString);
      JsonEvento.AddPair('Titulo', Query.FieldByName('Titulo').AsString);
      JsonEvento.AddPair('Modalidades', Query.FieldByName('Modalidades')
        .AsString);

      Eventos.AddElement(JsonEvento);
      Query.Next;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE, 'Eventos obtenidos correctamente');
    JSON.AddPair(JSON_RESULTS, Eventos);

  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getEventosEMEM: TJsonObject;
var
  JSON, JsonEvento: TJsonObject;
  Query: TFDQuery;
  i: Integer;
  Eventos: TJSONArray;
begin
  try
    JSON := TJsonObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM EMEM_Eventos ORDER BY Fecha';
    Query.Open;
    Query.First;

    Eventos := TJSONArray.Create;
    for i := 1 to Query.RecordCount do
    begin
      JsonEvento := TJsonObject.Create;
      JsonEvento.AddPair('IdEvento', Query.FieldByName('IdEvento').AsString);
      JsonEvento.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
      JsonEvento.AddPair('Fecha', Query.FieldByName('Fecha').AsString);
      JsonEvento.AddPair('Dias', Query.FieldByName('Dias').AsString);
      JsonEvento.AddPair('Visible', Query.FieldByName('Visible').AsString);
      JsonEvento.AddPair('Descripcion', Query.FieldByName('Descripcion')
        .AsString);
      JsonEvento.AddPair('Titulo', Query.FieldByName('Titulo').AsString);
      JsonEvento.AddPair('Modalidades', Query.FieldByName('Modalidades')
        .AsString);

      Eventos.AddElement(JsonEvento);
      Query.Next;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE, 'Eventos obtenidos correctamente');
    JSON.AddPair(JSON_RESULTS, Eventos);
    { Tengo que crear en la base de datos la lista de eventos }

  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getFuncionesOrganizador(IdOrganizador,
  IdEvento: string): TJSONArray;
var
  JSON, JsonFuncion: TJsonObject;
  Query: TFDQuery;
  i: Integer;
  Funciones: TJSONArray;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text :=
      'SELECT * FROM emem_funciones_organizador WHERE IdOrganizador=' + #39 +
      IdOrganizador + #39 + ' AND IdEvento=' + #39 + IdEvento + #39;
    Query.Open;
    Query.First;

    Funciones := TJSONArray.Create;
    for i := 1 to Query.RecordCount do
    begin
      JsonFuncion := TJsonObject.Create;

      JsonFuncion.AddPair('IdFuncion', Query.FieldByName('IdFuncion').AsString);
      JsonFuncion.AddPair('Funcion', Query.FieldByName('Funcion').AsString);
      JsonFuncion.AddPair('IdOrganizador', Query.FieldByName('IdOrganizador')
        .AsString);
      JsonFuncion.AddPair('IdEvento', Query.FieldByName('IdEvento').AsString);

      Funciones.AddElement(JsonFuncion);
      Query.Next;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE, 'Funciones obtenidas correctamente');
    JSON.AddPair(JSON_RESULTS, Funciones);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := Funciones;
  Query.Free;
end;

function TmoduloEventoEMEM.getHorasCronograma(IdDia: string): TJSONArray;
var
  JSON, JsonHora: TJsonObject;
  Query: TFDQuery;
  i: Integer;
  Horas: TJSONArray;
  IdEventoCronograma: string;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM emem_evento_cronograma WHERE IdDia=' + #39
      + IdDia + #39 + ' ORDER BY Orden';
    Query.Open;
    Query.First;

    Horas := TJSONArray.Create;
    for i := 1 to Query.RecordCount do
    begin
      JsonHora := TJsonObject.Create;

      IdEventoCronograma := Query.FieldByName('IdEventoCronograma').AsString;
      JsonHora.AddPair('IdEventoCronograma', IdEventoCronograma);
      JsonHora.AddPair('Hora', Query.FieldByName('Hora').AsString);
      JsonHora.AddPair('Titulo', Query.FieldByName('Titulo').AsString);
      JsonHora.AddPair('Descripcion', Query.FieldByName('Descripcion')
        .AsString);
      JsonHora.AddPair('Enlace', Query.FieldByName('Enlace').AsString);
      JsonHora.AddPair('IdDia', Query.FieldByName('IdDia').AsString);
      JsonHora.AddPair('Orden', Query.FieldByName('Orden').AsString);

      JsonHora.AddPair('Ponencias', getPonenciasCronograma(IdEventoCronograma));

      Horas.AddElement(JsonHora);
      Query.Next;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE, 'Horas obtenidas correctamente');
    JSON.AddPair(JSON_RESULTS, Horas);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := Horas;
  Query.Free;
end;

function TmoduloEventoEMEM.getModalidadPonencia(IdModalidad: string)
  : TJsonObject;
var
  JSON: TJsonObject;
  Query: TFDQuery;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM emem_modalidades WHERE IdModalidad=' + #39
      + IdModalidad + #39;
    Query.Open;

    JSON.AddPair('IdModalidad', Query.FieldByName('IdModalidad').AsString);
    JSON.AddPair('Modalidad', Query.FieldByName('Modalidad').AsString);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getOrganizador(IdOrganizador, IdEvento: string)
  : TJsonObject;
var
  JSON: TJsonObject;
  Organizadores: TJSONArray;
  i: Integer;
  Query: TFDQuery;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM emem_organizadores WHERE IdOrganizador=' +
      #39 + IdOrganizador + #39;
    Query.Open;

    JSON.AddPair('IdOrganizador', Query.FieldByName('IdOrganizador').AsString);
    JSON.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
    JSON.AddPair('Correo', Query.FieldByName('Correo').AsString);

    JSON.AddPair('Funciones', getFuncionesOrganizador(IdOrganizador, IdEvento));
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getParticipante(IdParticipante: string): TJsonObject;
var
  JSON: TJsonObject;
  Query: TFDQuery;
begin
  try
    JSON := TJsonObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM emem_participante WHERE IdParticipante=' +
      #39 + IdParticipante + #39;
    Query.Open;
    Query.First;

    JSON.AddPair('IdParticipante', IdParticipante);
    JSON.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
    JSON.AddPair('Correo', Query.FieldByName('Correo').AsString);
    JSON.AddPair('Documento', Query.FieldByName('Documento').AsString);
    JSON.AddPair('Institucion', Query.FieldByName('Institucion').AsString);
    JSON.AddPair('Titulo', Query.FieldByName('Titulo').AsString);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getParticipanteEvento(Documento, IdEvento: string)
  : TJsonObject;
var
  JSON: TJsonObject;
  Query: TFDQuery;
  IdParticipante, IdTipoParticipante: string;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;

    Query.SQL.Text := 'SELECT * FROM emem_participante_evento as epe INNER' +
      ' JOIN emem_participante as ep ON epe.IdParticipante=ep.IdParticipante ' +
      'WHERE ep.Documento=' + #39 + Documento + #39 + ' AND epe.IdEvento=' + #39
      + IdEvento + #39;
    Query.Open;

    JSON.AddPair('IdParticipanteEvento',
      Query.FieldByName('IdParticipanteEvento').AsString);

    JSON.AddPair('IdEvento', IdEvento);
    JSON.AddPair('Evento', getEvento(IdEvento));

    IdParticipante := Query.FieldByName('IdParticipante').AsString;
    JSON.AddPair('IdParticipante', IdParticipante);
    JSON.AddPair('Participante', getParticipante(IdParticipante));

    IdTipoParticipante := Query.FieldByName('IdTipoParticipante').AsString;
    JSON.AddPair('IdTipoParticipante', IdTipoParticipante);
    JSON.AddPair('TipoParticipacion', getTipoParticipacion(IdTipoParticipante));
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getPonencias(IdEvento: string): TJsonObject;
var
  JSON, jsonModalidad: TJsonObject;
  QModalidades: TFDQuery;
  Modalidades: TJSONArray;
  i: Integer;
  IdModalidad: string;
begin
  try
    JSON := TJsonObject.Create;
    QModalidades := TFDQuery.Create(nil);
    QModalidades.Connection := moduloDatos.Conexion;

    QModalidades.Close;
    QModalidades.SQL.Text :=
      'SELECT * FROM emem_modalidades ORDER BY Modalidad';
    QModalidades.Open;
    QModalidades.First;

    Modalidades := TJSONArray.Create;
    for i := 1 to QModalidades.RecordCount do
    begin
      jsonModalidad := TJsonObject.Create;

      IdModalidad := QModalidades.FieldByName('IdModalidad').AsString;
      jsonModalidad.AddPair('IdModalidad', IdModalidad);
      jsonModalidad.AddPair('Modalidad', QModalidades.FieldByName('Modalidad')
        .AsString);

      { Agregar las conferencias }
      jsonModalidad.AddPair('Conferencias',
        getConferenciasPonenciasByModalidadEvento(IdModalidad, IdEvento,
        'PONENCIA'));

      Modalidades.AddElement(jsonModalidad);
      QModalidades.Next;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE, 'Las conferencia se obtuvieron correctamente');
    JSON.AddPair(JSON_RESULTS, Modalidades);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  QModalidades.Free;
end;

function TmoduloEventoEMEM.getPonenciasCronograma(IdEventoCronograma: string)
  : TJSONArray;
var
  JSON, jsonponencia: TJsonObject;
  ponencias: TJSONArray;
  i: Integer;
  Query: TFDQuery;
  IdConferencista, IdModalidad: string;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text :=
      'SELECT * FROM emem_conferencias WHERE IdEventoCronograma=' + #39 +
      IdEventoCronograma + #39 + ' ORDER BY IdModalidad';
    Query.Open;
    Query.First;

    ponencias := TJSONArray.Create;
    for i := 1 to Query.RecordCount do
    begin
      jsonponencia := TJsonObject.Create;

      IdConferencista := Query.FieldByName('IdConferencista').AsString;
      jsonponencia.AddPair('IdConferencia', IdConferencista);
      jsonponencia.AddPair('Conferencista', getConferencista(IdConferencista));

      jsonponencia.AddPair('Titulo', Query.FieldByName('Titulo').AsString);
      jsonponencia.AddPair('Resumen', Query.FieldByName('Resumen').AsString);
      jsonponencia.AddPair('IdEvento', Query.FieldByName('IdEvento').AsString);

      IdModalidad := Query.FieldByName('IdModalidad').AsString;
      jsonponencia.AddPair('IdModalidad', IdModalidad);
      jsonponencia.AddPair('Modalidad', getModalidadPonencia(IdModalidad));

      jsonponencia.AddPair('Tipo', Query.FieldByName('Tipo').AsString);
      jsonponencia.AddPair('Enlace', Query.FieldByName('Enlace').AsString);
      jsonponencia.AddPair('IdEventoCronograma',
        Query.FieldByName('IdEventoCronograma').AsString);

      ponencias.AddElement(jsonponencia);
      Query.Next;
    end;
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := ponencias;
  Query.Free;
end;

function TmoduloEventoEMEM.getTipoParticipacion(IdTipoParticipacion: string)
  : TJsonObject;
var
  JSON: TJsonObject;
  Query: TFDQuery;
begin
  try
    JSON := TJsonObject.Create;

    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text :=
      'SELECT * FROM emem_tipo_participante WHERE IdTipoParticipante=' + #39 +
      IdTipoParticipacion + #39;
    Query.Open;
    Query.First;

    JSON.AddPair('IdTipoParticipante', IdTipoParticipacion);
    JSON.AddPair('Nombre', Query.FieldByName('Nombre').AsString);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.getTiposParticipacion: TJsonObject;
var
  JSON, JsonTipo: TJsonObject;
  Query: TFDQuery;
  i: Integer;
  TiposParticipacion: TJSONArray;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM emem_tipo_participante';
    Query.Open;
    Query.First;

    TiposParticipacion := TJSONArray.Create;

    for i := 1 to Query.RecordCount do
    begin
      JsonTipo := TJsonObject.Create;
      JsonTipo.AddPair('IdTipoParticipante',
        Query.FieldByName('IdTipoParticipante').AsString);
      JsonTipo.AddPair('Nombre', Query.FieldByName('Nombre').AsString);

      TiposParticipacion.AddElement(JsonTipo);
      Query.Next;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE,
      'Los tipos de participantes se obtuvieron correctamente');
    JSON.AddPair(JSON_RESULTS, TiposParticipacion);
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

function TmoduloEventoEMEM.postParticipante(datos: TJsonObject): TJsonObject;
var
  JSON: TJsonObject;
  i: Integer;
  Query: TFDQuery;
  Documento, IdEvento, IdParticipante: string;
begin
  try
    JSON := TJsonObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    Query.Close;

    { Verificar si el participante ya existe }
    Documento := datos.GetValue('Documento').Value;
    IdEvento := datos.GetValue('IdEvento').Value;

    Query.SQL.Text := 'SELECT * FROM emem_participante WHERE Documento=' + #39 +
      Documento + #39;
    Query.Open;

    if Query.RecordCount >= 1 then
    begin
      { Determinar si ya esta registrado para el evento actual }
      IdParticipante := Query.FieldByName('IdParticipante').AsString;

      Query.Close;
      Query.SQL.Text :=
        'SELECT * FROM emem_participante_evento WHERE IdParticipante=' + #39 +
        IdParticipante + #39 + ' AND IdEvento=' + #39 + IdEvento + #39;
      Query.Open;

      if Query.RecordCount = 0 then
      begin
        Query.Close;
        Query.SQL.Text := 'INSERT INTO emem_participante_evento (';
        Query.SQL.Add('IdParticipanteEvento, ');
        Query.SQL.Add('IdEvento, ');
        Query.SQL.Add('IdTipoParticipante, ');
        Query.SQL.Add('TituloPonencia, ');
        Query.SQL.Add('IdParticipante) VALUES (');
        Query.SQL.Add(':IdParticipanteEvento, ');
        Query.SQL.Add(':IdEvento, ');
        Query.SQL.Add(':IdTipoParticipante, ');
        Query.SQL.Add(':TituloPonencia, ');
        Query.SQL.Add(':IdParticipante)');

        Query.Params.ParamByName('IdParticipanteEvento').Value :=
          moduloDatos.generarID;

        Query.Params.ParamByName('IdEvento').Value :=
          datos.GetValue('IdEvento').Value;

        Query.Params.ParamByName('IdTipoParticipante').Value :=
          datos.GetValue('IdTipoParticipante').Value;

        Query.Params.ParamByName('TituloPonencia').Value :=
          datos.GetValue('TituloPonencia').Value;

        Query.Params.ParamByName('IdParticipante').Value := IdParticipante;

        Query.ExecSQL;

        JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
        JSON.AddPair(JSON_RESPONSE,
          'La inscripción se realizó satisfactoriamente');
      end;
    end
    else
    begin

      Query.Close;
      Query.SQL.Text := 'INSERT INTO emem_participante (';
      Query.SQL.Add('IdParticipante, ');
      Query.SQL.Add('Nombre, ');
      Query.SQL.Add('Correo, ');
      Query.SQL.Add('Documento, ');
      Query.SQL.Add('Institucion, ');
      Query.SQL.Add('Titulo) VALUES (');
      Query.SQL.Add(':IdParticipante, ');
      Query.SQL.Add(':Nombre, ');
      Query.SQL.Add(':Correo, ');
      Query.SQL.Add(':Documento, ');
      Query.SQL.Add(':Institucion, ');
      Query.SQL.Add(':Titulo)');

      IdParticipante := moduloDatos.generarID;
      Query.Params.ParamByName('IdParticipante').Value := IdParticipante;
      Query.Params.ParamByName('Nombre').Value :=
        datos.GetValue('Nombre').Value;
      Query.Params.ParamByName('Correo').Value :=
        datos.GetValue('Correo').Value;
      Query.Params.ParamByName('Documento').Value :=
        datos.GetValue('Documento').Value;
      Query.Params.ParamByName('Institucion').Value :=
        datos.GetValue('Institucion').Value;
      Query.Params.ParamByName('Titulo').Value :=
        datos.GetValue('Titulo').Value;
      Query.ExecSQL;

      { Crer el registro para el evento actual }
      Query.Close;
      Query.SQL.Text := 'INSERT INTO emem_participante_evento (';
      Query.SQL.Add('IdParticipanteEvento, ');
      Query.SQL.Add('IdEvento, ');
      Query.SQL.Add('IdTipoParticipante, ');
      Query.SQL.Add('TituloPonencia, ');
      Query.SQL.Add('IdParticipante) VALUES (');
      Query.SQL.Add(':IdParticipanteEvento, ');
      Query.SQL.Add(':IdEvento, ');
      Query.SQL.Add(':IdTipoParticipante, ');
      Query.SQL.Add(':TituloPonencia, ');
      Query.SQL.Add(':IdParticipante)');

      Query.Params.ParamByName('IdParticipanteEvento').Value :=
        moduloDatos.generarID;
      Query.Params.ParamByName('IdEvento').Value :=
        datos.GetValue('IdEvento').Value;
      Query.Params.ParamByName('IdTipoParticipante').Value :=
        datos.GetValue('IdTipoParticipante').Value;
      Query.Params.ParamByName('TituloPonencia').Value :=
        datos.GetValue('TituloPonencia').Value;
      Query.Params.ParamByName('IdParticipante').Value := IdParticipante;

      Query.ExecSQL;

      JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      JSON.AddPair(JSON_RESPONSE,
        'La inscripción se realizó satisfactoriamente');
    end;

  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
end;

end.
