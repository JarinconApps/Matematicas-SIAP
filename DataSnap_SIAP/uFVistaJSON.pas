unit uFVistaJSON;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.ExtCtrls;

type
  TFVistaJSON = class(TForm)
    Panel1: TPanel;
    seConsola: TSynEdit;
  private
    { Private declarations }
  public
    procedure imprimir(msg: string);
  end;

var
  FVistaJSON: TFVistaJSON;

implementation

{$R *.dfm}
{ TFVistaJSON }

procedure TFVistaJSON.imprimir(msg: string);
begin
  seConsola.Lines.Add(msg);
  Show;
end;

end.
