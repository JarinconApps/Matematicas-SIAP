unit uTCRUDModel;

interface

uses classes, system.sysutils, contnrs, system.json, FireDAC.Comp.Client,
  uTAttribute, dialogs, uMd5, inifiles;

Type

  { Para usar el modelo copie el siguiente ejemplo:

    Rol := TCRUDModel.create;

    // Atributos de la tabla
    Rol.addAttribute('IdRol', taString);
    Rol.addAttribute('Nombre', taString);

    // Respuestas de acción
    Rol.ResponsePost := 'El Rol se creo correctamente';
    Rol.ResponsePut := 'El Rol se actualizo correctamente';
    Rol.ResponseDelete := 'El Rol se elimino correctamente';

    // Arquitectura del Objeto
    Rol.Connection := Conexion;
    Rol.IdPrimary := 'IdRol';
    Rol.TableName := 'Roles';
    Rol.OrderBy := 'Nombre';
    Rol.ModelName := 'Rol';
  }

  TCRUDModel = class(TObject)
  private
    FConnection: TFDConnection;
    FTableName: string;
    FIdPrimary: string;
    FResponsePost: string;
    FResponsePut: string;
    FResponseDelete: string;
    FEncripter: TMD5;
    errorLog: TIniFile;
    fileLog: TIniFile;

    FAttributes: TObjectList;
    FModels: TObjectList;
    FModelsArray: TObjectList;
    FIdRefs: TStringList;
    FModelName: string;
    FOrderBy: string;
    FModelNameArray: string;
    FToken: string;

    procedure setConnection(const Value: TFDConnection);
    procedure setTableName(const Value: string);
    procedure setIdPrimary(const Value: string);
    procedure setResponseDelete(const Value: string);
    procedure setResponsePost(const Value: string);
    procedure setResponsePut(const Value: string);
    procedure setModelName(const Value: string);
    procedure setOrderBy(const Value: string);
    procedure setModelNameArray(const Value: string);
    procedure setToken(const Value: string);

    function getDataQuery(Query: TFDQuery): TJSONObject;
    function toLowerCase(str: string): string;
    function generateID: string;

    function errorType(err: string): string;
    procedure printErrorLog(process, err: string);
    procedure printLog(process, msg: string);
  public
    constructor create;
    destructor destroy; override;

    function get(Id: string): TJSONObject;
    function getAll: TJSONObject;
    function getAllByIDToArray(IdRef, IdRefVal: string): TJSONArray;
    function getAllByIDToJson(IdRef, IdRefVal: string): TJSONObject;
    function post(data: TJSONObject): TJSONObject;
    function put(data: TJSONObject): TJSONObject;
    function putPassword(data: TJSONObject): TJSONObject;
    function delete(Id: string): TJSONObject;
    function getArchitecture: TJSONObject;

    function login(data: TJSONObject): TJSONObject;

    procedure addAttribute(attributeName: string;
      attributeType: TTypeAttribute);
    function getAttribute(Id: integer): TAttribute;
    function countAttributes: integer;

    procedure AddModel(model: TCRUDModel);
    function GetModel(Id: integer): TCRUDModel;
    function countModel: integer;

    procedure AddModelArray(model: TCRUDModel; IdRef: string);
    function GetModelArray(Id: integer): TCRUDModel;
    function GetIdRefModel(Id: integer): string;
    function countModelArray: integer;
  published

    property Connection: TFDConnection read FConnection write setConnection;
    property Token: string read FToken write setToken;

    property TableName: string read FTableName write setTableName;
    property IdPrimary: string read FIdPrimary write setIdPrimary;
    property ModelName: string read FModelName write setModelName;
    property ModelNameArray: string read FModelNameArray
      write setModelNameArray;
    property OrderBy: string read FOrderBy write setOrderBy;

    property ResponseDelete: string read FResponseDelete
      write setResponseDelete;
    property ResponsePost: string read FResponsePost write setResponsePost;
    property ResponsePut: string read FResponsePut write setResponsePut;

  end;

const
  JSON_STATUS = 'Status';
  JSON_ERROR = 'Error';
  JSON_RESULTS = 'Results';
  JSON_RESPONSE = 'Response';
  JSON_DATA = 'Data';
  JSON_ARCHITECTURE = 'Archicteture';
  RESPONSE_ACCESO_DENEGADO = 'Acceso Denegado';
  RESPONSE_CORRECTO = 'Correcto';
  RESPONSE_INCORRECTO = 'Incorrecto';
  RESPONSE_REGISTER = 'Register';

  Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

implementation

{ TCRUDModel }

procedure TCRUDModel.addAttribute(attributeName: string;
  attributeType: TTypeAttribute);
var
  Id: integer;
begin
  Id := FAttributes.Add(TAttribute.create);
  getAttribute(Id).Attribute := attributeName;
  getAttribute(Id).TypeAttribute := attributeType;
end;

procedure TCRUDModel.AddModel(model: TCRUDModel);
begin
  FModels.Add(model);
end;

procedure TCRUDModel.AddModelArray(model: TCRUDModel; IdRef: string);
begin
  FModelsArray.Add(model);
  FIdRefs.Add(IdRef);
end;

function TCRUDModel.countAttributes: integer;
begin
  Result := FAttributes.Count;
end;

function TCRUDModel.countModel: integer;
begin
  Result := FModels.Count;
end;

function TCRUDModel.countModelArray: integer;
begin
  Result := FModelsArray.Count;
end;

constructor TCRUDModel.create;
begin
  FAttributes := TObjectList.create;
  FModels := TObjectList.create;
  FModelsArray := TObjectList.create;
  FIdRefs := TStringList.create;
  FEncripter := TMD5.create(nil);

  errorLog := TIniFile.create(ExtractFilePath(ParamStr(0)) + '\error.log');
  fileLog := TIniFile.create(ExtractFilePath(ParamStr(0)) + '\log.log');
end;

function TCRUDModel.delete(Id: string): TJSONObject;
var
  Query: TFDQuery;
  JsonResponse: TJSONObject;
begin
  try
    printLog('delete', 'execute delete: ' + Id);
    JsonResponse := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := FConnection;

    Query.Close;
    Query.SQL.Text := 'DELETE FROM ' + FTableName + ' WHERE ' + FIdPrimary + '='
      + #39 + Id + #39;
    Query.ExecSQL;

    JsonResponse.AddPair(JSON_STATUS, 'Correct');
    JsonResponse.AddPair(JSON_RESPONSE, FResponseDelete);

    JsonResponse.AddPair(JSON_ARCHITECTURE, getDataQuery(Query));
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_ERROR, E.Message);
      JsonResponse.AddPair(JSON_STATUS, 'Incorrect');
      printErrorLog('delete', E.Message);
    end;
  end;

  Result := JsonResponse;
  Query.Free;
end;

destructor TCRUDModel.destroy;
begin;
  FAttributes.Free;

  errorLog.Free;
  fileLog.Free;

  inherited destroy;
end;

function TCRUDModel.errorType(err: string): string;
begin
  if err.IndexOf('duplicados') >= 0 then
  begin
    Result := 'Ya existe un registro con los datos ingresados';
    exit;
  end;

  Result := err;
end;

function TCRUDModel.generateID: string;
var
  i: integer;
  errorLog: TStringList;
begin
  try
    Result := '';

    for i := 1 to 8 do
    begin
      Result := Result + Codes64[Random(length(Codes64)) + 1];
    end;
    Result := Result + '-';
    for i := 1 to 4 do
    begin
      Result := Result + Codes64[Random(length(Codes64)) + 1];
    end;
    Result := Result + '-';
    for i := 1 to 4 do
    begin
      Result := Result + Codes64[Random(length(Codes64)) + 1];
    end;
    Result := Result + '-';
    for i := 1 to 12 do
    begin
      Result := Result + Codes64[Random(length(Codes64)) + 1];
    end;

    printLog('generateID', 'ID: ' + Result);
  except
    on E: Exception do
      printErrorLog('generateID', E.Message);
  end;
end;

function TCRUDModel.get(Id: string): TJSONObject;
var
  Query, QArray: TFDQuery;
  i: integer;
  Attribute, IdRef, IdRefVal: String;
  TypeAttribute: TTypeAttribute;
  model: TCRUDModel;
  JsonResponse, JsonArchitect: TJSONObject;
  fs: TFormatSettings;
begin
  try
    printLog('get', 'execute get: ' + Id);
    JsonResponse := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := FConnection;

    QArray := TFDQuery.create(nil);
    QArray.Connection := FConnection;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM ' + FTableName + ' WHERE ' + FIdPrimary +
      '=' + #39 + Id + #39;
    Query.Open;

    JsonArchitect := TJSONObject.create;
    JsonArchitect.AddPair('SQL', Query.SQL.Text);
    JsonArchitect.AddPair('Registers', IntToStr(Query.RecordCount));
    JsonResponse.AddPair(JSON_ARCHITECTURE, JsonArchitect);

    if Query.RecordCount >= 1 then
    begin

      { Set the properties for each attribute }
      for i := 1 to countAttributes do
      begin
        Attribute := getAttribute(i - 1).Attribute;
        TypeAttribute := getAttribute(i - 1).TypeAttribute;
        if TypeAttribute = taDate then
        begin
          fs := TFormatSettings.create;
          fs.DateSeparator := '-';
          fs.ShortDateFormat := 'yyyy-mm-dd';

          JsonResponse.AddPair(Attribute,
            DateToStr(Query.FieldByName(Attribute).AsDateTime, fs));
        end
        else
          JsonResponse.AddPair(Attribute, Query.FieldByName(Attribute)
            .AsString);
      end;

      { Set the properties for each model }
      for i := 1 to countModel do
      begin
        model := GetModel(i - 1);
        IdRef := model.IdPrimary;
        IdRefVal := Query.FieldByName(IdRef).AsString;
        JsonResponse.AddPair(model.ModelName, model.get(IdRefVal));
      end;

      { Set the array for each model }
      for i := 1 to countModelArray do
      begin
        model := GetModelArray(i - 1);
        IdRef := GetIdRefModel(i - 1);
        IdRefVal := Query.FieldByName(IdRef).AsString;

        JsonResponse.AddPair(model.ModelNameArray,
          model.getAllByIDToArray(IdRef, IdRefVal));
      end;
    end
    else
      JsonResponse.AddPair(JSON_RESPONSE, 'La tabla ' + FTableName +
        ' no tiene registros');

    JsonResponse.AddPair(JSON_ARCHITECTURE, getDataQuery(Query));

  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_ERROR, E.Message);
      JsonResponse.AddPair(JSON_STATUS, 'Incorrect');
      printErrorLog('get', E.Message);
    end;
  end;

  Result := JsonResponse;
  Query.Free;
end;

function TCRUDModel.getAll: TJSONObject;
var
  Query: TFDQuery;
  i: integer;
  Records: TJSONArray;
  Attribute, IdRef, IdRefVal: String;
  TypeAttribute: TTypeAttribute;
  model: TCRUDModel;
  j: integer;
  JsonRecord, JsonResponse: TJSONObject;
  fs: TFormatSettings;
begin
  try
    printLog('getAll', 'execute getAll');
    JsonResponse := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := FConnection;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM ' + FTableName + ' ORDER BY ' + FOrderBy;
    Query.Open;

    if Query.RecordCount >= 1 then
    begin

      Records := TJSONArray.create;
      for j := 1 to Query.RecordCount do
      begin
        JsonRecord := TJSONObject.create;

        { Set the properties for each attribute }
        for i := 1 to countAttributes do
        begin
          Attribute := getAttribute(i - 1).Attribute;
          TypeAttribute := getAttribute(i - 1).TypeAttribute;
          if TypeAttribute = taDate then
          begin
            fs := TFormatSettings.create;
            fs.DateSeparator := '-';
            fs.ShortDateFormat := 'yyyy-mm-dd';

            JsonRecord.AddPair(Attribute,
              DateToStr(Query.FieldByName(Attribute).AsDateTime, fs));
          end
          else
            JsonRecord.AddPair(Attribute, Query.FieldByName(Attribute)
              .AsString);
        end;

        { Set the properties for each model }
        for i := 1 to countModel do
        begin
          model := GetModel(i - 1);
          IdRef := model.IdPrimary;
          IdRefVal := Query.FieldByName(IdRef).AsString;
          JsonRecord.AddPair(model.ModelName, model.get(IdRefVal));
        end;

        { Set the array for each model }
        for i := 1 to countModelArray do
        begin
          model := GetModelArray(i - 1);
          IdRef := GetIdRefModel(i - 1);
          IdRefVal := Query.FieldByName(IdRef).AsString;

          JsonRecord.AddPair(model.ModelNameArray,
            model.getAllByIDToArray(IdRef, IdRefVal));
        end;

        Records.AddElement(JsonRecord);

        Query.Next;
      end;

      JsonResponse.AddPair(JSON_STATUS, 'Correcto');
      JsonResponse.AddPair(JSON_RESULTS, Records);
    end
    else
      JsonResponse.AddPair(JSON_RESPONSE, 'La tabla ' + FTableName +
        ' no tiene registros');

    JsonResponse.AddPair(JSON_ARCHITECTURE, getDataQuery(Query));

  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_ERROR, E.Message);
      JsonResponse.AddPair(JSON_STATUS, 'Incorrecto');
      printErrorLog('getAll', E.Message);
    end;
  end;

  Result := JsonResponse;
  Query.Free;
end;

function TCRUDModel.getAllByIDToArray(IdRef, IdRefVal: string): TJSONArray;
var
  Query: TFDQuery;
  i: integer;
  Records: TJSONArray;
  Attribute: String;
  TypeAttribute: TTypeAttribute;
  model: TCRUDModel;
  j: integer;
  JsonRecord, JsonResponse: TJSONObject;
  fs: TFormatSettings;
begin
  try
    printLog('getAllByIDToArray', 'execute getAllByIDToArray: ' + IdRef);
    JsonResponse := TJSONObject.create;
    Records := TJSONArray.create;

    Query := TFDQuery.create(nil);
    Query.Connection := FConnection;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM ' + FTableName + ' WHERE ' + IdRef + '=' +
      #39 + IdRefVal + #39 + ' ORDER BY ' + FOrderBy;
    Query.Open;

    if Query.RecordCount >= 1 then
    begin

      for j := 1 to Query.RecordCount do
      begin
        JsonRecord := TJSONObject.create;

        { Set the properties for each attribute }
        for i := 1 to countAttributes do
        begin
          Attribute := getAttribute(i - 1).Attribute;
          TypeAttribute := getAttribute(i - 1).TypeAttribute;
          if TypeAttribute = taDate then
          begin
            fs := TFormatSettings.create;
            fs.DateSeparator := '-';
            fs.ShortDateFormat := 'yyyy-mm-dd';

            JsonRecord.AddPair(Attribute,
              DateToStr(Query.FieldByName(Attribute).AsDateTime, fs));
          end
          else
            JsonRecord.AddPair(Attribute, Query.FieldByName(Attribute)
              .AsString);
        end;

        { Set the properties for each model }
        for i := 1 to countModel do
        begin
          model := GetModel(i - 1);
          IdRef := model.IdPrimary;
          IdRefVal := Query.FieldByName(IdRef).AsString;
          JsonRecord.AddPair(model.ModelName, model.get(IdRefVal));
        end;

        { Set the array for each model }
        for i := 1 to countModelArray do
        begin
          model := GetModelArray(i - 1);
          IdRef := GetIdRefModel(i - 1);
          IdRefVal := Query.FieldByName(IdRef).AsString;

          JsonRecord.AddPair(model.ModelNameArray,
            model.getAllByIDToArray(IdRef, IdRefVal));
        end;

        Records.AddElement(JsonRecord);

        Query.Next;
      end;

      JsonResponse.AddPair(JSON_STATUS, 'Correcto');
      JsonResponse.AddPair(JSON_RESULTS, Records);
    end;

    JsonResponse.AddPair(JSON_ARCHITECTURE, getDataQuery(Query));

  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_ERROR, E.Message);
      JsonResponse.AddPair(JSON_STATUS, 'Incorrect');
      Records.AddElement(JsonResponse);
      printErrorLog('getAllByIDToArray', E.Message);
    end;
  end;

  Result := Records;
  Query.Free;
end;

function TCRUDModel.getAllByIDToJson(IdRef, IdRefVal: string): TJSONObject;
var
  JsonResponse: TJSONObject;
begin
  try
    printLog('getAllByIDToJson', 'execute getAllByIDToJson: ' + IdRef);
    JsonResponse := TJSONObject.create;

    JsonResponse.AddPair(JSON_STATUS, 'Correcto');
    JsonResponse.AddPair(JSON_RESULTS, getAllByIDToArray(IdRef, IdRefVal));
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_ERROR, E.Message);
      JsonResponse.AddPair(JSON_STATUS, 'Incorrecto');
      printErrorLog('getAllByIDToJson', E.Message);
    end;
  end;

  Result := JsonResponse;
end;

function TCRUDModel.getArchitecture: TJSONObject;
var
  Attributes: TJSONArray;
  i: integer;
  JsonResponse: TJSONObject;
begin
  printLog('getArchitecture', 'execute getArchitecture');
  JsonResponse := TJSONObject.create;

  JsonResponse.AddPair('TableName', TableName);
  JsonResponse.AddPair('IdPrimary', IdPrimary);
  JsonResponse.AddPair('ModelName', ModelName);

  JsonResponse.AddPair('ResponseDelete', ResponseDelete);
  JsonResponse.AddPair('ResponsePost', ResponsePost);
  JsonResponse.AddPair('ResponsePut', ResponsePut);

  Attributes := TJSONArray.create;
  for i := 1 to countAttributes do
  begin
    Attributes.Add(getAttribute(i - 1).Attribute);
  end;

  JsonResponse.AddPair('Attributes', Attributes);

  Result := JsonResponse;
end;

function TCRUDModel.getAttribute(Id: integer): TAttribute;
begin
  Result := (FAttributes.Items[Id] as TAttribute);
end;

function TCRUDModel.getDataQuery(Query: TFDQuery): TJSONObject;
begin
  Result := TJSONObject.create;
  Result.AddPair('SQL', Query.SQL.Text);
  Result.AddPair('Registers', IntToStr(Query.RecordCount));
end;

function TCRUDModel.GetIdRefModel(Id: integer): string;
begin
  Result := FIdRefs[Id];
end;

function TCRUDModel.GetModel(Id: integer): TCRUDModel;
begin
  Result := (FModels.Items[Id] as TCRUDModel);
end;

function TCRUDModel.GetModelArray(Id: integer): TCRUDModel;
begin
  Result := (FModelsArray.Items[Id] as TCRUDModel);
end;

function TCRUDModel.login(data: TJSONObject): TJSONObject;
var
  Query: TFDQuery;
  JsonResponse: TJSONObject;
  Value, ValueRef, IdRef, IdVal, IdRefValue, Contra1, Contra2: string;
begin
  try
    printLog('login', 'execute login: ' + data.ToString);
    JsonResponse := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := FConnection;

    IdRef := data.GetValue('IdRef').Value;
    IdRefValue := data.GetValue('IdRefValue').Value;
    Value := data.GetValue('Value').Value;
    ValueRef := data.GetValue('ValueRef').Value;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM ' + FTableName + ' WHERE ' + IdRef + '=' +
      #39 + IdRefValue + #39;
    Query.Open;

    if Query.RecordCount > 0 then
    begin
      FEncripter.Text := Value;
      Contra1 := FEncripter.MD5;
      Contra2 := Query.FieldByName(ValueRef).AsString;

      if Contra1 = Contra2 then
      begin
        JsonResponse.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
        JsonResponse.AddPair('Token', FToken);
        JsonResponse.AddPair(JSON_RESPONSE, 'Acceso correcto');

        IdVal := Query.FieldByName(FIdPrimary).AsString;
        JsonResponse.AddPair(FModelName, get(IdVal));
      end
      else
      begin
        JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
        JsonResponse.AddPair(JSON_RESPONSE, 'Contraseña incorrecta');
      end;
    end
    else
    begin
      JsonResponse.AddPair(JSON_RESPONSE, 'El ' + FModelName +
        ' no esta registrado');
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    end;

  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, 'Incorrecto');
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
  Query.Free;
end;

function TCRUDModel.post(data: TJSONObject): TJSONObject;
var
  JsonResponse: TJSONObject;
  Query: TFDQuery;
  i: integer;
  TypeAtribute: TTypeAttribute;
  Atribute: string;
  fs: TFormatSettings;
  dataPost: TJSONObject;
begin
  try
    printLog('post', 'execute post: ' + data.ToJSON);
    JsonResponse := TJSONObject.create;

    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    if not Assigned(FConnection) then
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE,
        'No existe una conexión con la base de datos');
      exit;
    end;

    Query := TFDQuery.create(nil);
    Query.Connection := FConnection;

    dataPost := TJSONObject.create;
    dataPost := TJSONObject.ParseJSONValue(data.ToString) as TJSONObject;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('INSERT INTO ' + FTableName + ' (');

    dataPost.AddPair(FIdPrimary, generateID);

    for i := 1 to countAttributes do
    begin
      if i <> countAttributes then
        Query.SQL.Add(getAttribute(i - 1).Attribute + ', ')
      else
        Query.SQL.Add(getAttribute(i - 1).Attribute + ' ')
    end;

    Query.SQL.Add(') VALUES (');
    for i := 1 to countAttributes do
    begin
      if i <> countAttributes then
        Query.SQL.Add(':' + getAttribute(i - 1).Attribute + ', ')
      else
        Query.SQL.Add(':' + getAttribute(i - 1).Attribute)
    end;
    Query.SQL.Add(')');

    for i := 1 to countAttributes do
    begin
      TypeAtribute := getAttribute(i - 1).TypeAttribute;
      Atribute := getAttribute(i - 1).Attribute;

      case TypeAtribute of
        taString:
          Query.Params.ParamByName(Atribute).Value :=
            toLowerCase(dataPost.GetValue(Atribute).Value);

        taVideo:
          Query.Params.ParamByName(Atribute).Value :=
            dataPost.GetValue(Atribute).Value;

        taInteger:
          Query.Params.ParamByName(Atribute).Value :=
            StrToInt(dataPost.GetValue(Atribute).Value);

        taFloat:
          Query.Params.ParamByName(Atribute).Value :=
            StrToFloat(dataPost.GetValue(Atribute).Value);

        taBoolean:
          Query.Params.ParamByName(Atribute).Value :=
            StrToBool(dataPost.GetValue(Atribute).Value);

        taMemo:
          Query.Params.ParamByName(Atribute).AsWideMemo :=
            toLowerCase(dataPost.GetValue(Atribute).Value);

        taDate:
          Query.Params.ParamByName(Atribute).Value :=
            StrToDate(dataPost.GetValue(Atribute).Value, fs);

        taPassword:
          begin
            FEncripter.Text := dataPost.GetValue(Atribute).Value;
            Query.Params.ParamByName(Atribute).Value := FEncripter.MD5;
          end;
      end;
    end;

    Query.ExecSQL;

    JsonResponse.AddPair(JSON_STATUS, 'Correcto');
    JsonResponse.AddPair(JSON_RESPONSE, FResponsePost);
    JsonResponse.AddPair(RESPONSE_REGISTER, dataPost);

    JsonResponse.AddPair(JSON_ARCHITECTURE, getDataQuery(Query));

  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, 'Incorrecto');
      JsonResponse.AddPair(JSON_RESPONSE, errorType(E.Message));
      printErrorLog('post', E.Message);
    end;
  end;

  Result := JsonResponse;
  Query.Free;
end;

procedure TCRUDModel.printErrorLog(process, err: string);
var
  countError: integer;
begin
  countError := errorLog.ReadInteger('Errors', 'Count', 0);
  Inc(countError);

  errorLog.WriteInteger('Errors', 'Count', countError);
  errorLog.WriteString('Error' + IntToStr(countError), 'Date', DateToStr(now));
  errorLog.WriteString('Error' + IntToStr(countError), 'Procedure', process);
  errorLog.WriteString('Error' + IntToStr(countError), 'Error', err);
end;

procedure TCRUDModel.printLog(process, msg: string);
var
  countLog: integer;
begin
  countLog := fileLog.ReadInteger('Logs', 'Count', 0);
  Inc(countLog);

  fileLog.WriteInteger('Logs', 'Count', countLog);
  fileLog.WriteString('Logs', 'Log' + IntToStr(countLog), msg);
end;

function TCRUDModel.put(data: TJSONObject): TJSONObject;
var
  Query: TFDQuery;
  TypeAtribute: TTypeAttribute;
  Atribute, Id: string;
  TypeAttribute: TTypeAttribute;
  i: integer;
  JsonResponse: TJSONObject;
  fs: TFormatSettings;
begin
  try
    printLog('put', 'execute put: ' + data.ToString);
    JsonResponse := TJSONObject.create;

    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    Query := TFDQuery.create(nil);
    Query.Connection := FConnection;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('UPDATE ' + FTableName + ' SET ');

    for i := 1 to countAttributes do
    begin
      Atribute := getAttribute(i - 1).Attribute;
      TypeAtribute := getAttribute(i - 1).TypeAttribute;

      if (Atribute <> FIdPrimary) and (TypeAtribute <> taPassword) then
      begin
        if i <> countAttributes then
          Query.SQL.Add(Atribute + '=:' + Atribute + ', ')
        else
          Query.SQL.Add(Atribute + '=:' + Atribute)
      end;
    end;

    Id := data.GetValue(FIdPrimary).Value;
    Query.SQL.Add(' WHERE ' + FIdPrimary + '=' + #39 + Id + #39);

    for i := 1 to countAttributes do
    begin
      TypeAtribute := getAttribute(i - 1).TypeAttribute;
      Atribute := getAttribute(i - 1).Attribute;

      if (Atribute <> FIdPrimary) and (TypeAtribute <> taPassword) then
      begin

        case TypeAtribute of
          taString:
            Query.Params.ParamByName(Atribute).Value :=
              toLowerCase(data.GetValue(Atribute).Value);

          taVideo:
            Query.Params.ParamByName(Atribute).Value :=
              data.GetValue(Atribute).Value;

          taInteger:
            Query.Params.ParamByName(Atribute).Value :=
              StrToInt(data.GetValue(Atribute).Value);

          taFloat:
            Query.Params.ParamByName(Atribute).Value :=
              StrToFloat(data.GetValue(Atribute).Value);

          taBoolean:
            Query.Params.ParamByName(Atribute).Value :=
              StrToBool(data.GetValue(Atribute).Value);

          taMemo:
            Query.Params.ParamByName(Atribute).AsWideMemo :=
              toLowerCase(data.GetValue(Atribute).Value);

          taDate:
            Query.Params.ParamByName(Atribute).Value :=
              StrToDate(data.GetValue(Atribute).Value, fs);

          taPassword:
            begin
              FEncripter.Text := data.GetValue(Atribute).Value;
              Query.Params.ParamByName(Atribute).Value := FEncripter.MD5;
            end;
        end;
      end;
    end;

    Query.ExecSQL;

    JsonResponse.AddPair(JSON_STATUS, 'Correcto');
    JsonResponse.AddPair(JSON_RESPONSE, FResponsePut);
    JsonResponse.AddPair(RESPONSE_REGISTER,
      TJSONObject.ParseJSONValue(data.ToJSON));

    JsonResponse.AddPair(JSON_ARCHITECTURE, getDataQuery(Query));

  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, 'Incorrecto');
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
      printErrorLog('put', E.Message);
    end;
  end;

  Result := JsonResponse;
  Query.Free;
end;

function TCRUDModel.putPassword(data: TJSONObject): TJSONObject;
var
  Field, OldValue, NewValue, md5OldValue, md5NewValue, IdRefValue: string;
  Query: TFDQuery;
  JsonResponse, JsonData: TJSONObject;
begin
  try
    printLog('putPassword', 'execute putPassword: ' + data.ToString);
    JsonResponse := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := FConnection;

    JsonData := TJSONObject.create;
    JsonData := TJSONObject.ParseJSONValue(data.ToJSON) as TJSONObject;
    JsonResponse.AddPair('Body', JsonData);

    Field := data.GetValue('Field').Value;
    OldValue := data.GetValue('OldValue').Value;
    NewValue := data.GetValue('NewValue').Value;
    IdRefValue := data.GetValue('IdRefVal').Value;

    FEncripter.Text := OldValue;
    md5OldValue := FEncripter.MD5;
    FEncripter.Text := NewValue;
    md5NewValue := FEncripter.MD5;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM ' + FTableName + ' WHERE ' + FIdPrimary +
      '=' + #39 + IdRefValue + #39;
    Query.Open;

    if Query.FieldByName(Field).AsString = md5OldValue then
    begin
      Query.Close;
      Query.SQL.Text := 'UPDATE ' + FTableName + ' SET ' + Field + '=:' + Field
        + ' WHERE ' + FIdPrimary + '=' + #39 + IdRefValue + #39;

      Query.Params.ParamByName(Field).Value := md5NewValue;
      Query.ExecSQL;

      JsonResponse.AddPair(JSON_STATUS, 'Correcto');
      JsonResponse.AddPair(JSON_RESPONSE,
        'La contraseña se actualizo correctamante');
    end
    else
    begin
      JsonResponse.AddPair(JSON_STATUS, 'Incorrecto');
      JsonResponse.AddPair(JSON_RESPONSE,
        'La contraseña antigua no es correcta');
    end;

    JsonResponse.AddPair(JSON_ARCHITECTURE, getDataQuery(Query));

  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, 'Incorrecto');
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
      printErrorLog('putPassword', E.Message);
    end;
  end;

  Result := JsonResponse;
  Query.Free;
end;

procedure TCRUDModel.setConnection(const Value: TFDConnection);
begin
  FConnection := Value;
end;

procedure TCRUDModel.setIdPrimary(const Value: string);
begin
  FIdPrimary := Value;
end;

procedure TCRUDModel.setModelName(const Value: string);
begin
  FModelName := Value;
end;

procedure TCRUDModel.setModelNameArray(const Value: string);
begin
  FModelNameArray := Value;
end;

procedure TCRUDModel.setOrderBy(const Value: string);
begin
  FOrderBy := Value;
end;

procedure TCRUDModel.setResponseDelete(const Value: string);
begin
  FResponseDelete := Value;
end;

procedure TCRUDModel.setResponsePost(const Value: string);
begin
  FResponsePost := Value;
end;

procedure TCRUDModel.setResponsePut(const Value: string);
begin
  FResponsePut := Value;
end;

procedure TCRUDModel.setTableName(const Value: string);
begin
  FTableName := Value;
end;

procedure TCRUDModel.setToken(const Value: string);
begin
  FToken := Value;
end;

function TCRUDModel.toLowerCase(str: string): string;
begin
  Result := AnsiLowerCase(str);
end;

end.
