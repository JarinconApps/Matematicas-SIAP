unit uModuloUtilidades;

interface

uses
  System.SysUtils, System.Classes;

type
  TModuloUtilidades = class(TDataModule)
  private
    { Private declarations }
  public
    function generarToken: string;
  end;

var
  ModuloUtilidades: TModuloUtilidades;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TModuloUtilidades }

function TModuloUtilidades.generarToken: string;
var
  Base: string;
  i: Integer;
begin
  Base := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567980';
  result := '';
  for i := 1 to 32 do
  begin
    result := result + Base[Random(length(Base)) + 1];
  end;

  result := result + '-';

  for i := 1 to 16 do
  begin
    result := result + Base[Random(length(Base)) + 1];
  end;

  result := result + '-';

  for i := 1 to 8 do
  begin
    result := result + Base[Random(length(Base)) + 1];
  end;

  result := result + '-';

  for i := 1 to 4 do
  begin
    result := result + Base[Random(length(Base)) + 1];
  end;

  result := result + '-';

  for i := 1 to 2 do
  begin
    result := result + Base[Random(length(Base)) + 1];
  end;

  result := result + '-';

  for i := 1 to 1 do
  begin
    result := result + Base[Random(length(Base)) + 1];
  end;

end;

end.
