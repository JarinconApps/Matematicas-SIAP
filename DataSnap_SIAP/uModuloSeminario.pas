unit uModuloSeminario;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uConstantes, uModuloDatos;

type
  TModuloSeminario = class(TDataModule)
  private
    { Private declarations }
  public
    function ordenarNumerosSeminario: TJSONObject;
  end;

var
  ModuloSeminario: TModuloSeminario;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TModuloSeminario }

function TModuloSeminario.ordenarNumerosSeminario: TJSONObject;
var
  Query, QSeminario: TFDQuery;
  i: integer;
  JSON: TJSONObject;
  IdSeminario: string;
begin
  try
    JSON := TJSONObject.Create;
    Query := TFDQuery.Create(nil);
    Query.Connection := moduloDatos.Conexion;
    QSeminario := TFDQuery.Create(nil);
    QSeminario.Connection := moduloDatos.Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_seminario ORDER BY fecha';
    Query.Open;
    Query.First;

    for i := 1 to Query.RecordCount do
    begin
      QSeminario.Close;
      QSeminario.SQL.Text := 'UPDATE siap_seminario SET numero=:numero WHERE ' +
        'idseminario=' + #39 + Query.FieldByName('idseminario').AsString + #39;
      QSeminario.Params.ParamByName('numero').Value := i;
      QSeminario.ExecSQL;
    end;

    JSON.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    JSON.AddPair(JSON_RESPONSE,
      'Los registros del seminario se ordenaron correctamente');
  except
    on E: Exception do
    begin
      JSON.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JSON.AddPair(JSON_STATUS, E.Message);
    end;
  end;

  result := JSON;
  Query.Free;
  QSeminario.Free;
end;

end.
