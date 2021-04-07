program DataSnap_MADS;
{$APPTYPE GUI}
{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uFDataSnapMatematicas in 'uFDataSnapMatematicas.pas' {FDataSnapMatematicas} ,
  uMetodosServidor in 'uMetodosServidor.pas' {Matematicas: TDataModule} ,
  uModuloWeb in 'uModuloWeb.pas' {ModuloWeb: TWebModule} ,
  uTConcurrencia in 'uTConcurrencia.pas',
  uTPropiedadesTabla in 'uTPropiedadesTabla.pas' {$R *.res},
  uTUsuario in 'uTUsuario.pas',
  uTParticipante in 'uTParticipante.pas',
  uTResumen in 'uTResumen.pas',
  uTPalabraClave in 'uTPalabraClave.pas',
  uTAutoresResumen in 'uTAutoresResumen.pas',
  uTReferenciaResumen in 'uTReferenciaResumen.pas',
  uFResumenes in 'uFResumenes.pas' {FResumenes} ,
  uFCertificados in 'uFCertificados.pas' {FCertificados} ,
  Utilidades in '..\..\..\..\Dropbox\MIS_PROYECTOS\7000_Librerias\Utilidades\Utilidades.pas',
  uModuloDatos in 'uModuloDatos.pas' {moduloDatos: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.Title := 'Data Snap Matem�ticas';
  Application.CreateForm(TmoduloDatos, moduloDatos);
  Application.CreateForm(TFDataSnapMatematicas, FDataSnapMatematicas);
  Application.CreateForm(TFResumenes, FResumenes);
  Application.CreateForm(TFCertificados, FCertificados);

  Application.Run;

end.
