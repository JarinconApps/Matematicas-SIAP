unit uFResumenes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, shellapi,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFResumenes = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    seResumen: TSynEdit;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    edRuta: TEdit;
    GroupBox2: TGroupBox;
    edListas: TEdit;
    TabSheet3: TTabSheet;
    seExcel: TSynEdit;
  private
    cont: integer;
    FIdAutor: string;
    procedure setIdAutor(const Value: string);
  public
    procedure limpiarDocumento;
    procedure limpiarDocumento2;
    procedure iniciarDocumentoExcel;

    procedure agregarLinea(ll: string);
    procedure agregarTitulo(ss: string);
    procedure agregarAutores(ss: string);
    procedure agregarFecha(ss: string);

    procedure agregarParticipante(cedula, nombre: string);

    procedure agregarEstilo;

    procedure agregarResumen(ss: string);
    procedure agregarPalabrasClave(ss: string);
    procedure iniciarBibligrafia;
    procedure agregarReferencia(ss: string);
    procedure terminarDocumento;
    procedure terminarDocumento2;

    procedure exportarDocumento;
    procedure exportarListas;
    procedure exportarExcel;

    property IdAutor: string read FIdAutor write setIdAutor;
  end;

var
  FResumenes: TFResumenes;

implementation

{$R *.dfm}
{ TForm1 }

procedure TFResumenes.agregarAutores(ss: string);
begin
  agregarLinea('\author{' + ss + '}');
end;

procedure TFResumenes.agregarEstilo;
begin
  agregarLinea('\maketitle');
  agregarLinea('\thispagestyle{fancy}');
end;

procedure TFResumenes.agregarFecha(ss: string);
begin
  agregarLinea('\date{' + ss + '}');
end;

procedure TFResumenes.agregarLinea(ll: string);
begin
  seResumen.Lines.Add(ll);
end;

procedure TFResumenes.agregarPalabrasClave(ss: string);
begin
  seResumen.Lines.Add('\subsection*{Palabras Clave}');
  seResumen.Lines.Add(ss);
  seResumen.Lines.Add('\rule[0.25ex]{1\columnwidth}{1pt}');
end;

procedure TFResumenes.agregarParticipante(cedula, nombre: string);
begin
  seExcel.Lines.Add(cedula + ';' + nombre);
end;

procedure TFResumenes.agregarReferencia(ss: string);
begin
  Inc(cont);
  agregarLinea('\bibitem{ref' + IntToStr(cont) + '}' + ss);
end;

procedure TFResumenes.agregarResumen(ss: string);
begin
  agregarLinea(ss);
end;

procedure TFResumenes.agregarTitulo(ss: string);
begin
  seResumen.Lines.Add('\title{' + ss + '}');
end;

procedure TFResumenes.exportarDocumento;
var
  fileBat: TStringList;
begin
  seResumen.Lines.SaveToFile(edRuta.text + '\' + FIdAutor + '.tex');

  fileBat := TStringList.Create;
  fileBat.Add('cd C:\xampp\htdocs\matematicas\descargas\resumenes-emem');
  fileBat.Add('pdflatex -file-line-error ' + FIdAutor + '.tex');
  fileBat.SaveToFile(edRuta.text + '\compilar.bat');

  ShellExecute(handle, nil, pchar(edRuta.text + '\compilar.bat'), nil, nil,
    SW_NORMAL);
end;

procedure TFResumenes.exportarExcel;
begin
  seExcel.Lines.SaveToFile(edListas.text + '\' + FIdAutor + '.csv');
end;

procedure TFResumenes.exportarListas;
var
  fileBat: TStringList;
begin
  seResumen.Lines.SaveToFile(edListas.text + '\' + FIdAutor + '.tex');

  fileBat := TStringList.Create;
  fileBat.Add('cd C:\xampp\htdocs\matematicas\descargas\listas');
  fileBat.Add('pdflatex -file-line-error ' + FIdAutor + '.tex');
  fileBat.SaveToFile(edListas.text + '\compilar.bat');

  ShellExecute(handle, nil, pchar(edListas.text + '\compilar.bat'), nil, nil,
    SW_NORMAL);
end;

procedure TFResumenes.iniciarBibligrafia;
begin
  agregarLinea('\begin{thebibliography}{1}');
end;

procedure TFResumenes.iniciarDocumentoExcel;
begin
  seExcel.Lines.Clear;
end;

procedure TFResumenes.limpiarDocumento;
begin
  seResumen.Lines.Clear;

  seResumen.Lines.Add
    ('\documentclass[12pt,twoside,twocolumn,english]{article}');
  seResumen.Lines.Add('\usepackage[T1]{fontenc}');
  seResumen.Lines.Add('\usepackage[latin9]{inputenc}');
  seResumen.Lines.Add('\usepackage{geometry}');
  seResumen.Lines.Add
    ('\geometry{verbose,tmargin=3cm,bmargin=3cm,lmargin=2cm,rmargin=2cm}');
  seResumen.Lines.Add('\usepackage{fancyhdr}');
  seResumen.Lines.Add('\pagestyle{fancy}');
  seResumen.Lines.Add('\usepackage{babel}');
  seResumen.Lines.Add('\usepackage{url}');
  seResumen.Lines.Add('\usepackage{longtable}');
  seResumen.Lines.Add('\tolerance = 10000');
  seResumen.Lines.Add('\pretolerance = 10000');
  seResumen.Lines.Add('\setlength{\parindent}{0pt}');
  seResumen.Lines.Add('\usepackage[unicode=true,pdfusetitle,');
  seResumen.Lines.Add
    (' bookmarks=true,bookmarksnumbered=false,bookmarksopen=false,');
  seResumen.Lines.Add
    (' breaklinks=false,pdfborder={0 0 1},backref=false,colorlinks=false]');
  seResumen.Lines.Add(' {hyperref}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add('\makeatletter');
  seResumen.Lines.Add
    ('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% User specified LaTeX commands.');
  seResumen.Lines.Add('\usepackage{fancyhdr}');
  seResumen.Lines.Add('\pagestyle{fancy}');
  seResumen.Lines.Add('\fancyhf{}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add
    ('\fancyhead[RO]{5 Workshop de Educación Matemática, Estadística y Matemáticas - EMEM 2019, 5-7 de noviembre de 2019, Armenia, Colombia.}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add
    ('\fancyfoot[LO]{  \rule[0.25ex]{1\columnwidth}{1pt} \\ Programa de Licenciatura en Matemáticas, Universidad del Quindío \hfill{} \thepage}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add('\setlength\columnsep{1cm}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add('\makeatother');
  seResumen.Lines.Add('');
  seResumen.Lines.Add('\begin{document}');

  cont := 0;
end;

procedure TFResumenes.limpiarDocumento2;
begin
  seResumen.Lines.Clear;

  seResumen.Lines.Add('\documentclass[12pt,twoside,spanish]{article}');
  seResumen.Lines.Add('\usepackage[T1]{fontenc}');
  seResumen.Lines.Add('\usepackage[latin9]{inputenc}');
  seResumen.Lines.Add('\usepackage{geometry}');
  seResumen.Lines.Add('\usepackage{longtable}');
  seResumen.Lines.Add
    ('\geometry{verbose,tmargin=3cm,bmargin=3cm,lmargin=2cm,rmargin=2cm}');
  seResumen.Lines.Add('\usepackage{fancyhdr}');
  seResumen.Lines.Add('\pagestyle{fancy}');
  seResumen.Lines.Add('\usepackage{babel}');
  seResumen.Lines.Add('\usepackage{url}');
  seResumen.Lines.Add('\usepackage{array}');
  seResumen.Lines.Add('\tolerance = 10000');
  seResumen.Lines.Add('\pretolerance = 10000');
  seResumen.Lines.Add('\setlength{\parindent}{0pt}');
  seResumen.Lines.Add('\usepackage[unicode=true,pdfusetitle,');
  seResumen.Lines.Add
    (' bookmarks=true,bookmarksnumbered=false,bookmarksopen=false,');
  seResumen.Lines.Add
    (' breaklinks=false,pdfborder={0 0 1},backref=false,colorlinks=false]');
  seResumen.Lines.Add(' {hyperref}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add('\makeatletter');
  seResumen.Lines.Add
    ('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% User specified LaTeX commands.');
  seResumen.Lines.Add('\usepackage{fancyhdr}');
  seResumen.Lines.Add('\pagestyle{fancy}');
  seResumen.Lines.Add('\fancyhf{}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add
    ('\fancyhead[RO]{5 Workshop de Educación Matemática, Estadística y Matemáticas - EMEM 2019, 5-7 de noviembre de 2019, Armenia, Colombia.}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add
    ('\fancyfoot[LO]{  \rule[0.25ex]{1\columnwidth}{1pt} \\ Programa de Licenciatura en Matemáticas, Universidad del Quindío \hfill{} \thepage}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add('\setlength\columnsep{1cm}');
  seResumen.Lines.Add('');
  seResumen.Lines.Add('\makeatother');
  seResumen.Lines.Add('');
  seResumen.Lines.Add('\begin{document}');

  cont := 0;
end;

procedure TFResumenes.setIdAutor(const Value: string);
begin
  FIdAutor := Value;
end;

procedure TFResumenes.terminarDocumento;
begin
  agregarLinea('\end{thebibliography}');
  agregarLinea('\end{document}');
end;

procedure TFResumenes.terminarDocumento2;
begin
  agregarLinea('\end{document}');
end;

end.
