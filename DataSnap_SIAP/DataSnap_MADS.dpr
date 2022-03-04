program DataSnap_MADS;
{$APPTYPE GUI}
{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uFDataSnapMatematicas in 'uFDataSnapMatematicas.pas' {FDataSnapMatematicas},
  uMetodosServidor in 'uMetodosServidor.pas' {Matematicas: TDataModule},
  uModuloWeb in 'uModuloWeb.pas' {ModuloWeb: TWebModule},
  uTConcurrencia in 'uTConcurrencia.pas',
  uTPropiedadesTabla in 'uTPropiedadesTabla.pas' {$R *.res},
  uTUsuario in 'uTUsuario.pas',
  uTParticipante in 'uTParticipante.pas',
  uTResumen in 'uTResumen.pas',
  uTPalabraClave in 'uTPalabraClave.pas',
  uTAutoresResumen in 'uTAutoresResumen.pas',
  uTReferenciaResumen in 'uTReferenciaResumen.pas',
  uFResumenes in 'uFResumenes.pas' {FResumenes},
  uFCertificados in 'uFCertificados.pas' {FCertificados},
  Utilidades in 'Utilidades.pas',
  uModuloDatos in 'uModuloDatos.pas' {moduloDatos: TDataModule},
  uFVisorContenido in 'uFVisorContenido.pas' {FVisorContenido},
  uTAttribute in 'uTAttribute.pas',
  uTCRUDModel in 'uTCRUDModel.pas',
  uTValidateToken in 'uTValidateToken.pas',
  uModuloEventoEMEM in 'Modulos\uModuloEventoEMEM.pas' {moduloEventoEMEM: TDataModule},
  uConstantes in 'uConstantes.pas',
  uFVistaJSON in 'uFVistaJSON.pas' {FVistaJSON},
  uModuloUtilidades in 'uModuloUtilidades.pas' {ModuloUtilidades: TDataModule},
  uModuloSeminario in 'uModuloSeminario.pas' {ModuloSeminario: TDataModule},
  uModuloPracticaDocente in 'uModuloPracticaDocente.pas' {moduloPracticaDocente: TDataModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.Title := 'Data Snap Matemáticas';
  Application.CreateForm(TmoduloDatos, moduloDatos);
  Application.CreateForm(TFDataSnapMatematicas, FDataSnapMatematicas);
  Application.CreateForm(TFResumenes, FResumenes);
  Application.CreateForm(TFCertificados, FCertificados);
  Application.CreateForm(TFVisorContenido, FVisorContenido);
  Application.CreateForm(TmoduloEventoEMEM, moduloEventoEMEM);
  Application.CreateForm(TFVistaJSON, FVistaJSON);
  Application.CreateForm(TModuloUtilidades, ModuloUtilidades);
  Application.CreateForm(TModuloSeminario, ModuloSeminario);
  Application.CreateForm(TmoduloPracticaDocente, moduloPracticaDocente);
  Application.Run;

end.
