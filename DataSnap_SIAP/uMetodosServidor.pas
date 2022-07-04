{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit uMetodosServidor;

interface

uses System.SysUtils, System.Classes, dialogs, System.Json, Contnrs,
  Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, uFDataSnapMatematicas, uTCurso, uTConcurrencia, uTUsuario,
  uTParticipante, uTResumen, uTPalabraClave, uTAutoresResumen,
  uTReferenciaResumen, uFResumenes, IdMessage, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, uFCertificados, Utilidades, ComObj,
  Datasnap.DSHTTPWebBroker,
  Web.HTTPApp, uModuloDatos, {uFVisorContenido,} uConstantes, uModuloEventoEMEM,
  uModuloSeminario, uModuloPracticaDocente;

type
{$METHODINFO ON}
  TIntegerString = record
    vString: string;
    vInteger: integer;
  end;

  TValidacion = record
    Observacion: string;
    HorasDocencia: integer;
    HorasServicio: integer;
    Cruces: integer;
  end;

  TMatematicas = class(TDataModule)
    Conexion: TFDConnection;
    DireccionLibreria: TFDPhysPgDriverLink;
    SMTP: TIdSMTP;
    SSL: TIdSSLIOHandlerSocketOpenSSL;
    Data: TIdMessage;
    procedure DataModuleCreate(Sender: tobject);
  private
    AccesoDenegado: string;
    FParametros: TStringList;
    FTipoParametro: TStringList;
    FHoras: TStringList;
    FDias: TStringList;

    procedure iniciarConexion;
    procedure terminarConexion;

    procedure escribirMensaje(msg: string; tipo: string);

    function transformarNombre(sNombre: string): string;
    function extractYearFromDate(fecha: string): word;
    function cadenaToPostgres(cadena: string): string;
  public

    procedure limpiarConsulta(Query: TFDQuery);
    procedure SELECT(nombreTabla, OrdenarPor: string; Query: TFDQuery);
    procedure SelectWhere(nombreTabla, Identificador, ID: string;
      Query: TFDQuery);
    procedure SelectWhereOrder(nombreTabla, Identificador, OrdenarPor,
      ID: string; Query: TFDQuery);
    procedure InnerJoin(Tabla1, Tabla2, Parametro, IdBusqueda, Valor: string;
      Query: TFDQuery);
    procedure InnerJoin3(Tabla1, Tabla2, Tabla3, Parametro1, Parametro2,
      IdBusqueda, Valor: string; Query: TFDQuery);
    procedure INSERT(nombreTabla: string; Query: TFDQuery);
    procedure DELETE(nombreTabla, Identificador, ID: string; Query: TFDQuery);
    procedure UPDATE(nombreTabla, Identificador, ID: string; Query: TFDQuery);
    procedure limpiarParametros;
    procedure agregarParametro(Param: string; tipo: string);
    function crearJSON(Query: TFDQuery): TJSONObject;
    procedure asignarDatos(datos: TJSONObject; Query: TFDQuery);
    function Texto(ss: string): string;
    function JsonRespuesta: string;
    function JsonError: string;
    procedure enviarError(hora, fecha, procedimiento, mensaje: string);

    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;

    { Pruebas }
    function pruebaExcel: TJSONObject;

    function validarTokenHeader: boolean;
    function accesoDenegadoToken: TJSONObject;

    { CRUD: concurrencias }
    function concurrencia(idClave: string): TJSONObject;
    function updateconcurrencia(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function cancelconcurrencia(const idClave: string; const token: string)
      : TJSONObject;
    function acceptconcurrencia(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { CRUD: usuarios }
    function usuario(idClave: string): TJSONObject;
    function updateusuario(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function updateLoginUsuario(const datos: TJSONObject): TJSONObject;
    function cancelusuario(const idClave: string; const token: string)
      : TJSONObject;
    function acceptusuario(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { CRUD: participantes }
    function participante(idClave: string): TJSONObject;
    function cancelparticipante(const idClave: string; const token: string)
      : TJSONObject;
    function acceptparticipante(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { CRUD: resumenes }
    function resumen(idClave: string): TJSONObject;
    function resumenPorTipo(const tipo: string): TJSONObject;
    function resumenesAutor(idClave: string): TJSONObject;
    function updateresumen(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function cancelresumen(const idClave: string; const token: string)
      : TJSONObject;
    function acceptresumen(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { CRUD: palabraClave }
    function palabraClave(idClave: string): TJSONObject;
    function palabraClaveResumen(idClave: string): TJSONObject;
    function updatepalabraClave(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function cancelpalabraClave(const idClave: string; const token: string)
      : TJSONObject;
    function acceptpalabraClave(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { CRUD: autorResumen }
    function autorResumen(idClave: string): TJSONObject;
    function autoresResumen(idClave: string): TJSONObject;
    function updateautorResumen(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function cancelautorResumen(const cedula: string; const id_resumen: string;
      const token: string): TJSONObject;
    function acceptautorResumen(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function cancelborrarResumen(const id_resumen: string; const token: string)
      : TJSONObject;
    function autorPorCedula(cedula: string): TJSONObject;
    function updateagregarAutorResumen(const token: string;
      const datos: TJSONObject): TJSONObject;

    { CRUD: referenciaResumen }
    function referenciaResumen(idClave: string): TJSONObject;
    function referenciasResumen(idClave: string): TJSONObject;
    function updatereferenciaResumen(const token: string;
      const datos: TJSONObject): TJSONObject;
    function cancelreferenciaResumen(const idClave: string; const token: string)
      : TJSONObject;
    function acceptreferenciaResumen(const token: string;
      const datos: TJSONObject): TJSONObject;

    { CRUD: Talleres del Evento }
    function updateinscribirTaller(const token: string;
      const datos: TJSONObject): TJSONObject;
    function estadisticasTaller(const idResumen: string): TJSONObject;
    function obtenerTallerParticipante(const cedula: string): TJSONObject;
    function cancelsalirDelTaller(const cedula: string; const token: string)
      : TJSONObject;

    { CRUD: Exportaciones de Archivos }
    function updateobtenerCertificados(const datos: TJSONObject): TJSONObject;
    function obtenerListasTalleres: TJSONObject;
    function listaPosters: TJSONObject;

    { CRUD: Comunicación con el usuario }
    function updateenviarCorreo(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { CRUD Eventos }
    function eventosEMEM: TJSONObject;
    function eventoEMEM(IdEvento: string): TJSONObject;
    function conferenciasEMEM(IdEvento: string): TJSONObject;
    function ponenciasEMEM(IdEvento: string): TJSONObject;
    function cronogramaEMEM(IdEvento: string): TJSONObject;
    function organizadoresEvento(IdEvento: string): TJSONObject;
    function tipoParticipacion: TJSONObject;
    function participanteEvento(Documento, IdEvento: string): TJSONObject;

    { Configuraciones }
    function permiteCrearResumenes: TJSONObject;
    function permiteInscribirseTalleres: TJSONObject;

    function obtenerConexion(clave: string): TJSONObject;
    function updatetoken(const datos: TJSONObject): TJSONObject;
    function descargarResumenEmem(clave: string): TJSONObject;
    function descargarCertificadosUnificados(fecha: string): TJSONObject;

    { TipoContrato }
    function updateTipoContrato(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function TipoContrato(const ID: string): TJSONObject;
    function TiposContrato: TJSONObject;
    function cancelTipoContrato(const token: string; const ID: string)
      : TJSONObject;
    function acceptTipoContrato(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { Error }
    function updateError(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Error(const ID: string): TJSONObject;
    function Errores: TJSONObject;
    function cancelError(const token: string; const ID: string): TJSONObject;
    function cancelErrorPorMensaje(const token: string; const msg: string)
      : TJSONObject;
    function acceptError(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { CategoriaDocente }
    function updateCategoriaDocente(const token: string;
      const datos: TJSONObject): TJSONObject;
    function CategoriaDocente(const ID: string): TJSONObject;
    function CategoriasDocente: TJSONObject;
    function cancelCategoriaDocente(const token: string; const ID: string)
      : TJSONObject;
    function acceptCategoriaDocente(const token: string;
      const datos: TJSONObject): TJSONObject;

    { Docente }
    function updateDocente(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Docente(const ID: string): TJSONObject;
    function Docentes(const OrdenarPor: string): TJSONObject;
    function DirectoresJurados: TJSONObject;
    function DireccionJuradoDocente(IdDocente: string): TJSONObject;
    function obtenerHorasDocencia(IdDocente: string): integer;
    function obtenerTipoContrato(IdDocente: string): string;
    function DocentesPorContrato(const IdContrato: string): TJSONObject;
    function cancelDocente(const token: string; const ID: string): TJSONObject;
    function acceptDocente(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function acceptFotoDocente(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function validarToken(token: string): TJSONObject;

    { Formación de los docentes }
    function updateFormacion(datos: TJSONObject): TJSONObject;
    function formacion(IdDocente: string): TJSONObject;
    function acceptFormacion(datos: TJSONObject): TJSONObject;
    function cancelFormacion(IdFormacion: string): TJSONObject;

    { Facultad }
    function updateFacultad(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Facultad(const ID: string): TJSONObject;
    function Facultades: TJSONObject;
    function cancelFacultad(const token: string; const ID: string): TJSONObject;
    function acceptFacultad(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { Programa }
    function updatePrograma(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Programa(const ID: string): TJSONObject;
    function Programas: TJSONObject;
    function cancelPrograma(const token: string; const ID: string): TJSONObject;
    function acceptPrograma(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { ServicioPrograma }
    function updateServicioPrograma(const token: string;
      const datos: TJSONObject): TJSONObject;
    function ServicioPrograma(const ID: string): TJSONObject;
    function ServiciosPrograma(const OrdenarPor: string; const Periodo: string)
      : TJSONObject;
    function obtenerNombreServicio(const ID: string): string;
    function ServiciosProgramaDocente(const IdDocente: string;
      const Periodo: string): TJSONObject;
    function obtenerDocenteServicio(idservicio, Periodo: string): string;
    function obtenerHorasServicio(idservicio: string): string;
    function validarHorario(IdDocente, idservicio, Periodo: string)
      : TValidacion;
    function cancelServicioPrograma(const token: string; const ID: string)
      : TJSONObject;
    function acceptServicioPrograma(const token: string;
      const datos: TJSONObject): TJSONObject;

    { HorarioServicio }
    function updateHorarioServicio(const token: string;
      const datos: TJSONObject): TJSONObject;
    function HorarioServicio(const ID: string): TJSONObject;
    function HorariosServicio(const IdSercicioPrograma: string): TJSONObject;
    function cancelHorarioServicio(const token: string; const ID: string)
      : TJSONObject;
    function acceptHorarioServicio(const token: string;
      const datos: TJSONObject): TJSONObject;

    { AgendaServicio }
    function updateAgendaServicio(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function AgendaServicio(const ID: string): TJSONObject;
    function AgendasPorPeriodo(const Periodo: string): TJSONObject;
    function AgendasServicio(const IdDocente: string; const Periodo: string)
      : TJSONObject;
    function EstadoAgendas(const Periodo: string): TJSONObject;
    function obtenerNumerosActas(const IdDocente: string; Periodo: string)
      : TJSONObject;
    function ReporteProgramaServicios(const IdProgrma, Periodo: string)
      : TJSONObject;
    function ReporteHorasFacultad(Periodo: string): TJSONObject;
    function cancelDesasociarAgenda(const token: string;
      const IdServicioPrograma: string): TJSONObject;
    function cancelAgendaServicio(const token: string; const ID: string)
      : TJSONObject;
    function acceptAgendaServicio(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function acceptAgendaNumeroContrato(const token: string;
      const datos: TJSONObject): TJSONObject;
    function AgendasPorPrograma(const Periodo: string): TJSONObject;
    function AgendasPorDocente(const IdDocente: string): TJSONObject;

    { Configuracion }
    function updateConfiguracion(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Configuracion(const ID: string): TJSONObject;
    function obtenerSemanasSemestre: integer;
    function obtenerHorasCatedra: integer;
    function obtenerHorasContrato: integer;
    function Configuraciones: TJSONObject;
    function cancelConfiguracion(const token: string; const ID: string)
      : TJSONObject;
    function acceptConfiguracion(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { FuncionDocente }
    function updateFuncionDocente(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function FuncionDocente(const ID: string): TJSONObject;
    function FuncionesDocente: TJSONObject;
    function cancelFuncionDocente(const token: string; const ID: string)
      : TJSONObject;
    function acceptFuncionDocente(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { ActividadDocente }
    function updateActividadDocente(const token: string;
      const datos: TJSONObject): TJSONObject;
    function ActividadDocente(const ID: string): TJSONObject;
    function ActividadesDocente(const IdFuncion: string): TJSONObject;
    function cancelActividadDocente(const token: string; const ID: string)
      : TJSONObject;
    function acceptActividadDocente(const token: string;
      const datos: TJSONObject): TJSONObject;

    { SubactividadDocente }
    function updateSubactividadDocente(const token: string;
      const datos: TJSONObject): TJSONObject;
    function SubactividadDocente(const ID: string): TJSONObject;
    function SubactividadesDocente(const IdActividad: string): TJSONObject;
    function cancelSubactividadDocente(const token: string; const ID: string)
      : TJSONObject;
    function acceptSubactividadDocente(const token: string;
      const datos: TJSONObject): TJSONObject;

    { Afiliacion }
    function updateAfiliacion(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Afiliacion(const ID: string): TJSONObject;
    function Afiliaciones: TJSONObject;
    function cancelAfiliacion(const token: string; const ID: string)
      : TJSONObject;
    function acceptAfiliacion(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { ParticipanteEmem }
    function updateParticipanteEmem(datos: TJSONObject): TJSONObject;
    function ParticipanteEmem(const ID: string): TJSONObject;
    function ParticipantesEmem: TJSONObject;
    function cancelParticipanteEmem(const token: string; const ID: string)
      : TJSONObject;
    function acceptParticipanteEmem(const token: string;
      const datos: TJSONObject): TJSONObject;

    { Egresado }
    function updateEgresado(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Egresado(const ID: string): TJSONObject;
    function Egresados: TJSONObject;
    function cancelEgresado(const token: string; const ID: string): TJSONObject;
    function acceptEgresado(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { GrupoInvestigacion }
    function updateGrupoInvestigacion(const token: string;
      const datos: TJSONObject): TJSONObject;
    function GrupoInvestigacion(const ID: string): TJSONObject;
    function GruposInvestigacion: TJSONObject;
    function cancelGrupoInvestigacion(const token: string; const ID: string)
      : TJSONObject;
    function acceptGrupoInvestigacion(const token: string;
      const datos: TJSONObject): TJSONObject;

    { Modalidad }
    function updateModalidad(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Modalidad(const ID: string): TJSONObject;
    function Modalidades: TJSONObject;
    function cancelModalidad(const token: string; const ID: string)
      : TJSONObject;
    function acceptModalidad(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { AreaProfundizacion }
    function updateAreaProfundizacion(const token: string;
      const datos: TJSONObject): TJSONObject;
    function AreaProfundizacion(const ID: string): TJSONObject;
    function AreasProfundizacion: TJSONObject;
    function cancelAreaProfundizacion(const token: string; const ID: string)
      : TJSONObject;
    function acceptAreaProfundizacion(const token: string;
      const datos: TJSONObject): TJSONObject;

    { Area Docente }
    function updateAreaDocente(const datos: TJSONObject): TJSONObject;
    function AreasDocente(const IdDocente: string): TJSONObject;
    function cancelAreaDocente(const IdAreaDocente: string): TJSONObject;

    { TrabajoGrado }
    function updateTrabajoGrado(const datos: TJSONObject): TJSONObject;
    function TrabajoGrado(const ID: string): TJSONObject;
    function updateTrabajosGrado(filtroBusqueda: TJSONObject): TJSONObject;
    function cancelTrabajoGrado(const ID: string): TJSONObject;
    function acceptTrabajoGrado(const datos: TJSONObject): TJSONObject;
    function DirectoresTrabajosGrado: TJSONObject;
    function EvaluadoresTrabajosGrado: TJSONObject;
    function EstadisticasTrabajoGrado: TJSONObject;
    function TrabajosGradoInicianPorAnio: TJSONObject;
    function TrabajosGradoFinPorAnio: TJSONObject;
    function TrabajosGradoCalificacionFinal: TJSONObject;
    function TrabajosGradoAreaProfundizacion: TJSONObject;
    function TrabajosGradoByGrupoInvestigacion: TJSONObject;
    function TrabajosGradoByModalidad: TJSONObject;
    function TrabajosGradoByTiempoEjecucion: TJSONObject;
    function TrabajosGradoByEstado: TJSONObject;

    { Periodo }
    function updatePeriodo(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Periodo(const ID: string): TJSONObject;
    function Periodos: TJSONObject;
    function cancelPeriodo(const token: string; const ID: string): TJSONObject;
    function acceptPeriodo(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { ActividadFuncionDocente }
    function updateActividadFuncionDocente(const token: string;
      const datos: TJSONObject): TJSONObject;
    function ActividadFuncionDocente(const ID: string): TJSONObject;
    function ActividadesFuncionesDocente(const IdDocente: string;
      const Periodo: string): TJSONObject;
    function cancelActividadFuncionDocente(const token: string;
      const ID: string): TJSONObject;
    function acceptActividadFuncionDocente(const token: string;
      const datos: TJSONObject): TJSONObject;

    { Favorito }
    function updateFavorito(const token: string; const datos: TJSONObject)
      : TJSONObject;
    function Favorito(const ID: string): TJSONObject;
    function Favoritos: TJSONObject;
    function cancelFavorito(const token: string; const ID: string): TJSONObject;
    function acceptFavorito(const token: string; const datos: TJSONObject)
      : TJSONObject;

    { Perfil del Docente }
    function PerfilDocente(IdDocente: string): TJSONObject;

    { Plan de Mejoramiento }
    function factoresCalidad: TJSONObject;
    function factorCalidad(ID: string): TJSONObject;
    function updateFactorCalidad(factorCalidad: TJSONObject): TJSONObject;
    function acceptFactorCalidad(factorCalidad: TJSONObject): TJSONObject;
    function cancelFactorCalidad(idfactorcalidad: string): TJSONObject;

    function Requisitos: TJSONObject;
    function Requisito(ID: string): TJSONObject;
    function TiposAccion: TJSONObject;
    function TipoAccion(ID: string): TJSONObject;
    function Fuentes: TJSONObject;
    function Fuente(ID: string): TJSONObject;

    function PlanesMejoramiento: TJSONObject;
    function PlanMejoramiento(IdPlan: string): TJSONObject;
    function updatePlanMejoramiento(PlanMejoramiento: TJSONObject): TJSONObject;
    function acceptPlanMejoramiento(PlanMejoramiento: TJSONObject): TJSONObject;
    function cancelPlanMejoramiento(IdPlan: string): TJSONObject;

    function updateGrupoInvDocente(datos: TJSONObject): TJSONObject;
    function acceptGrupoInvDocente(datos: TJSONObject): TJSONObject;
    function cancelGrupoInvDocente(IdGrupoDocente: string): TJSONObject;
    function GrupoInvDocente(IdDocente: string): TJSONObject;
    function DocentesGrupoInvestigacion(IdGrupo: string): TJSONObject;

    function updateTipoProduccion(datos: TJSONObject): TJSONObject;
    function acceptTipoProduccion(datos: TJSONObject): TJSONObject;
    function cancelTipoProduccion(IdTipo: string): TJSONObject;
    function TiposProduccion: TJSONObject;

    function updateProducto(ProduccionDocente: TJSONObject): TJSONObject;
    function acceptProducto(ProduccionDocente: TJSONObject): TJSONObject;
    function cancelProducto(IdProducto: string): TJSONObject;
    function ProductosDocente(IdDocente: string): TJSONObject;
    function Productos: TJSONObject;

    function updateEnlaceDivulgacion(enlace: TJSONObject): TJSONObject;
    function enlacesDivulgacion(IdDocente: string): TJSONObject;
    function acceptEnlaceDivulgacion(enlace: TJSONObject): TJSONObject;
    function cancelEnlaceDivulgacion(IdEnlace: string): TJSONObject;

    function updateSeminario(datos: TJSONObject): TJSONObject;
    function seminario(IdSeminario: string): TJSONObject;
    function seminarios: TJSONObject;
    function acceptSeminario(datos: TJSONObject): TJSONObject;
    function cancelSeminario(IdSeminario: string): TJSONObject;
    function actualizarNumerosSeminario: TJSONObject;

    function updateFechaPresupuestoPm(datos: TJSONObject): TJSONObject;
    function FechasPresupuestoPm: TJSONObject;
    function FechaPresupuestoPm(IdFecha: string): TJSONObject;
    function acceptFechaPresupuestoPm(datos: TJSONObject): TJSONObject;
    function cancelFechaPresupuestoPm(IdFecha: string): TJSONObject;

    function updatePresupuestoPm(datos: TJSONObject): TJSONObject;
    function presupuestosPm(IdPlan: string): TJSONObject;
    function getPresupuestosPm(IdPlan: string): TJSONArray;
    function getPrespuestoByFechaPlan(IdPlan: string): TJSONArray;
    function acceptPresupuestoPm(datos: TJSONObject): TJSONObject;
    function cancelPresupuestoPm(idpresupuesto: string): TJSONObject;

    { Crud para práctica docente }
    function PeriodosPractica: TJSONObject;
    function Estudiante(Documento, Periodo: string): TJSONObject;
    function updateEstudiantePeriodo(Estudiante: TJSONObject): TJSONObject;
    function updateEstudiante(Estudiante: TJSONObject): TJSONObject;
    function acceptEstudiante(Estudiante: TJSONObject): TJSONObject;
    function Estudiantes: TJSONObject;
    function cancelEstudiante(IdEstudiante: string): TJSONObject;
    function updateEnviarCorreoPractica(datos: TJSONObject): TJSONObject;
    function EstadisticasPeriodo(IdPeriodo: string): TJSONObject;
    function updateCartaPermiso(datos: TJSONObject): TJSONObject;
    function acceptCartaPermiso(datos: TJSONObject): TJSONObject;
    function CartasPermisoByPeriodo(Periodo: string): TJSONObject;
    function CartaPermiso(IdCarta: string): TJSONObject;
    function cancelCartaPermiso(IdCarta: string): TJSONObject;
    function EstudiantesByPeriodo(IdPeriodo: string): TJSONObject;
    function updateEstudianteCarta(datos: TJSONObject): TJSONObject;
    function acceptEstudianteCarta(datos: TJSONObject): TJSONObject;
    function cancelEstudianteCarta(IdEstudianteCarta: string): TJSONObject;
    function EstudiantesBySecretaria(IdPeriodo: string): TJSONObject;
    function Secretarias: TJSONObject;

  end;
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses System.StrUtils;

{ Método INSERT - Favorito }
function TMatematicas.updateFavorito(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
  Freq: integer;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      // Determinar si ya existe para actualizar la frecuencia
      Query.Close;
      Query.SQL.Text := 'SELECT * FROM siap_favoritos WHERE idfavorito=' + #39 +
        datos.GetValue('idfavorito').Value + #39;
      Query.Open;

      // ShowMessage(datos.GetValue('idfavorito').Value);

      if Query.RecordCount > 0 then
      begin
        Freq := Query.FieldByName('frecuencia').AsInteger + 1;
        ID := Query.FieldByName('idfavorito').AsString;

        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('UPDATE siap_favoritos SET ');
        Query.SQL.Add('titulo=:titulo, ');
        Query.SQL.Add('icono=:icono, ');
        Query.SQL.Add('ruta=:ruta, ');
        Query.SQL.Add('frecuencia=:frecuencia WHERE idfavorito=' + #39 +
          ID + #39);

        Query.Params.ParamByName('titulo').AsString :=
          datos.GetValue('titulo').Value;
        Query.Params.ParamByName('icono').AsString :=
          LowerCase(datos.GetValue('icono').Value);
        Query.Params.ParamByName('ruta').AsString :=
          datos.GetValue('ruta').Value;
        Query.Params.ParamByName('frecuencia').AsInteger := Freq;

        Query.ExecSQL;

        Json.AddPair(JsonRespuesta, 'El Favorito se actualizo correctamente');
      end
      else
      begin
        limpiarConsulta(Query);

        limpiarParametros;

        agregarParametro('idfavorito', 'String');
        agregarParametro('titulo', 'String');
        agregarParametro('icono', 'String');
        agregarParametro('ruta', 'String');
        agregarParametro('frecuencia', 'Integer');

        INSERT('siap_favoritos', Query);

        asignarDatos(datos, Query);

        Json.AddPair(JsonRespuesta, 'El Favorito se creo correctamente');
      end;
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateFavorito',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateFavorito', Json.toString);
  Query.Free;
end;

function TMatematicas.updateFechaPresupuestoPm(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;

    if validarTokenHeader then
    begin
      Query := TFDQuery.create(nil);
      Query.Connection := Conexion;

      Query.Close;
      Query.SQL.Text :=
        'INSERT INTO siap_fechas_plan_mejoramiento (idfecha, fecha)' +
        ' VALUES (:idfecha, :fecha)';
      Query.Params.ParamByName('idfecha').Value := moduloDatos.generarID;
      Query.Params.ParamByName('fecha').Value := datos.GetValue('fecha').Value;
      Query.ExecSQL;

      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, 'La fecha se creo correctamente');
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, AccesoDenegado);
    end;
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.updateFormacion(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  QFormacion: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QFormacion := TFDQuery.create(nil);
    QFormacion.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QFormacion.Close;
      QFormacion.SQL.Text := 'INSERT INTO siap_formacion (idformacion,' +
        'titulo,fechainicio,fechafin,institucion,iddocente) VALUES (' +
        ':idformacion,:titulo,:fechainicio,:fechafin,:institucion,:iddocente)';

      QFormacion.Params.ParamByName('idformacion').Value :=
        moduloDatos.generarID;
      QFormacion.Params.ParamByName('titulo').Value :=
        datos.GetValue('titulo').Value;
      QFormacion.Params.ParamByName('fechainicio').Value :=
        datos.GetValue('fechainicio').Value;
      QFormacion.Params.ParamByName('fechafin').Value :=
        datos.GetValue('fechafin').Value;
      QFormacion.Params.ParamByName('institucion').Value :=
        datos.GetValue('institucion').Value;
      QFormacion.Params.ParamByName('iddocente').Value :=
        StrToInt(datos.GetValue('iddocente').Value);

      QFormacion.ExecSQL;

      Json.AddPair('Respuesta', 'La formación se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateFormacion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateFormacion', Json.toString);
  QFormacion.Free;
end;

{ Método GET - Favorito }
function TMatematicas.Favorito(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_favoritos', 'idfavorito', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idfavorito', 'String');
    agregarParametro('titulo', 'String');
    agregarParametro('icono', 'String');
    agregarParametro('ruta', 'String');
    agregarParametro('frecuencia', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getFavorito',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Favorito', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Favorito }
function TMatematicas.Favoritos: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i, cant: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Favoritos', ArrayJson);

    limpiarConsulta(Query);
    Query.SQL.Text := 'SELECT * FROM siap_favoritos ORDER BY frecuencia desc';
    Query.Open;

    limpiarParametros;
    agregarParametro('idfavorito', 'String');
    agregarParametro('titulo', 'String');
    agregarParametro('icono', 'String');
    agregarParametro('ruta', 'String');
    agregarParametro('frecuencia', 'String');

    cant := Query.RecordCount;
    if cant > 12 then
      cant := 12;
    Query.First;

    for i := 1 to cant do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllFavorito',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Favoritos', Json.toString);
  Query.Free;
end;

function TMatematicas.FechaPresupuestoPm(IdFecha: string): TJSONObject;
var
  Json, JsonFecha: TJSONObject;
  Query: TFDQuery;
  Fechas: TJSONArray;
  i: integer;
begin
  try
    Json := TJSONObject.create;

    if validarTokenHeader then
    begin
      Query := TFDQuery.create(nil);
      Query.Connection := Conexion;

      Query.Close;
      Query.SQL.Text :=
        'SELECT * FROM siap_fechas_plan_mejoramiento WHERE idfecha=' + #39 +
        IdFecha + #39;
      Query.Open;
      Query.Next;

      Fechas := TJSONArray.create;
      for i := 1 to Query.RecordCount do
      begin
        JsonFecha := TJSONObject.create;
        JsonFecha.AddPair('idfecha', Query.FieldByName('idfecha').AsString);
        JsonFecha.AddPair('fecha', Query.FieldByName('fecha').AsString);

        Fechas.AddElement(JsonFecha);
        Query.Next;
      end;

      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, 'Las fechas se obtuvieron correctamente');
      Json.AddPair(JSON_RESULTS, Fechas);
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, AccesoDenegado);
    end;
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.FechasPresupuestoPm: TJSONObject;
var
  Json, JsonFecha: TJSONObject;
  Query: TFDQuery;
  Fechas: TJSONArray;
  i: integer;
begin
  try
    Json := TJSONObject.create;

    if validarTokenHeader then
    begin
      Query := TFDQuery.create(nil);
      Query.Connection := Conexion;

      Query.Close;
      Query.SQL.Text :=
        'SELECT * FROM siap_fechas_plan_mejoramiento ORDER BY fecha';
      Query.Open;
      Query.First;

      Fechas := TJSONArray.create;
      for i := 1 to Query.RecordCount do
      begin
        JsonFecha := TJSONObject.create;
        JsonFecha.AddPair('idfecha', Query.FieldByName('idfecha').AsString);
        JsonFecha.AddPair('fecha', Query.FieldByName('fecha').AsString);

        Fechas.AddElement(JsonFecha);
        Query.Next;
      end;

      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, 'Las fechas se obtuvieron correctamente');
      Json.AddPair(JSON_RESULTS, Fechas);
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, AccesoDenegado);
    end;
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.formacion(IdDocente: string): TJSONObject;
var
  QFormacion: TFDQuery;
  Formaciones: TJSONArray;
  JsonFormaciones, JsonFormacion: TJSONObject;
  i: integer;
begin
  try
    QFormacion := TFDQuery.create(nil);
    QFormacion.Connection := Conexion;

    JsonFormaciones := TJSONObject.create;

    QFormacion.Close;
    QFormacion.SQL.Text := 'SELECT * FROM siap_formacion WHERE iddocente=' + #39
      + IdDocente + #39;
    QFormacion.Open;

    Formaciones := TJSONArray.create;
    for i := 1 to QFormacion.RecordCount do
    begin
      JsonFormacion := TJSONObject.create;
      JsonFormacion.AddPair('idformacion', QFormacion.FieldByName('idformacion')
        .AsString);
      JsonFormacion.AddPair('titulo', QFormacion.FieldByName('titulo')
        .AsString);
      JsonFormacion.AddPair('fechainicio', QFormacion.FieldByName('fechainicio')
        .AsString);
      JsonFormacion.AddPair('fechafin', QFormacion.FieldByName('fechafin')
        .AsString);
      JsonFormacion.AddPair('institucion', QFormacion.FieldByName('institucion')
        .AsString);
      JsonFormacion.AddPair('iddocente', QFormacion.FieldByName('iddocente')
        .AsString);

      Formaciones.AddElement(JsonFormacion);
      QFormacion.Next;
    end;

    JsonFormaciones.AddPair('Formaciones', Formaciones);
  except
    on E: Exception do
      JsonFormaciones.AddPair('Error', E.Message);
  end;

  QFormacion.Free;
  Result := JsonFormaciones;
end;

{ Método DELETE - Favorito }
function TMatematicas.cancelFavorito(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_favoritos', 'idfavorito', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'El Favorito se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteFavorito',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelFavorito', Json.toString);
  Query.Free;
end;

function TMatematicas.cancelFechaPresupuestoPm(IdFecha: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;

    if validarTokenHeader then
    begin
      Query := TFDQuery.create(nil);
      Query.Connection := Conexion;

      Query.Close;
      Query.SQL.Text :=
        'DELETE FROM siap_fechas_plan_mejoramiento WHERE idfecha=' + #39 +
        IdFecha + #39;
      Query.ExecSQL;

      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, 'La fecha se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, AccesoDenegado);
    end;
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.cancelFormacion(IdFormacion: string): TJSONObject;
var
  Json: TJSONObject;
  QFormacion: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QFormacion := TFDQuery.create(nil);
    QFormacion.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QFormacion.Close;
      QFormacion.SQL.Text := 'DELETE FROM siap_formacion WHERE idformacion=' +
        #39 + IdFormacion + #39;
      QFormacion.ExecSQL;

      QFormacion.ExecSQL;

      Json.AddPair('Respuesta', 'La formación se elimino correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateFormacion',
        E.Message + IdFormacion);
    end;
  end;

  Result := Json;
  escribirMensaje('updateFormacion', Json.toString);
  QFormacion.Free;
end;

{ Método UPDATE - Favorito }
function TMatematicas.acceptFavorito(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idfavorito', 'String');
      agregarParametro('titulo', 'String');
      agregarParametro('icono', 'String');
      agregarParametro('ruta', 'String');
      agregarParametro('frecuencia', 'String');

      ID := datos.GetValue('idfavorito').Value;
      UPDATE('siap_favoritos', 'idfavorito', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Favorito se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptFavorito',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateFavorito', Json.toString);
  Query.Free;
end;

function TMatematicas.acceptFechaPresupuestoPm(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;

    if validarTokenHeader then
    begin
      Query := TFDQuery.create(nil);
      Query.Connection := Conexion;

      Query.Close;
      Query.SQL.Text := 'UPDATE siap_fechas_plan_mejoramiento SET fecha=:fecha '
        + ' WHERE idfecha=' + #39 + datos.GetValue('idfecha').Value + #39;

      Query.Params.ParamByName('fecha').Value := datos.GetValue('fecha').Value;
      Query.ExecSQL;

      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, 'La fecha se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, AccesoDenegado);
    end;
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

{ Método INSERT - ActividadFuncionDocente }
function TMatematicas.updateActividadFuncionDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idactividadprograma', 'String');
      agregarParametro('idfuncion', 'String');
      agregarParametro('idactividad', 'String');
      agregarParametro('idsubactividad', 'String');
      agregarParametro('actividad', 'String');
      agregarParametro('iddocente', 'Integer');
      agregarParametro('periodo', 'String');
      agregarParametro('calculada', 'String');
      agregarParametro('horas', 'Float');

      INSERT('siap_actividades_funciones_docente', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Actividad se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now),
        'updateActividadFuncionDocente', E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateActividadFuncionDocente', Json.toString);
  Query.Free;
end;

{ Método GET - ActividadFuncionDocente }
function TMatematicas.ActividadFuncionDocente(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_actividades_funciones_docente', 'idactividadprograma',
      Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idactividadprograma', 'String');
    agregarParametro('idfuncion', 'String');
    agregarParametro('idactividad', 'String');
    agregarParametro('idsubactividad', 'String');
    agregarParametro('actividad', 'String');
    agregarParametro('iddocente', 'String');
    agregarParametro('periodo', 'String');
    agregarParametro('horas', 'String');
    agregarParametro('calculada', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getActividadFuncionDocente',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('ActividadFuncionDocente', Json.toString);
  Query.Free;
end;

function TMatematicas.actualizarNumerosSeminario: TJSONObject;
begin
  Result := ModuloSeminario.ordenarNumerosSeminario;
end;

{ Método GET-ALL - ActividadFuncionDocente }
function TMatematicas.ActividadesFuncionesDocente(const IdDocente: string;
  const Periodo: string): TJSONObject;
var
  Json: TJSONObject;
  Query, Query2: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
  horas, horMaxCont, horasFunciones, HorasDocencia, horasRestantes,
    horasSemestre, horasTotal: real;
  calculadas: string;
  serviciosDocente: TJSONObject;
  contrato: string;
  formato: TFormatSettings;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  Query2 := TFDQuery.create(nil);
  Query2.Connection := Conexion;

  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('ActividadesFuncionesDocente', ArrayJson);

    contrato := obtenerTipoContrato(IdDocente);

    // Leer todas las funciones del docente
    limpiarConsulta(Query);
    Query.SQL.Add('SELECT fd.funcion as funcion,');
    Query.SQL.Add('    ad.actividad as actividad,');
    Query.SQL.Add('	   sd.subactividad as subactividad,');
    Query.SQL.Add('	   afd.periodo as periodo,');
    Query.SQL.Add('	   afd.horas as horas,');
    Query.SQL.Add('	   afd.actividad as actividadprograma,');
    Query.SQL.Add('    afd.calculada as calculada, ');
    Query.SQL.Add('	   afd.idactividadprograma as idactividadprograma');
    Query.SQL.Add('	   FROM siap_actividades_funciones_docente as afd ');
    Query.SQL.Add('INNER JOIN siap_funciones_docentes as fd  ');
    Query.SQL.Add('ON afd.idfuncion=fd.idfunciondocente ');
    Query.SQL.Add('INNER JOIN siap_actividades_docentes as ad ');
    Query.SQL.Add('ON afd.idactividad=ad.idactividaddocente ');
    Query.SQL.Add('INNER JOIN siap_subactividades_docentes as sd ');
    Query.SQL.Add('ON afd.idsubactividad=sd.idsubactividaddocente ');
    Query.SQL.Add('WHERE afd.iddocente=' + IdDocente + ' AND afd.periodo=' + #39
      + Periodo + #39 + ' ORDER BY afd.calculada desc');
    Query.Open;

    FDataSnapMatematicas.comentarioSQL('Script ActividadesFuncionesDocente');
    FDataSnapMatematicas.escribirSQL(Query.SQL.Text);

    limpiarParametros;
    agregarParametro('idactividadprograma', 'String');
    agregarParametro('funcion', 'String');
    agregarParametro('actividad', 'String');
    agregarParametro('subactividad', 'String');
    agregarParametro('actividadprograma', 'String');
    agregarParametro('periodo', 'String');
    agregarParametro('horas', 'String');
    agregarParametro('calculada', 'String');

    horasFunciones := 0;
    Query2.Close;
    Query2.SQL.Text := 'SELECT * FROM siap_periodos WHERE periodo=' + #39 +
      Periodo + #39;
    Query2.Open;

    escribirMensaje('tipo-contrato', contrato);
    escribirMensaje('periodo', Periodo);

    if contrato = 'carrera' then
      horMaxCont := Query2.FieldByName('hormaxcarrera').AsInteger
    else if contrato = 'contrato' then
      horMaxCont := Query2.FieldByName('hormaxcontrato').AsInteger
    else
      horMaxCont := Query2.FieldByName('hormaxcatedratico').AsInteger;

    escribirMensaje('horMaxCont', floatTostr(horMaxCont));

    for i := 1 to Query.RecordCount do
    begin
      horas := Query.FieldByName('horas').AsFloat;
      calculadas := Query.FieldByName('calculada').AsString;

      if calculadas = 'semestrales' then
        horasSemestre := horas
      else
        horasSemestre := 17 * horas;

      horasFunciones := horasFunciones + horasSemestre;
      JsonLinea := TJSONObject.create;

      JsonLinea := crearJSON(Query);
      JsonLinea.AddPair('horassemestre', floatTostr(horasSemestre));
      ArrayJson.AddElement(JsonLinea);
      Query.Next;
    end;

    { Obtener el número de horas de materias o servicios }
    serviciosDocente := TJSONObject.create;
    serviciosDocente := AgendasServicio(IdDocente, Periodo);
    HorasDocencia :=
      StrToFloat(serviciosDocente.GetValue('horasSemestrales').Value);

    horasTotal := HorasDocencia + horasFunciones;
    horasRestantes := horMaxCont - horasTotal;

    formato.DecimalSeparator := '.';

    Json.AddPair('horasDocencia', floatTostr(HorasDocencia));
    Json.AddPair('horasFunciones', floatTostr(horasFunciones));
    Json.AddPair('horasTotales', floatTostr(horasTotal));
    Json.AddPair('horasRestantes', floatTostr(horasRestantes, formato));
    Json.AddPair('horasMaxContrato', floatTostr(horMaxCont));

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now),
        'getAllActividadFuncionDocente', E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('ActividadesFuncionesDocente', Json.toString);
  Query.Free;
  Query2.Free;
end;

{ Método DELETE - ActividadFuncionDocente }
function TMatematicas.cancelActividadFuncionDocente(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_actividades_funciones_docente', 'idactividadprograma',
        Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'La Actividad se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now),
        'deleteActividadFuncionDocente', E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelActividadFuncionDocente', Json.toString);
  Query.Free;
end;

{ Método UPDATE - ActividadFuncionDocente }
function TMatematicas.acceptActividadFuncionDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idactividadprograma', 'String');
      agregarParametro('idfuncion', 'String');
      agregarParametro('idactividad', 'String');
      agregarParametro('idsubactividad', 'String');
      agregarParametro('actividad', 'String');
      agregarParametro('iddocente', 'Integer');
      agregarParametro('periodo', 'String');
      agregarParametro('horas', 'Float');
      agregarParametro('calculada', 'String');

      ID := datos.GetValue('idactividadprograma').Value;
      UPDATE('siap_actividades_funciones_docente', 'idactividadprograma',
        Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Actividad se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now),
        'acceptActividadFuncionDocente', E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateActividadFuncionDocente', Json.toString);
  Query.Free;
end;

{ Método INSERT - Periodo }
function TMatematicas.updatePeriodo(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idperiodo', 'String');
      agregarParametro('periodo', 'String');
      agregarParametro('hormaxcarrera', 'Integer');
      agregarParametro('hormaxcontrato', 'Integer');
      agregarParametro('hormaxcatedratico', 'Integer');

      INSERT('siap_periodos', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El periodo se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updatePeriodo',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updatePeriodo', Json.toString);
  Query.Free;
end;

function TMatematicas.updatePlanMejoramiento(PlanMejoramiento: TJSONObject)
  : TJSONObject;
var
  QPlan: TFDQuery;
  JsonResp: TJSONObject;
  fs: TFormatSettings;
begin
  try
    QPlan := TFDQuery.create(nil);
    QPlan.Connection := Conexion;

    JsonResp := TJSONObject.create;

    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    QPlan.Close;
    QPlan.SQL.Clear;
    QPlan.SQL.Add('INSERT INTO siap_plan_mejoramiento (');
    QPlan.SQL.Add('idplan, ');
    QPlan.SQL.Add('orden, ');
    QPlan.SQL.Add('idfuente, ');
    QPlan.SQL.Add('idfactorcalidad, ');
    QPlan.SQL.Add('idrequisito, ');
    QPlan.SQL.Add('descripcion_mejora, ');
    QPlan.SQL.Add('idtipoaccion, ');
    QPlan.SQL.Add('causas_principales, ');
    QPlan.SQL.Add('metas, ');
    QPlan.SQL.Add('fecha_inicio, ');
    QPlan.SQL.Add('fecha_fin, ');
    QPlan.SQL.Add('actividades, ');
    QPlan.SQL.Add('responsable_ejecucion, ');
    QPlan.SQL.Add('responsable_seguimiento, ');
    QPlan.SQL.Add('indicador_meta, ');
    QPlan.SQL.Add('formula_indicador, ');
    QPlan.SQL.Add('resultado_indicador, ');
    QPlan.SQL.Add('avance_meta, ');
    QPlan.SQL.Add('seguimiento, ');
    QPlan.SQL.Add('observaciones, ');
    QPlan.SQL.Add('estado_actual_accion) VALUES (');

    QPlan.SQL.Add(':idplan, ');
    QPlan.SQL.Add(':orden, ');
    QPlan.SQL.Add(':idfuente, ');
    QPlan.SQL.Add(':idfactorcalidad, ');
    QPlan.SQL.Add(':idrequisito, ');
    QPlan.SQL.Add(':descripcion_mejora, ');
    QPlan.SQL.Add(':idtipoaccion, ');
    QPlan.SQL.Add(':causas_principales, ');
    QPlan.SQL.Add(':metas, ');
    QPlan.SQL.Add(':fecha_inicio, ');
    QPlan.SQL.Add(':fecha_fin, ');
    QPlan.SQL.Add(':actividades, ');
    QPlan.SQL.Add(':responsable_ejecucion, ');
    QPlan.SQL.Add(':responsable_seguimiento, ');
    QPlan.SQL.Add(':indicador_meta, ');
    QPlan.SQL.Add(':formula_indicador, ');
    QPlan.SQL.Add(':resultado_indicador, ');
    QPlan.SQL.Add(':avance_meta, ');
    QPlan.SQL.Add(':seguimiento, ');
    QPlan.SQL.Add(':observaciones, ');
    QPlan.SQL.Add(':estado_actual_accion)');

    QPlan.Params.ParamByName('idplan').Value := moduloDatos.generarID;

    QPlan.Params.ParamByName('orden').Value :=
      StrToInt(PlanMejoramiento.GetValue('orden').Value);

    QPlan.Params.ParamByName('idfuente').Value :=
      PlanMejoramiento.GetValue('idfuente').Value;

    QPlan.Params.ParamByName('idfactorcalidad').Value :=
      PlanMejoramiento.GetValue('idfactorcalidad').Value;

    QPlan.Params.ParamByName('idrequisito').Value :=
      PlanMejoramiento.GetValue('idrequisito').Value;

    QPlan.Params.ParamByName('descripcion_mejora').AsWideMemo :=
      PlanMejoramiento.GetValue('descripcion_mejora').Value;

    QPlan.Params.ParamByName('idtipoaccion').Value :=
      PlanMejoramiento.GetValue('idtipoaccion').Value;

    QPlan.Params.ParamByName('causas_principales').AsWideMemo :=
      PlanMejoramiento.GetValue('causas_principales').Value;

    QPlan.Params.ParamByName('metas').AsWideMemo :=
      PlanMejoramiento.GetValue('metas').Value;

    QPlan.Params.ParamByName('fecha_inicio').AsDate :=
      StrToDate(PlanMejoramiento.GetValue('fecha_inicio').Value, fs);

    QPlan.Params.ParamByName('fecha_fin').AsDate :=
      StrToDate(PlanMejoramiento.GetValue('fecha_fin').Value, fs);

    QPlan.Params.ParamByName('actividades').AsWideMemo :=
      PlanMejoramiento.GetValue('actividades').Value;

    QPlan.Params.ParamByName('responsable_ejecucion').Value :=
      PlanMejoramiento.GetValue('responsable_ejecucion').Value;

    QPlan.Params.ParamByName('responsable_seguimiento').Value :=
      PlanMejoramiento.GetValue('responsable_seguimiento').Value;

    QPlan.Params.ParamByName('indicador_meta').AsWideMemo :=
      PlanMejoramiento.GetValue('indicador_meta').Value;

    QPlan.Params.ParamByName('formula_indicador').AsWideMemo :=
      PlanMejoramiento.GetValue('formula_indicador').Value;

    QPlan.Params.ParamByName('resultado_indicador').AsWideMemo :=
      PlanMejoramiento.GetValue('resultado_indicador').Value;

    QPlan.Params.ParamByName('avance_meta').AsWideMemo :=
      PlanMejoramiento.GetValue('avance_meta').Value;

    QPlan.Params.ParamByName('seguimiento').AsWideMemo :=
      PlanMejoramiento.GetValue('seguimiento').Value;

    QPlan.Params.ParamByName('observaciones').AsWideMemo :=
      PlanMejoramiento.GetValue('observaciones').Value;

    QPlan.Params.ParamByName('estado_actual_accion').Value :=
      PlanMejoramiento.GetValue('estado_actual_accion').Value;

    QPlan.ExecSQL;

    JsonResp.AddPair('Respuesta', 'El plan se creo correctamente');
  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  QPlan.Free;
end;

{ Método GET - Periodo }
function TMatematicas.PerfilDocente(IdDocente: string): TJSONObject;
var
  JsonPerfil, JsonTemp: TJSONObject;
  ListaJurado, ListaDirector: TJSONArray;
  Query: TFDQuery;
  i: integer;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    JsonPerfil := TJSONObject.create;

    { Jurado como evaluador en trabajos de grado %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE idjurado1=' + #39
      + IdDocente + #39 + ' or idjurado2=' + #39 + IdDocente + #39 +
      ' or idjurado3=' + #39 + IdDocente + #39;
    Query.Open;
    Query.First;

    ListaJurado := TJSONArray.create;

    for i := 1 to Query.RecordCount do
    begin
      JsonTemp := TJSONObject.create;
      JsonTemp.AddPair('Titulo', Query.FieldByName('titulo').AsString);
      JsonTemp.AddPair('EvaluacionPropuesta',
        Query.FieldByName('evaluacionpropuesta').AsString);
      JsonTemp.AddPair('EvaluacionSustentacion',
        Query.FieldByName('evaluacionsustentacion').AsString);
      JsonTemp.AddPair('EvaluacionTrabajoEscrito',
        Query.FieldByName('evaluaciontrabajoescrito').AsString);
      JsonTemp.AddPair('CalificacionFinal',
        Query.FieldByName('calificacionfinal').AsString);
      JsonTemp.AddPair('Estudiante1', Query.FieldByName('estudiante1')
        .AsString);
      JsonTemp.AddPair('Estudiante2', Query.FieldByName('estudiante2')
        .AsString);
      JsonTemp.AddPair('Estudiante3', Query.FieldByName('estudiante3')
        .AsString);
      JsonTemp.AddPair('FechaInicio', Query.FieldByName('fechainicioejecucion')
        .AsString);
      JsonTemp.AddPair('FechaSustentacion',
        Query.FieldByName('fechasustentacion').AsString);

      ListaJurado.AddElement(JsonTemp);
      Query.Next;
    end;

    JsonPerfil.AddPair('JuradoTrabajosGrado', ListaJurado);

    { Director de trabajos de grado %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE iddirector=' + #39
      + IdDocente + #39;
    Query.Open;
    Query.First;

    ListaDirector := TJSONArray.create;

    for i := 1 to Query.RecordCount do
    begin
      JsonTemp := TJSONObject.create;
      JsonTemp.AddPair('Titulo', Query.FieldByName('titulo').AsString);
      JsonTemp.AddPair('EvaluacionPropuesta',
        Query.FieldByName('evaluacionpropuesta').AsString);
      JsonTemp.AddPair('EvaluacionSustentacion',
        Query.FieldByName('evaluacionsustentacion').AsString);
      JsonTemp.AddPair('EvaluacionTrabajoEscrito',
        Query.FieldByName('evaluaciontrabajoescrito').AsString);
      JsonTemp.AddPair('CalificacionFinal',
        Query.FieldByName('calificacionfinal').AsString);
      JsonTemp.AddPair('Estudiante1', Query.FieldByName('estudiante1')
        .AsString);
      JsonTemp.AddPair('Estudiante2', Query.FieldByName('estudiante2')
        .AsString);
      JsonTemp.AddPair('Estudiante3', Query.FieldByName('estudiante3')
        .AsString);
      JsonTemp.AddPair('FechaInicio', Query.FieldByName('fechainicioejecucion')
        .AsString);
      JsonTemp.AddPair('FechaSustentacion',
        Query.FieldByName('fechasustentacion').AsString);

      ListaDirector.AddElement(JsonTemp);
      Query.Next;
    end;

    JsonPerfil.AddPair('DirectorTrabajosGrado', ListaDirector);

  except
    on E: Exception do
    begin
      JsonPerfil.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'PerfilDocente',
        E.Message + '=>' + IdDocente);
    end;
  end;

  Result := JsonPerfil;
  escribirMensaje('PerfilDocente', JsonPerfil.toString);
  Query.Free;
end;

function TMatematicas.Periodo(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_periodos', 'idperiodo', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idperiodo', 'String');
    agregarParametro('periodo', 'String');
    agregarParametro('hormaxcarrera', 'String');
    agregarParametro('hormaxcontrato', 'String');
    agregarParametro('hormaxcatedratico', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getPeriodo',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Periodo', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Periodo }
function TMatematicas.Periodos: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Periodos', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_periodos', 'periodo', Query);

    limpiarParametros;
    agregarParametro('idperiodo', 'String');
    agregarParametro('periodo', 'String');
    agregarParametro('hormaxcarrera', 'String');
    agregarParametro('hormaxcontrato', 'String');
    agregarParametro('hormaxcatedratico', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllPeriodo',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Periodos', Json.toString);
  Query.Free;
end;

{ Método DELETE - Periodo }
function TMatematicas.cancelPeriodo(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_periodos', 'idperiodo', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'El periodo se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deletePeriodo',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelPeriodo', Json.toString);
  Query.Free;
end;

function TMatematicas.cancelPlanMejoramiento(IdPlan: string): TJSONObject;
var
  QPlan: TFDQuery;
  JsonPlan: TJSONObject;
  i: integer;
begin
  try
    QPlan := TFDQuery.create(nil);
    QPlan.Connection := Conexion;
    JsonPlan := TJSONObject.create;

    QPlan.Close;
    QPlan.SQL.Text := 'DELETE FROM siap_plan_mejoramiento WHERE idplan=' + #39 +
      IdPlan + #39;
    QPlan.ExecSQL;

    JsonPlan.AddPair('Respuesta', 'El plan se elimino correctamente');

  except
    on E: Exception do
      JsonPlan.AddPair('Error', E.Message);

  end;

  Result := JsonPlan;
  QPlan.Free;
end;

{ Método UPDATE - Periodo }
function TMatematicas.acceptPeriodo(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idperiodo', 'String');
      agregarParametro('periodo', 'String');
      agregarParametro('hormaxcarrera', 'Integer');
      agregarParametro('hormaxcontrato', 'Integer');
      agregarParametro('hormaxcatedratico', 'Integer');

      ID := datos.GetValue('idperiodo').Value;
      UPDATE('siap_periodos', 'idperiodo', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El periodo se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptPeriodo',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updatePeriodo', Json.toString);
  Query.Free;
end;

function TMatematicas.acceptPlanMejoramiento(PlanMejoramiento: TJSONObject)
  : TJSONObject;
var
  QPlan: TFDQuery;
  JsonResp: TJSONObject;
  IdPlan: string;
  fs: TFormatSettings;
begin
  try
    QPlan := TFDQuery.create(nil);
    QPlan.Connection := Conexion;

    JsonResp := TJSONObject.create;
    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    IdPlan := PlanMejoramiento.GetValue('idplan').Value;

    QPlan.Close;
    QPlan.SQL.Clear;
    QPlan.SQL.Add('UPDATE siap_plan_mejoramiento SET ');
    QPlan.SQL.Add('orden=:orden, ');
    QPlan.SQL.Add('idfuente=:idfuente, ');
    QPlan.SQL.Add('idfactorcalidad=:idfactorcalidad, ');
    QPlan.SQL.Add('idrequisito=:idrequisito, ');
    QPlan.SQL.Add('descripcion_mejora=:descripcion_mejora, ');
    QPlan.SQL.Add('idtipoaccion=:idtipoaccion, ');
    QPlan.SQL.Add('causas_principales=:causas_principales, ');
    QPlan.SQL.Add('metas=:metas, ');
    QPlan.SQL.Add('fecha_inicio=:fecha_inicio, ');
    QPlan.SQL.Add('fecha_fin=:fecha_fin, ');
    QPlan.SQL.Add('actividades=:actividades, ');
    QPlan.SQL.Add('responsable_ejecucion=:responsable_ejecucion, ');
    QPlan.SQL.Add('responsable_seguimiento=:responsable_seguimiento, ');
    QPlan.SQL.Add('indicador_meta=:indicador_meta, ');
    QPlan.SQL.Add('formula_indicador=:formula_indicador, ');
    QPlan.SQL.Add('resultado_indicador=:resultado_indicador, ');
    QPlan.SQL.Add('avance_meta=:avance_meta, ');
    QPlan.SQL.Add('seguimiento=:seguimiento, ');
    QPlan.SQL.Add('observaciones=:observaciones, ');
    QPlan.SQL.Add('estado_actual_accion=:estado_actual_accion WHERE idplan=' +
      #39 + IdPlan + #39);

    QPlan.Params.ParamByName('orden').Value :=
      StrToInt(PlanMejoramiento.GetValue('orden').Value);

    QPlan.Params.ParamByName('idfuente').Value :=
      PlanMejoramiento.GetValue('idfuente').Value;

    QPlan.Params.ParamByName('idfactorcalidad').Value :=
      PlanMejoramiento.GetValue('idfactorcalidad').Value;

    QPlan.Params.ParamByName('idrequisito').Value :=
      PlanMejoramiento.GetValue('idrequisito').Value;

    QPlan.Params.ParamByName('descripcion_mejora').AsWideMemo :=
      PlanMejoramiento.GetValue('descripcion_mejora').Value;

    QPlan.Params.ParamByName('idtipoaccion').Value :=
      PlanMejoramiento.GetValue('idtipoaccion').Value;

    QPlan.Params.ParamByName('causas_principales').AsWideMemo :=
      PlanMejoramiento.GetValue('causas_principales').Value;

    QPlan.Params.ParamByName('metas').AsWideMemo :=
      PlanMejoramiento.GetValue('metas').Value;

    QPlan.Params.ParamByName('fecha_inicio').AsDate :=
      StrToDate(PlanMejoramiento.GetValue('fecha_inicio').Value, fs);

    QPlan.Params.ParamByName('fecha_fin').AsDate :=
      StrToDate(PlanMejoramiento.GetValue('fecha_fin').Value, fs);

    QPlan.Params.ParamByName('actividades').AsWideMemo :=
      PlanMejoramiento.GetValue('actividades').Value;

    QPlan.Params.ParamByName('responsable_ejecucion').Value :=
      PlanMejoramiento.GetValue('responsable_ejecucion').Value;

    QPlan.Params.ParamByName('responsable_seguimiento').Value :=
      PlanMejoramiento.GetValue('responsable_seguimiento').Value;

    QPlan.Params.ParamByName('indicador_meta').AsWideMemo :=
      PlanMejoramiento.GetValue('indicador_meta').Value;

    QPlan.Params.ParamByName('formula_indicador').AsWideMemo :=
      PlanMejoramiento.GetValue('formula_indicador').Value;

    QPlan.Params.ParamByName('resultado_indicador').AsWideMemo :=
      PlanMejoramiento.GetValue('resultado_indicador').Value;

    QPlan.Params.ParamByName('avance_meta').AsWideMemo :=
      PlanMejoramiento.GetValue('avance_meta').Value;

    QPlan.Params.ParamByName('seguimiento').AsWideMemo :=
      PlanMejoramiento.GetValue('seguimiento').Value;

    QPlan.Params.ParamByName('observaciones').AsWideMemo :=
      PlanMejoramiento.GetValue('observaciones').Value;

    QPlan.Params.ParamByName('estado_actual_accion').Value :=
      PlanMejoramiento.GetValue('estado_actual_accion').Value;

    QPlan.ExecSQL;

    JsonResp.AddPair('Respuesta', 'El plan se actualizo correctamente');
  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  QPlan.Free;
end;

{ Método INSERT - TrabajoGrado }
function TMatematicas.updateTrabajoGrado(const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  QTrabajoGrado: TFDQuery;
  objWebModule: TWebModule;
  token: string;
  sDat: TStringList;
begin
  try
    QTrabajoGrado := TFDQuery.create(nil);
    QTrabajoGrado.Connection := Conexion;
    Json := TJSONObject.create;

    { sDat := TStringList.create;
      sDat.Add(datos.toString);
      sDat.SaveToFile('C:\Users\julia\Desktop\datos.json');
      sDat.Free; }

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      QTrabajoGrado.Close;
      QTrabajoGrado.SQL.Clear;
      QTrabajoGrado.SQL.Add('INSERT INTO siap_trabajosgrado (');
      QTrabajoGrado.SQL.Add('idtrabajogrado, ');
      QTrabajoGrado.SQL.Add('titulo, ');
      QTrabajoGrado.SQL.Add('estudiante1, ');
      QTrabajoGrado.SQL.Add('estudiante2, ');
      QTrabajoGrado.SQL.Add('estudiante3, ');
      QTrabajoGrado.SQL.Add('estudiante1_tm, ');
      QTrabajoGrado.SQL.Add('estudiante2_tm, ');
      QTrabajoGrado.SQL.Add('estudiante3_tm, ');
      QTrabajoGrado.SQL.Add('idjurado1, ');
      QTrabajoGrado.SQL.Add('idjurado2, ');
      QTrabajoGrado.SQL.Add('idjurado3, ');
      QTrabajoGrado.SQL.Add('iddirector, ');
      QTrabajoGrado.SQL.Add('idcodirector, ');
      QTrabajoGrado.SQL.Add('idmodalidad, ');
      QTrabajoGrado.SQL.Add('idareaprofundizacion, ');
      QTrabajoGrado.SQL.Add('idgrupoinvestigacion, ');
      QTrabajoGrado.SQL.Add('actanombramientojurados, ');
      QTrabajoGrado.SQL.Add('actapropuesta, ');
      QTrabajoGrado.SQL.Add('evaluacionpropuesta, ');
      QTrabajoGrado.SQL.Add('evaluaciontrabajoescrito, ');
      QTrabajoGrado.SQL.Add('evaluacionsustentacion, ');
      QTrabajoGrado.SQL.Add('fechasustentacion, ');
      QTrabajoGrado.SQL.Add('calificacionfinal, ');
      QTrabajoGrado.SQL.Add('estudiantecedederechos, ');
      QTrabajoGrado.SQL.Add('fechainicioejecucion, ');
      QTrabajoGrado.SQL.Add('estadoproyecto ) VALUES (');
      QTrabajoGrado.SQL.Add(':idtrabajogrado, ');
      QTrabajoGrado.SQL.Add(':titulo, ');
      QTrabajoGrado.SQL.Add(':estudiante1, ');
      QTrabajoGrado.SQL.Add(':estudiante2, ');
      QTrabajoGrado.SQL.Add(':estudiante3, ');
      QTrabajoGrado.SQL.Add(':estudiante1_tm, ');
      QTrabajoGrado.SQL.Add(':estudiante2_tm, ');
      QTrabajoGrado.SQL.Add(':estudiante3_tm, ');
      QTrabajoGrado.SQL.Add(':idjurado1, ');
      QTrabajoGrado.SQL.Add(':idjurado2, ');
      QTrabajoGrado.SQL.Add(':idjurado3, ');
      QTrabajoGrado.SQL.Add(':iddirector, ');
      QTrabajoGrado.SQL.Add(':idcodirector, ');
      QTrabajoGrado.SQL.Add(':idmodalidad, ');
      QTrabajoGrado.SQL.Add(':idareaprofundizacion, ');
      QTrabajoGrado.SQL.Add(':idgrupoinvestigacion, ');
      QTrabajoGrado.SQL.Add(':actanombramientojurados, ');
      QTrabajoGrado.SQL.Add(':actapropuesta, ');
      QTrabajoGrado.SQL.Add(':evaluacionpropuesta, ');
      QTrabajoGrado.SQL.Add(':evaluaciontrabajoescrito, ');
      QTrabajoGrado.SQL.Add(':evaluacionsustentacion, ');
      QTrabajoGrado.SQL.Add(':fechasustentacion, ');
      QTrabajoGrado.SQL.Add(':calificacionfinal, ');
      QTrabajoGrado.SQL.Add(':estudiantecedederechos, ');
      QTrabajoGrado.SQL.Add(':fechainicioejecucion, ');
      QTrabajoGrado.SQL.Add(':estadoproyecto)');

      QTrabajoGrado.Params.ParamByName('idtrabajogrado').Value :=
        datos.GetValue('idtrabajogrado').Value;

      QTrabajoGrado.Params.ParamByName('titulo').Value :=
        datos.GetValue('titulo').Value;

      QTrabajoGrado.Params.ParamByName('estudiante1').Value :=
        datos.GetValue('estudiante1').Value;

      QTrabajoGrado.Params.ParamByName('estudiante2').Value :=
        datos.GetValue('estudiante2').Value;

      QTrabajoGrado.Params.ParamByName('estudiante3').Value :=
        datos.GetValue('estudiante3').Value;

      QTrabajoGrado.Params.ParamByName('estudiante1_tm').Value :=
        datos.GetValue('estudiante1_tm').Value;

      QTrabajoGrado.Params.ParamByName('estudiante2_tm').Value :=
        datos.GetValue('estudiante2_tm').Value;

      QTrabajoGrado.Params.ParamByName('estudiante3_tm').Value :=
        datos.GetValue('estudiante3_tm').Value;

      QTrabajoGrado.Params.ParamByName('idjurado1').Value :=
        StrToInt(datos.GetValue('idjurado1').Value);

      QTrabajoGrado.Params.ParamByName('idjurado2').Value :=
        StrToInt(datos.GetValue('idjurado2').Value);

      QTrabajoGrado.Params.ParamByName('idjurado3').Value :=
        StrToInt(datos.GetValue('idjurado3').Value);

      QTrabajoGrado.Params.ParamByName('iddirector').Value :=
        StrToInt(datos.GetValue('iddirector').Value);

      if datos.GetValue('idcodirector').Value <> '' then
        QTrabajoGrado.Params.ParamByName('idcodirector').Value :=
          StrToInt(datos.GetValue('idcodirector').Value);

      QTrabajoGrado.Params.ParamByName('idmodalidad').Value :=
        datos.GetValue('idmodalidad').Value;

      QTrabajoGrado.Params.ParamByName('idareaprofundizacion').Value :=
        datos.GetValue('idareaprofundizacion').Value;

      QTrabajoGrado.Params.ParamByName('idgrupoinvestigacion').Value :=
        datos.GetValue('idgrupoinvestigacion').Value;

      QTrabajoGrado.Params.ParamByName('actanombramientojurados').Value :=
        datos.GetValue('actanombramientojurados').Value;

      QTrabajoGrado.Params.ParamByName('actapropuesta').Value :=
        datos.GetValue('actapropuesta').Value;

      QTrabajoGrado.Params.ParamByName('evaluacionpropuesta').Value :=
        datos.GetValue('evaluacionpropuesta').Value;

      QTrabajoGrado.Params.ParamByName('evaluaciontrabajoescrito').Value :=
        datos.GetValue('evaluaciontrabajoescrito').Value;

      QTrabajoGrado.Params.ParamByName('evaluacionsustentacion').Value :=
        datos.GetValue('evaluacionsustentacion').Value;

      QTrabajoGrado.Params.ParamByName('fechasustentacion').Value :=
        datos.GetValue('fechasustentacion').Value;

      QTrabajoGrado.Params.ParamByName('calificacionfinal').Value :=
        datos.GetValue('calificacionfinal').Value;

      QTrabajoGrado.Params.ParamByName('estudiantecedederechos').Value :=
        datos.GetValue('estudiantecedederechos').Value;

      QTrabajoGrado.Params.ParamByName('fechainicioejecucion').Value :=
        datos.GetValue('fechainicioejecucion').Value;

      QTrabajoGrado.Params.ParamByName('estadoproyecto').Value :=
        datos.GetValue('estadoproyecto').Value;

      QTrabajoGrado.ExecSQL;

      Json.AddPair(JsonRespuesta, 'El trabajo de grado se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateTrabajoGrado',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateTrabajoGrado', Json.toString);
  QTrabajoGrado.Free;
end;

{ Método GET - TrabajoGrado }
function TMatematicas.TrabajoGrado(const ID: string): TJSONObject;
var
  Json, JsonTiempo: TJSONObject;
  Query: TFDQuery;
  i, meses, semestres, anos: integer;
  Idval: string;
  fecha1, fecha2, dias: TDate;
  sFecha1, sFecha2: string;
  fs: TFormatSettings;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE idtrabajogrado=' +
      #39 + ID + #39;
    Query.Open;

    { Fechas de Trabajo de Grado }
    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    sFecha1 := Query.FieldByName('fechainicioejecucion').AsString;
    sFecha2 := Query.FieldByName('fechasustentacion').AsString;

    if (sFecha1 <> '') and (sFecha2 <> '') then
    begin
      fecha1 := StrToDate(sFecha1, fs);
      fecha2 := StrToDate(sFecha2, fs);
      dias := fecha2 - fecha1;
      meses := round(dias) div 30;
      semestres := round(dias) div 180;
      anos := round(dias) div 365;
    end
    else
    begin
      dias := 0;
      meses := 0;
      semestres := 0;
      anos := 0;
    end;

    JsonTiempo := TJSONObject.create;
    JsonTiempo.AddPair('Dias', floatTostr(dias));
    JsonTiempo.AddPair('Meses', IntToStr(meses));
    JsonTiempo.AddPair('Semestres', IntToStr(semestres));
    JsonTiempo.AddPair('Anos', IntToStr(anos));

    Json.AddPair('cantidadsemestresejecucion', JsonTiempo);

    Json.AddPair('idtrabajogrado', Query.FieldByName('idtrabajogrado')
      .AsString);

    Json.AddPair('titulo', Query.FieldByName('titulo').AsString);

    Json.AddPair('estudiante1', Query.FieldByName('estudiante1').AsString);
    Json.AddPair('estudiante2', Query.FieldByName('estudiante2').AsString);
    Json.AddPair('estudiante3', Query.FieldByName('estudiante3').AsString);

    Json.AddPair('estudiante1_tm', Query.FieldByName('estudiante1_tm')
      .AsString);
    Json.AddPair('estudiante2_tm', Query.FieldByName('estudiante2_tm')
      .AsString);
    Json.AddPair('estudiante3_tm', Query.FieldByName('estudiante3_tm')
      .AsString);

    Idval := Query.FieldByName('idjurado1').AsString;
    Json.AddPair('idjurado1', Idval);
    Json.AddPair('jurado1', Docente(Idval));

    Idval := Query.FieldByName('idjurado2').AsString;
    Json.AddPair('idjurado2', Idval);
    Json.AddPair('jurado2', Docente(Idval));

    Idval := Query.FieldByName('idjurado3').AsString;
    Json.AddPair('idjurado3', Idval);
    Json.AddPair('jurado3', Docente(Idval));

    Idval := Query.FieldByName('iddirector').AsString;
    Json.AddPair('iddirector', Idval);
    Json.AddPair('director', Docente(Idval));

    Idval := Query.FieldByName('idcodirector').AsString;
    Json.AddPair('idcodirector', Idval);
    Json.AddPair('codirector', Docente(Idval));

    Idval := Query.FieldByName('idmodalidad').AsString;
    Json.AddPair('idmodalidad', Idval);
    Json.AddPair('modalidad', Modalidad(Idval));

    Idval := Query.FieldByName('idareaprofundizacion').AsString;
    Json.AddPair('idareaprofundizacion', Idval);

    Json.AddPair('areaProfundizacion', AreaProfundizacion(Idval));

    Idval := Query.FieldByName('idgrupoinvestigacion').AsString;
    Json.AddPair('idgrupoinvestigacion', Idval);

    Json.AddPair('grupoInvestigacion', GrupoInvestigacion(Idval));

    Json.AddPair('actanombramientojurados',
      Query.FieldByName('actanombramientojurados').AsString);

    Json.AddPair('actapropuesta', Query.FieldByName('actanombramientojurados')
      .AsString);

    Json.AddPair('evaluacionpropuesta', Query.FieldByName('evaluacionpropuesta')
      .AsString);

    Json.AddPair('evaluaciontrabajoescrito',
      Query.FieldByName('evaluaciontrabajoescrito').AsString);

    Json.AddPair('evaluacionsustentacion',
      Query.FieldByName('evaluacionsustentacion').AsString);

    Json.AddPair('fechainicioejecucion', sFecha1);
    Json.AddPair('fechasustentacion', sFecha2);

    Json.AddPair('calificacionfinal', Query.FieldByName('calificacionfinal')
      .AsString);

    Json.AddPair('estudiantecedederechos',
      Query.FieldByName('estudiantecedederechos').AsString);

    Json.AddPair('estadoproyecto', Query.FieldByName('estadoproyecto')
      .AsString);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getTrabajoGrado',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('TrabajoGrado', Json.toString);
  Query.Free;
end;

function TMatematicas.TrabajosGradoAreaProfundizacion: TJSONObject;
var
  QTrabajos, QAreas: TFDQuery;
  JsonResponse, JsonEst: TJSONObject;
  Estadisticas: TJSONArray;
  i, cont: integer;
  AreasProfundizacion: TStringList;
  area: string;
  j, total: integer;
  Etiquetas, datos: TJSONArray;
  percent: string;
  fs: TFormatSettings;
begin
  try
    JsonResponse := TJSONObject.create;

    QTrabajos := TFDQuery.create(nil);
    QTrabajos.Connection := Conexion;
    QAreas := TFDQuery.create(nil);
    QAreas.Connection := Conexion;

    Estadisticas := TJSONArray.create;
    Etiquetas := TJSONArray.create;
    datos := TJSONArray.create;

    AreasProfundizacion := TStringList.create;

    QAreas.Close;
    QAreas.SQL.Text := 'SELECT * FROM siap_areasprofundizacion ORDER BY nombre';
    QAreas.Open;
    QAreas.First;

    fs := TFormatSettings.create;
    fs.DecimalSeparator := '.';

    QTrabajos.Close;
    QTrabajos.SQL.Text := 'SELECT * FROM siap_trabajosgrado';
    QTrabajos.Open;
    total := QTrabajos.RecordCount;

    for i := 1 to QAreas.RecordCount do
    begin
      area := QAreas.FieldByName('idareaprofundizacion').AsString;

      QTrabajos.Close;
      QTrabajos.SQL.Text :=
        'SELECT * FROM siap_trabajosgrado WHERE idareaprofundizacion=' + #39 +
        area + #39;
      QTrabajos.Open;

      JsonEst := TJSONObject.create;
      JsonEst.AddPair('Label', QAreas.FieldByName('nombre').AsString);
      JsonEst.AddPair('Count', IntToStr(QTrabajos.RecordCount));

      percent := FloatToStrF(100 * (QTrabajos.RecordCount / total), ffNumber,
        3, 2, fs);
      JsonEst.AddPair('Percent', percent);

      Etiquetas.Add(QAreas.FieldByName('nombre').AsString);
      datos.Add(QTrabajos.RecordCount);

      Estadisticas.AddElement(JsonEst);

      QAreas.Next;
    end;

    JsonResponse.AddPair('Statistics', Estadisticas);
    JsonResponse.AddPair('Labels', Etiquetas);

    JsonEst := TJSONObject.create;
    JsonEst.AddPair('data', datos);
    JsonEst.AddPair('label', 'Trabajos de Grado por Área de Profundización');
    JsonResponse.AddPair('Data', JsonEst);
    JsonResponse.AddPair('Ordenar', 'Si');
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
  QTrabajos.Free;
  QAreas.Free;
end;

function TMatematicas.TrabajosGradoByEstado: TJSONObject;
var
  QTrabajos: TFDQuery;
  JsonResponse, JsonEst: TJSONObject;
  Estadisticas: TJSONArray;
  Etiquetas, datos: TJSONArray;
  i, total, cont: integer;
  estados: TStringList;
  estado: string;
  j: integer;
  percent: string;
  fs: TFormatSettings;
begin
  try
    JsonResponse := TJSONObject.create;

    QTrabajos := TFDQuery.create(nil);
    QTrabajos.Connection := Conexion;

    Estadisticas := TJSONArray.create;
    Etiquetas := TJSONArray.create;
    datos := TJSONArray.create;

    estados := TStringList.create;
    estados.Add('proceso');
    estados.Add('terminado');

    cont := 0;
    fs := TFormatSettings.create;
    fs.DecimalSeparator := '.';

    QTrabajos.Close;
    QTrabajos.SQL.Text := 'SELECT * FROM siap_trabajosgrado';
    QTrabajos.Open;
    total := QTrabajos.RecordCount;

    for j := 1 to estados.Count do
    begin
      estado := estados[j - 1];
      QTrabajos.Close;
      QTrabajos.SQL.Text :=
        'SELECT * FROM siap_trabajosgrado WHERE estadoproyecto=' + #39 +
        estado + #39;
      QTrabajos.Open;

      JsonEst := TJSONObject.create;
      JsonEst.AddPair('Label', estado);
      JsonEst.AddPair('Count', IntToStr(QTrabajos.RecordCount));

      percent := FloatToStrF(100 * (QTrabajos.RecordCount / total), ffNumber,
        3, 2, fs);
      JsonEst.AddPair('Percent', percent);

      Etiquetas.Add(estado);
      datos.Add(QTrabajos.RecordCount);

      Estadisticas.AddElement(JsonEst);
    end;

    JsonResponse.AddPair('Statistics', Estadisticas);
    JsonResponse.AddPair('Labels', Etiquetas);

    JsonEst := TJSONObject.create;
    JsonEst.AddPair('data', datos);
    JsonEst.AddPair('label', 'Trabajos de Grado por Estado');
    JsonResponse.AddPair('Data', JsonEst);
    JsonResponse.AddPair('Ordenar', 'Si');
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
  QTrabajos.Free;
end;

function TMatematicas.TrabajosGradoByGrupoInvestigacion: TJSONObject;
var
  QTrabajos, QGrupos: TFDQuery;
  JsonResponse, JsonEst: TJSONObject;
  Estadisticas: TJSONArray;
  Etiquetas, datos: TJSONArray;
  i, cont: integer;
  IdGrupo, NombreGrupo: string;
  j, total: integer;
  percent: string;
  fs: TFormatSettings;
  fecha: TDate;
begin
  try
    JsonResponse := TJSONObject.create;

    QTrabajos := TFDQuery.create(nil);
    QTrabajos.Connection := Conexion;
    QGrupos := TFDQuery.create(nil);
    QGrupos.Connection := Conexion;

    Estadisticas := TJSONArray.create;
    Etiquetas := TJSONArray.create;
    datos := TJSONArray.create;

    QGrupos.Close;
    QGrupos.SQL.Text :=
      'SELECT * FROM siap_gruposinvestigacion ORDER BY nombre';
    QGrupos.Open;
    QGrupos.First;

    fs := TFormatSettings.create;
    fs.DecimalSeparator := '.';

    QTrabajos.Close;
    QTrabajos.SQL.Text := 'SELECT * FROM siap_trabajosgrado';
    QTrabajos.Open;
    total := QTrabajos.RecordCount;

    for i := 1 to QGrupos.RecordCount do
    begin
      IdGrupo := QGrupos.FieldByName('idgrupoinvestigacion').AsString;
      NombreGrupo := QGrupos.FieldByName('sigla').AsString;

      QTrabajos.Close;
      QTrabajos.SQL.Text :=
        'SELECT * FROM siap_trabajosgrado WHERE idgrupoinvestigacion=' + #39 +
        IdGrupo + #39 + ' ORDER BY fechainicioejecucion';
      QTrabajos.Open;

      if QTrabajos.RecordCount > 0 then
      begin
        JsonEst := TJSONObject.create;
        JsonEst.AddPair('Label', NombreGrupo);
        JsonEst.AddPair('Count', IntToStr(QTrabajos.RecordCount));

        percent := FloatToStrF(100 * (QTrabajos.RecordCount / total), ffNumber,
          3, 2, fs);
        JsonEst.AddPair('Percent', percent);

        Etiquetas.Add(NombreGrupo);
        datos.Add(QTrabajos.RecordCount);

        Estadisticas.AddElement(JsonEst);
      end;

      QGrupos.Next;
    end;

    // Ordenar de menor a mayor

    JsonResponse.AddPair('Statistics', Estadisticas);
    JsonResponse.AddPair('Labels', Etiquetas);

    JsonEst := TJSONObject.create;
    JsonEst.AddPair('data', datos);
    JsonEst.AddPair('label', 'Trabajos de Grado por Grupo de Investigación');
    JsonResponse.AddPair('Data', JsonEst);
    JsonResponse.AddPair('Ordenar', 'Si');
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
  QTrabajos.Free;
  QGrupos.Free;
end;

function TMatematicas.TrabajosGradoByModalidad: TJSONObject;
var
  QTrabajos, QModalidades: TFDQuery;
  JsonResponse, JsonEst: TJSONObject;
  Estadisticas: TJSONArray;
  Etiquetas, datos: TJSONArray;
  i, total, cont: integer;
  IdModalidad, Modalidad: string;
  j: integer;
  percent: string;
  fs: TFormatSettings;
begin
  try
    JsonResponse := TJSONObject.create;

    QTrabajos := TFDQuery.create(nil);
    QTrabajos.Connection := Conexion;
    QModalidades := TFDQuery.create(nil);
    QModalidades.Connection := Conexion;

    Estadisticas := TJSONArray.create;
    Etiquetas := TJSONArray.create;
    datos := TJSONArray.create;

    QModalidades.Close;
    QModalidades.SQL.Text := 'SELECT * FROM siap_modalidades ORDER BY nombre';
    QModalidades.Open;
    QModalidades.First;

    fs := TFormatSettings.create;
    fs.DecimalSeparator := '.';

    QTrabajos.Close;
    QTrabajos.SQL.Text := 'SELECT * FROM siap_trabajosgrado';
    QTrabajos.Open;
    total := QTrabajos.RecordCount;

    for i := 1 to QModalidades.RecordCount do
    begin
      IdModalidad := QModalidades.FieldByName('idmodalidad').AsString;
      Modalidad := QModalidades.FieldByName('nombre').AsString;

      QTrabajos.Close;
      QTrabajos.SQL.Text :=
        'SELECT * FROM siap_trabajosgrado WHERE idmodalidad=' + #39 +
        IdModalidad + #39;
      QTrabajos.Open;

      if QTrabajos.RecordCount > 0 then
      begin
        JsonEst := TJSONObject.create;
        JsonEst.AddPair('Label', Modalidad);
        JsonEst.AddPair('Count', IntToStr(QTrabajos.RecordCount));

        percent := FloatToStrF(100 * (QTrabajos.RecordCount / total), ffNumber,
          3, 2, fs);
        JsonEst.AddPair('Percent', percent);

        Etiquetas.Add(Modalidad);
        datos.Add(QTrabajos.RecordCount);

        Estadisticas.AddElement(JsonEst);
      end;

      QModalidades.Next;
    end;

    JsonResponse.AddPair('Statistics', Estadisticas);
    JsonResponse.AddPair('Labels', Etiquetas);

    JsonEst := TJSONObject.create;
    JsonEst.AddPair('data', datos);
    JsonEst.AddPair('label', 'Trabajos de Grado por Modalidad');
    JsonResponse.AddPair('Data', JsonEst);
    JsonResponse.AddPair('Ordenar', 'Si');
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
  QTrabajos.Free;
  QModalidades.Free;
end;

function TMatematicas.TrabajosGradoByTiempoEjecucion: TJSONObject;
var
  QTrabajos: TFDQuery;
  JsonResponse, JsonEst: TJSONObject;
  Estadisticas: TJSONArray;
  Etiquetas, datos: TJSONArray;
  i, cantidad, cont, cant: integer;
  j: integer;
  fs: TFormatSettings;
  sFecha1, sFecha2, etiqueta: string;
  fecha1, fecha2: TDate;
  dias, meses: integer;
  estadoProyecto: string;
  cantidadMeses: TStringList;
  mesMax, mesMin: integer;
  percent: string;
  fs2: TFormatSettings;
begin
  try
    JsonResponse := TJSONObject.create;

    QTrabajos := TFDQuery.create(nil);
    QTrabajos.Connection := Conexion;

    Estadisticas := TJSONArray.create;
    Etiquetas := TJSONArray.create;
    datos := TJSONArray.create;

    QTrabajos.Close;
    QTrabajos.SQL.Text := 'SELECT * FROM siap_trabajosgrado';
    QTrabajos.Open;
    QTrabajos.First;

    cantidadMeses := TStringList.create;

    fs2 := TFormatSettings.create;
    fs2.DecimalSeparator := '.';

    for i := 1 to QTrabajos.RecordCount do
    begin
      { Fechas de Trabajo de Grado }
      fs := TFormatSettings.create;
      fs.DateSeparator := '-';
      fs.ShortDateFormat := 'yyyy-mm-dd';

      estadoProyecto := QTrabajos.FieldByName('estadoproyecto').AsString;

      sFecha1 := QTrabajos.FieldByName('fechainicioejecucion').AsString;
      sFecha2 := QTrabajos.FieldByName('fechasustentacion').AsString;

      if (sFecha1 <> '') and (sFecha2 <> '') and (estadoProyecto = 'terminado')
      then
      begin
        fecha1 := StrToDate(sFecha1, fs);
        fecha2 := StrToDate(sFecha2, fs);
        dias := round(fecha2 - fecha1);
        meses := round(dias) div 30;

        cantidadMeses.Add(IntToStr(meses));
      end;

      QTrabajos.Next;
    end;

    mesMax := 0;
    mesMin := 100;

    // Obtener el mínimo y el máximo
    for i := 1 to cantidadMeses.Count do
    begin
      cant := StrToInt(cantidadMeses[i - 1]);
      if cant > mesMax then
        mesMax := cant;
      if cant < mesMin then
        mesMin := cant;
    end;

    cant := mesMin;
    while cant < mesMax do
    begin
      cont := 0;
      for i := 1 to cantidadMeses.Count do
      begin
        cantidad := StrToInt(cantidadMeses[i - 1]);
        if (cantidad >= cant) and (cantidad < (cant + 6)) then
          Inc(cont);
      end;

      if cont > 0 then
      begin
        JsonEst := TJSONObject.create;
        etiqueta := 'Entre ' + IntToStr(cant) + '-' + IntToStr(cant + 6)
          + ' meses';
        JsonEst.AddPair('Label', etiqueta);
        JsonEst.AddPair('Count', IntToStr(cont));

        percent := FloatToStrF(100 * (cont / QTrabajos.RecordCount), ffNumber,
          3, 2, fs2);
        JsonEst.AddPair('Percent', percent);

        Etiquetas.Add(etiqueta);
        datos.Add(cont);

        Estadisticas.AddElement(JsonEst);
      end;
      cant := cant + 6;
    end;

    Estadisticas.Add(mesMin);
    Estadisticas.Add(mesMax);

    JsonResponse.AddPair('Statistics', Estadisticas);
    JsonResponse.AddPair('Labels', Etiquetas);

    JsonEst := TJSONObject.create;
    JsonEst.AddPair('data', datos);
    JsonEst.AddPair('label', 'Trabajos de Grado por Tiempo de Ejecución');
    JsonResponse.AddPair('Data', JsonEst);
    JsonResponse.AddPair('Ordenar', 'No');
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
  QTrabajos.Free;
end;

function TMatematicas.TrabajosGradoCalificacionFinal: TJSONObject;
var
  QTrabajos: TFDQuery;
  JsonResponse, JsonEst: TJSONObject;
  Estadisticas: TJSONArray;
  i, cont: integer;
  calificaciones: TStringList;
  calificacion: string;
  j, total: integer;
  Etiquetas, datos: TJSONArray;
  percent: string;
  fs: TFormatSettings;
begin
  try
    JsonResponse := TJSONObject.create;

    QTrabajos := TFDQuery.create(nil);
    QTrabajos.Connection := Conexion;

    Estadisticas := TJSONArray.create;
    Etiquetas := TJSONArray.create;
    datos := TJSONArray.create;

    calificaciones := TStringList.create;
    calificaciones.Add('aprobado');
    calificaciones.Add('aprobado meritorio');
    calificaciones.Add('aprobado laureado');

    cont := 0;
    fs := TFormatSettings.create;
    fs.DecimalSeparator := '.';

    QTrabajos.Close;
    QTrabajos.SQL.Text := 'SELECT * FROM siap_trabajosgrado';
    QTrabajos.Open;
    total := QTrabajos.RecordCount;

    for j := 1 to calificaciones.Count do
    begin
      calificacion := calificaciones[j - 1];
      QTrabajos.Close;
      QTrabajos.SQL.Text :=
        'SELECT * FROM siap_trabajosgrado WHERE calificacionfinal=' + #39 +
        calificacion + #39;
      QTrabajos.Open;

      JsonEst := TJSONObject.create;
      JsonEst.AddPair('Label', calificacion);
      JsonEst.AddPair('Count', IntToStr(QTrabajos.RecordCount));

      percent := FloatToStrF(100 * (QTrabajos.RecordCount / total), ffNumber,
        3, 2, fs);
      JsonEst.AddPair('Percent', percent);

      Etiquetas.Add(calificacion);
      datos.Add(QTrabajos.RecordCount);

      Estadisticas.AddElement(JsonEst);
    end;

    JsonResponse.AddPair('Statistics', Estadisticas);
    JsonResponse.AddPair('Labels', Etiquetas);

    JsonEst := TJSONObject.create;
    JsonEst.AddPair('data', datos);
    JsonEst.AddPair('label',
      'Trabajos de Grado clasificados por Calificación Final');
    JsonResponse.AddPair('Data', JsonEst);
    JsonResponse.AddPair('Ordenar', 'Si');
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
  QTrabajos.Free;
end;

function TMatematicas.TrabajosGradoFinPorAnio: TJSONObject;
var
  QTrabajos: TFDQuery;
  JsonResponse, JsonEst: TJSONObject;
  Estadisticas: TJSONArray;
  i, cont: integer;
  anio, anioTemp: word;
  Etiquetas, datos: TJSONArray;
  percent: string;
  fs: TFormatSettings;
begin
  try
    JsonResponse := TJSONObject.create;

    QTrabajos := TFDQuery.create(nil);
    QTrabajos.Connection := Conexion;

    QTrabajos.Close;
    QTrabajos.SQL.Text :=
      'SELECT * FROM siap_trabajosgrado ORDER BY fechasustentacion';
    QTrabajos.Open;
    QTrabajos.First;

    Estadisticas := TJSONArray.create;
    Etiquetas := TJSONArray.create;
    datos := TJSONArray.create;

    cont := 0;
    anio := 1900;
    fs := TFormatSettings.create;
    fs.DecimalSeparator := '.';

    // Fecha por defecto para empezar a contar los trabajos por año
    for i := 1 to QTrabajos.RecordCount do
    begin
      anioTemp := extractYearFromDate(QTrabajos.FieldByName('fechasustentacion')
        .AsString);
      if anio <> anioTemp then
      begin
        anio := anioTemp;
        if cont > 0 then
        begin
          JsonEst := TJSONObject.create;
          JsonEst.AddPair('Label', IntToStr(anio));
          JsonEst.AddPair('Count', IntToStr(cont));

          percent := FloatToStrF(100 * (cont / QTrabajos.RecordCount), ffNumber,
            3, 2, fs);
          JsonEst.AddPair('Percent', percent);

          Estadisticas.AddElement(JsonEst);
          Etiquetas.Add(IntToStr(anio));
          datos.Add(cont);
          cont := 0;
        end;
      end;

      Inc(cont);
      QTrabajos.Next;
    end;

    JsonResponse.AddPair('Statistics', Estadisticas);
    JsonResponse.AddPair('Labels', Etiquetas);

    JsonEst := TJSONObject.create;
    JsonEst.AddPair('data', datos);
    JsonEst.AddPair('label', 'Trabajos de Grado Sustentados por Año');
    JsonResponse.AddPair('Data', JsonEst);
    JsonResponse.AddPair('Ordenar', 'No');
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
  QTrabajos.Free;
end;

function TMatematicas.TrabajosGradoInicianPorAnio: TJSONObject;
var
  QTrabajos: TFDQuery;
  JsonResponse, JsonEst: TJSONObject;
  Estadisticas: TJSONArray;
  Etiquetas, datos: TJSONArray;
  i, cont: integer;
  percent: string;
  anio, anioTemp: word;
  fs: TFormatSettings;
begin
  try
    JsonResponse := TJSONObject.create;

    QTrabajos := TFDQuery.create(nil);
    QTrabajos.Connection := Conexion;

    QTrabajos.Close;
    QTrabajos.SQL.Text :=
      'SELECT * FROM siap_trabajosgrado ORDER BY fechainicioejecucion';
    QTrabajos.Open;
    QTrabajos.First;

    Estadisticas := TJSONArray.create;
    Etiquetas := TJSONArray.create;
    datos := TJSONArray.create;

    cont := 0;
    anio := 1900;

    fs := TFormatSettings.create;
    fs.DecimalSeparator := '.';

    // Fecha por defecto para empezar a contar los trabajos por año
    for i := 1 to QTrabajos.RecordCount do
    begin
      anioTemp := extractYearFromDate
        (QTrabajos.FieldByName('fechainicioejecucion').AsString);
      if anio <> anioTemp then
      begin
        anio := anioTemp;
        if cont > 0 then
        begin
          JsonEst := TJSONObject.create;
          JsonEst.AddPair('Label', IntToStr(anio));
          JsonEst.AddPair('Count', IntToStr(cont));

          percent := FloatToStrF(100 * (cont / QTrabajos.RecordCount), ffNumber,
            3, 2, fs);
          JsonEst.AddPair('Percent', percent);

          Etiquetas.Add(IntToStr(anio));
          datos.Add(cont);

          Estadisticas.AddElement(JsonEst);
          cont := 0;
        end;
      end;

      Inc(cont);
      QTrabajos.Next;
    end;

    JsonResponse.AddPair('Statistics', Estadisticas);
    JsonResponse.AddPair('Labels', Etiquetas);

    JsonEst := TJSONObject.create;
    JsonEst.AddPair('data', datos);
    JsonEst.AddPair('label', 'Trabajos de Grado que Iniciaron por Año');
    JsonResponse.AddPair('Data', JsonEst);
    JsonResponse.AddPair('Ordenar', 'No');
  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
  QTrabajos.Free;
end;

{ Método GET-ALL - TrabajoGrado }
function TMatematicas.updateTrabajosGrado(filtroBusqueda: TJSONObject)
  : TJSONObject;
var
  Json, JsonTiempo: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
  meses, semestres, anos, dias: real;
  fecha1, fecha2, fecha3, fecha4, diasEntre: TDate;
  ID, sFecha1, sFecha2, Resultados, todos: string;
  fs: TFormatSettings;
  desde, hasta, cantidad, total: integer;
  attrOrdenar: TJSONArray;
  titulo, Estudiante, fechaInicio, fechaFin: string;
  jsonDocente, paginacion: TJSONObject;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;

    titulo := filtroBusqueda.GetValue('titulo').Value;
    Estudiante := filtroBusqueda.GetValue('estudiante').Value;

    limpiarConsulta(Query);
    Query.Close;
    Query.SQL.Clear;

    Query.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE ';
    Query.SQL.Add('lower(Estudiante1) LIKE ' + cadenaToPostgres(Estudiante)
      + ' or ');
    Query.SQL.Add('lower(Estudiante2) LIKE ' + cadenaToPostgres(Estudiante)
      + ' or ');
    Query.SQL.Add('lower(Estudiante3) LIKE ' + cadenaToPostgres(Estudiante));
    Query.Open;
    Query.First;

    Json.AddPair('SQL', Query.SQL.Text);

    if todos = 'si' then
    begin
      desde := 1;
      hasta := total;
    end;

    total := Query.RecordCount;

    Resultados := 'Registros ' + IntToStr(desde) + '-' + IntToStr(hasta) +
      ' de ' + IntToStr(total);

    for i := 1 to total do
    begin
      JsonLinea := TJSONObject.create;
      JsonLinea.AddPair('idtrabajogrado', Query.FieldByName('idtrabajogrado')
        .AsString);
      JsonLinea.AddPair('titulo', Query.FieldByName('titulo').AsString);

      JsonLinea.AddPair('estudiante1', Query.FieldByName('estudiante1')
        .AsString);
      JsonLinea.AddPair('estudiante2', Query.FieldByName('estudiante2')
        .AsString);
      JsonLinea.AddPair('estudiante3', Query.FieldByName('estudiante3')
        .AsString);
      JsonLinea.AddPair('actanombramientojurados',
        Query.FieldByName('actanombramientojurados').AsString);
      JsonLinea.AddPair('actapropuesta', Query.FieldByName('actapropuesta')
        .AsString);
      JsonLinea.AddPair('evaluacionpropuesta',
        Query.FieldByName('evaluacionpropuesta').AsString);
      JsonLinea.AddPair('evaluaciontrabajoescrito',
        Query.FieldByName('evaluaciontrabajoescrito').AsString);
      JsonLinea.AddPair('fechasustentacion',
        Query.FieldByName('fechasustentacion').AsString);
      JsonLinea.AddPair('calificacionfinal',
        Query.FieldByName('calificacionfinal').AsString);
      JsonLinea.AddPair('fechainicioejecucion',
        Query.FieldByName('fechainicioejecucion').AsString);
      JsonLinea.AddPair('estadoproyecto', Query.FieldByName('estadoproyecto')
        .AsString);

      { Fechas de Trabajo de Grado }
      { fs := TFormatSettings.create;
        fs.DateSeparator := '-';
        fs.ShortDateFormat := 'yyyy-mm-dd';

        sFecha1 := Query.FieldByName('fechainicioejecucion').AsString;
        sFecha2 := Query.FieldByName('fechasustentacion').AsString;

        try
        fecha1 := StrToDate(sFecha1, fs);
        fecha2 := StrToDate(sFecha2, fs);
        fecha3 := StrToDate(fechaInicio, fs);
        fecha4 := StrToDate(fechaFin, fs);
        diasEntre := fecha2 - fecha1;
        dias := round(diasEntre);
        meses := round(dias) / 30;
        semestres := round(dias) / 180;
        anos := round(dias) / 365;
        except
        dias := 0;
        meses := 0;
        semestres := 0;
        anos := 0;
        end;

        JsonTiempo := TJSONObject.create;
        JsonTiempo.AddPair('Dias', floatTostr(dias));
        JsonTiempo.AddPair('Meses', FloatToStrF(meses, ffNumber, 3, 1));
        JsonTiempo.AddPair('Semestres', FloatToStrF(semestres, ffNumber, 3, 1));
        JsonTiempo.AddPair('Anos', FloatToStrF(anos, ffNumber, 3, 1));

        JsonLinea.AddPair('cantidadsemestresejecucion', JsonTiempo);

        ID := Query.FieldByName('idjurado1').AsString;
        JsonLinea.AddPair('idjurado1', ID);
        jsonDocente := Docente(ID);
        jsonDocente.RemovePair('foto');
        JsonLinea.AddPair('jurado1', jsonDocente);

        ID := Query.FieldByName('idjurado2').AsString;
        JsonLinea.AddPair('idjurado2', ID);
        jsonDocente := Docente(ID);
        jsonDocente.RemovePair('foto');
        JsonLinea.AddPair('jurado2', jsonDocente);

        ID := Query.FieldByName('idjurado3').AsString;
        JsonLinea.AddPair('idjurado3', ID);
        jsonDocente := Docente(ID);
        jsonDocente.RemovePair('foto');
        JsonLinea.AddPair('jurado3', jsonDocente);

        ID := Query.FieldByName('iddirector').AsString;
        JsonLinea.AddPair('iddirector', ID);
        jsonDocente := Docente(ID);
        jsonDocente.RemovePair('foto');
        JsonLinea.AddPair('director', jsonDocente);

        ID := Query.FieldByName('idcodirector').AsString;
        JsonLinea.AddPair('idcodirector', ID);
        jsonDocente := Docente(ID);
        jsonDocente.RemovePair('foto');
        JsonLinea.AddPair('codirector', jsonDocente);

        ID := Query.FieldByName('idmodalidad').AsString;
        JsonLinea.AddPair('idmodalidad', ID);
        JsonLinea.AddPair('modalidad', Modalidad(ID));

        ID := Query.FieldByName('idareaprofundizacion').AsString;
        JsonLinea.AddPair('idareaprofundizacion', ID);
        JsonLinea.AddPair('areaProfundizacion', AreaProfundizacion(ID));

        ID := Query.FieldByName('idgrupoinvestigacion').AsString;
        JsonLinea.AddPair('idgrupoinvestigacion', ID);
        JsonLinea.AddPair('grupoInvestigacion', GrupoInvestigacion(ID));

        JsonLinea.AddPair('actapropuesta',
        Query.FieldByName('actanombramientojurados').AsString);

        JsonLinea.AddPair('evaluacionpropuesta',
        Query.FieldByName('evaluacionpropuesta').AsString);

        JsonLinea.AddPair('evaluaciontrabajoescrito',
        Query.FieldByName('evaluaciontrabajoescrito').AsString);

        JsonLinea.AddPair('evaluacionsustentacion',
        Query.FieldByName('evaluacionsustentacion').AsString);

        JsonLinea.AddPair('fechasustentacion',
        Query.FieldByName('fechasustentacion').AsString);

        JsonLinea.AddPair('calificacionfinal',
        Query.FieldByName('calificacionfinal').AsString);

        JsonLinea.AddPair('estudiantecedederechos',
        Query.FieldByName('estudiantecedederechos').AsString);

        JsonLinea.AddPair('fechainicioejecucion',
        Query.FieldByName('fechainicioejecucion').AsString);

        JsonLinea.AddPair('estadoproyecto', Query.FieldByName('estadoproyecto')
        .AsString); }

      ArrayJson.AddElement(JsonLinea);
      Query.Next;
    end;

    paginacion.Free;
    paginacion := TJSONObject.create;
    paginacion.AddPair('total', IntToStr(total));
    paginacion.AddPair('desde', IntToStr(desde));
    paginacion.AddPair('cantidad', IntToStr(cantidad));
    paginacion.AddPair('resultado', Resultados);
    paginacion.AddPair('todos', todos);
    paginacion.AddPair('contenido', ArrayJson);

    Json.AddPair('titulo', titulo);
    Json.AddPair('estudiante', Estudiante);
    Json.AddPair('paginacion', paginacion);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllTrabajoGrado',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('TrabajosGrado', Json.toString);
  Query.Free;
end;

{ Método DELETE - TrabajoGrado }
function TMatematicas.cancelTrabajoGrado(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_trabajosgrado', 'idtrabajogrado', Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'El trabajo de grado se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteTrabajoGrado',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelTrabajoGrado', Json.toString);
  Query.Free;
end;

{ Método UPDATE - TrabajoGrado }
function TMatematicas.acceptTrabajoGrado(const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
  objWebModule: TWebModule;
  token: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('titulo', 'String');
      agregarParametro('estudiante1', 'String');
      agregarParametro('estudiante2', 'String');
      agregarParametro('estudiante3', 'String');
      agregarParametro('estudiante1_tm', 'String');
      agregarParametro('estudiante2_tm', 'String');
      agregarParametro('estudiante3_tm', 'String');
      agregarParametro('idjurado1', 'Integer');
      agregarParametro('idjurado2', 'Integer');
      agregarParametro('idjurado3', 'Integer');
      agregarParametro('iddirector', 'Integer');
      agregarParametro('idcodirector', 'Integer');
      agregarParametro('idmodalidad', 'String');
      agregarParametro('idareaprofundizacion', 'String');
      agregarParametro('idgrupoinvestigacion', 'String');
      agregarParametro('actapropuesta', 'String');
      agregarParametro('fechasustentacion', 'String');
      agregarParametro('calificacionfinal', 'String');
      agregarParametro('actanombramientojurados', 'String');
      agregarParametro('evaluacionpropuesta', 'String');
      agregarParametro('evaluaciontrabajoescrito', 'String');
      agregarParametro('evaluacionsustentacion', 'String');
      agregarParametro('estudiantecedederechos', 'String');
      agregarParametro('fechainicioejecucion', 'String');
      agregarParametro('estadoproyecto', 'String');

      ID := datos.GetValue('idtrabajogrado').Value;
      UPDATE('siap_trabajosgrado', 'idtrabajogrado', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'El trabajo de grado se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptTrabajoGrado',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateTrabajoGrado', Json.toString);
  Query.Free;
end;

{ Método INSERT - AreaProfundizacion }
function TMatematicas.updateAreaDocente(const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('INSERT INTO siap_areas_docente (idareadocente, iddocente,' +
      ' idareaprofundizacion) VALUES (:idareadocente, :iddocente,' +
      ' :idareaprofundizacion)');

    Query.Params.ParamByName('idareadocente').Value := moduloDatos.generarID;
    Query.Params.ParamByName('iddocente').Value :=
      StrToInt(datos.GetValue('iddocente').Value);
    Query.Params.ParamByName('idareaprofundizacion').Value :=
      datos.GetValue('idareaprofundizacion').Value;

    Query.ExecSQL;

    Json.AddPair(JSON_RESPONSE,
      'El área de profundización se creo correctamente');
    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
  except
    on E: Exception do
      Json.AddPair('Error', E.Message);
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.updateAreaProfundizacion(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idareaprofundizacion', 'String');
      agregarParametro('nombre', 'String');

      INSERT('siap_areasprofundizacion', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'El Área de Profundización se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateAreaProfundizacion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateAreaProfundizacion', Json.toString);
  Query.Free;
end;

{ Método GET - AreaProfundizacion }
function TMatematicas.AreaProfundizacion(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_areasprofundizacion', 'idareaprofundizacion',
      Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idareaprofundizacion', 'String');
    agregarParametro('nombre', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAreaProfundizacion',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('AreaProfundizacion', Json.toString);
  Query.Free;
end;

function TMatematicas.AreasDocente(const IdDocente: string): TJSONObject;
var
  Json, JsonArea: TJSONObject;
  AreasDocente: TJSONArray;
  Query: TFDQuery;
  i: integer;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_areas_docente as ad INNER JOIN' +
      ' siap_areasprofundizacion as ap ON ad.idareaprofundizacion = ' +
      'ap.idareaprofundizacion WHERE iddocente=' + IdDocente;
    Query.Open;

    AreasDocente := TJSONArray.create;

    if Query.RecordCount > 0 then
    begin
      for i := 1 to Query.RecordCount do
      begin
        JsonArea := TJSONObject.create;
        JsonArea.AddPair('idareadocente', Query.FieldByName('idareadocente')
          .AsString);
        JsonArea.AddPair('iddocente', Query.FieldByName('iddocente').AsString);
        JsonArea.AddPair('idareaprofundizacion',
          Query.FieldByName('idareaprofundizacion').AsString);
        JsonArea.AddPair('nombre', Query.FieldByName('nombre').AsString);

        AreasDocente.AddElement(JsonArea);
        Query.Next;
      end;

      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, IntToStr(AreasDocente.Count) +
        ' encontradas para el docente');
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE,
        'El docente no tiene áreas de profundización');
    end;

    Json.AddPair(JSON_RESULTS, AreasDocente);

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_RESPONSE, 'Error para obtener las áreas del docente');
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    end;
  end;

  Result := Json;
  Query.Free;
end;

{ Método GET-ALL - AreaProfundizacion }
function TMatematicas.AreasProfundizacion: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('AreasProfundizacion', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_areasprofundizacion', 'nombre', Query);

    limpiarParametros;
    agregarParametro('idareaprofundizacion', 'String');
    agregarParametro('nombre', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllAreaProfundizacion',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('AreasProfundizacion', Json.toString);
  Query.Free;
end;

{ Método DELETE - AreaProfundizacion }
function TMatematicas.cancelAreaDocente(const IdAreaDocente: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'DELETE FROM siap_areas_docente WHERE idareadocente=' +
      #39 + IdAreaDocente + #39;
    Query.ExecSQL;

    Json.AddPair(JSON_RESPONSE, 'El área se desvinculo correctamente');
    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_RESPONSE, 'Error para desvincular el área');
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.cancelAreaProfundizacion(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_areasprofundizacion', 'idareaprofundizacion',
        Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'El Área de Profundización se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteAreaProfundizacion',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelAreaProfundizacion', Json.toString);
  Query.Free;
end;

{ Método UPDATE - AreaProfundizacion }
function TMatematicas.acceptAreaProfundizacion(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idareaprofundizacion', 'String');
      agregarParametro('nombre', 'String');

      ID := datos.GetValue('idareaprofundizacion').Value;
      UPDATE('siap_areasprofundizacion', 'idareaprofundizacion',
        Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'El Área de Profundización se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptAreaProfundizacion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateAreaProfundizacion', Json.toString);
  Query.Free;
end;

{ Método INSERT - Modalidad }
function TMatematicas.updateModalidad(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idmodalidad', 'String');
      agregarParametro('nombre', 'String');

      INSERT('siap_modalidades', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Modalidad se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateModalidad',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateModalidad', Json.toString);
  Query.Free;
end;

{ Método GET - Modalidad }
function TMatematicas.Modalidad(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_modalidades', 'idmodalidad', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idmodalidad', 'String');
    agregarParametro('nombre', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getModalidad',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Modalidad', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Modalidad }
function TMatematicas.Modalidades: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Modalidades', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_modalidades', 'nombre', Query);

    limpiarParametros;
    agregarParametro('idmodalidad', 'String');
    agregarParametro('nombre', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllModalidad',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Modalidades', Json.toString);
  Query.Free;
end;

{ Método DELETE - Modalidad }
function TMatematicas.cancelModalidad(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_modalidades', 'idmodalidad', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'La Modalidad se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteModalidad',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelModalidad', Json.toString);
  Query.Free;
end;

{ Método UPDATE - Modalidad }
function TMatematicas.acceptModalidad(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idmodalidad', 'String');
      agregarParametro('nombre', 'String');

      ID := datos.GetValue('idmodalidad').Value;
      UPDATE('siap_modalidades', 'idmodalidad', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Modalidad se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptModalidad',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateModalidad', Json.toString);
  Query.Free;
end;

{ Método INSERT - GrupoInvestigacion }
function TMatematicas.updateGrupoInvDocente(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  QGrupoDoc: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QGrupoDoc := TFDQuery.create(nil);
    QGrupoDoc.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QGrupoDoc.Close;
      QGrupoDoc.SQL.Text := 'INSERT INTO siap_grupos_docente (idgrupodocente,' +
        'iddocente,idgrupoinvestigacion,fechaingreso) VALUES (' +
        ':idgrupodocente,:iddocente,:idgrupoinvestigacion,:fechaingreso)';

      QGrupoDoc.Params.ParamByName('idgrupodocente').Value :=
        moduloDatos.generarID;
      QGrupoDoc.Params.ParamByName('iddocente').Value :=
        StrToInt(datos.GetValue('iddocente').Value);
      QGrupoDoc.Params.ParamByName('idgrupoinvestigacion').Value :=
        datos.GetValue('idgrupoinvestigacion').Value;
      QGrupoDoc.Params.ParamByName('fechaingreso').Value :=
        datos.GetValue('fechaingreso').Value;

      QGrupoDoc.ExecSQL;

      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE,
        'El docente se asigno correctamente al grupo');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_RESPONSE, E.Message);
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO)
    end;
  end;

  Result := Json;
  QGrupoDoc.Free;
end;

function TMatematicas.updateGrupoInvestigacion(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idgrupoinvestigacion', 'String');
      agregarParametro('nombre', 'String');
      agregarParametro('sigla', 'String');
      agregarParametro('iddirector', 'Integer');
      agregarParametro('mision', 'String');
      agregarParametro('vision', 'String');
      agregarParametro('logo', 'Base64');

      INSERT('siap_gruposinvestigacion', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'El grupo de investigación se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateGrupoInvestigacion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateGrupoInvestigacion', Json.toString);
  Query.Free;
end;

function TMatematicas.updateEstudiante(Estudiante: TJSONObject): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.postEstudiante(Estudiante)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.updateEstudianteCarta(datos: TJSONObject): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.postEstudianteCarta(datos)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.updateEstudiantePeriodo(Estudiante: TJSONObject)
  : TJSONObject;
begin
  Result := moduloPracticaDocente.putEstudiantePeriodo(Estudiante);
end;

{ Método GET - GrupoInvestigacion }
function TMatematicas.GrupoInvDocente(IdDocente: string): TJSONObject;
var
  Json, JsonGrupo: TJSONObject;
  QGrupoDoc: TFDQuery;
  objWebModule: TWebModule;
  Grupos: TJSONArray;
  token: string;
  i: integer;
begin
  try
    QGrupoDoc := TFDQuery.create(nil);
    QGrupoDoc.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QGrupoDoc.Close;
      QGrupoDoc.SQL.Text :=
        'SELECT * FROM siap_grupos_docente as sgd INNER JOIN ' +
        ' siap_gruposinvestigacion as sg ON sgd.idgrupoinvestigacion=' +
        ' sg.idgrupoinvestigacion WHERE sgd.iddocente=' + IdDocente;
      QGrupoDoc.Open;
      QGrupoDoc.First;

      Grupos := TJSONArray.create;
      for i := 1 to QGrupoDoc.RecordCount do
      begin
        JsonGrupo := TJSONObject.create;
        JsonGrupo.AddPair('idgrupodocente',
          QGrupoDoc.FieldByName('idgrupodocente').AsString);

        JsonGrupo.AddPair('iddocente', QGrupoDoc.FieldByName('iddocente')
          .AsString);

        JsonGrupo.AddPair('idgrupoinvestigacion',
          QGrupoDoc.FieldByName('idgrupoinvestigacion').AsString);

        JsonGrupo.AddPair('fechaingreso', QGrupoDoc.FieldByName('fechaingreso')
          .AsString);

        JsonGrupo.AddPair('nombre', QGrupoDoc.FieldByName('nombre').AsString);

        JsonGrupo.AddPair('sigla', QGrupoDoc.FieldByName('sigla').AsString);

        JsonGrupo.AddPair('iddirector', QGrupoDoc.FieldByName('iddirector')
          .AsString);
        JsonGrupo.AddPair('mision', QGrupoDoc.FieldByName('mision').AsString);

        JsonGrupo.AddPair('vision', QGrupoDoc.FieldByName('vision').AsString);

        Grupos.AddElement(JsonGrupo);
        QGrupoDoc.Next;
      end;

      Json.AddPair('Grupos', Grupos);

    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'cancelGrupoInvDocente',
        E.Message + IdDocente);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelGrupoInvDocente', Json.toString);
  QGrupoDoc.Free;
end;

function TMatematicas.GrupoInvestigacion(const ID: string): TJSONObject;
var
  Json, JsonGrupo, JsonDirector: TJSONObject;
  Query: TFDQuery;
  Grupos: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
  IdDocente: string;
begin

  try
    Json := TJSONObject.create;
    Grupos := TJSONArray.create;

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_gruposinvestigacion WHERE' +
      ' idgrupoinvestigacion=' + #39 + ID + #39;
    Query.Open;

    IdDocente := Query.FieldByName('iddirector').AsString;
    JsonGrupo := TJSONObject.create;
    JsonGrupo.AddPair('idgrupoinvestigacion',
      Query.FieldByName('idgrupoinvestigacion').AsString);
    JsonGrupo.AddPair('nombre', Query.FieldByName('nombre').AsString);
    JsonGrupo.AddPair('sigla', Query.FieldByName('sigla').AsString);
    JsonGrupo.AddPair('iddirector', IdDocente);
    JsonGrupo.AddPair('mision', Query.FieldByName('mision').AsString);
    JsonGrupo.AddPair('vision', Query.FieldByName('vision').AsString);
    JsonGrupo.AddPair('logo', Query.FieldByName('logo').AsString);

    // Obtener al director
    JsonDirector := TJSONObject.create;
    JsonDirector := Docente(IdDocente);

    JsonGrupo.AddPair('director', JsonDirector);
    Grupos.AddElement(JsonGrupo);

    Json.AddPair(JSON_RESULTS, Grupos);
    Json.AddPair(JSON_RESPONSE, 'Grupos de Investigación');
    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_RESPONSE, E.Message);
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    end;
  end;

  Result := Json;
  Query.Free;
end;

{ Método GET-ALL - GrupoInvestigacion }
function TMatematicas.GruposInvestigacion: TJSONObject;
var
  Json, JsonGrupo, JsonDirector: TJSONObject;
  Query: TFDQuery;
  Grupos: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
  IdDocente: string;
begin

  try
    Json := TJSONObject.create;
    Grupos := TJSONArray.create;

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_gruposinvestigacion ORDER BY nombre';
    Query.Open;

    for i := 1 to Query.RecordCount do
    begin
      IdDocente := Query.FieldByName('iddirector').AsString;
      JsonGrupo := TJSONObject.create;
      JsonGrupo.AddPair('idgrupoinvestigacion',
        Query.FieldByName('idgrupoinvestigacion').AsString);
      JsonGrupo.AddPair('nombre', Query.FieldByName('nombre').AsString);
      JsonGrupo.AddPair('sigla', Query.FieldByName('sigla').AsString);
      JsonGrupo.AddPair('iddirector', IdDocente);
      JsonGrupo.AddPair('mision', Query.FieldByName('mision').AsString);
      JsonGrupo.AddPair('vision', Query.FieldByName('vision').AsString);
      JsonGrupo.AddPair('logo', Query.FieldByName('logo').AsString);

      // Obtener al director
      JsonDirector := TJSONObject.create;
      JsonDirector := Docente(IdDocente);

      JsonGrupo.AddPair('director', JsonDirector);

      Grupos.AddElement(JsonGrupo);
      Query.Next;
    end;

    Json.AddPair(JSON_RESULTS, Grupos);
    Json.AddPair(JSON_RESPONSE, 'Grupos de Investigación');
    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_RESPONSE, E.Message);
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    end;
  end;

  Result := Json;
  Query.Free;
end;

{ Método DELETE - GrupoInvestigacion }
function TMatematicas.cancelGrupoInvDocente(IdGrupoDocente: string)
  : TJSONObject;
var
  Json: TJSONObject;
  QGrupoDoc: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QGrupoDoc := TFDQuery.create(nil);
    QGrupoDoc.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QGrupoDoc.Close;
      QGrupoDoc.SQL.Text := 'DELETE FROM siap_grupos_docente ' +
        'WHERE idgrupodocente=' + #39 + IdGrupoDocente + #39;

      QGrupoDoc.ExecSQL;

      Json.AddPair('Respuesta',
        'El docente se elimino del grupo de investigación');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'cancelGrupoInvDocente',
        E.Message + IdGrupoDocente);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelGrupoInvDocente', Json.toString);
  QGrupoDoc.Free;
end;

function TMatematicas.cancelGrupoInvestigacion(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_gruposinvestigacion', 'idgrupoinvestigacion',
        Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'El grupo de investigación se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteGrupoInvestigacion',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelGrupoInvestigacion', Json.toString);
  Query.Free;
end;

{ Método UPDATE - GrupoInvestigacion }
function TMatematicas.acceptGrupoInvDocente(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  QGrupoDoc: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QGrupoDoc := TFDQuery.create(nil);
    QGrupoDoc.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QGrupoDoc.Close;
      QGrupoDoc.SQL.Text := 'UPDATE siap_grupos_docente SET ' +
        'fechaingreso=:fechaingreso WHERE idgrupodocente=' + #39 +
        datos.GetValue('idgrupodocente').Value + #39;

      QGrupoDoc.Params.ParamByName('fechaingreso').Value :=
        datos.GetValue('fechaingreso').Value;

      QGrupoDoc.ExecSQL;

      Json.AddPair('Respuesta', 'El registro se actualizo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateGrupoInvDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateGrupoInvDocente', Json.toString);
  QGrupoDoc.Free;
end;

function TMatematicas.acceptGrupoInvestigacion(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idgrupoinvestigacion', 'String');
      agregarParametro('nombre', 'String');
      agregarParametro('sigla', 'String');
      agregarParametro('iddirector', 'Integer');
      agregarParametro('mision', 'String');
      agregarParametro('vision', 'String');
      agregarParametro('logo', 'Base64');

      ID := datos.GetValue('idgrupoinvestigacion').Value;
      UPDATE('siap_gruposinvestigacion', 'idgrupoinvestigacion',
        Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'El grupo de investigación se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptGrupoInvestigacion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateGrupoInvestigacion', Json.toString);
  Query.Free;
end;

{ Método INSERT - Egresado }
function TMatematicas.updateEgresado(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idegresado', 'String');
      agregarParametro('nombre', 'String');
      agregarParametro('celular', 'String');
      agregarParametro('correo', 'String');
      agregarParametro('esegresado', 'String');
      agregarParametro('fecha', 'String');
      agregarParametro('gradoescolaridad', 'String');
      agregarParametro('secretaria', 'String');
      agregarParametro('institucion', 'String');
      agregarParametro('municipio', 'String');
      agregarParametro('cargo', 'String');
      agregarParametro('nivellabora', 'String');

      INSERT('siap_egresados', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Egresado se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateEgresado',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateEgresado', Json.toString);
  Query.Free;
end;

function TMatematicas.updateEnlaceDivulgacion(enlace: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'INSERT INTO siap_divulgacion_docente (iddivulgacion,' +
      ' nombre, direccion, iddocente) VALUES (:iddivulgacion, :nombre, ' +
      ':direccion, :iddocente)';

    Query.Params.ParamByName('iddivulgacion').Value := moduloDatos.generarID;
    Query.Params.ParamByName('nombre').Value := enlace.GetValue('nombre').Value;
    Query.Params.ParamByName('direccion').Value :=
      enlace.GetValue('direccion').Value;
    Query.Params.ParamByName('iddocente').Value :=
      StrToInt(enlace.GetValue('iddocente').Value);

    Query.ExecSQL;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESPONSE, 'Enlace creado correctamente');
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

{ Método GET - Egresado }
function TMatematicas.Egresado(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_egresados', 'idegresado', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idegresado', 'String');
    agregarParametro('nombre', 'String');
    agregarParametro('celular', 'String');
    agregarParametro('correo', 'String');
    agregarParametro('esegresado', 'String');
    agregarParametro('fecha', 'String');
    agregarParametro('gradoescolaridad', 'String');
    agregarParametro('secretaria', 'String');
    agregarParametro('institucion', 'String');
    agregarParametro('municipio', 'String');
    agregarParametro('cargo', 'String');
    agregarParametro('nivellabora', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getEgresado',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Egresado', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Egresado }
function TMatematicas.Egresados: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Egresados', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_egresados', 'nombre', Query);

    limpiarParametros;
    agregarParametro('idegresado', 'String');
    agregarParametro('nombre', 'String');
    agregarParametro('celular', 'String');
    agregarParametro('correo', 'String');
    agregarParametro('esegresado', 'String');
    agregarParametro('fecha', 'String');
    agregarParametro('gradoescolaridad', 'String');
    agregarParametro('secretaria', 'String');
    agregarParametro('institucion', 'String');
    agregarParametro('municipio', 'String');
    agregarParametro('cargo', 'String');
    agregarParametro('nivellabora', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllEgresado',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Egresados', Json.toString);
  Query.Free;
end;

{ Método DELETE - Egresado }
function TMatematicas.cancelEgresado(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_egresados', 'idegresado', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'El Egresado se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteEgresado',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelEgresado', Json.toString);
  Query.Free;
end;

function TMatematicas.cancelEnlaceDivulgacion(IdEnlace: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text :=
      'DELETE FROM siap_divulgacion_docente WHERE iddivulgacion=' + #39 +
      IdEnlace + #39;

    Query.ExecSQL;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESPONSE, 'Enlace eliminado correctamente');
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

{ Método UPDATE - Egresado }
function TMatematicas.acceptEgresado(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idegresado', 'String');
      agregarParametro('nombre', 'String');
      agregarParametro('celular', 'String');
      agregarParametro('correo', 'String');
      agregarParametro('esegresado', 'String');
      agregarParametro('fecha', 'String');
      agregarParametro('gradoescolaridad', 'String');
      agregarParametro('secretaria', 'String');
      agregarParametro('institucion', 'String');
      agregarParametro('municipio', 'String');
      agregarParametro('cargo', 'String');
      agregarParametro('nivellabora', 'String');

      ID := datos.GetValue('idegresado').Value;
      UPDATE('siap_egresados', 'idegresado', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Egresado se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptEgresado',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateEgresado', Json.toString);
  Query.Free;
end;

function TMatematicas.acceptEnlaceDivulgacion(enlace: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'UPDATE siap_divulgacion_docente SET ' +
      ' nombre=:nombre, direccion=:direccion WHERE iddivulgacion=' + #39 +
      enlace.GetValue('iddivulgacion').Value + #39;

    Query.Params.ParamByName('nombre').Value := enlace.GetValue('nombre').Value;
    Query.Params.ParamByName('direccion').Value :=
      enlace.GetValue('direccion').Value;

    Query.ExecSQL;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESPONSE, 'Enlace actualizado correctamente');
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

{ Método GET - ParticipanteEmem }
function TMatematicas.ParticipanteEmem(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('emem_participantes', 'idparticipante', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idparticipante', 'String');
    agregarParametro('primernombre', 'String');
    agregarParametro('segundonombre', 'String');
    agregarParametro('primerapellido', 'String');
    agregarParametro('segundoapellido', 'String');
    agregarParametro('correo', 'String');
    agregarParametro('contra', 'String');
    agregarParametro('idafiliacion', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getParticipanteEmem',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('ParticipanteEmem', Json.toString);
  Query.Free;
end;

function TMatematicas.participanteEvento(Documento, IdEvento: string)
  : TJSONObject;
begin
  Result := moduloEventoEMEM.getParticipanteEvento(Documento, IdEvento);
end;

{ Método GET-ALL - ParticipanteEmem }
function TMatematicas.ParticipantesEmem: TJSONObject;
var
  Json, JsonAfiliacion, JsonParticipante: TJSONObject;
  Query, QAfiliacion: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
  IdAfiliacion: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  QAfiliacion := TFDQuery.create(nil);
  QAfiliacion.Connection := Conexion;

  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('ParticipantesEmem', ArrayJson);

    limpiarConsulta(Query);
    SELECT('emem_participantes', 'primernombre', Query);

    limpiarParametros;
    agregarParametro('idparticipante', 'String');
    agregarParametro('primernombre', 'String');
    agregarParametro('segundonombre', 'String');
    agregarParametro('primerapellido', 'String');
    agregarParametro('segundoapellido', 'String');
    agregarParametro('correo', 'String');
    agregarParametro('contra', 'String');
    agregarParametro('idafiliacion', 'String');

    for i := 1 to Query.RecordCount do
    begin
      JsonParticipante := TJSONObject.create;
      JsonParticipante := crearJSON(Query);

      // Obtener la afiliación
      IdAfiliacion := Query.FieldByName('idafiliacion').AsString;
      QAfiliacion.Close;
      QAfiliacion.SQL.Text :=
        'SELECT * FROM emem_afiliaciones WHERE idafiliacion=' + #39 +
        IdAfiliacion + #39;
      QAfiliacion.Open;

      JsonAfiliacion := TJSONObject.create;
      JsonAfiliacion.AddPair('idafiliacion',
        QAfiliacion.FieldByName('idafiliacion').AsString);
      JsonAfiliacion.AddPair('afiliacion', QAfiliacion.FieldByName('afiliacion')
        .AsString);

      JsonParticipante.AddPair('afiliacion', JsonAfiliacion);

      ArrayJson.AddElement(JsonParticipante);
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllParticipanteEmem',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('ParticipantesEmem', Json.toString);
  Query.Free;
  QAfiliacion.Free;
end;

{ Método DELETE - ParticipanteEmem }
function TMatematicas.cancelParticipanteEmem(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('emem_participantes', 'idparticipante', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'El participante se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteParticipanteEmem',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelParticipanteEmem', Json.toString);
  Query.Free;
end;

{ Método UPDATE - ParticipanteEmem }
function TMatematicas.acceptParticipanteEmem(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idparticipante', 'String');
      agregarParametro('primernombre', 'String');
      agregarParametro('segundonombre', 'String');
      agregarParametro('primerapellido', 'String');
      agregarParametro('segundoapellido', 'String');
      agregarParametro('correo', 'String');
      agregarParametro('contra', 'String');
      agregarParametro('idafiliacion', 'String');

      ID := datos.GetValue('idparticipante').Value;
      UPDATE('emem_participantes', 'idparticipante', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El participante se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptParticipanteEmem',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateParticipanteEmem', Json.toString);
  Query.Free;
end;

{ Método INSERT - Afiliacion }
function TMatematicas.updateAfiliacion(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idafiliacion', 'String');
      agregarParametro('afiliacion', 'String');

      INSERT('emem_afiliaciones', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La afiliación se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateAfiliacion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateAfiliacion', Json.toString);
  Query.Free;
end;

{ Método GET - Afiliacion }
function TMatematicas.Afiliacion(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('emem_afiliaciones', 'idafiliacion', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idafiliacion', 'String');
    agregarParametro('afiliacion', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAfiliacion',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Afiliacion', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Afiliacion }
function TMatematicas.Afiliaciones: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Afiliaciones', ArrayJson);

    limpiarConsulta(Query);
    SELECT('emem_afiliaciones', 'afiliacion', Query);

    limpiarParametros;
    agregarParametro('idafiliacion', 'String');
    agregarParametro('afiliacion', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllAfiliacion',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Afiliaciones', Json.toString);
  Query.Free;
end;

{ Método DELETE - Afiliacion }
function TMatematicas.cancelAfiliacion(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('emem_afiliaciones', 'idafiliacion', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'La afiliación se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteAfiliacion',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelAfiliacion', Json.toString);
  Query.Free;
end;

{ Método UPDATE - Afiliacion }
function TMatematicas.acceptAfiliacion(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idafiliacion', 'String');
      agregarParametro('afiliacion', 'String');

      ID := datos.GetValue('idafiliacion').Value;
      UPDATE('emem_afiliaciones', 'idafiliacion', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La afiliación se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptAfiliacion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateAfiliacion', Json.toString);
  Query.Free;
end;

{ Método INSERT - SubactividadDocente }
function TMatematicas.updateSubactividadDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idsubactividaddocente', 'String');
      agregarParametro('subactividad', 'String');
      agregarParametro('idactividaddocente', 'String');

      INSERT('siap_subactividades_docentes', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'La Subactividad Docente se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateSubactividadDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateSubactividadDocente', Json.toString);
  Query.Free;
end;

{ Método GET - SubactividadDocente }
function TMatematicas.SubactividadDocente(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_subactividades_docentes', 'idsubactividaddocente',
      Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idsubactividaddocente', 'String');
    agregarParametro('subactividad', 'String');
    agregarParametro('idactividaddocente', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getSubactividadDocente',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('SubactividadDocente', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - SubactividadDocente }
function TMatematicas.SubactividadesDocente(const IdActividad: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('SubactividadesDocentes', ArrayJson);

    limpiarConsulta(Query);
    SelectWhereOrder('siap_subactividades_docentes', 'idactividaddocente',
      'subactividad', Texto(IdActividad), Query);

    limpiarParametros;
    agregarParametro('idsubactividaddocente', 'String');
    agregarParametro('subactividad', 'String');
    agregarParametro('idactividaddocente', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllSubactividadDocente',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('SubactividadesDocente', Json.toString);
  Query.Free;
end;

{ Método DELETE - SubactividadDocente }
function TMatematicas.cancelSubactividadDocente(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_subactividades_docentes', 'idsubactividaddocente',
        Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'La Subactividad Docente se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteSubactividadDocente',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelSubactividadDocente', Json.toString);
  Query.Free;
end;

{ Método UPDATE - SubactividadDocente }
function TMatematicas.acceptSubactividadDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idsubactividaddocente', 'String');
      agregarParametro('subactividad', 'String');
      agregarParametro('idactividaddocente', 'String');

      ID := datos.GetValue('idsubactividaddocente').Value;
      UPDATE('siap_subactividades_docentes', 'idsubactividaddocente',
        Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'La Subactividad Docente se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptSubactividadDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateSubactividadDocente', Json.toString);
  Query.Free;
end;

{ Método INSERT - ActividadDocente }
function TMatematicas.updateActividadDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idactividaddocente', 'String');
      agregarParametro('actividad', 'String');
      agregarParametro('idfunciondocente', 'String');

      INSERT('siap_actividades_docentes', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Actividad Docente se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateActividadDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateActividadDocente', Json.toString);
  Query.Free;
end;

{ Método GET - ActividadDocente }
function TMatematicas.ActividadDocente(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_actividades_docentes', 'idactividaddocente',
      Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idactividaddocente', 'String');
    agregarParametro('actividad', 'String');
    agregarParametro('idfunciondocente', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getActividadDocente',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('ActividadDocente', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - ActividadDocente }
function TMatematicas.ActividadesDocente(const IdFuncion: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('ActividadesDocentes', ArrayJson);

    limpiarConsulta(Query);
    SelectWhereOrder('siap_actividades_docentes', 'idfunciondocente',
      'actividad', Texto(IdFuncion), Query);

    limpiarParametros;
    agregarParametro('idactividaddocente', 'String');
    agregarParametro('actividad', 'String');
    agregarParametro('idfunciondocente', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllActividadDocente',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('ActividadesDocente', Json.toString);
  Query.Free;
end;

{ Método DELETE - ActividadDocente }
function TMatematicas.cadenaToPostgres(cadena: string): string;
var
  resp: string;
begin
  resp := AnsiLowerCase(cadena);
  resp := StringReplace(resp, 'á', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'é', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'í', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'ó', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'ú', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'ä', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'ë', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'ï', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'ö', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'ü', '_', [rfReplaceAll]);
  resp := StringReplace(resp, 'ñ', '_', [rfReplaceAll]);

  Result := chr(39) + '%' + resp + '%' + chr(39);
end;

function TMatematicas.cancelActividadDocente(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_actividades_docentes', 'idactividaddocente',
        Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'La Actividad Docente se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteActividadDocente',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelActividadDocente', Json.toString);
  Query.Free;
end;

{ Método UPDATE - ActividadDocente }
function TMatematicas.acceptActividadDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idactividaddocente', 'String');
      agregarParametro('actividad', 'String');
      agregarParametro('idfunciondocente', 'String');

      ID := datos.GetValue('idactividaddocente').Value;
      UPDATE('siap_actividades_docentes', 'idactividaddocente',
        Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'La Actividad Docente se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptActividadDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateActividadDocente', Json.toString);
  Query.Free;
end;

{ Método INSERT - FuncionDocente }
function TMatematicas.updateFuncionDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idfunciondocente', 'String');
      agregarParametro('funcion', 'String');

      INSERT('siap_funciones_docentes', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Función Docente se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateFuncionDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateFuncionDocente', Json.toString);
  Query.Free;
end;

{ Método GET - FuncionDocente }
function TMatematicas.Fuente(ID: string): TJSONObject;
var
  Query: TFDQuery;
  JsonResp: TJSONObject;
  aFuentes: TJSONArray;
  i: integer;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    JsonResp := TJSONObject.create;
    aFuentes := TJSONArray.create;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_fuente_pm WHERE idfuente=' + #39
      + ID + #39;
    Query.Open;

    JsonResp.AddPair('idfuente', Query.FieldByName('idfuente').AsString);
    JsonResp.AddPair('fuente', Query.FieldByName('fuente').AsString);

  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  Query.Free;
end;

function TMatematicas.Fuentes: TJSONObject;
var
  QFuentes: TFDQuery;
  JsonFuentes, JsonFuente: TJSONObject;
  aFuentes: TJSONArray;
  i: integer;
begin
  try
    QFuentes := TFDQuery.create(nil);
    QFuentes.Connection := Conexion;

    JsonFuentes := TJSONObject.create;
    aFuentes := TJSONArray.create;

    QFuentes.Close;
    QFuentes.SQL.Text := 'SELECT * FROM siap_fuente_pm ORDER BY fuente';
    QFuentes.Open;
    QFuentes.First;

    for i := 1 to QFuentes.RecordCount do
    begin
      JsonFuente := TJSONObject.create;
      JsonFuente.AddPair('idfuente', QFuentes.FieldByName('idfuente').AsString);
      JsonFuente.AddPair('fuente', QFuentes.FieldByName('fuente').AsString);

      aFuentes.AddElement(JsonFuente);
      QFuentes.Next;
    end;

    JsonFuentes.AddPair('Fuentes', aFuentes);
  except
    on E: Exception do
      JsonFuentes.AddPair('Error', E.Message);
  end;

  Result := JsonFuentes;
  QFuentes.Free;
end;

function TMatematicas.FuncionDocente(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_funciones_docentes', 'idfunciondocente',
      Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idfunciondocente', 'String');
    agregarParametro('funcion', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getFuncionDocente',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('FuncionDocente', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - FuncionDocente }
function TMatematicas.FuncionesDocente: TJSONObject;
var
  Json, JsonFuncion, JsonActividad, JsonSubactividad: TJSONObject;
  Query, Query2, Query3: TFDQuery;
  ArrayJson, ArrayActividades, ArraySubactividades: TJSONArray;
  JsonLinea: TJSONObject;
  i, j, k: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  Query2 := TFDQuery.create(nil);
  Query2.Connection := Conexion;
  Query3 := TFDQuery.create(nil);
  Query3.Connection := Conexion;

  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('FuncionesDocentes', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_funciones_docentes', 'funcion', Query);

    limpiarParametros;
    agregarParametro('idfunciondocente', 'String');
    agregarParametro('funcion', 'String');

    for i := 1 to Query.RecordCount do
    begin
      JsonFuncion := TJSONObject.create;
      JsonFuncion := crearJSON(Query);

      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add
        ('SELECT * FROM siap_actividades_docentes WHERE idfunciondocente=' +
        Texto(Query.FieldByName('idfunciondocente').AsString));
      Query2.Open;
      Query2.First;

      ArrayActividades := TJSONArray.create;
      for j := 1 to Query2.RecordCount do
      begin
        JsonActividad := TJSONObject.create;
        JsonActividad.AddPair('idactividaddocente',
          Query2.FieldByName('idactividaddocente').AsString);
        JsonActividad.AddPair('actividad', Query2.FieldByName('actividad')
          .AsString);
        JsonActividad.AddPair('idfunciondocente',
          Query2.FieldByName('idfunciondocente').AsString);

        { Leer las subactividades }
        Query3.Close;
        Query3.SQL.Text := 'SELECT * FROM siap_subactividades_docentes WHERE' +
          ' idactividaddocente=' +
          Texto(Query2.FieldByName('idactividaddocente').AsString);
        Query3.Open;
        Query3.First;

        ArraySubactividades := TJSONArray.create;
        for k := 1 to Query3.RecordCount do
        begin
          JsonSubactividad := TJSONObject.create;
          JsonSubactividad.AddPair('idsubactividaddocente',
            Query3.FieldByName('idsubactividaddocente').AsString);
          JsonSubactividad.AddPair('subactividad',
            Query3.FieldByName('subactividad').AsString);
          JsonSubactividad.AddPair('idactividaddocente',
            Query3.FieldByName('idactividaddocente').AsString);

          ArraySubactividades.Add(JsonSubactividad);
          Query3.Next;
        end;

        JsonActividad.AddPair('subactividades', ArraySubactividades);
        ArrayActividades.Add(JsonActividad);

        Query2.Next;
      end;

      JsonFuncion.AddPair('actividades', ArrayActividades);
      ArrayJson.AddElement(JsonFuncion);
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllFuncionDocente',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('FuncionesDocente', Json.toString);
  Query.Free;
  Query2.Free;
  Query3.Free;
end;

function TMatematicas.PeriodosPractica: TJSONObject;
begin
  Result := moduloPracticaDocente.getPeriodos;
end;

function TMatematicas.getPrespuestoByFechaPlan(IdPlan: string): TJSONArray;
var
  Fechas, presupuestos: TJSONArray;
  JsonFecha, jsonpresupuesto, Json: TJSONObject;
  QFecha, QPres: TFDQuery;
  i: integer;
  j: integer;
begin
  try
    Json := TJSONObject.create;
    QFecha := TFDQuery.create(nil);
    QFecha.Connection := Conexion;
    QPres := TFDQuery.create(nil);
    QPres.Connection := Conexion;

    QFecha.Close;
    QFecha.SQL.Text :=
      'SELECT * FROM siap_fechas_plan_mejoramiento ORDER BY fecha';
    QFecha.Open;
    QFecha.First;

    Fechas := TJSONArray.create;
    for j := 1 to QFecha.RecordCount do
    begin
      JsonFecha := TJSONObject.create;
      JsonFecha.AddPair('idfecha', QFecha.FieldByName('idfecha').AsString);
      JsonFecha.AddPair('fecha', QFecha.FieldByName('fecha').AsString);

      QPres.Close;
      QPres.SQL.Text := 'SELECT * FROM siap_presupuesto_pm WHERE' + ' idplan=' +
        #39 + IdPlan + #39 + ' AND idfecha=' + #39 +
        QFecha.FieldByName('idfecha').AsString + #39;
      QPres.Open;
      QPres.First;

      presupuestos := TJSONArray.create;
      for i := 1 to QPres.RecordCount do
      begin
        jsonpresupuesto := TJSONObject.create;
        jsonpresupuesto.AddPair('idpresupuesto',
          QPres.FieldByName('idpresupuesto').Value);
        jsonpresupuesto.AddPair('idplan', QPres.FieldByName('idplan').Value);
        jsonpresupuesto.AddPair('idfecha', QPres.FieldByName('idfecha').Value);
        jsonpresupuesto.AddPair('descripcion',
          QPres.FieldByName('descripcion').Value);
        jsonpresupuesto.AddPair('valor', QPres.FieldByName('valor').Value);

        presupuestos.AddElement(jsonpresupuesto);
        QPres.Next;
      end;

      JsonFecha.AddPair('presupuestos', presupuestos);
      Fechas.AddElement(JsonFecha);

      QFecha.Next;
    end;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESPONSE, 'Los presupuestos se obtuvieron correctamente');
    Json.AddPair(JSON_RESULTS, presupuestos);
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Fechas;
  QPres.Free;
  QFecha.Free;
end;

function TMatematicas.getPresupuestosPm(IdPlan: string): TJSONArray;
var
  Json, jsonpresupuesto: TJSONObject;
  Query: TFDQuery;
  presupuestos: TJSONArray;
  i: integer;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_presupuesto_pm as ppm INNER JOIN' +
      ' siap_fechas_plan_mejoramiento as fpm ON ppm.idfecha=fpm.idfecha WHERE' +
      ' ppm.idplan=' + #39 + IdPlan + #39;
    Query.Open;
    Query.First;

    presupuestos := TJSONArray.create;
    for i := 1 to Query.RecordCount do
    begin
      jsonpresupuesto := TJSONObject.create;
      jsonpresupuesto.AddPair('idpresupuesto',
        Query.FieldByName('idpresupuesto').Value);
      jsonpresupuesto.AddPair('idplan', Query.FieldByName('idplan').Value);
      jsonpresupuesto.AddPair('idfecha', Query.FieldByName('idfecha').Value);
      jsonpresupuesto.AddPair('descripcion',
        Query.FieldByName('descripcion').Value);
      jsonpresupuesto.AddPair('valor', Query.FieldByName('valor').Value);
      jsonpresupuesto.AddPair('fecha', Query.FieldByName('fecha').Value);

      presupuestos.AddElement(jsonpresupuesto);
      Query.Next;
    end;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESPONSE, 'Los presupuestos se obtuvieron correctamente');
    Json.AddPair(JSON_RESULTS, presupuestos);
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := presupuestos;
  Query.Free;
end;

{ Método DELETE - FuncionDocente }
function TMatematicas.cancelFuncionDocente(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_funciones_docentes', 'idfunciondocente', Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'La Función Docente se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteFuncionDocente',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelFuncionDocente', Json.toString);
  Query.Free;
end;

{ Método UPDATE - FuncionDocente }
function TMatematicas.acceptFuncionDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idfunciondocente', 'String');
      agregarParametro('funcion', 'String');

      ID := datos.GetValue('idfunciondocente').Value;
      UPDATE('siap_funciones_docentes', 'idfunciondocente', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'La Función Docente se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptFuncionDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateFuncionDocente', Json.toString);
  Query.Free;
end;

{ Método INSERT - Configuracion }
function TMatematicas.updateConfiguracion(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idconfiguracion', 'String');
      agregarParametro('nombredirector', 'String');
      agregarParametro('nombredecano', 'String');

      INSERT('siap_configuraciones', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Configuración se agrego correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateConfiguracion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateConfiguracion', Json.toString);
  Query.Free;
end;

function TMatematicas.acceptEstudiante(Estudiante: TJSONObject): TJSONObject;
begin
  Result := moduloPracticaDocente.putEstudiante(Estudiante);
end;

function TMatematicas.acceptEstudianteCarta(datos: TJSONObject): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.putEstudianteCarta(datos)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

{ Método GET - Configuracion }
function TMatematicas.Configuracion(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_configuraciones', 'idconfiguracion', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idconfiguracion', 'String');
    agregarParametro('nombredirector', 'String');
    agregarParametro('nombredecano', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getConfiguracion',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Configuracion', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Configuracion }
function TMatematicas.Configuraciones: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Configuraciones', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_configuraciones', 'nombredirector', Query);

    limpiarParametros;
    agregarParametro('idconfiguracion', 'String');
    agregarParametro('nombredirector', 'String');
    agregarParametro('nombredecano', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllConfiguracion',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Configuraciones', Json.toString);
  Query.Free;
end;

{ Método DELETE - Configuracion }
function TMatematicas.cancelConfiguracion(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_configuraciones', 'idconfiguracion', Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'La Configuración se eliminó de la agenda correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteConfiguracion',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelConfiguracion', Json.toString);
  Query.Free;
end;

{ Método UPDATE - Configuracion }
function TMatematicas.acceptConfiguracion(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idconfiguracion', 'String');
      agregarParametro('nombredirector', 'String');
      agregarParametro('nombredecano', 'String');

      ID := datos.GetValue('idconfiguracion').Value;
      UPDATE('siap_configuraciones', 'idconfiguracion', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'La Configuración se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptConfiguracion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateConfiguracion', Json.toString);
  Query.Free;
end;

{ Método INSERT - AgendaServicio }
function TMatematicas.updateAgendaServicio(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idagendaservicio', 'String');
      agregarParametro('iddocente', 'Integer');
      agregarParametro('idservicioprograma', 'String');
      agregarParametro('periodo', 'String');

      INSERT('siap_agendas_servicios', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Servicio se agrego correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateAgendaServicio',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateAgendaServicio', Json.toString);
  Query.Free;
end;

{ Método GET - AgendaServicio }
function TMatematicas.AgendaServicio(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_agendas_servicios', 'idagendaservicio', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idagendaservicio', 'String');
    agregarParametro('iddocente', 'String');
    agregarParametro('idservicioprograma', 'String');
    agregarParametro('periodo', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAgendaServicio',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('AgendaServicio', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - AgendaServicio }
function TMatematicas.AgendasPorDocente(const IdDocente: string): TJSONObject;
var
  QPeriodos, QAgendas: TFDQuery;
  JsonAgendas, JsonPeriodo, JsonAgenda: TJSONObject;
  Periodos, Agendas: TJSONArray;
  i: integer;
  j: integer;
begin
  try
    JsonAgendas := TJSONObject.create;
    QPeriodos := TFDQuery.create(nil);
    QPeriodos.Connection := Conexion;
    QAgendas := TFDQuery.create(nil);
    QAgendas.Connection := Conexion;

    QPeriodos.Close;
    QPeriodos.SQL.Text := 'SELECT * FROM siap_periodos ORDER BY periodo';
    QPeriodos.Open;
    QPeriodos.First;

    Periodos := TJSONArray.create;
    for i := 1 to QPeriodos.RecordCount do
    begin
      QAgendas.Close;
      QAgendas.SQL.Text := 'SELECT * FROM siap_agendas_servicios as sas INNER' +
        ' JOIN siap_servicios_programas as ssp ON sas.idservicioprograma=' +
        'ssp.idservicioprograma INNER JOIN siap_programas as sp ON ' +
        'ssp.idprograma=sp.idprograma WHERE sas.periodo=' + #39 +
        QPeriodos.FieldByName('periodo').AsString + #39 + ' AND sas.iddocente='
        + #39 + IdDocente + #39;
      QAgendas.Open;
      QAgendas.First;

      JsonPeriodo := TJSONObject.create;
      JsonPeriodo.AddPair('idperiodo', QPeriodos.FieldByName('idperiodo')
        .AsString);
      JsonPeriodo.AddPair('periodo', QPeriodos.FieldByName('periodo').AsString);
      JsonPeriodo.AddPair('hormaxcarrera',
        QPeriodos.FieldByName('hormaxcarrera').AsString);
      JsonPeriodo.AddPair('hormaxcontrato',
        QPeriodos.FieldByName('hormaxcontrato').AsString);
      JsonPeriodo.AddPair('hormaxcatedratico',
        QPeriodos.FieldByName('hormaxcatedratico').AsString);

      Agendas := TJSONArray.create;
      for j := 1 to QAgendas.RecordCount do
      begin
        JsonAgenda := TJSONObject.create;
        JsonAgenda.AddPair('idagendaservicio',
          QAgendas.FieldByName('idagendaservicio').AsString);

        JsonAgenda.AddPair('iddocente', QAgendas.FieldByName('iddocente')
          .AsString);

        JsonAgenda.AddPair('idservicioprograma',
          QAgendas.FieldByName('idservicioprograma').AsString);

        JsonAgenda.AddPair('periodo', QAgendas.FieldByName('periodo').AsString);

        JsonAgenda.AddPair('numerocontrato',
          QAgendas.FieldByName('numerocontrato').AsString);

        JsonAgenda.AddPair('actafacultad', QAgendas.FieldByName('actafacultad')
          .AsString);

        JsonAgenda.AddPair('actaprograma', QAgendas.FieldByName('actaprograma')
          .AsString);

        JsonAgenda.AddPair('concertada', QAgendas.FieldByName('concertada')
          .AsString);

        JsonAgenda.AddPair('idservicioprograma',
          QAgendas.FieldByName('idservicioprograma').AsString);

        JsonAgenda.AddPair('asignatura', QAgendas.FieldByName('asignatura')
          .AsString);

        JsonAgenda.AddPair('idprograma', QAgendas.FieldByName('idprograma')
          .AsString);

        JsonAgenda.AddPair('horas', QAgendas.FieldByName('horas').AsString);

        JsonAgenda.AddPair('aulas', QAgendas.FieldByName('aulas').AsString);

        JsonAgenda.AddPair('periodo', QAgendas.FieldByName('periodo').AsString);

        JsonAgenda.AddPair('jornada', QAgendas.FieldByName('jornada').AsString);

        JsonAgenda.AddPair('grupo', QAgendas.FieldByName('grupo').AsString);

        JsonAgenda.AddPair('programa', QAgendas.FieldByName('programa')
          .AsString);

        JsonAgenda.AddPair('idfacultad', QAgendas.FieldByName('idfacultad')
          .AsString);

        Agendas.AddElement(JsonAgenda);
        QAgendas.Next;
      end;

      JsonPeriodo.AddPair('Agendas', Agendas);
      Periodos.AddElement(JsonPeriodo);

      QPeriodos.Next;
    end;

    JsonAgendas.AddPair('Periodos', Periodos);
  except
    on E: Exception do
      JsonAgendas.AddPair('Error', E.Message);
  end;

  Result := JsonAgendas;
  QPeriodos.Free;
  QAgendas.Free;
end;

function TMatematicas.AgendasPorPeriodo(const Periodo: string): TJSONObject;
var
  Query, QDoc: TFDQuery;
  Json, jsonDocente, JsonServicio, JsonContratos: TJSONObject;
  ArrayDocentes, ArrayContratos, ArrayServicios: TJSONArray;
  IdDocente: string;
  TiposContrato: TStringList;
  tc, d, m: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  QDoc := TFDQuery.create(nil);
  QDoc.Connection := Conexion;

  try
    escribirMensaje('AgendasPorPeriodo',
      'Se inicio el proceso de obtener las agendas por periodo');

    Json := TJSONObject.create;

    { Se crea una consulta para leer a los docentes por cada uno de los tipos
      de contrato, primero carrera, contrato y cátedra }
    TiposContrato := TStringList.create;
    TiposContrato.Add('carrera');
    TiposContrato.Add('contrato');
    TiposContrato.Add('catedrático');

    ArrayContratos := TJSONArray.create;
    Json.AddPair('Contratos', Json);

    for tc := 1 to TiposContrato.Count do
    begin
      JsonContratos := TJSONObject.create;
      JsonContratos.AddPair('TipoContrato', TiposContrato[tc - 1]);

      ArrayDocentes := TJSONArray.create;
      JsonContratos.AddPair('Docentes', ArrayDocentes);

      QDoc.Close;
      QDoc.SQL.Clear;
      QDoc.SQL.Add('SELECT * FROM siap_docentes AS d ');
      QDoc.SQL.Add('INNER JOIN siap_tipo_contrato AS tc ');
      QDoc.SQL.Add('ON tc.idtipocontrato = d.idtipocontrato ');
      QDoc.SQL.Add('INNER JOIN siap_categoria_docentes AS c ');
      QDoc.SQL.Add('ON d.idcategoriadocente = c.idcategoriadocente ');
      QDoc.SQL.Add('WHERE activo=' + #39 + 'si' + #39 + ' AND tc.contrato=' +
        #39 + TiposContrato[tc - 1] + #39 + ' ');
      QDoc.SQL.Add('ORDER BY d.nombre');

      FDataSnapMatematicas.comentarioSQL('Consulta de Docentes por Contrato');
      FDataSnapMatematicas.escribirSQL(QDoc.SQL.Text);

      QDoc.Open;
      QDoc.First;

      escribirMensaje('AgendasPorPeriodo',
        'Se realizó la consulta de la Lista de Docentes');

      { Ciclo para recorrer cada docente }
      for d := 1 to QDoc.RecordCount do
      begin
        IdDocente := QDoc.FieldByName('iddocente').AsString;

        jsonDocente := TJSONObject.create;
        jsonDocente.AddPair('iddocente', QDoc.FieldByName('iddocente')
          .AsString);
        jsonDocente.AddPair('nombre', QDoc.FieldByName('nombre').AsString);
        jsonDocente.AddPair('contrato', QDoc.FieldByName('contrato').AsString);
        jsonDocente.AddPair('categoria', QDoc.FieldByName('categoria')
          .AsString);

        escribirMensaje('Agrego al Docente (' + IntToStr(d) + ')',
          'AgendasPorPeriodo');

        { Realizar una consulta para leer los servicios asociadas al docente }
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add('SELECT * FROM siap_agendas_servicios as ags ');
        Query.SQL.Add('INNER JOIN siap_docentes as d ');
        Query.SQL.Add('ON ags.iddocente = d.iddocente ');
        Query.SQL.Add('INNER JOIN siap_tipo_contrato as tc ');
        Query.SQL.Add('ON d.idtipocontrato = tc.idtipocontrato ');
        Query.SQL.Add('INNER JOIN siap_categoria_docentes as cd ');
        Query.SQL.Add('ON d.idcategoriadocente = cd.idcategoriadocente ');
        Query.SQL.Add('INNER JOIN siap_servicios_programas as sp ');
        Query.SQL.Add('ON sp.idservicioprograma = ags.idservicioprograma ');
        Query.SQL.Add('WHERE ags.periodo=' + #39 + Periodo + #39 +
          ' and ags.iddocente=' + #39 + IdDocente + #39 + ' ');
        Query.SQL.Add('ORDER BY sp.jornada');

        FDataSnapMatematicas.comentarioSQL
          ('Consulta de los Servicios del Docente');
        FDataSnapMatematicas.escribirSQL(Query.SQL.Text);

        Query.Open;
        Query.First;

        ArrayServicios := TJSONArray.create;
        for m := 1 to Query.RecordCount do
        begin
          JsonServicio := TJSONObject.create;
          JsonServicio.AddPair('asignatura', Query.FieldByName('asignatura')
            .AsString);
          JsonServicio.AddPair('horas', Query.FieldByName('horas').AsString);
          JsonServicio.AddPair('grupo', Query.FieldByName('grupo').AsString);
          JsonServicio.AddPair('semanas', Query.FieldByName('semanas')
            .AsString);
          JsonServicio.AddPair('tipo', Query.FieldByName('tipo').AsString);

          ArrayServicios.Add(JsonServicio);
          Query.Next;
        end;

        { Agregar los servicios al docente }
        jsonDocente.AddPair('Servicios', ArrayServicios);

        { Agregar el docente a la lista de docentes }
        ArrayDocentes.Add(jsonDocente);
        QDoc.Next;
      end;
    end;
  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'AgendasPorPeriodo',
        E.Message + Periodo);
    end;
  end;

  Result := Json;
  escribirMensaje('AgendasServicio', Json.toString);
  Query.Free;
  QDoc.Free;
end;

function TMatematicas.AgendasPorPrograma(const Periodo: string): TJSONObject;
var
  Query: TFDQuery;
  Json, JsonPrograma: TJSONObject;
  Estadisticas: TJSONArray;
  Programa: string;
  cantidad: integer;
  i: integer;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Json := TJSONObject.create;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_servicios_programas as sp INNER' +
      ' JOIN siap_programas as prgm ON sp.idprograma=prgm.idprograma WHERE' +
      ' sp.periodo=' + #39 + Periodo + #39 + ' ORDER BY prgm.programa';
    Query.Open;
    Query.First;

    Programa := Query.FieldByName('programa').AsString;
    cantidad := 1;
    Query.Next;

    Estadisticas := TJSONArray.create;
    for i := 1 to Query.RecordCount - 1 do
    begin
      if Programa <> Query.FieldByName('programa').AsString then
      begin
        JsonPrograma := TJSONObject.create;
        JsonPrograma.AddPair('Programa', Programa);
        JsonPrograma.AddPair('Cantidad', IntToStr(cantidad));
        Estadisticas.AddElement(JsonPrograma);

        cantidad := 1;
        Programa := Query.FieldByName('programa').AsString;
      end
      else
      begin
        Inc(cantidad);
      end;

      Query.Next;
    end;

    Json.AddPair('Estadisticas', Estadisticas);
  except
    on E: Exception do
      Json.AddPair('Error', E.Message);
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.AgendasServicio(const IdDocente: string;
  const Periodo: string): TJSONObject;
var
  Json, JsonServicio, JsonHorario: TJSONObject;
  Query, Query2: TFDQuery;
  ArrayJson, ArrayHorario: TJSONArray;
  JsonLinea: TJSONObject;
  i, j: integer;
  sumaHorasSemana, sumaHorasSemestre, totalHorasContrato, horasRestantes,
    semanasSemestre, reconocimientoPosgrado, horasSemestre, horasFactor,
    horas: real;
  contrato, Jornada, Aulas, tipo, Observacion: string;
  formato: TFormatSettings;
  iPeriodo: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  Query2 := TFDQuery.create(nil);
  Query2.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('AgendasServicios', ArrayJson);

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT * FROM siap_agendas_servicios as a ');
    Query.SQL.Add('INNER JOIN siap_servicios_programas as s ');
    Query.SQL.Add('ON a.idservicioprograma = s.idservicioprograma ');
    Query.SQL.Add('INNER JOIN siap_programas as p ');
    Query.SQL.Add('ON s.idprograma = p.idprograma ');
    Query.SQL.Add('WHERE iddocente=' + IdDocente + ' AND a.periodo=' +
      Texto(Periodo));

    FDataSnapMatematicas.comentarioSQL('Consulta - AgendasServicios');
    FDataSnapMatematicas.escribirSQL(Query.SQL.Text);

    Query.Open;
    Query.First;

    FDataSnapMatematicas.comentarioSQL
      ('Consulta para obtener los servicios asociados a un docente');
    FDataSnapMatematicas.escribirSQL(Query.SQL.Text);

    limpiarParametros;
    agregarParametro('idagendaservicio', 'String');
    agregarParametro('iddocente', 'String');
    agregarParametro('idservicioprograma', 'String');
    agregarParametro('periodo', 'String');
    agregarParametro('asignatura', 'String');
    agregarParametro('idprograma', 'String');
    agregarParametro('programa', 'String');
    agregarParametro('horas', 'String');
    agregarParametro('jornada', 'String');
    agregarParametro('grupo', 'String');
    agregarParametro('semanas', 'Integer');
    agregarParametro('tipo', 'String');
    agregarParametro('numerocontrato', 'String');
    agregarParametro('actaprograma', 'String');
    agregarParametro('actafacultad', 'String');
    agregarParametro('grupo', 'String');
    agregarParametro('concertada', 'String');

    sumaHorasSemana := 0;
    sumaHorasSemestre := 0;
    reconocimientoPosgrado := 0;
    contrato := obtenerTipoContrato(IdDocente);
    Observacion := '';

    // Ciclo para contar la cantidad de materias o servicios
    for i := 1 to Query.RecordCount do
    begin
      JsonServicio := TJSONObject.create;
      JsonServicio := crearJSON(Query);

      // Obtiene las semanas del semestre particulares a cada matería/servicio
      semanasSemestre := Query.FieldByName('semanas').AsInteger;
      Jornada := Query.FieldByName('jornada').AsString;
      tipo := Query.FieldByName('tipo').AsString;

      { Hace una consulta para determinar los horarios asociados al servicio
        o materia de programa }
      Query2.Close;
      Query2.SQL.Text :=
        'SELECT * FROM siap_horarios_servicios WHERE idservicioprograma=' +
        Texto(Query.FieldByName('idservicioprograma').AsString);
      Query2.Open;
      Query2.First;

      { Si la jornada no es virtual entonces se cuentan las horas a través
        de los horarios, además también se crea un Array con los horarios }
      if (Jornada <> 'virtual') then
      begin
        ArrayHorario := TJSONArray.create;

        // Ciclo para contar los horarios de cada servicio o materia.
        Aulas := '';
        for j := 1 to Query2.RecordCount do
        begin
          JsonHorario := TJSONObject.create;
          JsonHorario.AddPair('idhorarioservicio',
            Query2.FieldByName('idhorarioservicio').AsString);
          JsonHorario.AddPair('dia', Query2.FieldByName('dia').AsString);
          JsonHorario.AddPair('inicio', Query2.FieldByName('inicio').AsString);
          JsonHorario.AddPair('fin', Query2.FieldByName('fin').AsString);
          JsonHorario.AddPair('aula', Query2.FieldByName('salon').AsString);

          ArrayHorario.Add(JsonHorario);
          Query2.Next;
        end;
      end;

      { Para obtener las horas totales de docencia se debe leer el periodo, en
        el cual se registran las horas totales en cada  uno de ellos, y por tipo
        de contrato, por ejemplo carrera 900 y contrato 940 }
      Query2.Close;
      Query2.SQL.Text := 'SELECT * FROM siap_periodos WHERE periodo=' + #39 +
        Periodo + #39;
      Query2.Open;

      { Obtener la cantidad de horas semanales, en el caso de la virtualidad
        totales }

      { sumaHorasSemestre empieza en cero (0), sumaHorasSemana empieza en cero (0)
        según sea la condición se suman las horas por semana, únicamente en el caso
        de que sea diferente de virtual y diferente de distancia }

      // Leer las horas
      horas := Query.FieldByName('horas').AsInteger;

      // Determinar si se suman las horas semanales
      if (Jornada <> 'virtual') and (Jornada <> 'distancia') then
        sumaHorasSemana := sumaHorasSemana + horas;

      { A partir del 2022-1 la norma cambio y las materias virtuales se
        agregaron al factor de profesores de carrera y contrato, por tal
        razón a continuación se deja una condición para que el histórico no se
        vea afectado y es determinar si estamos en el periodo antes o después
        de 2022-1 para realizar los cálculos }

      // Convertir el periodo a formato de número
      iPeriodo := StrToInt(Copy(Periodo, 1, 4));

      if iPeriodo < 2022 then
      begin
        { Para docentes de Carrera %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
        if contrato = 'carrera' then
        begin
          totalHorasContrato := Query2.FieldByName('hormaxcarrera').AsInteger;

          if (Jornada = 'virtual') and (tipo <> 'posgrado') then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre);
            horasFactor := horasSemestre;
          end
          else if Jornada = 'distancia' then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2.5;
            horasFactor := horasSemestre * 2.5;
          end
          else if (Jornada = 'posgrado') or (tipo = 'posgrado') then
          begin
            horasSemestre := horas * semanasSemestre;
            reconocimientoPosgrado := reconocimientoPosgrado + horasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 3.5;
            horasFactor := horasSemestre * 2.5;
          end
          else if (Jornada = 'virtual') and (tipo = 'posgrado') then
          begin
            horasSemestre := horas;
            reconocimientoPosgrado := reconocimientoPosgrado + horasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 3.5;
            horasFactor := horasSemestre * 2.5;
          end
          else
          begin
            horasSemestre := horas * semanasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2.5;
            horasFactor := horasSemestre * 2.5;
          end;
        end

        { Para docentes de contrato %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
        else if contrato = 'contrato' then
        begin
          totalHorasContrato := Query2.FieldByName('hormaxcontrato').AsInteger;
          if (Jornada = 'virtual') and (tipo <> 'posgrado') then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre);
          end
          else if Jornada = 'distancia' then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2;
            horasFactor := horasSemestre * 2;
          end
          else
          begin
            horasSemestre := horas * semanasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2;
            horasFactor := horasSemestre * 2;
          end;
        end

        { Para docentes catedráticos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
        else
        begin
          totalHorasContrato := Query2.FieldByName('hormaxcatedratico')
            .AsInteger;
          if Jornada = 'virtual' then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre);
          end
          else if Jornada = 'distancia' then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre)
          end
          else
          begin
            horasSemestre := horas * semanasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre);
          end;

          horasFactor := horasSemestre * 1;
        end;
      end
      else // Ahora se establece la nueva regla para el factor después de 2022-1
      begin
        { Para docentes de Carrera %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
        if contrato = 'carrera' then
        begin
          totalHorasContrato := Query2.FieldByName('hormaxcarrera').AsInteger;

          if (Jornada = 'virtual') and (tipo <> 'posgrado') then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2.5;
            horasFactor := horasSemestre * 2.5;
          end
          else if Jornada = 'distancia' then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2.5;
            horasFactor := horasSemestre * 2.5;
          end
          else if (Jornada = 'posgrado') or (tipo = 'posgrado') then
          begin
            horasSemestre := horas * semanasSemestre;
            reconocimientoPosgrado := reconocimientoPosgrado + horasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 3.5;
            horasFactor := horasSemestre * 2.5;
          end
          else if (Jornada = 'virtual') and (tipo = 'posgrado') then
          begin
            horasSemestre := horas;
            reconocimientoPosgrado := reconocimientoPosgrado + horasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 3.5;
            horasFactor := horasSemestre * 2.5;
          end
          else
          begin
            horasSemestre := horas * semanasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2.5;
            horasFactor := horasSemestre * 2.5;
          end;
        end

        { Para docentes de contrato %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
        else if contrato = 'contrato' then
        begin
          totalHorasContrato := Query2.FieldByName('hormaxcontrato').AsInteger;
          if (Jornada = 'virtual') and (tipo <> 'posgrado') then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2;
            horasFactor := horasSemestre * 2;
          end
          else if Jornada = 'distancia' then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2;
            horasFactor := horasSemestre * 2;
          end
          else
          begin
            horasSemestre := horas * semanasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre) * 2;
            horasFactor := horasSemestre * 2;
          end;
        end

        { Para docentes catedráticos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
        else
        begin
          totalHorasContrato := Query2.FieldByName('hormaxcatedratico')
            .AsInteger;
          if Jornada = 'virtual' then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre);
          end
          else if Jornada = 'distancia' then
          begin
            horasSemestre := horas;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre)
          end
          else
          begin
            horasSemestre := horas * semanasSemestre;
            sumaHorasSemestre := sumaHorasSemestre + (horasSemestre);
          end;

          horasFactor := horasSemestre * 1;
        end;
      end;

      if (Jornada <> 'virtual') then
        JsonServicio.AddPair('horarios', ArrayHorario);

      JsonServicio.AddPair('horassemestre', floatTostr(horasSemestre));
      JsonServicio.AddPair('horasfactor', floatTostr(horasFactor));

      ArrayJson.AddElement(JsonServicio);
      Query.Next;
    end;

    // Calcular las horas restantes
    horasRestantes := totalHorasContrato - sumaHorasSemestre;

    formato.DecimalSeparator := '.';

    Json.AddPair('horasSemanales', floatTostr(sumaHorasSemana));
    Json.AddPair('horasSemestrales', floatTostr(sumaHorasSemestre));
    Json.AddPair('totalHoras', floatTostr(horasRestantes));
    Json.AddPair('horasRestantes', floatTostr(horasRestantes, formato));
    Json.AddPair('reconocimientoPosgrado', floatTostr(reconocimientoPosgrado));

    if (sumaHorasSemana < 16) and (contrato = 'contrato') then
      Observacion := Observacion +
        'El docente no cumple con el mínimo de horas por semana';

    Json.AddPair('observacion', Observacion);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, '(AgendasServicio) - ' + E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllAgendaServicio',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  Query.Free;
  Query2.Free;
end;

function TMatematicas.EstadisticasTrabajoGrado: TJSONObject;
var
  JsonResponse: TJSONObject;
  Estadisticas: TJSONArray;
begin
  try
    JsonResponse := TJSONObject.create;
    Estadisticas := TJSONArray.create;

    // 1.0 Trabajos de grado que iniciaron por año
    Estadisticas.AddElement(TrabajosGradoInicianPorAnio);

    // 2.0 Trabajos de grado que finalizaron por año
    Estadisticas.AddElement(TrabajosGradoFinPorAnio);

    // 3.0 Trabajos de grado por tipo de calificación
    Estadisticas.AddElement(TrabajosGradoCalificacionFinal);

    // 4.0 Trabajos de grado por área de profundización
    Estadisticas.AddElement(TrabajosGradoAreaProfundizacion);

    // 5.0 Trabajos de grado por grupo de investigación
    Estadisticas.AddElement(TrabajosGradoByGrupoInvestigacion);

    // 6.0 Trabajos de grado por modalidad
    Estadisticas.AddElement(TrabajosGradoByModalidad);

    // 7.0 Trabajos de grado por tiempo de ejecuión
    Estadisticas.AddElement(TrabajosGradoByTiempoEjecucion);

    // 8.0 Trabajos de grado por estado del proyecto
    Estadisticas.AddElement(TrabajosGradoByEstado);

    JsonResponse.AddPair('Statistics', Estadisticas);

  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := JsonResponse;
end;

function TMatematicas.EstadoAgendas(const Periodo: string): TJSONObject;
var
  Json, JsonContrato, JsonFunciones, JsonNumeros, JsonAgenda: TJSONObject;
  Agendas, Contratos, Actividades: TJSONArray;
  Query: TFDQuery;
  TiposContratos: TStringList;
  i, j: integer;
  IdDocente: string;
  horPen, horMax, horFun: real;
  estado, Concertada: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  try
    Json := TJSONObject.create;

    TiposContratos := TStringList.create;
    TiposContratos.Add('carrera');
    TiposContratos.Add('contrato');
    TiposContratos.Add('catedrático');

    Contratos := TJSONArray.create;
    for i := 1 to TiposContratos.Count do
    begin
      Agendas := TJSONArray.create;

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('SELECT * FROM siap_docentes AS d ');
      Query.SQL.Add('INNER JOIN siap_tipo_contrato AS tc ');
      Query.SQL.Add('ON d.idtipocontrato = tc.idtipocontrato ');
      Query.SQL.Add('INNER JOIN siap_categoria_docentes AS cd ');
      Query.SQL.Add('ON d.idcategoriadocente = cd.idcategoriadocente ');
      Query.SQL.Add('WHERE activo='#39 + 'si' + #39 + ' AND contrato=' + #39 +
        TiposContratos[i - 1] + #39 + ' ORDER BY nombre');

      FDataSnapMatematicas.comentarioSQL('Consulta - EstadoAgendas');
      FDataSnapMatematicas.escribirSQL(Query.SQL.Text);

      Query.Open;
      Query.First;

      for j := 1 to Query.RecordCount do
      begin
        IdDocente := Query.FieldByName('iddocente').AsString;

        JsonAgenda := TJSONObject.create;

        // Obtener los servicios de Docencia
        JsonAgenda := AgendasServicio(IdDocente, Periodo);

        // Agregas los datos básicos
        JsonAgenda.AddPair('documento', IdDocente);
        JsonAgenda.AddPair('nombre', Query.FieldByName('nombre').AsString);
        JsonAgenda.AddPair('categoria', Query.FieldByName('categoria')
          .AsString);
        JsonAgenda.AddPair('contrato', Query.FieldByName('contrato').AsString);

        // Obtener las funciones complementarias
        JsonFunciones := TJSONObject.create;
        JsonFunciones := ActividadesFuncionesDocente(IdDocente, Periodo);

        Actividades := TJSONArray.create;
        Actividades := (JsonFunciones.GetValue('ActividadesFuncionesDocente')
          as TJSONArray);

        // Agregar las funciones
        JsonAgenda.AddPair('ActividadesFuncionesDocente', Actividades);
        JsonAgenda.AddPair('horasMaxContrato',
          JsonFunciones.GetValue('horasMaxContrato').Value);
        JsonAgenda.AddPair('horasFunciones',
          JsonFunciones.GetValue('horasFunciones').Value);
        JsonAgenda.AddPair('horasRestantes',
          JsonFunciones.GetValue('horasRestantes').Value);
        JsonAgenda.AddPair('horasTotales',
          JsonFunciones.GetValue('horasTotales').Value);

        // Obtener los números de actas
        JsonNumeros := TJSONObject.create;
        JsonNumeros := obtenerNumerosActas(IdDocente, Periodo);

        JsonAgenda.AddPair('numeroContrato',
          JsonNumeros.GetValue('numeroContrato').Value);
        JsonAgenda.AddPair('actaPrograma',
          JsonNumeros.GetValue('actaPrograma').Value);
        JsonAgenda.AddPair('actaFacultad',
          JsonNumeros.GetValue('actaFacultad').Value);
        JsonAgenda.AddPair('agendaCompletada',
          JsonNumeros.GetValue('agendaCompletada').Value);

        horPen := StringToFloat(JsonFunciones.GetValue('horasRestantes').Value);
        Concertada := JsonNumeros.GetValue('agendaConcertada').Value;

        // Validación para cuando todas las horas sean de solo funciones
        horMax := StringToFloat
          (JsonFunciones.GetValue('horasMaxContrato').Value);
        horFun := StringToFloat(JsonFunciones.GetValue('horasFunciones').Value);

        if (horPen < 0) then
          estado := 'Incorrecta (La agenda sobrepasa el número de horas permitido)'
        else if (horPen = 0) or (Concertada = 'si') then
        begin
          estado := 'Completa';
          if (Concertada = 'no') and (horMax = horFun) then
            Concertada := 'si';
        end
        else
          estado := 'En Proceso';

        JsonAgenda.AddPair('agendaConcertada', Concertada);
        JsonAgenda.AddPair('Estado', estado);

        Agendas.Add(JsonAgenda);
        Query.Next;
      end;

      JsonContrato := TJSONObject.create;
      JsonContrato.AddPair('TipoContrato', TiposContratos[i - 1]);
      JsonContrato.AddPair('Agendas', Agendas);

      Contratos.Add(JsonContrato);
    end;

    Json.AddPair('Contratos', Contratos);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, '(EstadoAgendas) - ' + E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'EstadoAgendas',
        E.Message + '=> ' + Periodo);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelAgendaServicio', Json.toString);
  Query.Free;
end;

function TMatematicas.Estudiantes: TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.getEstudiantes
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.EstudiantesByPeriodo(IdPeriodo: string): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.getEstudiantesByPeriodo(IdPeriodo)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.EstudiantesBySecretaria(IdPeriodo: string): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.getEstudiantesBySecretaria(IdPeriodo)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.EvaluadoresTrabajosGrado: TJSONObject;
var
  JsonContratos, JsonContrato, JsonTrabajoGrado, jsonDocente: TJSONObject;
  Docentes, Terminados, noTerminados, Contratos: TJSONArray;
  QContratos, QDocentes, QtrabajosGrado: TFDQuery;
  i, j, k: integer;
  IdDirector, IdTipoContrato: string;
  objWebModule: TWebModule;
  token: string;
begin
  try

    JsonContratos := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QDocentes := TFDQuery.create(nil);
      QDocentes.Connection := Conexion;
      QContratos := TFDQuery.create(nil);
      QContratos.Connection := Conexion;
      QtrabajosGrado := TFDQuery.create(nil);
      QtrabajosGrado.Connection := Conexion;

      QContratos.Close;
      QContratos.SQL.Text :=
        'SELECT * FROM siap_tipo_contrato ORDER by horas asc';
      QContratos.Open;
      QContratos.First;

      Contratos := TJSONArray.create;
      for k := 1 to QContratos.RecordCount do
      begin
        IdTipoContrato := QContratos.FieldByName('idtipocontrato').AsString;

        JsonContrato := TJSONObject.create;
        JsonContrato.AddPair('contrato', QContratos.FieldByName('contrato')
          .AsString);
        JsonContrato.AddPair('idtipocontrato',
          QContratos.FieldByName('idtipocontrato').AsString);

        QDocentes.Close;
        QDocentes.SQL.Text := 'SELECT * FROM siap_docentes WHERE activo=' + #39
          + 'si' + #39 + ' AND vinculacion=' + #39 + 'docente' + #39 +
          ' AND idtipocontrato=' + #39 + IdTipoContrato + #39 +
          ' ORDER BY nombre';
        QDocentes.Open;
        QDocentes.First;

        Docentes := TJSONArray.create;
        for i := 1 to QDocentes.RecordCount do
        begin
          IdDirector := QDocentes.FieldByName('iddocente').AsString;

          jsonDocente := TJSONObject.create;
          jsonDocente.AddPair('iddocente', QDocentes.FieldByName('iddocente')
            .AsString);
          jsonDocente.AddPair('nombre', QDocentes.FieldByName('nombre')
            .AsString);
          jsonDocente.AddPair('correo', QDocentes.FieldByName('correo')
            .AsString);
          jsonDocente.AddPair('telefono', QDocentes.FieldByName('telefono')
            .AsString);
          jsonDocente.AddPair('activo', QDocentes.FieldByName('activo')
            .AsString);
          jsonDocente.AddPair('documento', QDocentes.FieldByName('documento')
            .AsString);
          jsonDocente.AddPair('vinculacion',
            QDocentes.FieldByName('vinculacion').AsString);
          jsonDocente.AddPair('institucion',
            QDocentes.FieldByName('institucion').AsString);

          { Leer los trabajos de grado - TERMINADOS }
          QtrabajosGrado.Close;
          QtrabajosGrado.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE ' +
            ' (idjurado1=' + #39 + IdDirector + #39 + ' OR idjurado2=' + #39 +
            IdDirector + #39 + ' OR idjurado3=' + #39 + IdDirector + #39 +
            ') AND estadoproyecto=' + #39 + 'terminado' + #39;
          QtrabajosGrado.Open;
          QtrabajosGrado.First;

          jsonDocente.AddPair('SQL', QtrabajosGrado.SQL.Text);

          Terminados := TJSONArray.create;
          for j := 1 to QtrabajosGrado.RecordCount do
          begin
            JsonTrabajoGrado := TJSONObject.create;
            JsonTrabajoGrado.AddPair('titulo',
              QtrabajosGrado.FieldByName('titulo').AsString);
            JsonTrabajoGrado.AddPair('estudiante1',
              QtrabajosGrado.FieldByName('estudiante1').AsString);
            JsonTrabajoGrado.AddPair('estudiante2',
              QtrabajosGrado.FieldByName('estudiante2').AsString);
            JsonTrabajoGrado.AddPair('estudiante3',
              QtrabajosGrado.FieldByName('estudiante3').AsString);
            JsonTrabajoGrado.AddPair('actapropuesta',
              QtrabajosGrado.FieldByName('actapropuesta').AsString);
            JsonTrabajoGrado.AddPair('fechainicioejecucion',
              QtrabajosGrado.FieldByName('fechainicioejecucion').AsString);
            JsonTrabajoGrado.AddPair('estadoproyecto',
              QtrabajosGrado.FieldByName('estadoproyecto').AsString);

            Terminados.Add(JsonTrabajoGrado);
            QtrabajosGrado.Next;
          end;
          jsonDocente.AddPair('Terminados', Terminados);

          { Leer los trabajos de grado - NO TERMINADOS }
          QtrabajosGrado.Close;
          QtrabajosGrado.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE ' +
            ' (idjurado1=' + #39 + IdDirector + #39 + ' OR idjurado2=' + #39 +
            IdDirector + #39 + ' OR idjurado3=' + #39 + IdDirector + #39 +
            ') AND estadoproyecto=' + #39 + 'proceso' + #39;
          escribirMensaje(QtrabajosGrado.SQL.Text, 'SQL');
          QtrabajosGrado.Open;
          QtrabajosGrado.First;

          noTerminados := TJSONArray.create;
          for j := 1 to QtrabajosGrado.RecordCount do
          begin
            JsonTrabajoGrado := TJSONObject.create;
            JsonTrabajoGrado.AddPair('titulo',
              QtrabajosGrado.FieldByName('titulo').AsString);
            JsonTrabajoGrado.AddPair('estudiante1',
              QtrabajosGrado.FieldByName('estudiante1').AsString);
            JsonTrabajoGrado.AddPair('estudiante2',
              QtrabajosGrado.FieldByName('estudiante2').AsString);
            JsonTrabajoGrado.AddPair('estudiante3',
              QtrabajosGrado.FieldByName('estudiante3').AsString);
            JsonTrabajoGrado.AddPair('actapropuesta',
              QtrabajosGrado.FieldByName('actapropuesta').AsString);
            JsonTrabajoGrado.AddPair('fechainicioejecucion',
              QtrabajosGrado.FieldByName('fechainicioejecucion').AsString);
            JsonTrabajoGrado.AddPair('estadoproyecto',
              QtrabajosGrado.FieldByName('estadoproyecto').AsString);

            noTerminados.Add(JsonTrabajoGrado);
            QtrabajosGrado.Next;
          end;
          jsonDocente.AddPair('noTerminados', noTerminados);

          if (Terminados.Count > 0) or (noTerminados.Count > 0) then
            Docentes.Add(jsonDocente);

          QDocentes.Next;
        end;

        JsonContrato.AddPair('Docentes', Docentes);
        Contratos.AddElement(JsonContrato);
        QContratos.Next;
      end;

      JsonContratos.AddPair('Contratos', Contratos);
    end
    else
    begin
      JsonContratos.AddPair(JsonRespuesta, AccesoDenegado);
    end;
  except
    on E: Exception do
      JsonContratos.AddPair('Error', E.Message);
  end;

  Result := JsonContratos;
  QContratos.Free;
  QDocentes.Free;
  QtrabajosGrado.Free;
end;

function TMatematicas.eventoEMEM(IdEvento: string): TJSONObject;
begin
  Result := moduloEventoEMEM.getEventoEMEM(IdEvento);
end;

function TMatematicas.eventosEMEM: TJSONObject;
begin
  Result := moduloEventoEMEM.getEventosEMEM;
end;

function TMatematicas.extractYearFromDate(fecha: string): word;
var
  fs: TFormatSettings;
  dFecha: TDate;
  yy, mm, dd: word;
begin
  fs := TFormatSettings.create;
  fs.DateSeparator := '-';
  fs.ShortDateFormat := 'yyyy-mm-dd';

  dFecha := StrToDate(fecha, fs);

  DecodeDate(dFecha, yy, mm, dd);

  Result := yy;
end;

function TMatematicas.factorCalidad(ID: string): TJSONObject;
var
  Query: TFDQuery;
  JsonResp: TJSONObject;
  aFuentes: TJSONArray;
  i: integer;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    JsonResp := TJSONObject.create;
    aFuentes := TJSONArray.create;

    Query.Close;
    Query.SQL.Text :=
      'SELECT * FROM siap_factor_calidad_pm WHERE idfactorcalidad=' + #39
      + ID + #39;
    Query.Open;

    JsonResp.AddPair('idfactorcalidad', Query.FieldByName('idfactorcalidad')
      .AsString);
    JsonResp.AddPair('factor', Query.FieldByName('factor').AsString);
    JsonResp.AddPair('orden', Query.FieldByName('orden').AsString);

  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  Query.Free;
end;

function TMatematicas.factoresCalidad: TJSONObject;
var
  QFactores: TFDQuery;
  JsonFactores, JsonFactor: TJSONObject;
  Factores: TJSONArray;
  i: integer;
begin
  try
    QFactores := TFDQuery.create(nil);
    QFactores.Connection := Conexion;

    JsonFactores := TJSONObject.create;
    Factores := TJSONArray.create;

    QFactores.Close;
    QFactores.SQL.Text := 'SELECT * FROM siap_factor_calidad_pm ORDER BY orden';
    QFactores.Open;
    QFactores.First;

    for i := 1 to QFactores.RecordCount do
    begin
      JsonFactor := TJSONObject.create;
      JsonFactor.AddPair('idfactorcalidad',
        QFactores.FieldByName('idfactorcalidad').AsString);
      JsonFactor.AddPair('factor', QFactores.FieldByName('factor').AsString);
      JsonFactor.AddPair('orden', QFactores.FieldByName('orden').AsString);

      Factores.AddElement(JsonFactor);
      QFactores.Next;
    end;

    JsonFactores.AddPair('Factores', Factores);
  except
    on E: Exception do
      JsonFactores.AddPair('Error', E.Message);
  end;

  Result := JsonFactores;
  QFactores.Free;
end;

{ Método Delete - DesasociarAgenda }
function TMatematicas.cancelDesasociarAgenda(const token: string;
  const IdServicioPrograma: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_agendas_servicios', 'idservicioprograma',
        Texto(IdServicioPrograma), Query);

      Json.AddPair(JsonRespuesta,
        'El Servicio se eliminó de la agenda correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'cancelDesasociarAgenda',
        E.Message + '=> ' + IdServicioPrograma);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelAgendaServicio', Json.toString);
  Query.Free;
end;

{ Método DELETE - AgendaServicio }
function TMatematicas.cancelAgendaServicio(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_agendas_servicios', 'idagendaservicio', Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'El Servicio se eliminó de la agenda correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteAgendaServicio',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelAgendaServicio', Json.toString);
  Query.Free;
end;

{ Método UPDATE - AgendaServicio }
function TMatematicas.acceptAgendaNumeroContrato(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('UPDATE siap_agendas_servicios SET ');
      Query.SQL.Add('numerocontrato=:numerocontrato, ');
      Query.SQL.Add('actaprograma=:actaprograma, ');
      Query.SQL.Add('actafacultad=:actafacultad, ');
      Query.SQL.Add('concertada=:concertada, ');
      Query.SQL.Add('completada=:completada ');
      Query.SQL.Add('WHERE iddocente=' + datos.GetValue('iddocente').Value +
        ' AND periodo=' + #39 + datos.GetValue('periodo').Value + #39);

      Query.Params.ParamByName('numerocontrato').Value :=
        datos.GetValue('numerocontrato').Value;
      Query.Params.ParamByName('actaprograma').Value :=
        datos.GetValue('actaprograma').Value;
      Query.Params.ParamByName('actafacultad').Value :=
        datos.GetValue('actafacultad').Value;
      Query.Params.ParamByName('concertada').Value :=
        datos.GetValue('concertada').Value;
      Query.Params.ParamByName('completada').Value :=
        datos.GetValue('completada').Value;

      Query.ExecSQL;

      Json.AddPair(JsonRespuesta, 'La agenda se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptAgendaServicio',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateAgendaServicio', Json.toString);
  Query.Free;
end;

function TMatematicas.acceptAgendaServicio(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idagendaservicio', 'String');
      agregarParametro('iddocente', 'Integer');
      agregarParametro('idservicioprograma', 'String');
      agregarParametro('periodo', 'String');

      ID := datos.GetValue('idagendaservicio').Value;
      UPDATE('siap_agendas_servicios', 'idagendaservicio', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Servicio se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptAgendaServicio',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateAgendaServicio', Json.toString);
  Query.Free;
end;

{ Método INSERT - HorarioServicio }
function TMatematicas.updateHorarioServicio(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  iniA, finA, horas: integer;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idhorarioservicio', 'String');
      agregarParametro('dia', 'String');
      agregarParametro('inicio', 'String');
      agregarParametro('fin', 'String');
      agregarParametro('salon', 'String');
      agregarParametro('idservicioprograma', 'String');

      INSERT('siap_horarios_servicios', Query);

      asignarDatos(datos, Query);

      // Actualizar las horas del servicio
      iniA := FHoras.IndexOf(datos.GetValue('inicio').Value);
      finA := FHoras.IndexOf(datos.GetValue('fin').Value);
      horas := abs(finA - iniA);

      Query.Close;
      Query.SQL.Text := 'SELECT horas FROM siap_servicios_programas WHERE ' +
        'idservicioprograma=' + #39 + datos.GetValue('idservicioprograma')
        .Value + #39;;
      Query.Open;
      horas := horas + Query.FieldByName('horas').AsInteger;

      Query.Close;
      Query.SQL.Text := 'UPDATE siap_servicios_programas SET horas=:horas' +
        ' WHERE idservicioprograma=' + #39 +
        datos.GetValue('idservicioprograma').Value + #39;
      Query.Params.ParamByName('horas').Value := horas;
      Query.ExecSQL;

      Json.AddPair(JsonRespuesta, 'El Horario se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateHorarioServicio',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateHorarioServicio', Json.toString);
  Query.Free;
end;

{ Método GET - HorarioServicio }
function TMatematicas.HorarioServicio(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_horarios_servicios', 'idhorarioservicio',
      Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idhorarioservicio', 'String');
    agregarParametro('dia', 'String');
    agregarParametro('inicio', 'String');
    agregarParametro('fin', 'String');
    agregarParametro('salon', 'String');
    agregarParametro('idservicioprograma', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getHorarioServicio',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('HorarioServicio', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - HorarioServicio }
function TMatematicas.HorariosServicio(const IdSercicioPrograma: string)
  : TJSONObject;
var
  Json, JsonHoras: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
  horas, totalHoras: integer;
  hIni, hFin: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('HorariosServicios', ArrayJson);

    limpiarConsulta(Query);
    SelectWhereOrder('siap_horarios_servicios', 'idservicioprograma', 'dia',
      Texto(IdSercicioPrograma), Query);

    limpiarParametros;
    agregarParametro('idhorarioservicio', 'String');
    agregarParametro('dia', 'String');
    agregarParametro('inicio', 'String');
    agregarParametro('fin', 'String');
    agregarParametro('salon', 'String');
    agregarParametro('idservicioprograma', 'String');

    totalHoras := 0;

    for i := 1 to Query.RecordCount do
    begin
      JsonHoras := TJSONObject.create;
      JsonHoras := crearJSON(Query);

      hIni := Query.FieldByName('inicio').AsString;
      hFin := Query.FieldByName('fin').AsString;

      horas := FHoras.IndexOf(hFin) - FHoras.IndexOf(hIni);
      totalHoras := totalHoras + horas;

      JsonHoras.AddPair('total', IntToStr(horas));
      ArrayJson.AddElement(JsonHoras);

      Query.Next;
    end;

    Json.AddPair('totalHoras', IntToStr(totalHoras));

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllHorarioServicio',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('HorariosServicio', Json.toString);
  Query.Free;
end;

{ Método DELETE - HorarioServicio }
function TMatematicas.cancelHorarioServicio(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  IdServicioPrograma: string;
  iniA, finA, horas: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      // Actualizar las horas en el servicio programa
      Query.Close;
      Query.SQL.Text := 'SELECT * FROM siap_horarios_servicios WHERE ' +
        'idhorarioservicio=' + #39 + ID + #39;
      Query.Open;

      IdServicioPrograma := Query.FieldByName('idservicioprograma').AsString;
      iniA := FHoras.IndexOf(Query.FieldByName('inicio').AsString);
      finA := FHoras.IndexOf(Query.FieldByName('fin').AsString);
      horas := abs(finA - iniA);

      // Se borran las horas
      limpiarConsulta(Query);
      DELETE('siap_horarios_servicios', 'idhorarioservicio', Texto(ID), Query);

      // Se actualizan las horas en servicio programa
      Query.Close;
      Query.SQL.Text := 'SELECT horas FROM siap_servicios_programas WHERE ' +
        'idservicioprograma=' + #39 + IdServicioPrograma + #39;
      Query.Open;
      horas := Query.FieldByName('horas').AsInteger - horas;

      // Reasignas las horas del servicio (materia)
      Query.Close;
      Query.SQL.Text := 'UPDATE siap_servicios_programas SET horas=:horas ' +
        ' WHERE idservicioprograma=' + #39 + IdServicioPrograma + #39;
      Query.Params.ParamByName('horas').Value := horas;
      Query.ExecSQL;

      Json.AddPair(JsonRespuesta, 'El Horario se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteHorarioServicio',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelHorarioServicio', Json.toString);
  Query.Free;
end;

{ Método UPDATE - HorarioServicio }
function TMatematicas.acceptHorarioServicio(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idhorarioservicio', 'String');
      agregarParametro('dia', 'String');
      agregarParametro('inicio', 'String');
      agregarParametro('fin', 'String');
      agregarParametro('salon', 'String');
      agregarParametro('idservicioprograma', 'String');

      ID := datos.GetValue('idhorarioservicio').Value;
      UPDATE('siap_horarios_servicios', 'idhorarioservicio', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Horario se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptHorarioServicio',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateHorarioServicio', Json.toString);
  Query.Free;
end;

{ Método INSERT - ServicioPrograma }
function TMatematicas.updateSeminario(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  fs: TFormatSettings;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('INSERT INTO siap_seminario (');
    Query.SQL.Add('idseminario, ');
    Query.SQL.Add('semestre, ');
    Query.SQL.Add('numero, ');
    Query.SQL.Add('fecha, ');
    Query.SQL.Add('conferencista, ');
    Query.SQL.Add('titulo, ');
    Query.SQL.Add('resumen, ');
    Query.SQL.Add('origen_conferencista, ');
    Query.SQL.Add('grupo_dependencia, ');
    Query.SQL.Add('pais_origen, ');
    Query.SQL.Add('area_profundizacion, ');
    Query.SQL.Add('modalidad, ');
    Query.SQL.Add('graduados, ');
    Query.SQL.Add('estudiantes, ');
    Query.SQL.Add('nacional, ');
    Query.SQL.Add('internacional, ');
    Query.SQL.Add('lugar, ');
    Query.SQL.Add('youtube, ');
    Query.SQL.Add('evidencias ) VALUES (');
    Query.SQL.Add(':idseminario, ');
    Query.SQL.Add(':semestre, ');
    Query.SQL.Add(':numero, ');
    Query.SQL.Add(':fecha, ');
    Query.SQL.Add(':conferencista, ');
    Query.SQL.Add(':titulo, ');
    Query.SQL.Add(':resumen, ');
    Query.SQL.Add(':origen_conferencista, ');
    Query.SQL.Add(':grupo_dependencia, ');
    Query.SQL.Add(':pais_origen, ');
    Query.SQL.Add(':area_profundizacion, ');
    Query.SQL.Add(':modalidad, ');
    Query.SQL.Add(':graduados, ');
    Query.SQL.Add(':estudiantes, ');
    Query.SQL.Add(':nacional, ');
    Query.SQL.Add(':internacional, ');
    Query.SQL.Add(':lugar, ');
    Query.SQL.Add(':youtube, ');
    Query.SQL.Add(':evidencias )');

    Query.Params.ParamByName('idseminario').Value := moduloDatos.generarID;
    Query.Params.ParamByName('semestre').Value :=
      datos.GetValue('semestre').Value;
    Query.Params.ParamByName('numero').Value :=
      StrToInt(datos.GetValue('numero').Value);
    Query.Params.ParamByName('fecha').Value :=
      StrToDate(datos.GetValue('fecha').Value, fs);
    Query.Params.ParamByName('conferencista').Value :=
      datos.GetValue('conferencista').Value;
    Query.Params.ParamByName('titulo').Value := datos.GetValue('titulo').Value;
    Query.Params.ParamByName('resumen').Value :=
      datos.GetValue('resumen').Value;
    Query.Params.ParamByName('origen_conferencista').Value :=
      datos.GetValue('origen_conferencista').Value;
    Query.Params.ParamByName('grupo_dependencia').Value :=
      datos.GetValue('grupo_dependencia').Value;
    Query.Params.ParamByName('pais_origen').Value :=
      datos.GetValue('pais_origen').Value;
    Query.Params.ParamByName('area_profundizacion').Value :=
      datos.GetValue('area_profundizacion').Value;
    Query.Params.ParamByName('modalidad').Value :=
      datos.GetValue('modalidad').Value;
    Query.Params.ParamByName('graduados').Value :=
      StrToInt(datos.GetValue('graduados').Value);
    Query.Params.ParamByName('estudiantes').Value :=
      StrToInt(datos.GetValue('estudiantes').Value);
    Query.Params.ParamByName('nacional').Value :=
      StrToInt(datos.GetValue('nacional').Value);
    Query.Params.ParamByName('internacional').Value :=
      StrToInt(datos.GetValue('internacional').Value);
    Query.Params.ParamByName('lugar').Value := datos.GetValue('lugar').Value;
    Query.Params.ParamByName('youtube').Value :=
      datos.GetValue('youtube').Value;
    Query.Params.ParamByName('evidencias').Value :=
      datos.GetValue('evidencias').Value;

    Query.ExecSQL;

    Json.AddPair(JSON_RESPONSE, 'El evento se creo correctamente');
    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(json_register, datos);
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.updateServicioPrograma(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idservicioprograma', 'String');
      agregarParametro('asignatura', 'String');
      agregarParametro('idprograma', 'String');
      agregarParametro('horas', 'Integer');
      agregarParametro('aulas', 'String');
      agregarParametro('periodo', 'String');
      agregarParametro('semanas', 'Integer');
      agregarParametro('jornada', 'String');
      agregarParametro('grupo', 'String');
      agregarParametro('tipo', 'String');

      INSERT('siap_servicios_programas', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Servicio se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateServicioPrograma',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateServicioPrograma', Json.toString);
  Query.Free;
end;

{ Método GET - ServicioPrograma }
function TMatematicas.ServicioPrograma(const ID: string): TJSONObject;
var
  Json, JsonServicio: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    Query.SQL.Add('select * from siap_servicios_programas as s ');
    Query.SQL.Add('inner join siap_programas as p ');
    Query.SQL.Add('on s.idprograma = p.idprograma WHERE idservicioprograma=' +
      Texto(ID));
    Query.Open;

    limpiarParametros;
    agregarParametro('idservicioprograma', 'String');
    agregarParametro('asignatura', 'String');
    agregarParametro('idprograma', 'String');
    agregarParametro('aulas', 'String');
    agregarParametro('periodo', 'String');
    agregarParametro('semanas', 'Integer');
    agregarParametro('programa', 'String');
    agregarParametro('jornada', 'String');
    agregarParametro('grupo', 'String');
    agregarParametro('tipo', 'String');

    JsonServicio := TJSONObject.create;
    JsonServicio := crearJSON(Query);

    { Se calculan las horas a través de una función que leer los horarios. En el
      caso de Virtual o distancia envia las horas del curso por semestre }
    JsonServicio.AddPair('horas', obtenerHorasServicio(ID));
    Json := JsonServicio;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getServicioPrograma',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('ServicioPrograma', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - ServicioPrograma }
function TMatematicas.ServiciosPrograma(const OrdenarPor: string;
  const Periodo: string): TJSONObject;
var
  Json, JsonHorario, JsonTemp: TJSONObject;
  Query, Query2, Query3: TFDQuery;
  ArrayJson, ArrayHorario: TJSONArray;
  JsonLinea: TJSONObject;
  i, j, horasSemestre, hIni, hFin, total, totalHoras, ld,
    semanasSemestre: integer;
  inicio, fin, Jornada: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  Query2 := TFDQuery.create(nil);
  Query2.Connection := Conexion;
  Query3 := TFDQuery.create(nil);
  Query3.Connection := Conexion;

  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('ServiciosProgramas', ArrayJson);

    limpiarConsulta(Query);
    Query.SQL.Add('select * from siap_servicios_programas as s ');
    Query.SQL.Add('inner join siap_programas as p ');
    Query.SQL.Add('on s.idprograma = p.idprograma WHERE periodo=' +
      Texto(Periodo) + ' ORDER BY ' + OrdenarPor);
    Query.Open;

    limpiarParametros;
    agregarParametro('idservicioprograma', 'String');
    agregarParametro('asignatura', 'String');
    agregarParametro('idprograma', 'String');
    agregarParametro('aulas', 'String');
    agregarParametro('periodo', 'String');
    agregarParametro('programa', 'String');
    agregarParametro('semanas', 'Integer');
    agregarParametro('jornada', 'String');
    agregarParametro('grupo', 'String');
    agregarParametro('tipo', 'String');

    for i := 1 to Query.RecordCount do
    begin
      JsonTemp := TJSONObject.create;
      JsonTemp := crearJSON(Query);

      Query2.Close;
      Query2.SQL.Text :=
        'SELECT * FROM siap_horarios_servicios WHERE idservicioprograma=' +
        Texto(Query.FieldByName('idservicioprograma').AsString);
      Query2.Open;
      Query2.First;

      Jornada := Query.FieldByName('jornada').AsString;
      semanasSemestre := Query.FieldByName('semanas').AsInteger;

      // Obtener los horarios. Si es virtual omite el proceso de leer los horarios
      if Jornada <> 'virtual' then
      begin

        ArrayHorario := TJSONArray.create;
        totalHoras := 0;
        for j := 1 to Query2.RecordCount do
        begin
          inicio := Query2.FieldByName('inicio').AsString;
          fin := Query2.FieldByName('fin').AsString;

          hIni := FHoras.IndexOf(inicio);
          hFin := FHoras.IndexOf(fin);
          total := hFin - hIni;
          totalHoras := totalHoras + total;

          JsonHorario := TJSONObject.create;
          JsonHorario.AddPair('idhorarioservicio',
            Query2.FieldByName('idhorarioservicio').AsString);
          JsonHorario.AddPair('dia', Query2.FieldByName('dia').AsString);
          JsonHorario.AddPair('inicio', inicio);
          JsonHorario.AddPair('fin', fin);
          JsonHorario.AddPair('total', IntToStr(total));
          JsonHorario.AddPair('salon', Query2.FieldByName('salon').AsString);
          JsonHorario.AddPair('idservicioprograma',
            Query2.FieldByName('idservicioprograma').AsString);

          ArrayHorario.Add(JsonHorario);
          Query2.Next;
        end;

        if Jornada <> 'distancia' then
          horasSemestre := totalHoras * semanasSemestre
        else
        begin
          totalHoras := Query.FieldByName('horas').AsInteger;
          horasSemestre := Query.FieldByName('horas').AsInteger;
        end;
      end
      else
      begin
        totalHoras := Query.FieldByName('horas').AsInteger;
        horasSemestre := totalHoras;
      end;

      { Determinar quien tomo éste servicio }
      Query3.Close;
      Query3.SQL.Text := 'SELECT nombre FROM siap_agendas_servicios as ag ' +
        'INNER JOIN siap_docentes as d ' +
        'ON ag.iddocente = d.iddocente WHERE ag.idservicioprograma=' + #39 +
        Query.FieldByName('idservicioprograma').AsString + #39;
      Query3.Open;

      JsonTemp.AddPair('horas', IntToStr(totalHoras));
      JsonTemp.AddPair('horasSemestre', IntToStr(horasSemestre));
      if Query.FieldByName('jornada').AsString <> 'virtual' then
        JsonTemp.AddPair('horarios', ArrayHorario);
      JsonTemp.AddPair('docente', Query3.FieldByName('nombre').AsString);

      ArrayJson.AddElement(JsonTemp);
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllServicioPrograma',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('ServiciosPrograma', Json.toString);
  Query.Free;
  Query2.Free;
  Query3.Free;
end;

function TMatematicas.ServiciosProgramaDocente(const IdDocente, Periodo: string)
  : TJSONObject;
var
  Json, JsonHorario, JsonTemp: TJSONObject;
  Query, Query2, Query3: TFDQuery;
  ArrayJson, ArrayHorario: TJSONArray;
  JsonLinea: TJSONObject;
  i, j, total, TotalSemana, HorasDocencia, Semanas: integer;
  inicio, fin: string;
  validacion: TValidacion;
  Observacion, IdServicioPrograma, contrato: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  Query2 := TFDQuery.create(nil);
  Query2.Connection := Conexion;
  Query3 := TFDQuery.create(nil);
  Query3.Connection := Conexion;

  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('ServiciosProgramas', ArrayJson);

    { Leer los servicios del programa para el periodo especificado, esto genera
      una lista de servicios (materias las cuales se deben validar, que profesor
      ya la ha tomado y si se le cruzan al profesor que se envia como paramétro) }

    limpiarConsulta(Query);
    Query.SQL.Add('SELECT * FROM siap_servicios_programas AS s ');
    Query.SQL.Add('INNER JOIN siap_programas AS p ');
    Query.SQL.Add('ON s.idprograma = p.idprograma WHERE periodo=' +
      Texto(Periodo) + ' ORDER BY programa');

    FDataSnapMatematicas.escribirSQL
      ('/* Consulta de servicios de programas */');
    FDataSnapMatematicas.escribirSQL(Query.SQL.Text);
    Query.Open;

    limpiarParametros;
    agregarParametro('idservicioprograma', 'String');
    agregarParametro('asignatura', 'String');
    agregarParametro('idprograma', 'String');
    agregarParametro('horas', 'String');
    agregarParametro('aulas', 'String');
    agregarParametro('periodo', 'String');
    agregarParametro('programa', 'String');
    agregarParametro('semanas', 'Integer');
    agregarParametro('jornada', 'String');
    agregarParametro('grupo', 'String');
    agregarParametro('tipo', 'String');

    { Hacer un ciclo para recorrer todos los servicios o materias obtenidos }
    for i := 1 to Query.RecordCount do
    begin
      JsonTemp := TJSONObject.create;
      JsonTemp := crearJSON(Query);

      // Se obtiene el parámetro de semanas
      Semanas := Query.FieldByName('semanas').AsInteger;

      // Se obtiene el ID del Servicio para realizar otras consultas
      IdServicioPrograma := Query.FieldByName('idservicioprograma').AsString;

      { Se extraen las horas del servicio para realizar validaciones }
      Query2.Close;
      Query2.SQL.Text :=
        'SELECT * FROM siap_horarios_servicios WHERE idservicioprograma=' +
        Texto(IdServicioPrograma);
      Query2.Open;
      Query2.First;

      ArrayHorario := TJSONArray.create;
      TotalSemana := 0;

      { Se crea un arreglo de las horas del servicio para mostrarlas en la tabla }
      for j := 1 to Query2.RecordCount do
      begin
        inicio := Query2.FieldByName('inicio').AsString;
        fin := Query2.FieldByName('fin').AsString;
        total := (FHoras.IndexOf(fin) - FHoras.IndexOf(inicio));
        TotalSemana := TotalSemana + total;

        JsonHorario := TJSONObject.create;
        JsonHorario.AddPair('idhorarioservicio',
          Query2.FieldByName('idhorarioservicio').AsString);
        JsonHorario.AddPair('dia', Query2.FieldByName('dia').AsString);
        JsonHorario.AddPair('inicio', inicio);
        JsonHorario.AddPair('fin', fin);
        JsonHorario.AddPair('total', IntToStr(total));
        JsonHorario.AddPair('salon', Query2.FieldByName('salon').AsString);
        JsonHorario.AddPair('idservicioprograma',
          Query2.FieldByName('idservicioprograma').AsString);

        ArrayHorario.Add(JsonHorario);
        Query2.Next;
      end;

      { Determinar quien tomo éste servicio }
      Observacion := obtenerDocenteServicio(IdServicioPrograma, Periodo);

      { Determinar si se le cruza éste horario, Si NO fue tomado por otro docente }
      validacion.Cruces := 0;
      validacion.Observacion := '';
      if Observacion = '' then
      begin
        validacion := validarHorario(IdDocente, IdServicioPrograma, Periodo);
        Observacion := validacion.Observacion;
      end;

      { Determinar si el curso tiene mas horas de las que se pueden }
      if Observacion = '' then
      begin

        Query3.Close;
        Query3.SQL.Clear;
        Query3.SQL.Add('SELECT * FROM siap_docentes as d ');
        Query3.SQL.Add('INNER JOIN siap_tipo_contrato as t ');
        Query3.SQL.Add('ON d.idtipocontrato = t.idtipocontrato ');
        Query3.SQL.Add('WHERE iddocente=' + IdDocente);
        Query3.Open;

        FDataSnapMatematicas.escribirSQL(Query3.SQL.Text);

        total := Query3.FieldByName('horas').AsInteger;
        HorasDocencia := validacion.HorasDocencia;

        TotalSemana := TotalSemana * Semanas;

        contrato := Query3.FieldByName('contrato').AsString;
        if (contrato = 'catedrático') then
        begin

          if (HorasDocencia + TotalSemana) > total then
            Observacion := 'Excede las horas permitidas';
        end;
      end;

      JsonTemp.AddPair('horarios', ArrayHorario);
      JsonTemp.AddPair('observacion', Observacion);
      JsonTemp.AddPair('horasServicios', IntToStr(validacion.HorasServicio));
      JsonTemp.AddPair('cruces', IntToStr(validacion.Cruces));

      ArrayJson.AddElement(JsonTemp);
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now),
        'getAllServicioProgramaDocente', E.Message + ' -no data- ');
    end;
  end;

  Result := Json;
  escribirMensaje('ServiciosPrograma', Json.toString);
  Query.Free;
  Query2.Free;
  Query3.Free;
end;

{ Método DELETE - ServicioPrograma }
function TMatematicas.cancelSeminario(IdSeminario: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'DELETE FROM siap_seminario WHERE idseminario=' + #39 +
      IdSeminario + #39;
    Query.ExecSQL;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESPONSE, 'El evento se elimino correctamente');

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.cancelServicioPrograma(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_servicios_programas', 'idservicioprograma',
        Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'El Servicio se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteServicioPrograma',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelServicioPrograma', Json.toString);
  Query.Free;
end;

{ Método UPDATE - ServicioPrograma }
function TMatematicas.acceptSeminario(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  fs: TFormatSettings;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('UPDATE siap_seminario SET ');
    Query.SQL.Add('semestre=:semestre, ');
    Query.SQL.Add('numero=:numero, ');
    Query.SQL.Add('fecha=:fecha, ');
    Query.SQL.Add('conferencista=:conferencista, ');
    Query.SQL.Add('titulo=:titulo, ');
    Query.SQL.Add('resumen=:resumen, ');
    Query.SQL.Add('origen_conferencista=:origen_conferencista, ');
    Query.SQL.Add('grupo_dependencia=:grupo_dependencia, ');
    Query.SQL.Add('pais_origen=:pais_origen, ');
    Query.SQL.Add('area_profundizacion=:area_profundizacion, ');
    Query.SQL.Add('modalidad=:modalidad, ');
    Query.SQL.Add('graduados=:graduados, ');
    Query.SQL.Add('estudiantes=:estudiantes, ');
    Query.SQL.Add('nacional=:nacional, ');
    Query.SQL.Add('internacional=:internacional, ');
    Query.SQL.Add('lugar=:lugar, ');
    Query.SQL.Add('youtube=:youtube, ');
    Query.SQL.Add('evidencias=:evidencias WHERE idseminario=' + #39 +
      datos.GetValue('idseminario').Value + #39);

    Query.Params.ParamByName('semestre').Value :=
      datos.GetValue('semestre').Value;
    Query.Params.ParamByName('numero').Value :=
      StrToInt(datos.GetValue('numero').Value);
    Query.Params.ParamByName('fecha').Value :=
      StrToDate(datos.GetValue('fecha').Value, fs);
    Query.Params.ParamByName('conferencista').Value :=
      datos.GetValue('conferencista').Value;
    Query.Params.ParamByName('titulo').Value := datos.GetValue('titulo').Value;
    Query.Params.ParamByName('resumen').Value :=
      datos.GetValue('resumen').Value;
    Query.Params.ParamByName('origen_conferencista').Value :=
      datos.GetValue('origen_conferencista').Value;
    Query.Params.ParamByName('grupo_dependencia').Value :=
      datos.GetValue('grupo_dependencia').Value;
    Query.Params.ParamByName('pais_origen').Value :=
      datos.GetValue('pais_origen').Value;
    Query.Params.ParamByName('area_profundizacion').Value :=
      datos.GetValue('area_profundizacion').Value;
    Query.Params.ParamByName('modalidad').Value :=
      datos.GetValue('modalidad').Value;
    Query.Params.ParamByName('graduados').Value :=
      StrToInt(datos.GetValue('graduados').Value);
    Query.Params.ParamByName('estudiantes').Value :=
      StrToInt(datos.GetValue('estudiantes').Value);
    Query.Params.ParamByName('nacional').Value :=
      StrToInt(datos.GetValue('nacional').Value);
    Query.Params.ParamByName('internacional').Value :=
      StrToInt(datos.GetValue('internacional').Value);
    Query.Params.ParamByName('lugar').Value := datos.GetValue('lugar').Value;
    Query.Params.ParamByName('youtube').Value :=
      datos.GetValue('youtube').Value;
    Query.Params.ParamByName('evidencias').Value :=
      datos.GetValue('evidencias').Value;

    Query.ExecSQL;

    Json.AddPair(JSON_RESPONSE, 'El evento se actualizo correctamente');
    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(json_register, datos);

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.acceptServicioPrograma(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idservicioprograma', 'String');
      agregarParametro('asignatura', 'String');
      agregarParametro('idprograma', 'String');
      agregarParametro('horas', 'Integer');
      agregarParametro('aulas', 'String');
      agregarParametro('periodo', 'String');
      agregarParametro('semanas', 'Integer');
      agregarParametro('jornada', 'String');
      agregarParametro('grupo', 'String');
      agregarParametro('tipo', 'String');

      ID := datos.GetValue('idservicioprograma').Value;
      UPDATE('siap_servicios_programas', 'idservicioprograma',
        Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Servicio se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptServicioPrograma',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateServicioPrograma', Json.toString);
  Query.Free;
end;

{ Método INSERT - Programa }
function TMatematicas.updatePresupuestoPm(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    if validarTokenHeader then
    begin
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('INSERT INTO siap_presupuesto_pm (');
      Query.SQL.Add('idpresupuesto, ');
      Query.SQL.Add('idplan, ');
      Query.SQL.Add('idfecha, ');
      Query.SQL.Add('descripcion, ');
      Query.SQL.Add('valor) VALUES (');
      Query.SQL.Add(':idpresupuesto, ');
      Query.SQL.Add(':idplan, ');
      Query.SQL.Add(':idfecha, ');
      Query.SQL.Add(':descripcion, ');
      Query.SQL.Add(':valor)');

      Query.Params.ParamByName('idpresupuesto').Value := moduloDatos.generarID;
      Query.Params.ParamByName('idplan').Value :=
        datos.GetValue('idplan').Value;
      Query.Params.ParamByName('idfecha').Value :=
        datos.GetValue('idfecha').Value;
      Query.Params.ParamByName('descripcion').Value :=
        datos.GetValue('descripcion').Value;
      Query.Params.ParamByName('valor').Value :=
        StrToInt(datos.GetValue('valor').Value);
      Query.ExecSQL;

      Json.AddPair(JSON_RESPONSE, 'El presupuesto se creo correctamente');
      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, AccesoDenegado);
    end;
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.updateProducto(ProduccionDocente: TJSONObject)
  : TJSONObject;
var
  QProduccionDocente: TFDQuery;
  JsonResp: TJSONObject;
  token: string;
begin
  try
    QProduccionDocente := TFDQuery.create(nil);
    QProduccionDocente.Connection := Conexion;

    JsonResp := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QProduccionDocente.Close;
      QProduccionDocente.SQL.Clear;
      QProduccionDocente.SQL.Add('INSERT INTO siap_produccion_docente (');
      QProduccionDocente.SQL.Add('ciudad, ');
      QProduccionDocente.SQL.Add('editorial, ');
      QProduccionDocente.SQL.Add('fecha, ');
      QProduccionDocente.SQL.Add('fecha_fin, ');
      QProduccionDocente.SQL.Add('fecha_inicio, ');
      QProduccionDocente.SQL.Add('iddocente, ');
      QProduccionDocente.SQL.Add('idproduccion, ');
      QProduccionDocente.SQL.Add('idtipo, ');
      QProduccionDocente.SQL.Add('institucion, ');
      QProduccionDocente.SQL.Add('isbn, ');
      QProduccionDocente.SQL.Add('issn, ');
      QProduccionDocente.SQL.Add('numero, ');
      QProduccionDocente.SQL.Add('registro, ');
      QProduccionDocente.SQL.Add('revista, ');
      QProduccionDocente.SQL.Add('titulo, ');
      QProduccionDocente.SQL.Add('volumen) VALUES (');

      QProduccionDocente.SQL.Add(':ciudad, ');
      QProduccionDocente.SQL.Add(':editorial, ');
      QProduccionDocente.SQL.Add(':fecha, ');
      QProduccionDocente.SQL.Add(':fecha_fin, ');
      QProduccionDocente.SQL.Add(':fecha_inicio, ');
      QProduccionDocente.SQL.Add(':iddocente, ');
      QProduccionDocente.SQL.Add(':idproduccion, ');
      QProduccionDocente.SQL.Add(':idtipo, ');
      QProduccionDocente.SQL.Add(':institucion, ');
      QProduccionDocente.SQL.Add(':isbn, ');
      QProduccionDocente.SQL.Add(':issn, ');
      QProduccionDocente.SQL.Add(':numero, ');
      QProduccionDocente.SQL.Add(':registro, ');
      QProduccionDocente.SQL.Add(':revista, ');
      QProduccionDocente.SQL.Add(':titulo, ');
      QProduccionDocente.SQL.Add(':volumen)');

      QProduccionDocente.Params.ParamByName('ciudad').Value :=
        ProduccionDocente.GetValue('ciudad').Value;
      QProduccionDocente.Params.ParamByName('editorial').Value :=
        ProduccionDocente.GetValue('editorial').Value;
      QProduccionDocente.Params.ParamByName('fecha').Value :=
        ProduccionDocente.GetValue('fecha').Value;
      QProduccionDocente.Params.ParamByName('fecha_fin').Value :=
        ProduccionDocente.GetValue('fecha_fin').Value;
      QProduccionDocente.Params.ParamByName('fecha_inicio').Value :=
        ProduccionDocente.GetValue('fecha_inicio').Value;
      QProduccionDocente.Params.ParamByName('iddocente').Value :=
        ProduccionDocente.GetValue('iddocente').Value;
      QProduccionDocente.Params.ParamByName('idproduccion').Value :=
        moduloDatos.generarID;
      QProduccionDocente.Params.ParamByName('idtipo').Value :=
        ProduccionDocente.GetValue('idtipo').Value;
      QProduccionDocente.Params.ParamByName('institucion').Value :=
        ProduccionDocente.GetValue('institucion').Value;
      QProduccionDocente.Params.ParamByName('isbn').Value :=
        ProduccionDocente.GetValue('isbn').Value;
      QProduccionDocente.Params.ParamByName('issn').Value :=
        ProduccionDocente.GetValue('issn').Value;
      QProduccionDocente.Params.ParamByName('numero').Value :=
        ProduccionDocente.GetValue('numero').Value;
      QProduccionDocente.Params.ParamByName('registro').Value :=
        ProduccionDocente.GetValue('registro').Value;
      QProduccionDocente.Params.ParamByName('revista').Value :=
        ProduccionDocente.GetValue('revista').Value;
      QProduccionDocente.Params.ParamByName('titulo').Value :=
        ProduccionDocente.GetValue('titulo').Value;
      QProduccionDocente.Params.ParamByName('volumen').Value :=
        ProduccionDocente.GetValue('volumen').Value;

      QProduccionDocente.ExecSQL;

      JsonResp.AddPair('Respuesta',
        'El ProduccionDocente se creo correctamente');
    end
    else
    begin
      JsonResp.AddPair(JsonRespuesta, AccesoDenegado);
    end;
  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  QProduccionDocente.Free;
end;

function TMatematicas.updatePrograma(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idprograma', 'String');
      agregarParametro('programa', 'String');
      agregarParametro('idfacultad', 'String');

      INSERT('siap_programas', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Programa se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updatePrograma',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updatePrograma', Json.toString);
  Query.Free;
end;

{ Método GET - Programa }
function TMatematicas.PlanesMejoramiento: TJSONObject;
var
  QPlanes: TFDQuery;
  JsonPlanes, JsonPlan: TJSONObject;
  Planes: TJSONArray;
  i: integer;
  ID: string;
  fs: TFormatSettings;
begin
  try
    QPlanes := TFDQuery.create(nil);
    QPlanes.Connection := Conexion;

    JsonPlanes := TJSONObject.create;
    Planes := TJSONArray.create;

    fs := TFormatSettings.create;
    fs.ShortDateFormat := 'yyyy-mm-dd';
    fs.DateSeparator := '-';

    QPlanes.Close;
    QPlanes.SQL.Text := 'SELECT * FROM siap_plan_mejoramiento ORDER BY orden';
    QPlanes.Open;
    QPlanes.First;

    for i := 1 to QPlanes.RecordCount do
    begin
      JsonPlan := TJSONObject.create;

      JsonPlan.AddPair('idplan', QPlanes.FieldByName('idplan').AsString);
      JsonPlan.AddPair('orden', QPlanes.FieldByName('orden').AsString);

      ID := QPlanes.FieldByName('idfuente').AsString;
      JsonPlan.AddPair('idfuente', ID);
      JsonPlan.AddPair('fuente', Fuente(ID));

      ID := QPlanes.FieldByName('idfactorcalidad').AsString;
      JsonPlan.AddPair('idfactorcalidad', ID);
      JsonPlan.AddPair('factorCalidad', factorCalidad(ID));

      ID := QPlanes.FieldByName('idrequisito').AsString;
      JsonPlan.AddPair('idrequisito', ID);
      JsonPlan.AddPair('requisito', Requisito(ID));

      ID := QPlanes.FieldByName('idtipoaccion').AsString;
      JsonPlan.AddPair('idtipoaccion', ID);
      JsonPlan.AddPair('tipoAccion', TipoAccion(ID));

      JsonPlan.AddPair('descripcion_mejora',
        QPlanes.FieldByName('descripcion_mejora').AsString);

      JsonPlan.AddPair('causas_principales',
        QPlanes.FieldByName('causas_principales').AsString);
      JsonPlan.AddPair('metas', QPlanes.FieldByName('metas').AsString);

      JsonPlan.AddPair('fecha_inicio',
        DateToStr(QPlanes.FieldByName('fecha_inicio').AsDateTime, fs));
      JsonPlan.AddPair('fecha_fin', DateToStr(QPlanes.FieldByName('fecha_fin')
        .AsDateTime, fs));

      JsonPlan.AddPair('actividades', QPlanes.FieldByName('actividades')
        .AsString);
      JsonPlan.AddPair('responsable_ejecucion',
        QPlanes.FieldByName('responsable_ejecucion').AsString);
      JsonPlan.AddPair('responsable_seguimiento',
        QPlanes.FieldByName('responsable_seguimiento').AsString);
      JsonPlan.AddPair('indicador_meta', QPlanes.FieldByName('indicador_meta')
        .AsString);
      JsonPlan.AddPair('formula_indicador',
        QPlanes.FieldByName('formula_indicador').AsString);
      JsonPlan.AddPair('resultado_indicador',
        QPlanes.FieldByName('resultado_indicador').AsString);
      JsonPlan.AddPair('avance_meta', QPlanes.FieldByName('avance_meta')
        .AsString);
      JsonPlan.AddPair('seguimiento', QPlanes.FieldByName('seguimiento')
        .AsString);
      JsonPlan.AddPair('observaciones', QPlanes.FieldByName('observaciones')
        .AsString);
      JsonPlan.AddPair('estado_actual_accion',
        QPlanes.FieldByName('estado_actual_accion').AsString);

      JsonPlan.AddPair('presupuestos',
        getPresupuestosPm(QPlanes.FieldByName('idplan').AsString));

      JsonPlan.AddPair('fechas',
        getPrespuestoByFechaPlan(QPlanes.FieldByName('idplan').AsString));

      Planes.AddElement(JsonPlan);
      QPlanes.Next;
    end;

    JsonPlanes.AddPair('Planes', Planes);
  except
    on E: Exception do
      JsonPlanes.AddPair('Error', E.Message);

  end;

  Result := JsonPlanes;
  QPlanes.Free;
end;

function TMatematicas.PlanMejoramiento(IdPlan: string): TJSONObject;
var
  QPlan: TFDQuery;
  JsonPlan: TJSONObject;
  i: integer;
  ID: string;
  fs: TFormatSettings;
begin
  try
    QPlan := TFDQuery.create(nil);
    QPlan.Connection := Conexion;

    QPlan.Close;
    QPlan.SQL.Text := 'SELECT * FROM siap_plan_mejoramiento WHERE idplan=' + #39
      + IdPlan + #39;
    QPlan.Open;

    JsonPlan := TJSONObject.create;

    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    JsonPlan.AddPair('idplan', QPlan.FieldByName('idplan').AsString);
    JsonPlan.AddPair('orden', QPlan.FieldByName('orden').AsString);

    ID := QPlan.FieldByName('idfuente').AsString;
    JsonPlan.AddPair('idfuente', ID);
    JsonPlan.AddPair('fuente', Fuente(ID));

    ID := QPlan.FieldByName('idfactorcalidad').AsString;
    JsonPlan.AddPair('idfactorcalidad', ID);
    JsonPlan.AddPair('factorCalidad', factorCalidad(ID));

    ID := QPlan.FieldByName('idrequisito').AsString;
    JsonPlan.AddPair('idrequisito', ID);
    JsonPlan.AddPair('requisito', Requisito(ID));

    ID := QPlan.FieldByName('idtipoaccion').AsString;
    JsonPlan.AddPair('idtipoaccion', ID);
    JsonPlan.AddPair('tipoAccion', TipoAccion(ID));

    JsonPlan.AddPair('descripcion_mejora',
      QPlan.FieldByName('descripcion_mejora').AsString);

    JsonPlan.AddPair('causas_principales',
      QPlan.FieldByName('causas_principales').AsString);
    JsonPlan.AddPair('metas', QPlan.FieldByName('metas').AsString);

    JsonPlan.AddPair('fecha_inicio', DateToStr(QPlan.FieldByName('fecha_inicio')
      .AsDateTime, fs));
    JsonPlan.AddPair('fecha_fin', DateToStr(QPlan.FieldByName('fecha_fin')
      .AsDateTime, fs));

    JsonPlan.AddPair('actividades', QPlan.FieldByName('actividades').AsString);
    JsonPlan.AddPair('responsable_ejecucion',
      QPlan.FieldByName('responsable_ejecucion').AsString);
    JsonPlan.AddPair('responsable_seguimiento',
      QPlan.FieldByName('responsable_seguimiento').AsString);
    JsonPlan.AddPair('indicador_meta', QPlan.FieldByName('indicador_meta')
      .AsString);
    JsonPlan.AddPair('formula_indicador', QPlan.FieldByName('formula_indicador')
      .AsString);
    JsonPlan.AddPair('resultado_indicador',
      QPlan.FieldByName('resultado_indicador').AsString);
    JsonPlan.AddPair('avance_meta', QPlan.FieldByName('avance_meta').AsString);
    JsonPlan.AddPair('seguimiento', QPlan.FieldByName('seguimiento').AsString);
    JsonPlan.AddPair('observaciones', QPlan.FieldByName('observaciones')
      .AsString);
    JsonPlan.AddPair('estado_actual_accion',
      QPlan.FieldByName('estado_actual_accion').AsString);

    JsonPlan.AddPair('presupuestos',
      getPresupuestosPm(QPlan.FieldByName('idplan').AsString));
    JsonPlan.AddPair('fechas',
      getPrespuestoByFechaPlan(QPlan.FieldByName('idplan').AsString));

  except
    on E: Exception do
      JsonPlan.AddPair('Error', E.Message);
  end;

  Result := JsonPlan;
  QPlan.Free;
end;

function TMatematicas.ponenciasEMEM(IdEvento: string): TJSONObject;
begin
  Result := moduloEventoEMEM.getPonencias(IdEvento);
end;

function TMatematicas.presupuestosPm(IdPlan: string): TJSONObject;
var
  Json, jsonpresupuesto: TJSONObject;
begin
  try
    Json := TJSONObject.create;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESPONSE, 'Los presupuestos se obtuvieron correctamente');
    Json.AddPair(JSON_RESULTS, getPresupuestosPm(IdPlan));
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
end;

function TMatematicas.Productos: TJSONObject;
var
  QProduccionDocente, QTipoProducto: TFDQuery;
  JsonProduccionDocente, JsonRegistro, JsonTipos: TJSONObject;
  aTiposProducto, aProductos: TJSONArray;
  i: integer;
  objWebModule: TWebModule;
  token, IdTipo: string;
  j: integer;
begin
  try
    QProduccionDocente := TFDQuery.create(nil);
    QProduccionDocente.Connection := Conexion;
    QTipoProducto := TFDQuery.create(nil);
    QTipoProducto.Connection := Conexion;

    JsonProduccionDocente := TJSONObject.create;
    aTiposProducto := TJSONArray.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      QTipoProducto.Close;
      QTipoProducto.SQL.Text := 'SELECT * FROM siap_tipo_produccion WHERE tipo';
      QTipoProducto.Open;
      QTipoProducto.First;

      for j := 1 to QTipoProducto.RecordCount do
      begin
        IdTipo := QTipoProducto.FieldByName('idtipo').AsString;

        QProduccionDocente.Close;
        QProduccionDocente.SQL.Text :=
          'SELECT * FROM siap_produccion_docente WHERE idtipo=' + #39 +
          IdTipo + #39;
        QProduccionDocente.Open;
        QProduccionDocente.First;

        JsonTipos := TJSONObject.create;
        JsonTipos.AddPair('idtipo', IdTipo);
        JsonTipos.AddPair('tipo', QTipoProducto.FieldByName('tipo').AsString);

        aProductos := TJSONArray.create;
        for i := 1 to QProduccionDocente.RecordCount do
        begin
          JsonRegistro := TJSONObject.create;
          JsonRegistro.AddPair('ciudad',
            QProduccionDocente.FieldByName('ciudad').AsString);
          JsonRegistro.AddPair('editorial',
            QProduccionDocente.FieldByName('editorial').AsString);
          JsonRegistro.AddPair('fecha', QProduccionDocente.FieldByName('fecha')
            .AsString);
          JsonRegistro.AddPair('fecha_fin',
            QProduccionDocente.FieldByName('fecha_fin').AsString);
          JsonRegistro.AddPair('fecha_inicio',
            QProduccionDocente.FieldByName('fecha_inicio').AsString);
          JsonRegistro.AddPair('iddocente',
            QProduccionDocente.FieldByName('iddocente').AsString);
          JsonRegistro.AddPair('idproduccion',
            QProduccionDocente.FieldByName('idproduccion').AsString);
          JsonRegistro.AddPair('idtipo',
            QProduccionDocente.FieldByName('idtipo').AsString);
          JsonRegistro.AddPair('institucion',
            QProduccionDocente.FieldByName('institucion').AsString);
          JsonRegistro.AddPair('isbn', QProduccionDocente.FieldByName('isbn')
            .AsString);
          JsonRegistro.AddPair('issn', QProduccionDocente.FieldByName('issn')
            .AsString);
          JsonRegistro.AddPair('numero',
            QProduccionDocente.FieldByName('numero').AsString);
          JsonRegistro.AddPair('registro',
            QProduccionDocente.FieldByName('registro').AsString);
          JsonRegistro.AddPair('revista',
            QProduccionDocente.FieldByName('revista').AsString);
          JsonRegistro.AddPair('titulo',
            QProduccionDocente.FieldByName('titulo').AsString);
          JsonRegistro.AddPair('volumen',
            QProduccionDocente.FieldByName('volumen').AsString);

          aProductos.AddElement(JsonRegistro);
          QProduccionDocente.Next;
        end;

        JsonTipos.AddPair('Productos', aProductos);
        aTiposProducto.AddElement(JsonTipos);

        JsonTipos.AddPair('Productos', aProductos);
        QTipoProducto.Next;
      end;

      JsonProduccionDocente.AddPair('Tipos', aTiposProducto);
    end
    else
    begin
      JsonProduccionDocente.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
      JsonProduccionDocente.AddPair('Error', E.Message);
  end;

  Result := JsonProduccionDocente;
  QProduccionDocente.Free;
  QTipoProducto.Free;
end;

function TMatematicas.ProductosDocente(IdDocente: string): TJSONObject;
var
  QProduccionDocente, QTipoProducto: TFDQuery;
  JsonProduccionDocente, JsonRegistro, JsonTipos: TJSONObject;
  aTiposProducto, aProductos: TJSONArray;
  i: integer;
  objWebModule: TWebModule;
  token, IdTipo: string;
  j: integer;
begin
  try
    QProduccionDocente := TFDQuery.create(nil);
    QProduccionDocente.Connection := Conexion;
    QTipoProducto := TFDQuery.create(nil);
    QTipoProducto.Connection := Conexion;

    JsonProduccionDocente := TJSONObject.create;
    aTiposProducto := TJSONArray.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      QTipoProducto.Close;
      QTipoProducto.SQL.Text :=
        'SELECT * FROM siap_tipo_produccion ORDER BY tipo';
      QTipoProducto.Open;
      QTipoProducto.First;

      for j := 1 to QTipoProducto.RecordCount do
      begin
        IdTipo := QTipoProducto.FieldByName('idtipo').AsString;

        QProduccionDocente.Close;
        QProduccionDocente.SQL.Text :=
          'SELECT * FROM siap_produccion_docente WHERE idtipo=' + #39 + IdTipo +
          #39 + ' AND iddocente=' + IdDocente;
        QProduccionDocente.Open;
        QProduccionDocente.First;

        JsonTipos := TJSONObject.create;
        JsonTipos.AddPair('idtipo', IdTipo);
        JsonTipos.AddPair('tipo', QTipoProducto.FieldByName('tipo').AsString);

        aProductos := TJSONArray.create;
        for i := 1 to QProduccionDocente.RecordCount do
        begin
          JsonRegistro := TJSONObject.create;
          JsonRegistro.AddPair('ciudad',
            QProduccionDocente.FieldByName('ciudad').AsString);

          JsonRegistro.AddPair('editorial',
            QProduccionDocente.FieldByName('editorial').AsString);

          JsonRegistro.AddPair('fecha', QProduccionDocente.FieldByName('fecha')
            .AsString);

          JsonRegistro.AddPair('fecha_fin',
            QProduccionDocente.FieldByName('fecha_fin').AsString);

          JsonRegistro.AddPair('fecha_inicio',
            QProduccionDocente.FieldByName('fecha_inicio').AsString);

          JsonRegistro.AddPair('iddocente',
            QProduccionDocente.FieldByName('iddocente').AsString);

          JsonRegistro.AddPair('idproduccion',
            QProduccionDocente.FieldByName('idproduccion').AsString);

          JsonRegistro.AddPair('idtipo',
            QProduccionDocente.FieldByName('idtipo').AsString);

          JsonRegistro.AddPair('institucion',
            QProduccionDocente.FieldByName('institucion').AsString);

          JsonRegistro.AddPair('isbn', QProduccionDocente.FieldByName('isbn')
            .AsString);

          JsonRegistro.AddPair('issn', QProduccionDocente.FieldByName('issn')
            .AsString);
          JsonRegistro.AddPair('numero',
            QProduccionDocente.FieldByName('numero').AsString);

          JsonRegistro.AddPair('registro',
            QProduccionDocente.FieldByName('registro').AsString);

          JsonRegistro.AddPair('revista',
            QProduccionDocente.FieldByName('revista').AsString);

          JsonRegistro.AddPair('titulo',
            QProduccionDocente.FieldByName('titulo').AsString);

          JsonRegistro.AddPair('volumen',
            QProduccionDocente.FieldByName('volumen').AsString);

          aProductos.AddElement(JsonRegistro);
          QProduccionDocente.Next;
        end;

        JsonTipos.AddPair('Productos', aProductos);
        aTiposProducto.AddElement(JsonTipos);

        QTipoProducto.Next;
      end;

      JsonProduccionDocente.AddPair('Tipos', aTiposProducto);
    end
    else
    begin
      JsonProduccionDocente.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
      JsonProduccionDocente.AddPair('Error', E.Message);
  end;

  Result := JsonProduccionDocente;
  QProduccionDocente.Free;
  QTipoProducto.Free;
end;

function TMatematicas.Programa(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    Query.SQL.Add('SELECT * FROM siap_programas AS p ');
    Query.SQL.Add('INNER JOIN siap_facultades AS f ');
    Query.SQL.Add('ON p.idfacultad = f.idfacultad WHERE idprograma=' +
      Texto(ID));
    Query.Open;

    limpiarParametros;
    agregarParametro('idprograma', 'String');
    agregarParametro('programa', 'String');
    agregarParametro('facultad', 'String');
    agregarParametro('idfacultad', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getPrograma',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Programa', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Programa }
function TMatematicas.Programas: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Programas', ArrayJson);

    limpiarConsulta(Query);
    Query.SQL.Add('SELECT * FROM siap_programas AS p ');
    Query.SQL.Add('INNER JOIN siap_facultades AS f ');
    Query.SQL.Add('ON p.idfacultad = f.idfacultad ORDER BY p.programa');
    Query.Open;

    limpiarParametros;
    agregarParametro('idprograma', 'String');
    agregarParametro('programa', 'String');
    agregarParametro('facultad', 'String');
    agregarParametro('idfacultad', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllPrograma',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Programas', Json.toString);
  Query.Free;
end;

function TMatematicas.pruebaExcel: TJSONObject;
begin

end;

{ Método DELETE - Programa }
function TMatematicas.cancelPresupuestoPm(idpresupuesto: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    if validarTokenHeader then
    begin
      Query.Close;
      Query.SQL.Text := 'DELETE FROM siap_presupuesto_pm WHERE idpresupuesto=' +
        #39 + idpresupuesto + #39;
      Query.ExecSQL;

      Json.AddPair(JSON_RESPONSE, 'El presupuesto se eliminó correctamente');
      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, AccesoDenegado);
    end;
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.cancelProducto(IdProducto: string): TJSONObject;
var
  QProduccionDocente: TFDQuery;
  JsonProduccionDocente: TJSONObject;
  i: integer;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QProduccionDocente := TFDQuery.create(nil);
    QProduccionDocente.Connection := Conexion;
    JsonProduccionDocente := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      QProduccionDocente.Close;
      QProduccionDocente.SQL.Text :=
        'DELETE FROM siap_produccion_docente WHERE idproduccion=' + #39 +
        IdProducto + #39;
      QProduccionDocente.ExecSQL;

      JsonProduccionDocente.AddPair('Respuesta',
        'El ProduccionDocente se elimino correctamente');

    end
    else
    begin
      JsonProduccionDocente.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
      JsonProduccionDocente.AddPair('Error', E.Message);

  end;

  Result := JsonProduccionDocente;
  QProduccionDocente.Free;

end;

function TMatematicas.cancelPrograma(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_programas', 'idprograma', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'El Programa se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deletePrograma',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelPrograma', Json.toString);
  Query.Free;
end;

{ Método UPDATE - Programa }
function TMatematicas.acceptPresupuestoPm(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    if validarTokenHeader then
    begin
      Query.Close;
      Query.SQL.Clear;
      Query.SQL.Add('UPDATE siap_presupuesto_pm SET');
      Query.SQL.Add('idplan=:idplan, ');
      Query.SQL.Add('idfecha=:idfecha, ');
      Query.SQL.Add('descripcion=:descripcion, ');
      Query.SQL.Add('valor=:valor WHERE idpresupuesto=' + #39 +
        datos.GetValue('idpresupuesto').Value + #39);

      Query.Params.ParamByName('idplan').Value :=
        datos.GetValue('idplan').Value;
      Query.Params.ParamByName('idfecha').Value :=
        datos.GetValue('idfecha').Value;
      Query.Params.ParamByName('descripcion').Value :=
        datos.GetValue('descripcion').Value;
      Query.Params.ParamByName('valor').Value :=
        StrToInt(datos.GetValue('valor').Value);
      Query.ExecSQL;

      Json.AddPair(JSON_RESPONSE, 'El presupuesto se actualizó correctamente');
      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, AccesoDenegado);
    end;
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.acceptProducto(ProduccionDocente: TJSONObject)
  : TJSONObject;
var
  QProduccionDocente: TFDQuery;
  JsonResp: TJSONObject;
  idproduccion: string;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QProduccionDocente := TFDQuery.create(nil);
    QProduccionDocente.Connection := Conexion;

    JsonResp := TJSONObject.create;

    idproduccion := ProduccionDocente.GetValue('idproduccion').Value;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      QProduccionDocente.Close;
      QProduccionDocente.SQL.Clear;
      QProduccionDocente.SQL.Add('UPDATE siap_produccion_docente SET ');
      QProduccionDocente.SQL.Add('ciudad=:ciudad, ');
      QProduccionDocente.SQL.Add('editorial=:editorial, ');
      QProduccionDocente.SQL.Add('fecha=:fecha, ');
      QProduccionDocente.SQL.Add('fecha_fin=:fecha_fin, ');
      QProduccionDocente.SQL.Add('fecha_inicio=:fecha_inicio, ');
      QProduccionDocente.SQL.Add('iddocente=:iddocente, ');
      QProduccionDocente.SQL.Add('idtipo=:idtipo, ');
      QProduccionDocente.SQL.Add('institucion=:institucion, ');
      QProduccionDocente.SQL.Add('isbn=:isbn, ');
      QProduccionDocente.SQL.Add('issn=:issn, ');
      QProduccionDocente.SQL.Add('numero=:numero, ');
      QProduccionDocente.SQL.Add('registro=:registro, ');
      QProduccionDocente.SQL.Add('revista=:revista, ');
      QProduccionDocente.SQL.Add('titulo=:titulo, ');
      QProduccionDocente.SQL.Add('volumen=:volumen ');
      QProduccionDocente.SQL.Add(' WHERE idproduccion=' + #39 +
        idproduccion + #39);

      QProduccionDocente.Params.ParamByName('ciudad').Value :=
        ProduccionDocente.GetValue('ciudad').Value;

      QProduccionDocente.Params.ParamByName('editorial').Value :=
        ProduccionDocente.GetValue('editorial').Value;

      QProduccionDocente.Params.ParamByName('fecha').Value :=
        ProduccionDocente.GetValue('fecha').Value;

      QProduccionDocente.Params.ParamByName('fecha_fin').Value :=
        ProduccionDocente.GetValue('fecha_fin').Value;

      QProduccionDocente.Params.ParamByName('fecha_inicio').Value :=
        ProduccionDocente.GetValue('fecha_inicio').Value;

      QProduccionDocente.Params.ParamByName('iddocente').Value :=
        ProduccionDocente.GetValue('iddocente').Value;

      QProduccionDocente.Params.ParamByName('idtipo').Value :=
        ProduccionDocente.GetValue('idtipo').Value;

      QProduccionDocente.Params.ParamByName('institucion').Value :=
        ProduccionDocente.GetValue('institucion').Value;

      QProduccionDocente.Params.ParamByName('isbn').Value :=
        ProduccionDocente.GetValue('isbn').Value;

      QProduccionDocente.Params.ParamByName('issn').Value :=
        ProduccionDocente.GetValue('issn').Value;

      QProduccionDocente.Params.ParamByName('numero').Value :=
        ProduccionDocente.GetValue('numero').Value;

      QProduccionDocente.Params.ParamByName('registro').Value :=
        ProduccionDocente.GetValue('registro').Value;

      QProduccionDocente.Params.ParamByName('revista').Value :=
        ProduccionDocente.GetValue('revista').Value;

      QProduccionDocente.Params.ParamByName('titulo').Value :=
        ProduccionDocente.GetValue('titulo').Value;

      QProduccionDocente.Params.ParamByName('volumen').Value :=
        ProduccionDocente.GetValue('volumen').Value;

      QProduccionDocente.ExecSQL;

      JsonResp.AddPair('Respuesta',
        'El ProduccionDocente se actualizo correctamente');
    end
    else
    begin
      JsonResp.AddPair(JsonRespuesta, AccesoDenegado);
    end;
  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  QProduccionDocente.Free;
end;

function TMatematicas.acceptPrograma(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idprograma', 'String');
      agregarParametro('programa', 'String');
      agregarParametro('idfacultad', 'String');

      ID := datos.GetValue('idprograma').Value;
      UPDATE('siap_programas', 'idprograma', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Programa se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptPrograma',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updatePrograma', Json.toString);
  Query.Free;
end;

{ Método INSERT - Facultad }
function TMatematicas.updateFactorCalidad(factorCalidad: TJSONObject)
  : TJSONObject;
var
  QFactorCalidad: TFDQuery;
  JsonResp: TJSONObject;
begin
  try
    QFactorCalidad := TFDQuery.create(nil);
    QFactorCalidad.Connection := Conexion;

    JsonResp := TJSONObject.create;

    QFactorCalidad.Close;
    QFactorCalidad.SQL.Clear;
    QFactorCalidad.SQL.Add('INSERT INTO siap_factor_calidad_pm (');
    QFactorCalidad.SQL.Add('factor, ');
    QFactorCalidad.SQL.Add('orden, ');
    QFactorCalidad.SQL.Add('idfactorcalidad) VALUES (');

    QFactorCalidad.SQL.Add(':factor, ');
    QFactorCalidad.SQL.Add(':orden, ');
    QFactorCalidad.SQL.Add(':idfactorcalidad)');

    QFactorCalidad.Params.ParamByName('factor').Value :=
      factorCalidad.GetValue('factor').Value;
    QFactorCalidad.Params.ParamByName('orden').Value :=
      StrToInt(factorCalidad.GetValue('orden').Value);
    QFactorCalidad.Params.ParamByName('idfactorcalidad').Value :=
      moduloDatos.generarID;

    QFactorCalidad.ExecSQL;

    JsonResp.AddPair('Respuesta', 'El FactorCalidad se creo correctamente');
  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  QFactorCalidad.Free;
end;

function TMatematicas.updateFacultad(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idfacultad', 'String');
      agregarParametro('facultad', 'String');

      INSERT('siap_facultades', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Facultad se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateFacultad',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateFacultad', Json.toString);
  Query.Free;
end;

{ Método GET - Facultad }
function TMatematicas.Facultad(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_facultades', 'idfacultad', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idfacultad', 'String');
    agregarParametro('facultad', 'String');
    agregarParametro('nombrecorto', 'String');
    agregarParametro('color', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getFacultad',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Facultad', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Facultad }
function TMatematicas.Facultades: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Facultades', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_facultades', 'facultad', Query);

    limpiarParametros;
    agregarParametro('idfacultad', 'String');
    agregarParametro('facultad', 'String');
    agregarParametro('nombrecorto', 'String');
    agregarParametro('color', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllFacultad',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Facultades', Json.toString);
  Query.Free;
end;

{ Método DELETE - Facultad }
function TMatematicas.cancelFactorCalidad(idfactorcalidad: string): TJSONObject;
var
  QFactorCalidad: TFDQuery;
  JsonFactorCalidad: TJSONObject;
  i: integer;
begin
  try
    QFactorCalidad := TFDQuery.create(nil);
    QFactorCalidad.Connection := Conexion;
    JsonFactorCalidad := TJSONObject.create;

    QFactorCalidad.Close;
    QFactorCalidad.SQL.Text :=
      'DELETE FROM siap_factor_calidad_pm WHERE idfactorcalidad=' + #39 +
      idfactorcalidad + #39;
    QFactorCalidad.ExecSQL;

    JsonFactorCalidad.AddPair('Respuesta',
      'El FactorCalidad se elimino correctamente');

  except
    on E: Exception do
      JsonFactorCalidad.AddPair('Error', E.Message);
  end;

  Result := JsonFactorCalidad;
  QFactorCalidad.Free;
end;

function TMatematicas.cancelFacultad(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_facultades', 'idfacultad', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'La Facultad se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteFacultad',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelFacultad', Json.toString);
  Query.Free;
end;

{ Método UPDATE - Facultad }
function TMatematicas.acceptFactorCalidad(factorCalidad: TJSONObject)
  : TJSONObject;
var
  QFactorCalidad: TFDQuery;
  JsonResp: TJSONObject;
  idfactorcalidad: string;
begin
  try
    QFactorCalidad := TFDQuery.create(nil);
    QFactorCalidad.Connection := Conexion;

    JsonResp := TJSONObject.create;

    idfactorcalidad := factorCalidad.GetValue('idfactorcalidad').Value;

    QFactorCalidad.Close;
    QFactorCalidad.SQL.Clear;
    QFactorCalidad.SQL.Add('UPDATE siap_factor_calidad_pm SET ');
    QFactorCalidad.SQL.Add('factor=:factor, ');
    QFactorCalidad.SQL.Add('orden=:orden, ');
    QFactorCalidad.SQL.Add('idfactorcalidad=:idfactorcalidad ');
    QFactorCalidad.SQL.Add(' WHERE idfactorcalidad=' + #39 +
      idfactorcalidad + #39);

    QFactorCalidad.Params.ParamByName('factor').Value :=
      factorCalidad.GetValue('factor').Value;

    QFactorCalidad.Params.ParamByName('idfactorcalidad').Value :=
      factorCalidad.GetValue('idfactorcalidad').Value;

    QFactorCalidad.Params.ParamByName('orden').Value :=
      StrToInt(factorCalidad.GetValue('orden').Value);

    QFactorCalidad.ExecSQL;

    JsonResp.AddPair('Respuesta',
      'El FactorCalidad se actualizo correctamente');
  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  QFactorCalidad.Free;
end;

function TMatematicas.acceptFacultad(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idfacultad', 'String');
      agregarParametro('facultad', 'String');

      ID := datos.GetValue('idfacultad').Value;
      UPDATE('siap_facultades', 'idfacultad', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Facultad se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptFacultad',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateFacultad', Json.toString);
  Query.Free;
end;

{ Método INSERT - Docente }
function TMatematicas.updateDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      Query.Close;
      Query.SQL.Text := 'INSERT INTO Siap_Docentes (';
      Query.SQL.Add('iddocente, ');
      Query.SQL.Add('documento, ');
      Query.SQL.Add('nombre, ');
      Query.SQL.Add('telefono, ');
      Query.SQL.Add('correo, ');
      Query.SQL.Add('activo, ');
      Query.SQL.Add('institucion, ');
      Query.SQL.Add('vinculacion, ');
      Query.SQL.Add('idcategoriadocente, ');
      Query.SQL.Add('idtipocontrato, ');
      Query.SQL.Add('contra, ');
      Query.SQL.Add('areaprofundizacion, ');
      Query.SQL.Add('titulomayorformacion) VALUES (');
      Query.SQL.Add(':iddocente, ');
      Query.SQL.Add(':documento, ');
      Query.SQL.Add(':nombre, ');
      Query.SQL.Add(':telefono, ');
      Query.SQL.Add(':correo, ');
      Query.SQL.Add(':activo, ');
      Query.SQL.Add(':institucion, ');
      Query.SQL.Add(':vinculacion, ');
      Query.SQL.Add(':idcategoriadocente, ');
      Query.SQL.Add(':idtipocontrato, ');
      Query.SQL.Add(':contra, ');
      Query.SQL.Add(':areaprofundizacion, ');
      Query.SQL.Add(':titulomayorformacion)');

      Query.Params.ParamByName('iddocente').Value :=
        StrToInt(datos.GetValue('iddocente').Value);
      Query.Params.ParamByName('documento').Value :=
        datos.GetValue('documento').Value;
      Query.Params.ParamByName('nombre').Value :=
        datos.GetValue('nombre').Value;
      Query.Params.ParamByName('telefono').Value :=
        datos.GetValue('telefono').Value;
      Query.Params.ParamByName('correo').Value :=
        datos.GetValue('correo').Value;
      Query.Params.ParamByName('activo').Value :=
        datos.GetValue('activo').Value;
      Query.Params.ParamByName('institucion').Value :=
        datos.GetValue('institucion').Value;
      Query.Params.ParamByName('vinculacion').Value :=
        datos.GetValue('vinculacion').Value;
      Query.Params.ParamByName('idcategoriadocente').Value :=
        datos.GetValue('idcategoriadocente').Value;
      Query.Params.ParamByName('idtipocontrato').Value :=
        datos.GetValue('idtipocontrato').Value;
      Query.Params.ParamByName('contra').Value :=
        datos.GetValue('contra').Value;
      Query.Params.ParamByName('areaprofundizacion').Value :=
        datos.GetValue('areaprofundizacion').Value;
      Query.Params.ParamByName('titulomayorformacion').Value :=
        datos.GetValue('titulomayorformacion').Value;

      Query.ExecSQL;

      Json.AddPair(JsonRespuesta, 'El Docente se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      Json.AddPair('datos', datos.ToJSON);
      enviarError(TimeToStr(now), DateToStr(now), 'updateDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateDocente', Json.toString);
  Query.Free;
end;

{ Método GET - Docente }
function TMatematicas.DireccionJuradoDocente(IdDocente: string): TJSONObject;
var
  QTrabajo: TFDQuery;
  JsonResponse, JsonTrabajo: TJSONObject;
  DirigidosTerm, DirigidosNoTerm, Evaluados: TJSONArray;
  i: integer;
  IdTrabajo: string;
begin
  try
    JsonResponse := TJSONObject.create;

    QTrabajo := TFDQuery.create(nil);
    QTrabajo.Connection := Conexion;

    // Leer los trabajos que ha dirigido y que estan terminados
    QTrabajo.Close;
    QTrabajo.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE iddirector=' +
      #39 + IdDocente + #39 + ' AND estadoproyecto=' + #39 + 'terminado' + #39 +
      ' ORDER BY fechasustentacion';
    QTrabajo.Open;
    QTrabajo.First;

    DirigidosTerm := TJSONArray.create;
    for i := 1 to QTrabajo.RecordCount do
    begin
      IdTrabajo := QTrabajo.FieldByName('idtrabajogrado').AsString;
      DirigidosTerm.AddElement(TrabajoGrado(IdTrabajo));
      QTrabajo.Next;
    end;

    // Leer los trabajos que ha dirigido y que estan en proceso
    QTrabajo.Close;
    QTrabajo.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE iddirector=' +
      #39 + IdDocente + #39 + ' AND estadoproyecto=' + #39 + 'proceso' + #39 +
      ' ORDER BY fechasustentacion';
    QTrabajo.Open;
    QTrabajo.First;

    DirigidosNoTerm := TJSONArray.create;
    for i := 1 to QTrabajo.RecordCount do
    begin
      IdTrabajo := QTrabajo.FieldByName('idtrabajogrado').AsString;
      DirigidosNoTerm.AddElement(TrabajoGrado(IdTrabajo));
      QTrabajo.Next;
    end;

    // Leer los trabajos de grado en los que ha sido jurado y estan terminados
    QTrabajo.Close;
    QTrabajo.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE ' +
      '(idjurado1=' + #39 + IdDocente + #39 + ' OR ' + 'idjurado2=' + #39 +
      IdDocente + #39 + ' OR ' + 'idjurado3=' + #39 + IdDocente + #39 +
      ') AND estadoproyecto=' + #39 + 'terminado' + #39 +
      'ORDER BY fechasustentacion ';
    QTrabajo.Open;
    QTrabajo.First;

    Evaluados := TJSONArray.create;
    for i := 1 to QTrabajo.RecordCount do
    begin
      IdTrabajo := QTrabajo.FieldByName('idtrabajogrado').AsString;
      Evaluados.AddElement(TrabajoGrado(IdTrabajo));
      QTrabajo.Next;
    end;

    JsonTrabajo := TJSONObject.create;
    JsonTrabajo.AddPair('Terminados', DirigidosTerm);
    JsonTrabajo.AddPair('NoTerminados', DirigidosNoTerm);

    JsonResponse.AddPair('Dirigidos', JsonTrabajo);
    JsonResponse.AddPair('Jurado', Evaluados);

  except
    on E: Exception do
    begin
      JsonResponse.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      JsonResponse.AddPair(JSON_RESPONSE, E.Message);
    end;

  end;

  Result := JsonResponse;
  QTrabajo.Free;
end;

function TMatematicas.DirectoresJurados: TJSONObject;
var
  Json, JsonTemp: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
  ruta, ID: string;
  Foto: TStringList;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Docentes', ArrayJson);

    limpiarConsulta(Query);
    Query.SQL.Add('SELECT * FROM siap_docentes AS d ');
    Query.SQL.Add('INNER JOIN siap_categoria_docentes AS c ');
    Query.SQL.Add('ON d.idcategoriadocente = c.idcategoriadocente');
    Query.SQL.Add('INNER JOIN siap_tipo_contrato as t');
    Query.SQL.Add('ON d.idtipocontrato = t.idtipocontrato' +
      ' ORDER BY nombre');
    Query.Open;

    limpiarParametros;
    agregarParametro('iddocente', 'String');
    agregarParametro('documento', 'Integer');
    agregarParametro('nombre', 'String');
    agregarParametro('telefono', 'String');
    agregarParametro('correo', 'String');
    agregarParametro('categoria', 'String');
    agregarParametro('contrato', 'String');
    agregarParametro('activo', 'String');
    agregarParametro('idcategoriadocente', 'String');
    agregarParametro('idtipocontrato', 'String');
    agregarParametro('contra', 'String');
    agregarParametro('areaprofundizacion', 'String');
    agregarParametro('titulomayorformacion', 'String');

    for i := 1 to Query.RecordCount do
    begin
      JsonTemp := TJSONObject.create;
      JsonTemp := crearJSON(Query);

      ruta := ExtractFilePath(ParamStr(0)) + '\FotosDocentes';
      ID := JsonTemp.GetValue('iddocente').Value;
      Foto := TStringList.create;
      if FileExists(ruta + '\' + ID + '.foto.base64') then
      begin
        Foto.LoadFromFile(ruta + '\' + ID + '.foto.base64');
        JsonTemp.AddPair('foto', Foto[0]);
      end
      else
        JsonTemp.AddPair('foto', '');

      ArrayJson.AddElement(JsonTemp);
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'DirectoresJurados',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Docentes', Json.toString);
  Query.Free;
end;

function TMatematicas.Docente(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
  ruta: string;
  Foto: TStringList;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT * FROM siap_docentes AS d ');
    Query.SQL.Add('INNER JOIN siap_categoria_docentes AS c ');
    Query.SQL.Add('ON d.idcategoriadocente = c.idcategoriadocente');
    Query.SQL.Add('INNER JOIN siap_tipo_contrato as t');
    Query.SQL.Add('ON d.idtipocontrato = t.idtipocontrato');
    Query.SQL.Add('WHERE iddocente=' + ID);
    Query.Open;

    limpiarParametros;
    agregarParametro('iddocente', 'String');
    agregarParametro('documento', 'Integer');
    agregarParametro('nombre', 'String');
    agregarParametro('telefono', 'String');
    agregarParametro('correo', 'String');
    agregarParametro('categoria', 'String');
    agregarParametro('contrato', 'String');
    agregarParametro('activo', 'String');
    agregarParametro('institucion', 'String');
    agregarParametro('vinculacion', 'String');
    agregarParametro('idcategoriadocente', 'String');
    agregarParametro('idtipocontrato', 'String');
    agregarParametro('contra', 'String');
    agregarParametro('areaprofundizacion', 'String');
    agregarParametro('titulomayorformacion', 'String');

    Json := crearJSON(Query);

    ruta := ExtractFilePath(ParamStr(0)) + '\FotosDocentes';
    Foto := TStringList.create;
    if FileExists(ruta + '\' + ID + '.foto.base64') then
    begin
      Foto.LoadFromFile(ruta + '\' + ID + '.foto.base64');
      Json.AddPair('foto', Foto[0]);
    end
    else
      Json.AddPair('foto', '');

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getDocente',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Docente', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Docente }
function TMatematicas.Docentes(const OrdenarPor: string): TJSONObject;
var
  Json, JsonTemp: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
  ruta, ID: string;
  Foto: TStringList;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Docentes', ArrayJson);

    limpiarConsulta(Query);
    Query.SQL.Add('SELECT * FROM siap_docentes AS d ');
    Query.SQL.Add('INNER JOIN siap_categoria_docentes AS c ');
    Query.SQL.Add('ON d.idcategoriadocente = c.idcategoriadocente');
    Query.SQL.Add('INNER JOIN siap_tipo_contrato as t');
    Query.SQL.Add('ON d.idtipocontrato = t.idtipocontrato' +
      ' WHERE Vinculacion=' + #39 + 'docente' + #39 + ' ORDER BY ' +
      OrdenarPor);
    Query.Open;

    limpiarParametros;
    agregarParametro('iddocente', 'String');
    agregarParametro('documento', 'Integer');
    agregarParametro('nombre', 'String');
    agregarParametro('telefono', 'String');
    agregarParametro('correo', 'String');
    agregarParametro('categoria', 'String');
    agregarParametro('contrato', 'String');
    agregarParametro('activo', 'String');
    agregarParametro('institucion', 'String');
    agregarParametro('vinculacion', 'String');
    agregarParametro('idcategoriadocente', 'String');
    agregarParametro('idtipocontrato', 'String');
    agregarParametro('contra', 'String');
    agregarParametro('areaprofundizacion', 'String');
    agregarParametro('titulomayorformacion', 'String');

    for i := 1 to Query.RecordCount do
    begin
      JsonTemp := TJSONObject.create;
      JsonTemp := crearJSON(Query);

      ruta := ExtractFilePath(ParamStr(0)) + '\FotosDocentes';
      ID := JsonTemp.GetValue('iddocente').Value;
      Foto := TStringList.create;
      if FileExists(ruta + '\' + ID + '.foto.base64') then
      begin
        Foto.LoadFromFile(ruta + '\' + ID + '.foto.base64');
        JsonTemp.AddPair('foto', Foto[0]);
      end
      else
        JsonTemp.AddPair('foto', '');

      ArrayJson.AddElement(JsonTemp);
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message + ' - ' + OrdenarPor);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllDocente',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Docentes', Json.toString);
  Query.Free;
end;

function TMatematicas.DocentesGrupoInvestigacion(IdGrupo: string): TJSONObject;
var
  Json: TJSONObject;
  Docentes: TJSONArray;
  jsonDocente: TJSONObject;
  Query: TFDQuery;
  i: integer;
  ruta, IdDocente: string;
  Foto: TStringList;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_grupos_docente as gd INNER JOIN' +
      ' siap_docentes as d ON gd.iddocente=d.iddocente' +
      ' WHERE idgrupoinvestigacion='#39 + IdGrupo + #39;
    Query.Open;

    Docentes := TJSONArray.create;
    for i := 1 to Query.RecordCount do
    begin
      jsonDocente := TJSONObject.create;
      jsonDocente.AddPair('fechaingreso', Query.FieldByName('fechaingreso')
        .AsString);

      IdDocente := Query.FieldByName('iddocente').AsString;
      jsonDocente.AddPair('iddocente', IdDocente);
      jsonDocente.AddPair('nombre', Query.FieldByName('nombre').AsString);
      jsonDocente.AddPair('correo', Query.FieldByName('correo').AsString);
      jsonDocente.AddPair('telefono', Query.FieldByName('telefono').AsString);
      jsonDocente.AddPair('idcategoriadocente',
        Query.FieldByName('idcategoriadocente').AsString);
      jsonDocente.AddPair('idtipocontrato', Query.FieldByName('idtipocontrato')
        .AsString);
      jsonDocente.AddPair('activo', Query.FieldByName('activo').AsString);
      jsonDocente.AddPair('documento', Query.FieldByName('documento').AsString);
      jsonDocente.AddPair('vinculacion', Query.FieldByName('vinculacion')
        .AsString);
      jsonDocente.AddPair('institucion', Query.FieldByName('institucion')
        .AsString);

      ruta := ExtractFilePath(ParamStr(0)) + '\FotosDocentes';
      Foto := TStringList.create;
      if FileExists(ruta + '\' + IdDocente + '.foto.base64') then
      begin
        Foto.LoadFromFile(ruta + '\' + IdDocente + '.foto.base64');
        jsonDocente.AddPair('foto', Foto[0]);
      end
      else
        jsonDocente.AddPair('foto', '');

      Docentes.AddElement(jsonDocente);
      Query.Next;
    end;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESPONSE, 'Docentes del grupo');
    Json.AddPair(JSON_RESULTS, Docentes);

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.DocentesPorContrato(const IdContrato: string)
  : TJSONObject;
var
  Json, JsonTemp: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
  ruta, ID: string;
  Foto: TStringList;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Docentes', ArrayJson);

    limpiarConsulta(Query);

    Query.SQL.Add('SELECT * FROM siap_docentes AS d ');
    Query.SQL.Add('INNER JOIN siap_categoria_docentes AS c ');
    Query.SQL.Add('ON d.idcategoriadocente = c.idcategoriadocente');
    Query.SQL.Add('INNER JOIN siap_tipo_contrato as t');
    Query.SQL.Add('ON d.idtipocontrato = t.idtipocontrato');
    Query.SQL.Add(' WHERE d.idtipocontrato=' + Texto(IdContrato) +
      ' AND activo=' + #39 + 'si' + #39 + ' ORDER BY nombre');
    Query.Open;

    limpiarParametros;
    agregarParametro('iddocente', 'String');
    agregarParametro('documento', 'Integer');
    agregarParametro('nombre', 'String');
    agregarParametro('telefono', 'String');
    agregarParametro('correo', 'String');
    agregarParametro('categoria', 'String');
    agregarParametro('contrato', 'String');
    agregarParametro('institucion', 'String');
    agregarParametro('vinculacion', 'String');
    agregarParametro('activo', 'String');
    agregarParametro('idcategoriadocente', 'String');
    agregarParametro('idtipocontrato', 'String');
    agregarParametro('areaprofundizacion', 'String');
    agregarParametro('titulomayorformacion', 'String');

    for i := 1 to Query.RecordCount do
    begin
      JsonTemp := TJSONObject.create;
      JsonTemp := crearJSON(Query);

      ruta := ExtractFilePath(ParamStr(0)) + '\FotosDocentes';
      ID := JsonTemp.GetValue('iddocente').Value;
      Foto := TStringList.create;
      if FileExists(ruta + '\' + ID + '.foto.base64') then
      begin
        Foto.LoadFromFile(ruta + '\' + ID + '.foto.base64');
        JsonTemp.AddPair('foto', Foto[0]);
      end
      else
        JsonTemp.AddPair('foto', '');

      ArrayJson.AddElement(JsonTemp);
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllDocente',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Docentes', Json.toString);
  Query.Free;
end;

function TMatematicas.DirectoresTrabajosGrado: TJSONObject;
var
  JsonContratos, JsonContrato, JsonTrabajoGrado, jsonDocente: TJSONObject;
  Docentes, Terminados, noTerminados, Contratos: TJSONArray;
  QContratos, QDocentes, QtrabajosGrado: TFDQuery;
  i, j, k: integer;
  IdDirector, IdTipoContrato: string;
  objWebModule: TWebModule;
  token: string;
begin
  try

    JsonContratos := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QDocentes := TFDQuery.create(nil);
      QDocentes.Connection := Conexion;
      QContratos := TFDQuery.create(nil);
      QContratos.Connection := Conexion;
      QtrabajosGrado := TFDQuery.create(nil);
      QtrabajosGrado.Connection := Conexion;

      QContratos.Close;
      QContratos.SQL.Text :=
        'SELECT * FROM siap_tipo_contrato ORDER by horas asc';
      QContratos.Open;
      QContratos.First;

      Contratos := TJSONArray.create;
      for k := 1 to QContratos.RecordCount do
      begin
        IdTipoContrato := QContratos.FieldByName('idtipocontrato').AsString;

        JsonContrato := TJSONObject.create;
        JsonContrato.AddPair('contrato', QContratos.FieldByName('contrato')
          .AsString);
        JsonContrato.AddPair('idtipocontrato',
          QContratos.FieldByName('idtipocontrato').AsString);

        QDocentes.Close;
        QDocentes.SQL.Text := 'SELECT * FROM siap_docentes WHERE activo=' + #39
          + 'si' + #39 + ' AND vinculacion=' + #39 + 'docente' + #39 +
          ' AND idtipocontrato=' + #39 + IdTipoContrato + #39 +
          ' ORDER BY nombre';
        QDocentes.Open;
        QDocentes.First;

        Docentes := TJSONArray.create;
        for i := 1 to QDocentes.RecordCount do
        begin
          IdDirector := QDocentes.FieldByName('iddocente').AsString;

          jsonDocente := TJSONObject.create;
          jsonDocente.AddPair('iddocente', QDocentes.FieldByName('iddocente')
            .AsString);
          jsonDocente.AddPair('nombre', QDocentes.FieldByName('nombre')
            .AsString);
          jsonDocente.AddPair('correo', QDocentes.FieldByName('correo')
            .AsString);
          jsonDocente.AddPair('telefono', QDocentes.FieldByName('telefono')
            .AsString);
          jsonDocente.AddPair('activo', QDocentes.FieldByName('activo')
            .AsString);
          jsonDocente.AddPair('documento', QDocentes.FieldByName('documento')
            .AsString);
          jsonDocente.AddPair('vinculacion',
            QDocentes.FieldByName('vinculacion').AsString);
          jsonDocente.AddPair('institucion',
            QDocentes.FieldByName('institucion').AsString);

          { Leer los trabajos de grado - TERMINADOS }
          QtrabajosGrado.Close;
          QtrabajosGrado.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE ' +
            ' iddirector=' + #39 + IdDirector + #39 + ' AND estadoproyecto=' +
            #39 + 'terminado' + #39;
          QtrabajosGrado.Open;
          QtrabajosGrado.First;

          Terminados := TJSONArray.create;
          for j := 1 to QtrabajosGrado.RecordCount do
          begin
            JsonTrabajoGrado := TJSONObject.create;
            JsonTrabajoGrado.AddPair('titulo',
              QtrabajosGrado.FieldByName('titulo').AsString);
            JsonTrabajoGrado.AddPair('estudiante1',
              QtrabajosGrado.FieldByName('estudiante1').AsString);
            JsonTrabajoGrado.AddPair('estudiante2',
              QtrabajosGrado.FieldByName('estudiante2').AsString);
            JsonTrabajoGrado.AddPair('estudiante3',
              QtrabajosGrado.FieldByName('estudiante3').AsString);
            JsonTrabajoGrado.AddPair('actapropuesta',
              QtrabajosGrado.FieldByName('actapropuesta').AsString);
            JsonTrabajoGrado.AddPair('fechainicioejecucion',
              QtrabajosGrado.FieldByName('fechainicioejecucion').AsString);
            JsonTrabajoGrado.AddPair('estadoproyecto',
              QtrabajosGrado.FieldByName('estadoproyecto').AsString);

            Terminados.Add(JsonTrabajoGrado);
            QtrabajosGrado.Next;
          end;
          jsonDocente.AddPair('Terminados', Terminados);

          { Leer los trabajos de grado - NO TERMINADOS }
          QtrabajosGrado.Close;
          QtrabajosGrado.SQL.Text := 'SELECT * FROM siap_trabajosgrado WHERE ' +
            ' iddirector=' + #39 + IdDirector + #39 + ' AND estadoproyecto=' +
            #39 + 'proceso' + #39;
          QtrabajosGrado.Open;
          QtrabajosGrado.First;

          noTerminados := TJSONArray.create;
          for j := 1 to QtrabajosGrado.RecordCount do
          begin
            JsonTrabajoGrado := TJSONObject.create;
            JsonTrabajoGrado.AddPair('titulo',
              QtrabajosGrado.FieldByName('titulo').AsString);
            JsonTrabajoGrado.AddPair('estudiante1',
              QtrabajosGrado.FieldByName('estudiante1').AsString);
            JsonTrabajoGrado.AddPair('estudiante2',
              QtrabajosGrado.FieldByName('estudiante2').AsString);
            JsonTrabajoGrado.AddPair('estudiante3',
              QtrabajosGrado.FieldByName('estudiante3').AsString);
            JsonTrabajoGrado.AddPair('actapropuesta',
              QtrabajosGrado.FieldByName('actapropuesta').AsString);
            JsonTrabajoGrado.AddPair('fechainicioejecucion',
              QtrabajosGrado.FieldByName('fechainicioejecucion').AsString);
            JsonTrabajoGrado.AddPair('estadoproyecto',
              QtrabajosGrado.FieldByName('estadoproyecto').AsString);

            noTerminados.Add(JsonTrabajoGrado);
            QtrabajosGrado.Next;
          end;
          jsonDocente.AddPair('noTerminados', noTerminados);

          if (Terminados.Count > 0) or (noTerminados.Count > 0) then
            Docentes.Add(jsonDocente);

          QDocentes.Next;
        end;

        JsonContrato.AddPair('Docentes', Docentes);
        Contratos.AddElement(JsonContrato);
        QContratos.Next;
      end;

      JsonContratos.AddPair('Contratos', Contratos);
    end
    else
    begin
      JsonContratos.AddPair(JsonRespuesta, AccesoDenegado);
    end;
  except
    on E: Exception do
      JsonContratos.AddPair('Error', E.Message);
  end;

  Result := JsonContratos;
  QContratos.Free;
  QDocentes.Free;
  QtrabajosGrado.Free;
end;

{ Método DELETE - Docente }
function TMatematicas.cancelDocente(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_docentes', 'iddocente', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'El Docente se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteDocente',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelDocente', Json.toString);
  Query.Free;
end;

{ Método UPDATE - Docente }
function TMatematicas.acceptDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('iddocente', 'Integer');
      agregarParametro('documento', 'Integer');
      agregarParametro('nombre', 'String');
      agregarParametro('telefono', 'String');
      agregarParametro('correo', 'String');
      agregarParametro('activo', 'String');
      agregarParametro('vinculacion', 'String');
      agregarParametro('institucion', 'String');
      agregarParametro('idcategoriadocente', 'String');
      agregarParametro('idtipocontrato', 'String');
      agregarParametro('areaprofundizacion', 'String');
      agregarParametro('titulomayorformacion', 'String');

      ID := datos.GetValue('iddocente').Value;
      UPDATE('siap_docentes', 'iddocente', ID, Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Docente se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateDocente', Json.toString);
  Query.Free;
end;

function TMatematicas.acceptFormacion(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  QFormacion: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QFormacion := TFDQuery.create(nil);
    QFormacion.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QFormacion.Close;
      QFormacion.SQL.Text := 'UPDATE siap_formacion SET ' +
        'titulo=:titulo,fechainicio=:fechainicio,fechafin=:fechafin,' +
        'institucion=:institucion WHERE idformacion=' + #39 +
        datos.GetValue('idformacion').Value + #39;

      QFormacion.Params.ParamByName('titulo').Value :=
        datos.GetValue('titulo').Value;
      QFormacion.Params.ParamByName('fechainicio').Value :=
        datos.GetValue('fechainicio').Value;
      QFormacion.Params.ParamByName('fechafin').Value :=
        datos.GetValue('fechafin').Value;
      QFormacion.Params.ParamByName('institucion').Value :=
        datos.GetValue('institucion').Value;

      QFormacion.ExecSQL;

      Json.AddPair('Respuesta', 'La formación se actualizo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateFormacion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateFormacion', Json.toString);
  QFormacion.Free;
end;

function TMatematicas.acceptFotoDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  ID, ruta: string;
  Foto: TStringList;
begin
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      Foto := TStringList.create;
      Foto.Add(datos.GetValue('foto').Value);
      ID := datos.GetValue('iddocente').Value;

      ruta := ExtractFilePath(ParamStr(0)) + '\FotosDocentes';
      if not DirectoryExists(ruta) then
        CreateDir(ruta);

      Foto.SaveToFile(ruta + '\' + ID + '.foto.base64');

      Json.AddPair(JsonRespuesta, 'La Foto se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
end;

{ Método INSERT - CategoriaDocente }
function TMatematicas.updateCartaPermiso(datos: TJSONObject): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.postCartaPermiso(datos)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.updateCategoriaDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idcategoriadocente', 'String');
      agregarParametro('categoria', 'String');

      INSERT('siap_categoria_docentes', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Categoría se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateCategoriaDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateCategoriaDocente', Json.toString);
  Query.Free;
end;

{ Método GET - CategoriaDocente }
function TMatematicas.CartaPermiso(IdCarta: string): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.getCartaPermiso(IdCarta)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.CartasPermisoByPeriodo(Periodo: string): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.getCartasPermisoByPeriodo(Periodo)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.CategoriaDocente(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_categoria_docentes', 'idcategoriadocente',
      Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idcategoriadocente', 'String');
    agregarParametro('categoria', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getCategoriaDocente',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('CategoriaDocente', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - CategoriaDocente }
function TMatematicas.CategoriasDocente: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('CategoriasDocentes', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_categoria_docentes', 'categoria', Query);

    limpiarParametros;
    agregarParametro('idcategoriadocente', 'String');
    agregarParametro('categoria', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllCategoriaDocente',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('CategoriasDocente', Json.toString);
  Query.Free;
end;

{ Método DELETE - CategoriaDocente }
function TMatematicas.cancelCartaPermiso(IdCarta: string): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.deleteCartaPermiso(IdCarta)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.cancelCategoriaDocente(const token, ID: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_categoria_docentes', 'idcategoriadocente', Texto(ID), Query);

      Json.AddPair(JsonRespuesta, 'La Categoría se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteCategoriaDocente',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelCategoriaDocente', Json.toString);
  Query.Free;
end;

{ Método UPDATE - CategoriaDocente }
function TMatematicas.acceptCartaPermiso(datos: TJSONObject): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.putCartaPermiso(datos)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.acceptCategoriaDocente(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idcategoriadocente', 'String');
      agregarParametro('categoria', 'String');

      ID := datos.GetValue('idcategoriadocente').Value;
      UPDATE('siap_categoria_docentes', 'idcategoriadocente', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'La Categoría se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptCategoriaDocente',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateCategoriaDocente', Json.toString);
  Query.Free;
end;

{ Método INSERT - Error }
function TMatematicas.updateEnviarCorreoPractica(datos: TJSONObject)
  : TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.enviarCorreo(datos)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.updateError(const token: string; const datos: TJSONObject)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('iderror', 'String');
      agregarParametro('hora', 'String');
      agregarParametro('fecha', 'String');
      agregarParametro('procedimiento', 'String');
      agregarParametro('mensaje', 'String');

      INSERT('siap_errores', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Registro de Error se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateError',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateError', Json.toString);
  Query.Free;
end;

{ Método GET - Error }
function TMatematicas.Error(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_errores', 'iderror', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('iderror', 'String');
    agregarParametro('hora', 'String');
    agregarParametro('fecha', 'String');
    agregarParametro('procedimiento', 'String');
    agregarParametro('mensaje', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getError',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('Error', Json.toString);
  Query.Free;
end;

{ Método GET-ALL - Error }
function TMatematicas.Errores: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('Errores', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_errores', 'hora', Query);

    limpiarParametros;
    agregarParametro('iderror', 'String');
    agregarParametro('hora', 'String');
    agregarParametro('fecha', 'String');
    agregarParametro('procedimiento', 'String');
    agregarParametro('mensaje', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllError',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('Errores', Json.toString);
  Query.Free;
end;

{ Método DELETE - Error }
function TMatematicas.cancelError(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_errores', 'iderror', Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'El Registro de Error se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteError',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelError', Json.toString);
  Query.Free;
end;

function TMatematicas.cancelErrorPorMensaje(const token, msg: string)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_errores', 'mensaje', Texto(msg), Query);

      Json.AddPair(JsonRespuesta,
        'Los Registros de Error se eliminaron correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteError',
        E.Message + '=> ' + msg);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelError', Json.toString);
  Query.Free;
end;

function TMatematicas.cancelEstudiante(IdEstudiante: string): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.deleteEstudiante(IdEstudiante)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.cancelEstudianteCarta(IdEstudianteCarta: string)
  : TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.deleteEstudianteCarta(IdEstudianteCarta)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

{ Método UPDATE - Error }
function TMatematicas.acceptError(const token: string; const datos: TJSONObject)
  : TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('iderror', 'String');
      agregarParametro('hora', 'String');
      agregarParametro('fecha', 'String');
      agregarParametro('procedimiento', 'String');
      agregarParametro('mensaje', 'String');

      ID := datos.GetValue('iderror').Value;
      UPDATE('siap_errores', 'iderror', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'El Registro de Error se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptError',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateError', Json.toString);
  Query.Free;
end;

{ Método INSERT - TipoContrato }
function TMatematicas.updateTipoContrato(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idtipocontrato', 'String');
      agregarParametro('contrato', 'String');
      agregarParametro('horas', 'String');

      INSERT('siap_tipo_contrato', Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta, 'El Tipo de Contrato se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateTipoContrato',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateTipoContrato', Json.toString);
  Query.Free;
end;

function TMatematicas.updateTipoProduccion(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  QTipoProd: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QTipoProd := TFDQuery.create(nil);
    QTipoProd.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QTipoProd.Close;
      QTipoProd.SQL.Text :=
        'INSERT INTO siap_tipo_produccion (idtipo,tipo,identificador) VALUES (:idtipo,:tipo)';

      QTipoProd.Params.ParamByName('idtipo').Value := moduloDatos.generarID;
      QTipoProd.Params.ParamByName('tipo').Value :=
        datos.GetValue('tipo').Value;
      QTipoProd.Params.ParamByName('identificador').Value :=
        datos.GetValue('identificador').Value;

      QTipoProd.ExecSQL;

      Json.AddPair('Respuesta', 'El tipo de producción se creo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'updateTipoProduccion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateTipoProduccion', Json.toString);
  QTipoProd.Free;
end;

{ Método GET - TipoContrato }
function TMatematicas.TipoAccion(ID: string): TJSONObject;
var
  Query: TFDQuery;
  JsonResp: TJSONObject;
  aFuentes: TJSONArray;
  i: integer;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    JsonResp := TJSONObject.create;
    aFuentes := TJSONArray.create;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_tipo_accion_pm WHERE idtipoaccion=' +
      #39 + ID + #39;
    Query.Open;

    JsonResp.AddPair('idtipoaccion', Query.FieldByName('idtipoaccion')
      .AsString);
    JsonResp.AddPair('tipo_accion', Query.FieldByName('tipo_accion').AsString);

  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  Query.Free;
end;

function TMatematicas.TipoContrato(const ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    limpiarConsulta(Query);
    SelectWhere('siap_tipo_contrato', 'idtipocontrato', Texto(ID), Query);

    limpiarParametros;
    agregarParametro('idtipocontrato', 'String');
    agregarParametro('contrato', 'String');
    agregarParametro('horas', 'String');

    Json := crearJSON(Query);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getTipoContrato',
        E.Message + '=>' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('TipoContrato', Json.toString);
  Query.Free;
end;

function TMatematicas.tipoParticipacion: TJSONObject;
begin
  Result := moduloEventoEMEM.getTiposParticipacion;
end;

{ Método GET-ALL - TipoContrato }
function TMatematicas.TiposAccion: TJSONObject;
var
  QTiposAccion: TFDQuery;
  JsonTiposAccion, JsonTipoAccion: TJSONObject;
  aTiposAccion: TJSONArray;
  i: integer;
begin
  try
    QTiposAccion := TFDQuery.create(nil);
    QTiposAccion.Connection := Conexion;

    JsonTiposAccion := TJSONObject.create;
    aTiposAccion := TJSONArray.create;

    QTiposAccion.Close;
    QTiposAccion.SQL.Text :=
      'SELECT * FROM siap_tipo_accion_pm ORDER BY tipo_accion';
    QTiposAccion.Open;
    QTiposAccion.First;

    for i := 1 to QTiposAccion.RecordCount do
    begin
      JsonTipoAccion := TJSONObject.create;
      JsonTipoAccion.AddPair('idtipoaccion',
        QTiposAccion.FieldByName('idtipoaccion').AsString);
      JsonTipoAccion.AddPair('tipo_accion',
        QTiposAccion.FieldByName('tipo_accion').AsString);

      aTiposAccion.AddElement(JsonTipoAccion);
      QTiposAccion.Next;
    end;

    JsonTiposAccion.AddPair('TiposAccion', aTiposAccion);
  except
    on E: Exception do
      JsonTiposAccion.AddPair('Error', E.Message);
  end;

  Result := JsonTiposAccion;
  QTiposAccion.Free;
end;

function TMatematicas.TiposContrato: TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ArrayJson: TJSONArray;
  JsonLinea: TJSONObject;
  i: integer;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;
    ArrayJson := TJSONArray.create;
    Json.AddPair('TiposContratos', ArrayJson);

    limpiarConsulta(Query);
    SELECT('siap_tipo_contrato', 'contrato', Query);

    limpiarParametros;
    agregarParametro('idtipocontrato', 'String');
    agregarParametro('contrato', 'String');
    agregarParametro('horas', 'String');

    for i := 1 to Query.RecordCount do
    begin
      ArrayJson.AddElement(crearJSON(Query));
      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAllTipoContrato',
        E.Message + '-no data-');
    end;
  end;

  Result := Json;
  escribirMensaje('TiposContrato', Json.toString);
  Query.Free;
end;

function TMatematicas.TiposProduccion: TJSONObject;
var
  Json, JsonTipo: TJSONObject;
  QTipoProd: TFDQuery;
  Tipos: TJSONArray;
  objWebModule: TWebModule;
  token: string;
  i: integer;
begin
  try
    QTipoProd := TFDQuery.create(nil);
    QTipoProd.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QTipoProd.Close;
      QTipoProd.SQL.Text := 'SELECT * FROM siap_tipo_produccion';
      QTipoProd.Open;
      QTipoProd.First;

      Tipos := TJSONArray.create;
      for i := 1 to QTipoProd.RecordCount do
      begin
        JsonTipo := TJSONObject.create;
        JsonTipo.AddPair('idtipo', QTipoProd.FieldByName('idtipo').AsString);
        JsonTipo.AddPair('tipo', QTipoProd.FieldByName('tipo').AsString);
        JsonTipo.AddPair('identificador', QTipoProd.FieldByName('identificador')
          .AsString);

        Tipos.AddElement(JsonTipo);
        QTipoProd.Next;
      end;

      Json.AddPair('Tipos', Tipos);
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'TiposProduccion', E.Message);
    end;
  end;

  Result := Json;
  escribirMensaje('TiposProduccion', Json.toString);
  QTipoProd.Free;
end;

{ Método DELETE - TipoContrato }
function TMatematicas.cancelTipoContrato(const token, ID: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);
      DELETE('siap_tipo_contrato', 'idtipocontrato', Texto(ID), Query);

      Json.AddPair(JsonRespuesta,
        'El Tipo de Contrato se eliminó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'deleteTipoContrato',
        E.Message + '=> ' + ID);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelTipoContrato', Json.toString);
  Query.Free;
end;

function TMatematicas.cancelTipoProduccion(IdTipo: string): TJSONObject;
var
  Json: TJSONObject;
  QTipoProd: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QTipoProd := TFDQuery.create(nil);
    QTipoProd.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QTipoProd.Close;
      QTipoProd.SQL.Text := 'DELETE FROM siap_tipo_produccion ' +
        'WHERE idtipo=' + #39 + IdTipo + #39;

      QTipoProd.ExecSQL;

      Json.AddPair('Respuesta',
        'El tipo de producción se elimino correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'cancelTipoProduccion',
        E.Message + IdTipo);
    end;
  end;

  Result := Json;
  escribirMensaje('cancelTipoProduccion', Json.toString);
  QTipoProd.Free;
end;

{ Método UPDATE - TipoContrato }
function TMatematicas.acceptTipoContrato(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  ID: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      limpiarConsulta(Query);

      limpiarParametros;

      agregarParametro('idtipocontrato', 'String');
      agregarParametro('contrato', 'String');
      agregarParametro('horas', 'String');

      ID := datos.GetValue('idtipocontrato').Value;
      UPDATE('siap_tipo_contrato', 'idtipocontrato', Texto(ID), Query);

      asignarDatos(datos, Query);

      Json.AddPair(JsonRespuesta,
        'El Tipo de Contrato se actualizó correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptTipoContrato',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('updateTipoContrato', Json.toString);
  Query.Free;
end;

function TMatematicas.acceptTipoProduccion(datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  QTipoProd: TFDQuery;
  objWebModule: TWebModule;
  token: string;
begin
  try
    QTipoProd := TFDQuery.create(nil);
    QTipoProd.Connection := Conexion;
    Json := TJSONObject.create;

    objWebModule := GetDataSnapWebModule;
    token := objWebModule.Request.GetFieldByName('Autorizacion');

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      QTipoProd.Close;
      QTipoProd.SQL.Text := 'UPDATE siap_tipo_produccion SET ' +
        'tipo=:tipo,identificador=:identificador WHERE idtipo=' + #39 +
        datos.GetValue('idtipo').Value + #39;

      QTipoProd.Params.ParamByName('tipo').Value :=
        datos.GetValue('tipo').Value;
      QTipoProd.Params.ParamByName('identificador').Value :=
        datos.GetValue('identificador').Value;

      QTipoProd.ExecSQL;

      Json.AddPair('Respuesta',
        'El tipo de producción se actualizo correctamente');
    end
    else
    begin
      Json.AddPair(JsonRespuesta, AccesoDenegado);
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'acceptTipoProduccion',
        E.Message + datos.toString);
    end;
  end;

  Result := Json;
  escribirMensaje('acceptTipoProduccion', Json.toString);
  QTipoProd.Free;
end;

{ CRUD: referenciaResumen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
function TMatematicas.referenciaResumen(idClave: string): TJSONObject;
var
  _referenciaResumen: TreferenciaResumen;
begin
  try
    _referenciaResumen := TreferenciaResumen.create;
    _referenciaResumen.Conexion := Conexion;

    iniciarConexion;

    if idClave = 'all' then
      Result := _referenciaResumen.getAll
    else if idClave = 'model' then
      Result := _referenciaResumen.model
    else
      Result := _referenciaResumen.Get(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'get');

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-referenciaResumen');
  end;

  _referenciaResumen.Free;
end;

function TMatematicas.referenciasResumen(idClave: string): TJSONObject;
var
  _referenciaResumen: TreferenciaResumen;
begin
  try
    _referenciaResumen := TreferenciaResumen.create;
    _referenciaResumen.Conexion := Conexion;

    iniciarConexion;

    Result := _referenciaResumen.getReferenciasResumenes(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'get');

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-referenciasResumen');
  end;

  _referenciaResumen.Free;
end;

function TMatematicas.ReporteHorasFacultad(Periodo: string): TJSONObject;
var
  Json, JsonContrato, JsonNombreFacultad, JsonFacultad, jsonDocente,
    JsonFuncion, JsonEstadistica, JsonActividad: TJSONObject;

  Contratos, Docentes, NombresFacultades, Estadisticas, Funciones,
    Facultades: TJSONArray;

  Query, QContrato, QDocentes, QFacultad, QFunciones, QServicios,
    QActividades: TFDQuery;

  i, j, k, l, Semanas: integer;

  IdTipoContrato, FormaCalculoFuncion, IdFuncion, NombreContrato, IdDocente,
    IdFacultad, Jornada, tipo: string;

  Factor, TotalHorasAgenda, sumaHorasServicios, horas, sumaHorasSinFactor,
    sumaHorasConFactor, sumaHorasFunciones: real;

  sumaHorasFacultad, sumaHorasContrato: TStringList;
begin
  QServicios := TFDQuery.create(nil);
  QServicios.Connection := Conexion;
  QContrato := TFDQuery.create(nil);
  QContrato.Connection := Conexion;
  QFacultad := TFDQuery.create(nil);
  QFacultad.Connection := Conexion;
  QDocentes := TFDQuery.create(nil);
  QDocentes.Connection := Conexion;
  QFunciones := TFDQuery.create(nil);
  QFunciones.Connection := Conexion;
  QActividades := TFDQuery.create(nil);
  QActividades.Connection := Conexion;

  try
    Json := TJSONObject.create;

    { Leer los tipos de contrato que hay }
    QContrato.Close;
    QContrato.SQL.Text :=
      'SELECT * FROM siap_tipo_contrato ORDER BY horas desc';
    QContrato.Open;
    QContrato.First;

    Contratos := TJSONArray.create;

    for i := 1 to QContrato.RecordCount do
    begin
      IdTipoContrato := QContrato.FieldByName('idtipocontrato').AsString;
      NombreContrato := QContrato.FieldByName('contrato').AsString;

      JsonContrato := TJSONObject.create;
      JsonContrato.AddPair('IdTipoContrato', IdTipoContrato);
      JsonContrato.AddPair('Contrato', QContrato.FieldByName('contrato')
        .AsString);

      if NombreContrato = 'carrera' then
        Factor := 2.5;
      if NombreContrato = 'contrato' then
        Factor := 2.0;
      if NombreContrato = 'catedrático' then
        Factor := 1.0;

      { Leer los docentes por tipo de contrato }
      QDocentes.Close;
      QDocentes.SQL.Text := 'SELECT * FROM siap_docentes WHERE idtipocontrato='
        + #39 + IdTipoContrato + #39 + ' and Vinculacion=' + #39 + 'docente' +
        #39 + ' ORDER BY nombre';
      QDocentes.Open;
      QDocentes.First;

      Docentes := TJSONArray.create;

      { escribirMensaje('ReporteHorasFacultad',
        'Se realizo la consulta de docentes, Total = ' +
        IntToStr(QDocentes.RecordCount)); }

      sumaHorasFacultad := TStringList.create;
      sumaHorasContrato := TStringList.create;

      QFacultad.Close;
      QFacultad.SQL.Text := 'SELECT * FROM siap_facultades ORDER BY orden';
      QFacultad.Open;

      // Formatear las horas de cada facultad
      for j := 1 to QFacultad.RecordCount do
        sumaHorasFacultad.Add('0');

      // Formatear las horas de contrato
      for j := 1 to 6 do
        sumaHorasContrato.Add('0');

      for j := 1 to QDocentes.RecordCount do
      begin
        IdDocente := QDocentes.FieldByName('iddocente').AsString;
        TotalHorasAgenda := 0;

        jsonDocente := TJSONObject.create;
        jsonDocente.AddPair('IdDocente', QDocentes.FieldByName('iddocente')
          .AsString);
        jsonDocente.AddPair('Nombre', QDocentes.FieldByName('nombre').AsString);

        { Leer las facultades }
        QFacultad.Close;
        QFacultad.SQL.Text := 'SELECT * FROM siap_facultades ORDER BY orden';
        QFacultad.Open;
        QFacultad.First;

        { escribirMensaje('ReporteHorasFacultad',
          'Se realizo la consulta de Facultades, Total = ' +
          IntToStr(QFacultad.RecordCount)); }

        sumaHorasSinFactor := 0;
        sumaHorasConFactor := 0;

        Facultades := TJSONArray.create;
        for k := 1 to QFacultad.RecordCount do
        begin
          IdFacultad := QFacultad.FieldByName('idfacultad').AsString;

          JsonFacultad := TJSONObject.create;
          JsonFacultad.AddPair('IdFacultad', IdFacultad);
          JsonFacultad.AddPair('Nombre', QFacultad.FieldByName('facultad')
            .AsString);
          JsonFacultad.AddPair('NombreCorto',
            QFacultad.FieldByName('nombrecorto').AsString);
          JsonFacultad.AddPair('Color', QFacultad.FieldByName('color')
            .AsString);

          QServicios.Close;
          QServicios.SQL.Clear;
          QServicios.SQL.Add('SELECT * FROM siap_agendas_servicios as sas ');
          QServicios.SQL.Add('INNER JOIN siap_docentes as sd ');
          QServicios.SQL.Add('ON sas.iddocente = sd.iddocente ');
          QServicios.SQL.Add('INNER JOIN siap_servicios_programas as ssp ');
          QServicios.SQL.Add
            ('ON sas.idservicioprograma = ssp.idservicioprograma ');
          QServicios.SQL.Add('INNER JOIN siap_programas as sp ');
          QServicios.SQL.Add('ON sp.idprograma = ssp.idprograma ');
          QServicios.SQL.Add('INNER JOIN siap_facultades as sf ');
          QServicios.SQL.Add('ON sf.idfacultad = sp.idfacultad ');
          QServicios.SQL.Add('WHERE sas.periodo=' + #39 + Periodo + #39 +
            ' AND sd.iddocente=' + IdDocente + ' AND sf.idfacultad=' + #39 +
            IdFacultad + #39 + ' ORDER BY sf.orden');
          QServicios.Open;
          QServicios.First;

          { escribirMensaje('ReporteHorasFacultad',
            'Se realizo la consulta de Servicios, Total = ' +
            IntToStr(QServicios.RecordCount)); }

          sumaHorasServicios := 0;

          for l := 1 to QServicios.RecordCount do
          begin
            tipo := QServicios.FieldByName('tipo').AsString;
            Jornada := QServicios.FieldByName('jornada').AsString;
            horas := QServicios.FieldByName('horas').AsInteger;

            if (Jornada <> 'virtual') and (Jornada <> 'distancia') then
            begin
              Semanas := QServicios.FieldByName('semanas').AsInteger;
              sumaHorasServicios := sumaHorasServicios + horas * Semanas;

              sumaHorasSinFactor := sumaHorasSinFactor + horas * Semanas;

              if tipo = 'pregrado' then
                sumaHorasConFactor := sumaHorasConFactor +
                  (horas * Semanas) * Factor
              else
                sumaHorasConFactor := sumaHorasConFactor + (horas * Semanas) *
                  (Factor + 1);
            end
            else
            begin
              sumaHorasServicios := sumaHorasServicios + horas;
              sumaHorasSinFactor := sumaHorasSinFactor + horas;
            end;

            QServicios.Next;
          end;

          // Guardar la cantidad de horas de la facultad
          JsonFacultad.AddPair('TotalHoras', floatTostr(sumaHorasServicios));
          sumaHorasFacultad[k - 1] :=
            floatTostr(sumaHorasServicios + StrToInt(sumaHorasFacultad[k - 1]));
          Facultades.Add(JsonFacultad);

          QFacultad.Next;
        end;

        TotalHorasAgenda := TotalHorasAgenda + sumaHorasConFactor;

        { Si el tipo de contrato es carrera o contrato leer funciones docentes }
        QFunciones.Close;
        QFunciones.SQL.Text :=
          'SELECT * FROM siap_funciones_docentes ORDER BY funcion';
        QFunciones.Open;
        QFunciones.First;

        { escribirMensaje('ReporteHorasFacultad',
          'Se realizo la consulta de Funciones, Total = ' +
          IntToStr(QFunciones.RecordCount)); }

        Funciones := TJSONArray.create;
        for k := 1 to QFunciones.RecordCount do
        begin
          IdFuncion := QFunciones.FieldByName('idfunciondocente').AsString;

          JsonFuncion := TJSONObject.create;
          JsonFuncion.AddPair('IdFuncion', IdFuncion);
          JsonFuncion.AddPair('Nombre', QFunciones.FieldByName('funcion')
            .AsString);

          QActividades.Close;
          QActividades.SQL.Clear;
          QActividades.SQL.Add
            ('SELECT * FROM siap_actividades_funciones_docente as safd ');
          QActividades.SQL.Add('INNER JOIN siap_funciones_docentes as sfd ');
          QActividades.SQL.Add('ON safd.idfuncion = sfd.idfunciondocente ');
          QActividades.SQL.Add('WHERE safd.iddocente=' + IdDocente +
            ' AND safd.periodo=' + #39 + Periodo + #39 + ' AND safd.idfuncion='
            + #39 + IdFuncion + #39 + '');
          QActividades.Open;
          QActividades.First;

          sumaHorasFunciones := 0;
          for l := 1 to QActividades.RecordCount do
          begin
            FormaCalculoFuncion := QActividades.FieldByName
              ('calculada').AsString;
            horas := QActividades.FieldByName('horas').AsFloat;

            if FormaCalculoFuncion = 'semanales' then
              sumaHorasFunciones := sumaHorasFunciones + horas * 17
            else
              sumaHorasFunciones := sumaHorasFunciones + horas;

            QActividades.Next;
          end;

          JsonFuncion.AddPair('TotalHoras', floatTostr(sumaHorasFunciones));

          TotalHorasAgenda := TotalHorasAgenda + sumaHorasFunciones;

          Funciones.Add(JsonFuncion);

          sumaHorasContrato[k + 1] :=
            floatTostr(StrToFloat(sumaHorasContrato[k + 1]) +
            sumaHorasFunciones);

          QFunciones.Next;
        end;

        jsonDocente.AddPair('Facultades', Facultades);
        jsonDocente.AddPair('totalHorasSinFactor',
          floatTostr(sumaHorasSinFactor));
        jsonDocente.AddPair('totalHorasConFactor',
          floatTostr(sumaHorasConFactor));
        jsonDocente.AddPair('Funciones', Funciones);
        jsonDocente.AddPair('TotalHorasAgenda', floatTostr(TotalHorasAgenda));

        // Generar la suma de horas específicas
        sumaHorasContrato[0] := floatTostr(StrToFloat(sumaHorasContrato[0]) +
          sumaHorasSinFactor);
        sumaHorasContrato[1] := floatTostr(StrToFloat(sumaHorasContrato[1]) +
          sumaHorasConFactor);

        Docentes.Add(jsonDocente);

        QDocentes.Next;

        { Hacer la sumatoria de horas con factor, sin factor y otros }
      end;

      { Crear el vector de nombres de facultades }
      QFacultad.Close;
      QFacultad.SQL.Text := 'SELECT * FROM siap_facultades ORDER BY orden';
      QFacultad.Open;
      QFacultad.First;

      NombresFacultades := TJSONArray.create;
      for k := 1 to QFacultad.RecordCount do
      begin
        JsonNombreFacultad := TJSONObject.create;
        JsonNombreFacultad.AddPair('IdFacultad',
          QFacultad.FieldByName('idfacultad').AsString);
        JsonNombreFacultad.AddPair('Nombre', QFacultad.FieldByName('facultad')
          .AsString);
        JsonNombreFacultad.AddPair('NombreCorto',
          QFacultad.FieldByName('nombrecorto').AsString);

        { Enviar la cantidad horas por cada facultad }
        JsonNombreFacultad.AddPair('TotalHoras', sumaHorasFacultad[k - 1]);

        NombresFacultades.Add(JsonNombreFacultad);
        QFacultad.Next;
      end;

      Estadisticas := TJSONArray.create;
      { Docencia directa sin factor }
      JsonEstadistica := TJSONObject.create;
      JsonEstadistica.AddPair('Nombre', 'Docencia Directa (Sin Factor)');
      JsonEstadistica.AddPair('Horas', sumaHorasContrato[0]);
      Estadisticas.AddElement(JsonEstadistica);

      { Docencia directa con factor }
      JsonEstadistica := TJSONObject.create;
      JsonEstadistica.AddPair('Nombre', 'Docencia Directa (Con Factor)');
      JsonEstadistica.AddPair('Horas', sumaHorasContrato[1]);
      Estadisticas.AddElement(JsonEstadistica);

      { Docencia Complementaria }
      JsonEstadistica := TJSONObject.create;
      JsonEstadistica.AddPair('Nombre', 'Docencia Complementaria');
      JsonEstadistica.AddPair('Horas', sumaHorasContrato[2]);
      Estadisticas.AddElement(JsonEstadistica);

      { Investigación }
      JsonEstadistica := TJSONObject.create;
      JsonEstadistica.AddPair('Nombre', 'Investigación');
      JsonEstadistica.AddPair('Horas', sumaHorasContrato[3]);
      Estadisticas.AddElement(JsonEstadistica);

      { Extensión }
      JsonEstadistica := TJSONObject.create;
      JsonEstadistica.AddPair('Nombre', 'Extensión');
      JsonEstadistica.AddPair('Horas', sumaHorasContrato[4]);
      Estadisticas.AddElement(JsonEstadistica);

      { Agregar los reportes por cada tipo de contrato }
      JsonContrato.AddPair('Docentes', Docentes);
      JsonContrato.AddPair('Facultades', NombresFacultades);
      JsonContrato.AddPair('Estadisticas', Estadisticas);

      Contratos.Add(JsonContrato);

      QContrato.Next;

      escribirMensaje('ReporteHorasFacultad', 'Contrato Terminado: ' +
        Contratos.toString);
    end;

    Json.AddPair('Contratos', Contratos);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAgendaServicio',
        E.Message + '=>' + Periodo);
    end;
  end;

  Result := Json;
  escribirMensaje('AgendaServicio', Json.toString);

  QServicios.Free;
  QContrato.Free;
  QFacultad.Free;
  QDocentes.Free;
  QFunciones.Free;
  QActividades.Free;
end;

function TMatematicas.ReporteProgramaServicios(const IdProgrma, Periodo: string)
  : TJSONObject;
var
  Json, JsonServicio: TJSONObject;
  Servicios: TJSONArray;
  Query: TFDQuery;
  i: integer;
  horSem: integer;
  contrato: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  try
    Json := TJSONObject.create;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT * FROM siap_agendas_servicios ags ');
    Query.SQL.Add('INNER JOIN siap_docentes as doc ');
    Query.SQL.Add('ON ags.iddocente = doc.iddocente ');
    Query.SQL.Add('INNER JOIN siap_servicios_programas as sp');
    Query.SQL.Add('ON sp.idservicioprograma = ags.idservicioprograma ');
    Query.SQL.Add('INNER JOIN siap_programas as pr ');
    Query.SQL.Add('ON sp.idprograma = pr.idprograma ');
    Query.SQL.Add('INNER JOIN siap_categoria_docentes as cd  ');
    Query.SQL.Add('ON doc.idcategoriadocente = cd.idcategoriadocente ');
    Query.SQL.Add('INNER JOIN siap_tipo_contrato as tc ');
    Query.SQL.Add('ON tc.idtipocontrato = doc.idtipocontrato ');
    Query.SQL.Add('WHERE sp.idprograma=' + #39 + IdProgrma + #39 + '');
    Query.SQL.Add(' AND ags.periodo=' + #39 + Periodo + #39 +
      ' ORDER BY sp.asignatura');
    Query.Open;
    Query.First;

    FDataSnapMatematicas.comentarioSQL
      ('Consulta para reporte de servicios por programa');
    FDataSnapMatematicas.escribirSQL(Query.SQL.Text);

    Servicios := TJSONArray.create;

    for i := 1 to Query.RecordCount do
    begin
      JsonServicio := TJSONObject.create;

      JsonServicio.AddPair('iddocente', Query.FieldByName('iddocente')
        .AsString);
      JsonServicio.AddPair('periodo', Query.FieldByName('periodo').AsString);
      JsonServicio.AddPair('numerocontrato', Query.FieldByName('numerocontrato')
        .AsString);
      JsonServicio.AddPair('nombre', Query.FieldByName('nombre').AsString);
      JsonServicio.AddPair('correo', Query.FieldByName('correo').AsString);
      JsonServicio.AddPair('telefono', Query.FieldByName('telefono').AsString);
      JsonServicio.AddPair('asignatura', Query.FieldByName('asignatura')
        .AsString);
      JsonServicio.AddPair('horas', Query.FieldByName('horas').AsString);
      JsonServicio.AddPair('jornada', Query.FieldByName('jornada').AsString);
      JsonServicio.AddPair('tipo', Query.FieldByName('tipo').AsString);
      JsonServicio.AddPair('programa', Query.FieldByName('programa').AsString);
      JsonServicio.AddPair('categoria', Query.FieldByName('categoria')
        .AsString);
      JsonServicio.AddPair('grupo', Query.FieldByName('grupo').AsString);
      JsonServicio.AddPair('semanas', Query.FieldByName('semanas').AsString);

      contrato := Query.FieldByName('contrato').AsString;
      if contrato = 'catedrático' then
        contrato := 'Docente de Cátedra '
      else
        contrato := 'Docente de ' + contrato;

      JsonServicio.AddPair('contrato', contrato);

      if (Query.FieldByName('jornada').AsString = 'virtual') then
        JsonServicio.AddPair('horsem', 'virtual')
      else if (Query.FieldByName('jornada').AsString = 'distancia') then
        JsonServicio.AddPair('horsem', 'distancia')
      else
      begin
        horSem := StrToInt(Query.FieldByName('horas').AsString) *
          StrToInt(Query.FieldByName('semanas').AsString);
        JsonServicio.AddPair('horsem', IntToStr(horSem));
      end;

      Servicios.Add(JsonServicio);
      Query.Next;
    end;

    Json.AddPair('Servicios', Servicios);

  except
    on E: Exception do
    begin
      Json.AddPair(JsonError, E.Message);
      enviarError(TimeToStr(now), DateToStr(now), 'getAgendaServicio',
        E.Message + '=>' + IdProgrma);
    end;
  end;

  Result := Json;
  escribirMensaje('AgendaServicio', Json.toString);
  Query.Free;
end;

function TMatematicas.Requisito(ID: string): TJSONObject;
var
  Query: TFDQuery;
  JsonResp: TJSONObject;
  aFuentes: TJSONArray;
  i: integer;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    JsonResp := TJSONObject.create;
    aFuentes := TJSONArray.create;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_requisito_pm WHERE idrequisito=' + #39
      + ID + #39;
    Query.Open;

    JsonResp.AddPair('idrequisito', Query.FieldByName('idrequisito').AsString);
    JsonResp.AddPair('requisito', Query.FieldByName('requisito').AsString);

  except
    on E: Exception do
      JsonResp.AddPair('Error', E.Message);
  end;

  Result := JsonResp;
  Query.Free;
end;

function TMatematicas.Requisitos: TJSONObject;
var
  QRequisitos: TFDQuery;
  JsonRequisitos, JsonRequisito: TJSONObject;
  aRequisitos: TJSONArray;
  i: integer;
begin
  try
    QRequisitos := TFDQuery.create(nil);
    QRequisitos.Connection := Conexion;

    JsonRequisitos := TJSONObject.create;
    aRequisitos := TJSONArray.create;

    QRequisitos.Close;
    QRequisitos.SQL.Text :=
      'SELECT * FROM siap_requisito_pm ORDER BY requisito';
    QRequisitos.Open;
    QRequisitos.First;

    for i := 1 to QRequisitos.RecordCount do
    begin
      JsonRequisito := TJSONObject.create;
      JsonRequisito.AddPair('idrequisito',
        QRequisitos.FieldByName('idrequisito').AsString);
      JsonRequisito.AddPair('requisito', QRequisitos.FieldByName('requisito')
        .AsString);

      aRequisitos.AddElement(JsonRequisito);
      QRequisitos.Next;
    end;

    JsonRequisitos.AddPair('Requisitos', aRequisitos);
  except
    on E: Exception do
      JsonRequisitos.AddPair('Error', E.Message);
  end;

  Result := JsonRequisitos;
  QRequisitos.Free;
end;

function TMatematicas.updatereferenciaResumen(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _referenciaResumen: TreferenciaResumen;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _referenciaResumen := TreferenciaResumen.create;
      _referenciaResumen.Conexion := Conexion;

      iniciarConexion;
      Json := _referenciaResumen.post(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'post');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-updateReferenciaResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _referenciaResumen.Free;
end;

function TMatematicas.acceptreferenciaResumen(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _referenciaResumen: TreferenciaResumen;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _referenciaResumen := TreferenciaResumen.create;
      _referenciaResumen.Conexion := Conexion;

      iniciarConexion;
      Json := _referenciaResumen.put(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'put');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-acceptReferenciaResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _referenciaResumen.Free;
end;

function TMatematicas.cancelreferenciaResumen(const idClave: string;
  const token: string): TJSONObject;
var
  _referenciaResumen: TreferenciaResumen;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;

  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _referenciaResumen := TreferenciaResumen.create;
      _referenciaResumen.Conexion := Conexion;

      iniciarConexion;
      Json := _referenciaResumen.DELETE(idClave);
      terminarConexion;

      escribirMensaje(Json.toString, 'delete');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-cancelReferenciaResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _referenciaResumen.Free;
end;

{ CRUD: autorResumen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
function TMatematicas.autoresResumen(idClave: string): TJSONObject;
var
  Json, JsonFor: TJSONObject;
  ArregloJSON: TJSONArray;
  i: integer;
  Query, Query2: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Query2 := TFDQuery.create(nil);
    Query2.Connection := Conexion;

    iniciarConexion;

    Json := TJSONObject.create;
    ArregloJSON := TJSONArray.create;
    Json.AddPair('autores', ArregloJSON);

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM math_resumenes_autor WHERE id_resumen=' +
      chr(39) + idClave + chr(39) + ' ORDER BY id_resumen_autor';
    Query.Open;
    Query.First;

    for i := 1 to Query.RecordCount do
    begin
      JsonFor := TJSONObject.create;

      Query2.Close;
      Query2.SQL.Text := 'SELECT * FROM math_autor_resumen WHERE cedula=' +
        chr(39) + Query.FieldByName('cedula').AsString + chr(39);
      Query2.Open;

      JsonFor.AddPair('cedula', Query2.FieldByName('cedula').AsString);
      JsonFor.AddPair('correo', Query2.FieldByName('correo').AsString);
      JsonFor.AddPair('nombre', Query2.FieldByName('nombre').AsString);
      JsonFor.AddPair('institucion', Query2.FieldByName('institucion')
        .AsString);

      ArregloJSON.AddElement(JsonFor);

      Query.Next;
    end;
    terminarConexion;

    escribirMensaje(Json.toString, 'get');

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-autoresResumen');
  end;

  Result := Json;
  Query.Free;
  Query2.Free;
end;

function TMatematicas.autorPorCedula(cedula: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM math_autor_resumen WHERE cedula=' + chr(39)
      + cedula + chr(39);

    Query.Open;

    Json := TJSONObject.create;

    if Query.RecordCount > 0 then
    begin
      Json.AddPair('cedula', Query.FieldByName('cedula').AsString);
      Json.AddPair('nombre', Query.FieldByName('nombre').AsString);
      Json.AddPair('correo', Query.FieldByName('correo').AsString);
      Json.AddPair('institucion', Query.FieldByName('institucion').AsString);
      Json.AddPair('resultado', 'autor encontrado');
    end
    else
    begin
      Json.AddPair('cedula', cedula);
      Json.AddPair('nombre', '');
      Json.AddPair('correo', '');
      Json.AddPair('institucion', '');
      Json.AddPair('resultado', 'el autor no existe');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-autorPorCedula');
      Json.AddPair('error', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.autorResumen(idClave: string): TJSONObject;
var
  _autorResumen: TautorResumen;
begin
  try
    _autorResumen := TautorResumen.create;
    _autorResumen.Conexion := Conexion;

    iniciarConexion;

    if idClave = 'all' then
      Result := _autorResumen.getAll
    else if idClave = 'model' then
      Result := _autorResumen.model
    else
      Result := _autorResumen.Get(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'get');

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-autorResumen');
  end;

  _autorResumen.Free;
end;

function TMatematicas.Estudiante(Documento, Periodo: string): TJSONObject;
begin
  Result := moduloPracticaDocente.BuscarEstudiante(Documento, Periodo);
end;

function TMatematicas.updateagregarAutorResumen(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  Json := TJSONObject.create;
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      iniciarConexion;

      Query.Close;
      Query.SQL.Text := 'SELECT * FROM math_autor_resumen WHERE cedula=' +
        chr(39) + datos.GetValue('cedula').Value + chr(39);
      Query.Open;

      if Query.RecordCount > 0 then
      begin
        Query.Close;
        Query.SQL.Text :=
          'INSERT INTO math_resumenes_autor (cedula, id_resumen)' +
          ' VALUES (:cedula, :id_resumen)';
        Query.Params.ParamByName('cedula').Value :=
          datos.GetValue('cedula').Value;
        Query.Params.ParamByName('id_resumen').Value :=
          datos.GetValue('id_resumen').Value;
        Query.ExecSQL;

        Json.AddPair('resultado', 'El autor se creo correctamente');
      end
      else
      begin
        Query.Close;
        Query.SQL.Text := 'INSERT INTO math_autor_resumen (cedula, nombre,' +
          'correo,institucion)' +
          ' VALUES (:cedula, :nombre, :correo, :institucion)';

        Query.Params.ParamByName('cedula').Value :=
          datos.GetValue('cedula').Value;
        Query.Params.ParamByName('nombre').Value :=
          datos.GetValue('nombre').Value;
        Query.Params.ParamByName('correo').Value :=
          datos.GetValue('correo').Value;
        Query.Params.ParamByName('institucion').Value :=
          datos.GetValue('institucion').Value;
        Query.ExecSQL;

        Query.Close;
        Query.SQL.Text :=
          'INSERT INTO math_resumenes_autor (cedula, id_resumen)' +
          ' VALUES (:cedula, :id_resumen)';
        Query.Params.ParamByName('cedula').Value :=
          datos.GetValue('cedula').Value;
        Query.Params.ParamByName('id_resumen').Value :=
          datos.GetValue('id_resumen').Value;
        Query.ExecSQL;

        Json.AddPair('resultado', 'El autor se creo correctamente');
      end;

      terminarConexion;

      escribirMensaje(Json.toString, 'post');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-updateAgregarAutorResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.updateautorResumen(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _autorResumen: TautorResumen;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _autorResumen := TautorResumen.create;
      _autorResumen.Conexion := Conexion;

      iniciarConexion;
      Json := _autorResumen.post(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'post');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-updateAutorResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _autorResumen.Free;
end;

function TMatematicas.acceptautorResumen(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      iniciarConexion;

      Query.Close;
      Query.SQL.Text := 'UPDATE math_autor_resumen SET nombre=:nombre' +
        ', correo=:correo, institucion=:institucion WHERE cedula=' + chr(39) +
        datos.GetValue('cedula').Value + chr(39);

      escribirMensaje('primera linea', '0');
      Query.Params.ParamByName('nombre').Value :=
        datos.GetValue('nombre').Value;
      Query.Params.ParamByName('correo').Value :=
        datos.GetValue('correo').Value;
      Query.Params.ParamByName('institucion').Value :=
        datos.GetValue('institucion').Value;
      escribirMensaje('segunda linea', '0');
      Query.ExecSQL;

      Json.AddPair('resultado', 'autor actualizado correctamete');
      escribirMensaje('tercera linea', '0');
      terminarConexion;

      escribirMensaje(Json.toString, 'put');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-acceptAutorResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.cancelautorResumen(const cedula: string;
  const id_resumen: string; const token: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      iniciarConexion;

      Query.Close;
      Query.SQL.Text := 'DELETE FROM math_resumenes_autor WHERE cedula=' +
        chr(39) + cedula + chr(39) + ' AND id_resumen=' + chr(39) + id_resumen
        + chr(39);
      Query.ExecSQL;

      Json.AddPair('respuesta', 'el autor se elimino correctamente');

      terminarConexion;

      escribirMensaje(Json.toString, 'delete');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje('cancelautorResumen' + E.Message,
        'error-cancelAutorResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.cancelborrarResumen(const id_resumen: string;
  const token: string): TJSONObject;
var
  i: integer;
  Json: TJSONObject;
  Query, Query2: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Query2 := TFDQuery.create(nil);
    Query2.Connection := Conexion;

    if token = FDataSnapMatematicas.obtenerToken then
    begin

      { Borrar palabras clave }
      Query.Close;
      Query.SQL.Text := 'SELECT * FROM math_palabras_clave WHERE id_resumen=' +
        chr(39) + id_resumen + chr(39);
      Query.Open;
      Query.First;

      for i := 1 to Query.RecordCount do
      begin
        Query2.Close;
        Query2.SQL.Text :=
          'DELETE FROM math_palabras_clave WHERE id_palabra_clave=' + chr(39) +
          Query.FieldByName('id_palabra_clave').AsString + chr(39);
        Query2.ExecSQL;
        Query.Next;
      end;

      { Borrar Autores }
      Query.Close;
      Query.SQL.Text := 'SELECT * FROM math_resumenes_autor WHERE id_resumen=' +
        chr(39) + id_resumen + chr(39);
      Query.Open;
      Query.First;

      for i := 1 to Query.RecordCount do
      begin
        Query2.Close;
        Query2.SQL.Text :=
          'DELETE FROM math_resumenes_autor WHERE id_resumen_autor=' + chr(39) +
          Query.FieldByName('id_resumen_autor').AsString + chr(39);
        Query2.ExecSQL;
        Query.Next;
      end;

      { Borrar Referencias }
      Query.Close;
      Query.SQL.Text :=
        'SELECT * FROM math_bibliografia_resumen WHERE id_resumen=' + chr(39) +
        id_resumen + chr(39);
      Query.Open;
      Query.First;

      for i := 1 to Query.RecordCount do
      begin
        Query2.Close;
        Query2.SQL.Text :=
          'DELETE FROM math_bibliografia_resumen WHERE id_bibliografia=' +
          chr(39) + Query.FieldByName('id_bibliografia').AsString + chr(39);
        Query2.ExecSQL;
        Query.Next;
      end;

      { Borrar resumen }
      Query.Close;
      Query.SQL.Text := 'DELETE FROM math_resumen WHERE id_resumen=' + chr(39) +
        id_resumen + chr(39);
      Query.ExecSQL;

      Json.AddPair('respuesta', 'El resumen fue borrado correctamente');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-cancelBorrarResumen');
      Json.AddPair('respuesta', 'Ocurrio un error en: borrarResumen (' +
        E.Message + ')');
    end;
  end;

  Query.Free;
  Query2.Free;
end;

{ CRUD: palabraClave %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
function TMatematicas.palabraClave(idClave: string): TJSONObject;
var
  _palabraClave: TpalabraClave;
begin
  try
    _palabraClave := TpalabraClave.create;
    _palabraClave.Conexion := Conexion;

    iniciarConexion;

    if idClave = 'all' then
      Result := _palabraClave.getAll
    else if idClave = 'model' then
      Result := _palabraClave.model
    else
      Result := _palabraClave.Get(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'get');

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-palabraClave');
  end;

  _palabraClave.Free;
end;

function TMatematicas.palabraClaveResumen(idClave: string): TJSONObject;
var
  _palabraClave: TpalabraClave;
begin
  try
    _palabraClave := TpalabraClave.create;
    _palabraClave.Conexion := Conexion;

    iniciarConexion;

    Result := _palabraClave.getPalabrasResumenes(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'get');

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-palabraClaveResumen');
  end;

  _palabraClave.Free;
end;

function TMatematicas.updatepalabraClave(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _palabraClave: TpalabraClave;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _palabraClave := TpalabraClave.create;
      _palabraClave.Conexion := Conexion;

      iniciarConexion;
      Json := _palabraClave.post(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'post');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-updatePalabraClave');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _palabraClave.Free;
end;

function TMatematicas.updateParticipanteEmem(datos: TJSONObject): TJSONObject;
begin
  Result := moduloEventoEMEM.postParticipante(datos);
end;

function TMatematicas.acceptpalabraClave(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _palabraClave: TpalabraClave;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _palabraClave := TpalabraClave.create;
      _palabraClave.Conexion := Conexion;

      iniciarConexion;
      Json := _palabraClave.put(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'put');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-acceptPalabraClave');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _palabraClave.Free;
end;

function TMatematicas.cancelpalabraClave(const idClave: string;
  const token: string): TJSONObject;
var
  _palabraClave: TpalabraClave;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;

  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _palabraClave := TpalabraClave.create;
      _palabraClave.Conexion := Conexion;

      iniciarConexion;
      Json := _palabraClave.DELETE(idClave);
      terminarConexion;

      escribirMensaje(Json.toString, 'delete');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-cancelPalabraClave');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _palabraClave.Free;
end;

{ CRUD: resumenes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
function TMatematicas.resumen(idClave: string): TJSONObject;
var
  _resumen: Tresumen;
begin
  try
    _resumen := Tresumen.create;
    _resumen.Conexion := Conexion;

    iniciarConexion;

    if idClave = 'all' then
      Result := _resumen.getAll
    else if idClave = 'model' then
      Result := _resumen.model
    else
      Result := _resumen.Get(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'get');

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-resumen');
  end;

  _resumen.Free;
end;

function TMatematicas.resumenesAutor(idClave: string): TJSONObject;
var
  _resumen: Tresumen;
begin
  try
    _resumen := Tresumen.create;
    _resumen.Conexion := Conexion;

    iniciarConexion;

    Result := _resumen.getForAutor(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'get');

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-resumenesAutor');
  end;
  _resumen.Free;
end;

function TMatematicas.resumenPorTipo(const tipo: string): TJSONObject;
var
  Json, JsonFor: TJSONObject;
  ArregloJSON: TJSONArray;
  i: integer;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    ArregloJSON := TJSONArray.create;
    Json.AddPair('resumenes', ArregloJSON);

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM math_resumen WHERE tipo=' + chr(39) + tipo
      + chr(39) + ' ORDER BY capacidad';
    Query.Open;
    Query.First;

    escribirMensaje('datos', IntToStr(Query.RecordCount));

    for i := 1 to Query.RecordCount do
    begin
      JsonFor := TJSONObject.create;
      JsonFor.AddPair('idResumen', Query.FieldByName('id_resumen').AsString);
      JsonFor.AddPair('titulo', Query.FieldByName('titulo').AsString);
      JsonFor.AddPair('resumen', Query.FieldByName('resumen').AsString);
      JsonFor.AddPair('linea', Query.FieldByName('linea').AsString);
      JsonFor.AddPair('tipo', Query.FieldByName('tipo').AsString);
      JsonFor.AddPair('objetivo', Query.FieldByName('objetivo').AsString);
      JsonFor.AddPair('capacidad', Query.FieldByName('capacidad').AsString);
      JsonFor.AddPair('materiales', Query.FieldByName('materiales').AsString);
      JsonFor.AddPair('prerequisito', Query.FieldByName('prerequisito')
        .AsString);
      JsonFor.AddPair('requiereSala', Query.FieldByName('requiere_sala')
        .AsString);
      JsonFor.AddPair('evaluado', Query.FieldByName('evaluado').AsString);
      JsonFor.AddPair('idAutor', Query.FieldByName('id_autor').AsString);
      JsonFor.AddPair('nombreAutor', Query.FieldByName('nombre_autor')
        .AsString);
      JsonFor.AddPair('subtitulo', Query.FieldByName('subtitulo').AsString);

      ArregloJSON.AddElement(JsonFor);

      Query.Next;
    end;

  except
    on E: Exception do
    begin
      Json.AddPair('error', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.updateresumen(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _resumen: Tresumen;
  Json: TJSONObject;
begin

  Json := TJSONObject.create;
  try
    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _resumen := Tresumen.create;
      _resumen.Conexion := Conexion;

      iniciarConexion;
      Json := _resumen.post(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'post');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-updateResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _resumen.Free;
end;

function TMatematicas.acceptresumen(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _resumen: Tresumen;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _resumen := Tresumen.create;
      _resumen.Conexion := Conexion;

      iniciarConexion;
      Json := _resumen.put(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'put')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-acceptResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _resumen.Free;
end;

function TMatematicas.cancelresumen(const idClave: string; const token: string)
  : TJSONObject;
var
  _resumen: Tresumen;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;

  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _resumen := Tresumen.create;
      _resumen.Conexion := Conexion;

      iniciarConexion;
      Json := _resumen.DELETE(idClave);
      terminarConexion;

      escribirMensaje(Json.toString, 'delete')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-cancelResumen');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _resumen.Free;
end;

{ CRUD: participantees %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
function TMatematicas.participante(idClave: string): TJSONObject;
var
  _participante: Tparticipante;
begin
  try
    _participante := Tparticipante.create;
    _participante.Conexion := Conexion;

    iniciarConexion;

    if idClave = 'all' then
      Result := _participante.getAll
    else if idClave = 'model' then
      Result := _participante.model
    else
      Result := _participante.Get(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'post')

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-participante');
  end;

  _participante.Free;
end;

function TMatematicas.permiteCrearResumenes: TJSONObject;
var
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  if FDataSnapMatematicas.permiteCrearResumen then
    Json.AddPair('permite', 'si')
  else
    Json.AddPair('permite', 'no');

  Result := Json;
end;

function TMatematicas.permiteInscribirseTalleres: TJSONObject;
var
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  if FDataSnapMatematicas.permiteInscribirTalleres then
    Json.AddPair('permite', 'si')
  else
    Json.AddPair('permite', 'no');

  Result := Json;
end;

function TMatematicas.acceptparticipante(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _participante: Tparticipante;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _participante := Tparticipante.create;
      _participante.Conexion := Conexion;

      iniciarConexion;
      Json := _participante.put(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'put')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-acceptParticipante');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _participante.Free;
end;

function TMatematicas.cancelparticipante(const idClave: string;
  const token: string): TJSONObject;
var
  _participante: Tparticipante;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;

  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _participante := Tparticipante.create;
      _participante.Conexion := Conexion;

      iniciarConexion;
      Json := _participante.DELETE(idClave);
      terminarConexion;

      escribirMensaje(Json.toString, 'delete')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-cancelParticipante');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _participante.Free;
end;

{ CRUD: usuarioes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
function TMatematicas.usuario(idClave: string): TJSONObject;
var
  _usuario: Tusuario;
begin
  try
    _usuario := Tusuario.create;
    _usuario.Conexion := Conexion;

    iniciarConexion;

    if idClave = 'all' then
      Result := _usuario.getAll
    else if idClave = 'model' then
      Result := _usuario.model
    else
      Result := _usuario.Get(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'post')

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-usuario');
  end;

  _usuario.Free;
end;

function TMatematicas.validarHorario(IdDocente, idservicio, Periodo: string)
  : TValidacion;
var
  Query: TFDQuery;
  Query2: TFDQuery;
  diaA, diaB, iniA, iniB, finA, finB, dia, hora: integer;
  i: integer;
  j, Cruces: integer;
  fm1, fm2, fm3, fm4, fm5, fm6, fm7, fm8, fm9: boolean;
  HorasDocencia, horas, HorasServicio: integer;
  sDia, sCruce: string;
begin
  Result.Observacion := '';
  Result.HorasDocencia := 0;
  HorasDocencia := 0;

  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  Query2 := TFDQuery.create(nil);
  Query2.Connection := Conexion;

  { Leer el horario del servicio enviado }
  Query2.Close;
  Query2.SQL.Text :=
    'select * from siap_horarios_servicios where idservicioprograma=' +
    Texto(idservicio);
  Query2.Open;
  Query2.First;

  HorasServicio := 0;

  sDia := Query2.FieldByName('dia').AsString;
  if (sDia <> 'virtual') and (sDia <> 'distancia') then
  begin

    { Se repite el ciclo los días que tenga el horario, por ejemplo
      lunes y martes de 2:00 pm a 4:00 pm y se toman las horas y día como iniciales }
    for i := 1 to Query2.RecordCount do
    begin
      // Horas del servicio a comparar
      diaA := FDias.IndexOf(Query2.FieldByName('dia').AsString);
      iniA := FHoras.IndexOf(Query2.FieldByName('inicio').AsString);
      finA := FHoras.IndexOf(Query2.FieldByName('fin').AsString);

      HorasServicio := HorasServicio + abs(finA - iniA);

      { Leer los servicios asociados al docente }
      Query.Close;
      Query.SQL.Clear;

      Query.SQL.Add('SELECT * FROM siap_agendas_servicios as a ');
      Query.SQL.Add('INNER JOIN siap_horarios_servicios as h ');
      Query.SQL.Add('ON a.idservicioprograma = h.idservicioprograma ');
      Query.SQL.Add('WHERE a.iddocente = ' + IdDocente);
      Query.SQL.Add(' AND a.periodo = ' + Texto(Periodo));
      Query.Open;
      Query.First;

      FDataSnapMatematicas.comentarioSQL
        ('Consulta de los horarios de un docente');
      FDataSnapMatematicas.escribirSQL(Query.SQL.Text);

      // Ciclo para recorrer cada una de las materias YA asignadas al docente.
      horas := 0;
      for j := 1 to Query.RecordCount do
      begin
        diaB := FDias.IndexOf(Query.FieldByName('dia').AsString);
        iniB := FHoras.IndexOf(Query.FieldByName('inicio').AsString);
        finB := FHoras.IndexOf(Query.FieldByName('fin').AsString);

        dia := abs(diaB - diaA);
        horas := horas + abs(finB - iniB);
        Cruces := 0;

        if dia = 0 then
        begin
          fm1 := (iniA > iniB) and (finA < finB);
          fm2 := (iniA < iniB) and (finA > finB);
          fm3 := (iniA < iniB) and (finA = finB);
          fm4 := (iniA = iniB) and (finA > finB);
          fm5 := (iniA = iniB) and (finA = finB);
          fm6 := (iniA < iniB) and (finA < finB) and (finA > iniB);
          fm7 := (iniA > iniB) and (finA > finB) and (finB > iniA);
          fm8 := (iniA > iniB) and (finA = finB);
          fm9 := (iniA = iniB) and (finA < finB);

          if fm1 then
          begin
            Inc(Cruces);
            sCruce := 'fm1: ';
          end;

          if fm2 then
          begin
            Inc(Cruces);
            sCruce := 'fm2: ';
          end;

          if fm3 then
          begin
            Inc(Cruces);
            sCruce := 'fm3: ';
          end;

          if fm4 then
          begin
            Inc(Cruces);
            sCruce := 'fm4: ';
          end;

          if fm5 then
          begin
            Inc(Cruces);
            sCruce := 'fm5: ';
          end;

          if fm6 then
          begin
            Inc(Cruces);
            sCruce := 'fm6: ';
          end;

          if fm7 then
          begin
            Inc(Cruces);
            sCruce := 'fm7: ';
          end;

          if fm8 then
          begin
            Inc(Cruces);
            sCruce := 'fm8: ';
          end;

          if fm9 then
          begin
            Inc(Cruces);
            sCruce := 'fm9: ';
          end;

          if Cruces > 0 then
          begin
            sCruce := sCruce + IntToStr(iniA) + '-' + IntToStr(finA) + ' + ' +
              IntToStr(iniB) + '-' + IntToStr(finB);
            // Result.Observacion := 'El Horario se Cruza (' + sCruce + ')';
            Result.Observacion := 'El Horario se Cruza';
            Result.Cruces := Cruces;
            exit;
          end;

        end;

        Query.Next;
      end;
      Query2.Next;
    end;

    Result.HorasServicio := HorasServicio;
    Result.HorasDocencia := HorasDocencia;
  end
  else
    Result.Observacion := '';

  Query.Free;
  Query2.Free;
end;

function TMatematicas.validarToken(token: string): TJSONObject;
var
  Json: TJSONObject;
begin
  try
    Json := TJSONObject.create;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
      Json.AddPair(JSON_RESPONSE, 'Token Válido');
    end
    else
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, 'Token Inválido');
    end;

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
end;

function TMatematicas.validarTokenHeader: boolean;
var
  objWebModule: TWebModule;
  token: string;
begin
  objWebModule := GetDataSnapWebModule;
  token := objWebModule.Request.GetFieldByName('Autorizacion');

  Result := token = FDataSnapMatematicas.obtenerToken;
end;

function TMatematicas.updateusuario(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _usuario: Tusuario;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _usuario := Tusuario.create;
      _usuario.Conexion := Conexion;

      iniciarConexion;
      Json := _usuario.post(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'post')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-updateUsuario');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _usuario.Free;
end;

function TMatematicas.acceptusuario(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _usuario: Tusuario;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _usuario := Tusuario.create;
      _usuario.Conexion := Conexion;

      iniciarConexion;
      Json := _usuario.put(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'put')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-acceptUsuario');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _usuario.Free;
end;

function TMatematicas.accesoDenegadoToken: TJSONObject;
begin
  Result := TJSONObject.create;
  Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
  Result.AddPair(JSON_RESPONSE, 'Acceso denegado, token inválido');
end;

function TMatematicas.cancelusuario(const idClave: string; const token: string)
  : TJSONObject;
var
  _usuario: Tusuario;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;

  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _usuario := Tusuario.create;
      _usuario.Conexion := Conexion;

      iniciarConexion;
      Json := _usuario.DELETE(idClave);
      terminarConexion;

      escribirMensaje(Json.toString, 'delete')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-cancelUsuario');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _usuario.Free;
end;

{ CRUD: concurrenciaes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
function TMatematicas.concurrencia(idClave: string): TJSONObject;
var
  _concurrencia: Tconcurrencia;
begin
  try
    _concurrencia := Tconcurrencia.create;
    _concurrencia.Conexion := Conexion;

    iniciarConexion;

    if idClave = 'all' then
      Result := _concurrencia.getAll
    else if idClave = 'model' then
      Result := _concurrencia.model
    else
      Result := _concurrencia.Get(idClave);

    terminarConexion;

    escribirMensaje(Result.toString, 'post')

  except
    on E: Exception do
      escribirMensaje(E.Message, 'error-concurrencia');
  end;

  _concurrencia.Free;
end;

function TMatematicas.conferenciasEMEM(IdEvento: string): TJSONObject;
begin
  Result := moduloEventoEMEM.getConferencias(IdEvento);
end;

function TMatematicas.updateconcurrencia(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _concurrencia: Tconcurrencia;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _concurrencia := Tconcurrencia.create;
      _concurrencia.Conexion := Conexion;

      iniciarConexion;
      Json := _concurrencia.post(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'post')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-updateConcurrencia');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _concurrencia.Free;
end;

function TMatematicas.updateenviarCorreo(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
begin
  try
    Json := TJSONObject.create;
    if token = FDataSnapMatematicas.obtenerToken then
    begin
      Data.Subject := datos.GetValue('asunto').Value;
      Data.Body.Clear;
      Data.Body.Add(datos.GetValue('mensaje').Value);
      Data.Recipients.EMailAddresses := datos.GetValue('correo').Value;

      try
        SMTP.Connect;
        SMTP.Send(Data);
      finally
        SMTP.Disconnect;
        Json.AddPair('respuesta', 'El correo fue enviado');
      end;
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;
  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-updateenviarCorreo');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
end;

function TMatematicas.updateinscribirTaller(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  Json: TJSONObject;
  idResumen: string;
  idParticipante: string;
  capacidad: integer;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      idResumen := datos.Get('idResumen').JsonValue.Value;
      idParticipante := datos.Get('idParticipante').JsonValue.Value;

      { Determinar si ya esta inscrito en algun taller }
      Query.Close;
      Query.SQL.Text :=
        'SELECT  * FROM math_resumen_participante WHERE id_participante=' +
        chr(39) + idParticipante + chr(39);
      Query.Open;

      if Query.RecordCount >= 1 then
      begin
        Json.AddPair('respuesta',
          'Lo sentimos ya esta inscrito en éste o en otro taller');
      end
      else
      begin
        { Determinar la capacidad del taller }
        Query.Close;
        Query.SQL.Text := 'SELECT * FROM math_resumen WHERE id_resumen=' +
          chr(39) + idResumen + chr(39);
        Query.Open;

        capacidad := Query.FieldByName('capacidad').AsInteger;

        { Determinar cuántos inscritos hay }
        Query.Close;
        Query.SQL.Text :=
          'SELECT  * FROM math_resumen_participante WHERE id_resumen=' + chr(39)
          + idResumen + chr(39);
        Query.Open;

        if Query.RecordCount < capacidad then
        begin

          Query.Close;
          Query.SQL.Text := 'INSERT INTO math_resumen_participante ' +
            '(id_participante, id_resumen)' +
            ' VALUES (:id_participante, :id_resumen )';

          Query.Params.ParamByName('id_resumen').Value := idResumen;
          Query.Params.ParamByName('id_participante').Value := idParticipante;

          Query.ExecSQL;

          Json.AddPair('respuesta',
            'El proceso de inscripción a éste taller fue exitoso');
        end
        else
        begin
          Json.AddPair('respuesta', 'Lo sentimos ya no hay cupos disponibles');
        end;
      end;
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recargue la página');
    end;

  except
    on E: Exception do
    begin
      Json.AddPair('error', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.updateLoginUsuario(const datos: TJSONObject): TJSONObject;
begin
  Result := moduloDatos.postLoginUsuario(datos);
end;

function TMatematicas.acceptconcurrencia(const token: string;
  const datos: TJSONObject): TJSONObject;
var
  _concurrencia: Tconcurrencia;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;
  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _concurrencia := Tconcurrencia.create;
      _concurrencia.Conexion := Conexion;

      iniciarConexion;
      Json := _concurrencia.put(datos);
      terminarConexion;

      escribirMensaje(Json.toString, 'put')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-acceptConcurrencia');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _concurrencia.Free;
end;

function TMatematicas.cancelconcurrencia(const idClave: string;
  const token: string): TJSONObject;
var
  _concurrencia: Tconcurrencia;
  Json: TJSONObject;
begin
  Json := TJSONObject.create;

  try

    if token = FDataSnapMatematicas.obtenerToken then
    begin
      _concurrencia := Tconcurrencia.create;
      _concurrencia.Conexion := Conexion;

      iniciarConexion;
      Json := _concurrencia.DELETE(idClave);
      terminarConexion;

      escribirMensaje(Json.toString, 'delete')
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recarge el navegador pulsando la tecla F5');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-cancelConcurrencia');
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  _concurrencia.Free;
end;

function TMatematicas.updateobtenerCertificados(const datos: TJSONObject)
  : TJSONObject;
var
  Json, JsonTemp: TJSONObject;
  ListaCertificados: TJSONArray;
  i: integer;
  nombre: string;
  cedula: string;
  fecha: string;
  tipo: string;
  titulo: string;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    ListaCertificados := TJSONArray.create;
    Json.AddPair('certificados', ListaCertificados);

    cedula := datos.Get('cedula').JsonValue.Value;
    fecha := datos.Get('fecha').JsonValue.Value;
    nombre := datos.Get('nombre').JsonValue.Value;

    FCertificados.iniciarDocumento(cedula);

    { Buscar en los participantes }
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM math_participante_emem WHERE cedula=' +
      chr(39) + cedula + chr(39);
    Query.Open;

    if Query.RecordCount > 0 then
    begin
      FCertificados.agregarCertificado(nombre, cedula, '', 'Participante');
    end;

    { Buscar en los autores de resumen con resumen aceptado }
    Query.Close;
    Query.SQL.Text := 'select * from math_resumenes_autor inner join ' +
      'math_autor_resumen on math_resumenes_autor.cedula = math_autor_resumen.cedula'
      + ' inner join math_resumen on math_resumen.id_resumen = ' +
      'math_resumenes_autor.id_resumen WHERE math_resumen.evaluado=' + chr(39) +
      'Aceptado' + chr(39) + ' AND math_autor_resumen.cedula = ' + chr(39) +
      cedula + chr(39) + ' AND math_resumen.fecha=' + chr(39) + fecha + chr(39);
    Query.Open;
    Query.First;

    for i := 1 to Query.RecordCount do
    begin
      tipo := Query.FieldByName('tipo').AsString;
      titulo := Query.FieldByName('titulo').AsString;
      FCertificados.agregarCertificado(nombre, cedula, titulo, tipo);

      Query.Next;
    end;

    FCertificados.finalizarDocumento;

    Json.AddPair('descarga',
      FDataSnapMatematicas.obtenerRutaDescargaCertificados + '/' + cedula
      + '.pdf');

  except
    on E: Exception do
    begin
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.obtenerConexion(clave: string): TJSONObject;
var
  i: integer;
  Json: TJSONObject;
begin
  try
    Json := TJSONObject.create;

    if clave = '51258908' then
    begin
      for i := 1 to Conexion.Params.Count do
      begin
        Json.AddPair('Parametro' + IntToStr(i), Conexion.Params[i - 1])
      end;
    end
    else
    begin
      Json.AddPair('respuesta', 'sin permisos para obtener datos');
    end;
  except
    on E: Exception do
      Json.AddPair('respuesta', E.Message);
  end;

  Result := Json;
end;

function TMatematicas.obtenerDocenteServicio(idservicio,
  Periodo: string): string;
var
  Query: TFDQuery;
begin
  { Se realiza una consulta para determinar el docente que tomo un servicio
    y mostrarlo en la tabla con el fin de discriminar los servicios que
    hacen falta }

  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT * FROM siap_agendas_servicios as a');
  Query.SQL.Add('INNER JOIN siap_servicios_programas as s ');
  Query.SQL.Add('ON a.idservicioprograma = s.idservicioprograma ');
  Query.SQL.Add('INNER JOIN siap_docentes as d ');
  Query.SQL.Add('ON a.iddocente = d.iddocente ');
  Query.SQL.Add('WHERE a.periodo=' + Texto(Periodo) +
    ' AND s.idservicioprograma=' + Texto(idservicio));

  FDataSnapMatematicas.escribirSQL(Query.SQL.Text);
  Query.Open;

  if Query.RecordCount >= 1 then
    Result := 'Tomado por ' + Query.FieldByName('nombre').AsString
  else
    Result := '';

  Query.Free;
end;

function TMatematicas.obtenerHorasCatedra: integer;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Text := 'SELECT * FROM siap_configuraciones';
  Query.Open;

  Result := Query.FieldByName('horascatedra').AsInteger;
  Query.Free;
end;

function TMatematicas.obtenerHorasContrato: integer;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Text := 'SELECT * FROM siap_configuraciones';
  Query.Open;

  Result := Query.FieldByName('horascontrato').AsInteger;
  Query.Free;
end;

function TMatematicas.obtenerHorasDocencia(IdDocente: string): integer;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  Query.SQL.Add('SELECT * FROM siap_docentes as d ');
  Query.SQL.Add('INNER JOIN siap_tipo_contrato as t ');
  Query.SQL.Add('ON d.idtipocontrato = t.idtipocontrato ');
  Query.SQL.Add('WHERE iddocente=' + Texto(IdDocente));
  Query.Open;

  Result := Query.FieldByName('horas').AsInteger;
  Query.Free;
end;

function TMatematicas.obtenerHorasServicio(idservicio: string): string;
var
  Query: TFDQuery;
  Jornada: string;
  i, horas: integer;
  inicio, fin: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  try

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add('SELECT * FROM siap_horarios_servicios AS hs ');
    Query.SQL.Add('INNER JOIN siap_servicios_programas AS sp ');
    Query.SQL.Add('ON hs.idservicioprograma = sp.idservicioprograma ');
    Query.SQL.Add('WHERE hs.idservicioprograma=' + #39 + idservicio + #39);
    Query.Open;

    Jornada := Query.FieldByName('jornada').AsString;

    if (Jornada = 'virtual') or (Jornada = 'distancia') then
    begin
      Result := Query.FieldByName('horas').AsString;
      exit;
    end;

    { Si pasa el filtro anterior, se debe calcular por el número de horas
      del horario }
    horas := 0;
    for i := 1 to Query.RecordCount do
    begin
      inicio := Query.FieldByName('inicio').AsString;
      fin := Query.FieldByName('fin').AsString;

      horas := horas + abs(FHoras.IndexOf(inicio) - FHoras.IndexOf(fin));
      Query.Next;
    end;

    Result := IntToStr(horas);

  except
    on E: Exception do
    begin
      enviarError(TimeToStr(now), DateToStr(now), 'obtenerHorasServicio',
        E.Message + ' => ' + idservicio);
    end;
  end;

  Query.Free;
end;

function TMatematicas.obtenerListasTalleres: TJSONObject;
var
  Json: TJSONObject;
  i: integer;
  idResumen: string;
  j: integer;
  Query, Query2, Query3: TFDQuery;
begin
  Json := TJSONObject.create;
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;
  Query2 := TFDQuery.create(nil);
  Query2.Connection := Conexion;
  Query3 := TFDQuery.create(nil);
  Query3.Connection := Conexion;

  try
    Query2.Close;
    Query2.SQL.Text := 'SELECT * FROM math_resumen WHERE tipo = ' + chr(39) +
      'Taller' + chr(39) + ' AND evaluado = ' + chr(39) + 'Aceptado' + chr(39);
    Query2.Open;
    Query2.First;

    FResumenes.limpiarDocumento2;
    FResumenes.IdAutor := 'ListasTalleres';
    FResumenes.iniciarDocumentoExcel;

    for i := 1 to Query2.RecordCount do
    begin
      idResumen := Query2.FieldByName('id_resumen').AsString;

      Query.Close;
      Query.SQL.Text := 'select * from math_resumen_participante inner join ' +
        'math_resumen on math_resumen_participante.id_resumen = math_resumen.id_resumen'
        + ' inner join math_participante_emem on math_resumen_participante.id_participante'
        + ' = math_participante_emem.cedula WHERE math_resumen_participante.id_resumen = '
        + chr(39) + idResumen + chr(39) +
        'ORDER BY math_participante_emem.nombre';
      Query.Open;
      Query.First;

      FResumenes.agregarLinea('\section{TALLER ' + IntToStr(i) + ': ' +
        Query2.FieldByName('titulo').AsString + '}');

      Query3.Close;
      Query3.SQL.Text := 'SELECT * FROM math_resumenes_autor INNER JOIN ' +
        'math_autor_resumen ON math_resumenes_autor.cedula = math_autor_resumen.cedula '
        + 'WHERE id_resumen=' + chr(39) + idResumen + chr(39);
      Query3.Open;

      FResumenes.agregarLinea('\subsection{Talleristas}');
      FResumenes.agregarLinea
        ('\begin{longtable}[c]{|>{\raggedright}m{1cm}|>{\raggedright}m{3cm}|>{\raggedright}m{5cm}|>{\raggedright}m{7cm}|}');
      FResumenes.agregarLinea('\hline');
      FResumenes.agregarLinea
        ('\textbf{No} & \textbf{Cédula} & \textbf{Nombre } & \textbf{Firma}\tabularnewline');
      FResumenes.agregarLinea('\hline ');

      for j := 1 to Query3.RecordCount do
      begin
        FResumenes.agregarLinea(IntToStr(j) + '\\ & ' +
          Query3.FieldByName('cedula').AsString + ' & ' +
          Query3.FieldByName('nombre').AsString + ' & \tabularnewline');
        FResumenes.agregarLinea('\hline');
        Query3.Next;
      end;

      FResumenes.agregarLinea('\end{longtable}');

      FResumenes.agregarLinea('\subsection{Participantes}');
      FResumenes.agregarLinea
        ('\begin{longtable}[c]{|>{\raggedright}m{1cm}|>{\raggedright}m{3cm}|>{\raggedright}m{5cm}|>{\raggedright}m{7cm}|}');
      FResumenes.agregarLinea('\hline');
      FResumenes.agregarLinea
        ('\textbf{No} & \textbf{Cédula} & \textbf{Nombre } & \textbf{Firma}\tabularnewline');
      FResumenes.agregarLinea('\hline ');

      FResumenes.agregarParticipante('Taller ' + IntToStr(i),
        Query2.FieldByName('titulo').AsString);

      for j := 1 to Query.RecordCount do
      begin
        FResumenes.agregarLinea(IntToStr(j) + '\\ & ' +
          Query.FieldByName('cedula').AsString + ' & ' +
          Query.FieldByName('nombre').AsString + ' & \tabularnewline');
        FResumenes.agregarLinea('\hline');
        FResumenes.agregarParticipante(Query.FieldByName('cedula').AsString,
          Query.FieldByName('nombre').AsString);
        Query.Next;
      end;

      FResumenes.agregarLinea('\end{longtable}');
      FResumenes.agregarLinea('\newpage{}');

      Query2.Next;
    end;
    FResumenes.terminarDocumento2;
    FResumenes.exportarListas;
    FResumenes.exportarExcel;

    Json.AddPair('rutaPdf',
      'http://201.185.240.142/matematicas/descargas/listas/ListasTalleres.pdf');
    Json.AddPair('rutaCsv',
      'http://201.185.240.142/matematicas/descargas/listas/ListasTalleres.csv');

  except
    on E: Exception do
    begin
      Json.AddPair('error', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
  Query2.Free;
  Query3.Free;
end;

function TMatematicas.obtenerNombreServicio(const ID: string): string;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  Query.SQL.Add
    ('select * from siap_servicios_programas WHERE idservicioprograma=' +
    Texto(ID));
  Query.Open;

  Result := Query.FieldByName('asignatura').AsString;
  Query.Free;
end;

function TMatematicas.obtenerNumerosActas(const IdDocente: string;
  Periodo: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
  Concertada, completada: string;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  Json := TJSONObject.create;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT * FROM siap_agendas_servicios ');
  Query.SQL.Add('WHERE iddocente=' + IdDocente + ' AND periodo=' + #39 +
    Periodo + #39);
  Query.Open;
  Query.First;

  if Query.RecordCount > 0 then
  begin
    Json.AddPair('numeroContrato', Query.FieldByName('numerocontrato')
      .AsString);
    Json.AddPair('actaFacultad', Query.FieldByName('actafacultad').AsString);
    Json.AddPair('actaPrograma', Query.FieldByName('actaprograma').AsString);

    Concertada := Query.FieldByName('concertada').AsString;
    if Concertada = '' then
      Concertada := 'no';
    Json.AddPair('agendaConcertada', Concertada);

    completada := Query.FieldByName('completada').AsString;
    if completada = '' then
      completada := 'no';
    Json.AddPair('agendaCompletada', completada);
  end
  else
  begin
    Json.AddPair('numeroContrato', '');
    Json.AddPair('actaFacultad', '');
    Json.AddPair('actaPrograma', '');
    Json.AddPair('agendaConcertada', 'no');
    Json.AddPair('agendaCompletada', 'no');
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.obtenerSemanasSemestre: integer;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Text := 'SELECT * FROM siap_configuraciones';
  Query.Open;

  Result := Query.FieldByName('semanassemestre').AsInteger;
  Query.Free;
end;

function TMatematicas.obtenerTallerParticipante(const cedula: string)
  : TJSONObject;
var
  Json: TJSONObject;
  idResumen: string;
  tituloResumen: string;
  salon: string;
  linea: string;
  nombre: string;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text :=
      'SELECT * FROM math_resumen_participante WHERE id_participante=' + chr(39)
      + cedula + chr(39);
    Query.Open;
    idResumen := Query.FieldByName('id_resumen').AsString;

    if Query.RecordCount > 0 then
    begin
      Json.AddPair('inscrito', 'si');

      Query.Close;
      Query.SQL.Text := 'SELECT * FROM math_resumen WHERE id_resumen=' + chr(39)
        + idResumen + chr(39);
      Query.Open;

      tituloResumen := Query.FieldByName('titulo').AsString;
      salon := Query.FieldByName('salon').AsString;
      linea := Query.FieldByName('linea').AsString;

      Query.Close;
      Query.SQL.Text := 'SELECT * FROM math_participante_emem WHERE cedula=' +
        chr(39) + cedula + chr(39);
      Query.Open;

      nombre := Query.FieldByName('nombre').AsString;

      Json.AddPair('respuesta', 'El participante ' + nombre +
        ' identificado con documento ' + cedula +
        ', se encuentra inscrito en el taller: "' + tituloResumen +
        '" en la línea de: "' + linea + '", que se realizará en: ' + salon);
    end
    else
    begin
      Json.AddPair('inscrito', 'no');
    end;

  except
    on E: Exception do
    begin
      Json.AddPair('error', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.obtenerTipoContrato(IdDocente: string): string;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.create(nil);
  Query.Connection := Conexion;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add('SELECT * FROM siap_docentes as d ');
  Query.SQL.Add('INNER JOIN siap_tipo_contrato as t ');
  Query.SQL.Add('ON t.idtipocontrato = d.idtipocontrato ');
  Query.SQL.Add('WHERE d.iddocente=' + IdDocente);
  Query.Open;

  escribirMensaje('Consulta Contrato', Query.FieldByName('contrato').AsString);
  Result := Query.FieldByName('contrato').AsString;
  Query.Free;
end;

function TMatematicas.organizadoresEvento(IdEvento: string): TJSONObject;
begin
  Result := moduloEventoEMEM.getContactoEvento(IdEvento);
end;

function TMatematicas.updatetoken(const datos: TJSONObject): TJSONObject;
var
  i, n, j: integer;
  nombre, correo, clave: string;
  token: string;
begin
  try
    nombre := datos.GetValue('nombre').Value;
    correo := datos.GetValue('correo').Value;
    clave := datos.GetValue('clave').Value;

    if (nombre = 'jprincon') and (correo = 'jarincon@uniquindio.edu.co') and
      (clave = 'Donmatematicas#512519') then
    begin
      token := FDataSnapMatematicas.obtenerToken;
    end
    else
    begin
      token := 'Acceso denegado, por favor recarge el navegador pulsando la tecla F5';
    end;

    Result := TJSONObject.create;
    Result.AddPair('token', token);
  except
    on E: Exception do
      Result.AddPair('error', E.Message + ', token');
  end;
end;

procedure TMatematicas.DataModuleCreate(Sender: tobject);
var
  datosToken: TJSONObject;
begin
  // DireccionLibreria.VendorHome := ExtractFilePath(ParamStr(0)) + 'librerias';

  { with Conexion.Params do
    begin
    Clear;
    Add('Database=saem');
    Add('User_Name=postgres');
    Add('DriverID=PG');
    Add('Password=postgres');
    Add('Server=' + FDataSnapMatematicas.edServidor.Text);
    Add('Port=5432');
    Add('CharaterSet=UTF8');
    end; }

  FParametros := TStringList.create;
  FTipoParametro := TStringList.create;

  FHoras := TStringList.create;
  FHoras.Add('7:00 a.m.');
  FHoras.Add('8:00 a.m.');
  FHoras.Add('9:00 a.m.');
  FHoras.Add('10:00 a.m.');
  FHoras.Add('11:00 a.m.');
  FHoras.Add('12:00 p.m.');
  FHoras.Add('1:00 p.m.');
  FHoras.Add('2:00 p.m.');
  FHoras.Add('3:00 p.m.');
  FHoras.Add('4:00 p.m.');
  FHoras.Add('5:00 p.m.');
  FHoras.Add('6:00 p.m.');
  FHoras.Add('7:00 p.m.');
  FHoras.Add('8:00 p.m.');
  FHoras.Add('9:00 p.m.');
  FHoras.Add('10:00 p.m.');

  FDias := TStringList.create;
  FDias.Add('lunes');
  FDias.Add('martes');
  FDias.Add('miércoles');
  FDias.Add('jueves');
  FDias.Add('viernes');
  FDias.Add('sábado');
  FDias.Add('domingo');

  AccesoDenegado := 'Acceso Denegado, por favor refresque el navegador';
end;

function TMatematicas.descargarCertificadosUnificados(fecha: string)
  : TJSONObject;
var
  Json, JsonTemp: TJSONObject;
  ListaCertificados: TJSONArray;
  ListaCedulas: TStringList;
  i: integer;
  nombre, cedula: string;
  tipo: string;
  titulo: string;
  j: integer;
  Query, Query2: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Query2 := TFDQuery.create(nil);
    Query2.Connection := Conexion;

    ListaCertificados := TJSONArray.create;
    Json.AddPair('certificados', ListaCertificados);

    FCertificados.iniciarDocumento('Certificados_EMEM' + fecha);

    Query2.Close;
    Query2.SQL.Text := 'SELECT * FROM math_resumenes_autor';
    Query2.Open;
    Query2.First;

    ListaCedulas := TStringList.create;

    for j := 1 to Query2.RecordCount do
    begin
      cedula := Query2.FieldByName('cedula').AsString;

      if ListaCedulas.IndexOf(cedula) < 0 then
      begin
        { Buscar en los participantes }
        Query.Close;
        Query.SQL.Text := 'SELECT * FROM math_participante_emem WHERE cedula=' +
          chr(39) + cedula + chr(39);
        Query.Open;

        nombre := transformarNombre(Query.FieldByName('nombre').AsString);

        if Query.RecordCount > 0 then
        begin
          FCertificados.agregarCertificado(nombre, cedula, '', 'Participante');
        end;

        { Buscar en los autores de resumen con resumen aceptado }
        Query.Close;
        Query.SQL.Text := 'select * from math_resumenes_autor inner join ' +
          'math_autor_resumen on math_resumenes_autor.cedula = math_autor_resumen.cedula'
          + ' inner join math_resumen on math_resumen.id_resumen = ' +
          'math_resumenes_autor.id_resumen WHERE math_resumen.evaluado=' +
          chr(39) + 'Aceptado' + chr(39) + ' AND math_autor_resumen.cedula = ' +
          chr(39) + cedula + chr(39) + ' AND math_resumen.fecha=' + chr(39) +
          fecha + chr(39);
        Query.Open;
        Query.First;

        nombre := transformarNombre(Query.FieldByName('nombre').AsString);

        for i := 1 to Query.RecordCount do
        begin
          tipo := Query.FieldByName('tipo').AsString;
          titulo := Query.FieldByName('titulo').AsString;
          FCertificados.agregarCertificado(nombre, cedula, titulo, tipo);
          Json.AddPair('cert ' + IntToStr(i) + '-' + IntToStr(j),
            cedula + '=' + nombre);

          Query.Next;
        end;

        ListaCedulas.Add(cedula);
      end;

      Query2.Next;
    end;

    FCertificados.finalizarDocumento;

    Json.AddPair('descarga',
      FDataSnapMatematicas.obtenerRutaDescargaCertificados + '/' +
      'Certificados_EMEM' + fecha + '.pdf');

  except
    on E: Exception do
    begin
      Json.AddPair('respuesta', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
  Query2.Free;
end;

function TMatematicas.descargarResumenEmem(clave: string): TJSONObject;
var
  Json: TJSONObject;
  idResumen: string;
  i: integer;
  ssAutores: TStringList;
  Query, Query2, Query3: TFDQuery;
  nombre, palabra, palabrasClave, correo, institucion, autores, resumen: string;
begin
  try
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Query2 := TFDQuery.create(nil);
    Query2.Connection := Conexion;
    Query3 := TFDQuery.create(nil);
    Query3.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM math_resumen WHERE id_resumen=' + chr(39) +
      clave + chr(39);
    Query.Open;

    Json := TJSONObject.create;

    if Query.RecordCount > 0 then
    begin
      idResumen := Query.FieldByName('id_resumen').AsString;
      FResumenes.IdAutor := idResumen;

      FResumenes.limpiarDocumento;
      FResumenes.agregarTitulo(Query.FieldByName('titulo').AsString);

      Query2.Close;
      Query2.SQL.Text :=
        'SELECT * FROM math_resumenes_autor INNER JOIN math_autor_resumen' +
        ' ON math_resumenes_autor.cedula = math_autor_resumen.cedula WHERE' +
        ' id_resumen=' + chr(39) + idResumen + chr(39) +
        ' ORDER BY id_resumen_autor';
      Query2.Open;
      Query2.First;

      autores := '';
      for i := 1 to Query2.RecordCount do
      begin
        nombre := Query2.FieldByName('nombre').AsString;
        correo := Query2.FieldByName('correo').AsString;
        institucion := Query2.FieldByName('institucion').AsString;

        autores := autores + nombre + '\thanks{' + institucion + ', ' +
          correo + '}  ';
        if i < Query2.RecordCount then
          if i = 2 then
            autores := autores + ' \\ '
          else
            autores := autores + ', ';

        Query2.Next;
      end;

      FResumenes.agregarAutores(autores);
      FResumenes.agregarFecha('Noviembre del 2019');

      FResumenes.agregarEstilo;

      Query3.Close;
      Query3.SQL.Text := 'SELECT * FROM math_palabras_clave WHERE id_resumen=' +
        chr(39) + clave + chr(39);
      Query3.Open;
      Query3.First;

      palabrasClave := '';
      for i := 1 to Query3.RecordCount do
      begin
        palabra := Query3.FieldByName('palabra').AsString;

        palabrasClave := palabrasClave + palabra;

        if i < Query3.RecordCount then
          palabrasClave := palabrasClave + ', ';

        Query3.Next;
      end;

      FResumenes.agregarPalabrasClave(palabrasClave);

      resumen := Query.FieldByName('resumen').AsString;
      resumen := StringReplace(resumen, '&', 'y', [rfReplaceAll, rfIgnoreCase]);
      FResumenes.agregarResumen(resumen);

      FResumenes.iniciarBibligrafia;

      Query3.Close;
      Query3.SQL.Text :=
        'SELECT * FROM math_bibliografia_resumen WHERE id_resumen=' + chr(39) +
        clave + chr(39) + ' ORDER BY bibliografia';
      Query3.Open;
      Query3.First;

      for i := 1 to Query3.RecordCount do
      begin
        FResumenes.agregarReferencia(Query3.FieldByName('bibliografia')
          .AsString);
        Query3.Next;
      end;

      FResumenes.terminarDocumento;
      FResumenes.exportarDocumento;

      Json.AddPair('ruta',
        'http://201.185.240.142/matematicas/descargas/resumenes-emem/' +
        idResumen + '.pdf');
    end;

  except
    on E: Exception do
    begin
      escribirMensaje(E.Message, 'error-descargarResumenEmem');
      Json.AddPair('error', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
  Query2.Free;
  Query3.Free;
end;

{ CONEXION DE LA APLICACION }
procedure TMatematicas.iniciarConexion;
begin
  Conexion.Connected := True;
end;

function TMatematicas.listaPosters: TJSONObject;
var
  Json, JsonTemp, JsonAutores: TJSONObject;
  listaAutores, listaPoster: TJSONArray;
  i: integer;
  titulo, linea, nombre, cedula, idResumen: string;
  j: integer;
  Query, Query2: TFDQuery;
begin
  try
    Json := TJSONObject.create;
    listaPoster := TJSONArray.create;
    Json.AddPair('Poster', listaPoster);

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;
    Query2 := TFDQuery.create(nil);
    Query2.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM math_resumen WHERE tipo=' + chr(39) +
      'Poster' + chr(39) + ' ORDER BY linea';
    Query.Open;

    for i := 1 to Query.RecordCount do
    begin
      JsonTemp := TJSONObject.create;
      listaAutores := TJSONArray.create;
      JsonTemp.AddPair('autores', listaAutores);

      titulo := Query.FieldByName('titulo').AsString;
      linea := Query.FieldByName('linea').AsString;
      idResumen := Query.FieldByName('id_resumen').AsString;

      JsonTemp.AddPair('titulo', titulo);
      JsonTemp.AddPair('linea', linea);

      { Buscar a los autores de cada resumen }
      Query2.Close;
      Query2.SQL.Text :=
        'SELECT * FROM math_resumenes_autor INNER JOIN math_autor_resumen ON math_resumenes_autor.cedula = math_autor_resumen.cedula WHERE id_resumen='
        + chr(39) + idResumen + chr(39);
      Query2.Open;

      for j := 1 to Query2.RecordCount do
      begin
        JsonAutores := TJSONObject.create;
        nombre := Query2.FieldByName('nombre').AsString;
        cedula := Query2.FieldByName('cedula').AsString;
        JsonAutores.AddPair('nombre', nombre);
        JsonAutores.AddPair('cedula', cedula);
        listaAutores.AddElement(JsonAutores);

        Query2.Next;
      end;

      listaPoster.Add(JsonTemp);
      Query.Next;
    end;
  except
    on E: Exception do
    begin
      Json.AddPair('error', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
  Query2.Free;
end;

procedure TMatematicas.terminarConexion;
begin
  Conexion.Connected := False;
end;

function TMatematicas.transformarNombre(sNombre: string): string;
begin
  Result := UpperCase(sNombre);
  Result := StringReplace(Result, 'á', 'Á', [rfReplaceAll]);
  Result := StringReplace(Result, 'é', 'É', [rfReplaceAll]);
  Result := StringReplace(Result, 'í', 'Í', [rfReplaceAll]);
  Result := StringReplace(Result, 'ó', 'Ó', [rfReplaceAll]);
  Result := StringReplace(Result, 'ú', 'Ú', [rfReplaceAll]);

  Result := StringReplace(Result, 'ñ', 'Ñ', [rfReplaceAll]);
end;

{ ESCRIBIR MENSAJES EN CONSOLA }
function TMatematicas.enlacesDivulgacion(IdDocente: string): TJSONObject;
var
  Json, JsonEnlace: TJSONObject;
  Enlaces: TJSONArray;
  Query: TFDQuery;
  i: integer;
begin
  try
    Json := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_divulgacion_docente WHERE iddocente='
      + #39 + IdDocente + #39;
    Query.Open;

    Enlaces := TJSONArray.create;

    for i := 1 to Query.RecordCount do
    begin
      JsonEnlace := TJSONObject.create;
      JsonEnlace.AddPair('iddivulgacion', Query.FieldByName('iddivulgacion')
        .AsString);
      JsonEnlace.AddPair('nombre', Query.FieldByName('nombre').AsString);
      JsonEnlace.AddPair('direccion', Query.FieldByName('direccion').AsString);
      JsonEnlace.AddPair('iddocente', Query.FieldByName('iddocente').AsString);

      Enlaces.AddElement(JsonEnlace);
      Query.Next;
    end;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESPONSE, 'Enlace obtenidos');
    Json.AddPair(JSON_RESULTS, Enlaces);
  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

procedure TMatematicas.enviarError(hora, fecha, procedimiento, mensaje: string);
var
  datos: TJSONObject;
begin
  datos := TJSONObject.create;

  datos.AddPair('iderror', moduloDatos.generarID);
  datos.AddPair('hora', hora);
  datos.AddPair('fecha', fecha);
  datos.AddPair('procedimiento', procedimiento);
  datos.AddPair('mensaje', mensaje);

  updateError(FDataSnapMatematicas.obtenerToken, datos);
end;

procedure TMatematicas.escribirMensaje(msg: string; tipo: string);
begin
  // FDataSnapMatematicas.escribirMensaje(msg, tipo);
end;

function TMatematicas.EstadisticasPeriodo(IdPeriodo: string): TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.getEstadisticasPeriodo(IdPeriodo)
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

function TMatematicas.estadisticasTaller(const idResumen: string): TJSONObject;
var
  Json: TJSONObject;
  capacidad: integer;
  inscritos: integer;
  Query: TFDQuery;
begin
  try
    Json := TJSONObject.create;

    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM math_resumen WHERE id_resumen=' + chr(39) +
      idResumen + chr(39);
    Query.Open;

    capacidad := Query.FieldByName('capacidad').AsInteger;

    { Determinar cuántos inscritos hay }
    Query.Close;
    Query.SQL.Text :=
      'SELECT  * FROM math_resumen_participante WHERE id_resumen=' + chr(39) +
      idResumen + chr(39);
    Query.Open;

    inscritos := Query.RecordCount;

    Json.AddPair('capacidad', IntToStr(capacidad));
    Json.AddPair('inscritos', IntToStr(inscritos));
    Json.AddPair('cupo', IntToStr(capacidad - inscritos));

  except
    on E: Exception do
    begin
      Json.AddPair('error', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

{ OPERACIONES BÁSICAS DEL SERVIDOR }
function TMatematicas.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TMatematicas.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TMatematicas.cancelsalirDelTaller(const cedula: string;
  const token: string): TJSONObject;
var
  Json: TJSONObject;
  Query: TFDQuery;
begin
  try
    if token = FDataSnapMatematicas.obtenerToken then
    begin
      Json := TJSONObject.create;
      Query := TFDQuery.create(nil);
      Query.Connection := Conexion;

      Query.Close;
      Query.SQL.Text :=
        'DELETE FROM math_resumen_participante WHERE id_participante=' + chr(39)
        + cedula + chr(39);
      Query.ExecSQL;

      Json.AddPair('respuesta', 'La inscripción se eliminto correctamente');
    end
    else
    begin
      Json.AddPair('respuesta',
        'Acceso denegado, por favor recargue el navegador');
    end;

  except
    on E: Exception do
    begin
      Json.AddPair('error', E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.JsonRespuesta: string;
begin
  Result := 'Respuesta';
end;

function TMatematicas.JsonError: string;
begin
  Result := 'Error';
end;

procedure TMatematicas.limpiarConsulta(Query: TFDQuery);
begin
  Query.Close;
  Query.SQL.Clear;
end;

function TMatematicas.Secretarias: TJSONObject;
begin
  Result := TJSONObject.create;

  if validarTokenHeader then
    Result := moduloPracticaDocente.getSecretarias
  else
  begin
    Result.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
    Result.AddPair(JSON_RESPONSE, AccesoDenegado);
  end;
end;

procedure TMatematicas.SELECT(nombreTabla, OrdenarPor: string; Query: TFDQuery);
begin
  Query.SQL.Text := 'SELECT * FROM ' + nombreTabla + ' ORDER BY ' + OrdenarPor;
  Query.Open;
  Query.First;
end;

procedure TMatematicas.SelectWhere(nombreTabla, Identificador, ID: string;
  Query: TFDQuery);
begin
  Query.SQL.Text := 'SELECT * FROM ' + nombreTabla + ' WHERE ' + Identificador
    + '=' + ID;
  Query.Open;
end;

procedure TMatematicas.SelectWhereOrder(nombreTabla, Identificador, OrdenarPor,
  ID: string; Query: TFDQuery);
begin
  Query.SQL.Text := 'SELECT * FROM ' + nombreTabla + ' WHERE ' + Identificador +
    '=' + ID + ' ORDER BY ' + OrdenarPor;
  Query.Open;
end;

function TMatematicas.seminario(IdSeminario: string): TJSONObject;
var
  Json, JsonEvento: TJSONObject;
  Eventos: TJSONArray;
  Query: TFDQuery;
  fecha: TDate;
  fs: TFormatSettings;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_seminario WHERE idseminario=' + #39 +
      IdSeminario + #39;
    Query.Open;

    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    Eventos := TJSONArray.create;

    JsonEvento := TJSONObject.create;
    JsonEvento.AddPair('idseminario', Query.FieldByName('idseminario')
      .AsString);
    JsonEvento.AddPair('semestre', Query.FieldByName('semestre').AsString);
    JsonEvento.AddPair('numero', Query.FieldByName('numero').AsString);

    fecha := Query.FieldByName('fecha').AsDateTime;
    JsonEvento.AddPair('fecha', DateToStr(fecha, fs));

    JsonEvento.AddPair('conferencista', Query.FieldByName('conferencista')
      .AsString);
    JsonEvento.AddPair('titulo', Query.FieldByName('titulo').AsString);
    JsonEvento.AddPair('resumen', Query.FieldByName('resumen').AsString);
    JsonEvento.AddPair('origen_conferencista',
      Query.FieldByName('origen_conferencista').AsString);
    JsonEvento.AddPair('grupo_dependencia',
      Query.FieldByName('grupo_dependencia').AsString);
    JsonEvento.AddPair('pais_origen', Query.FieldByName('pais_origen')
      .AsString);
    JsonEvento.AddPair('area_profundizacion',
      Query.FieldByName('area_profundizacion').AsString);
    JsonEvento.AddPair('modalidad', Query.FieldByName('modalidad').AsString);
    JsonEvento.AddPair('graduados', Query.FieldByName('graduados').AsString);
    JsonEvento.AddPair('estudiantes', Query.FieldByName('estudiantes')
      .AsString);
    JsonEvento.AddPair('nacional', Query.FieldByName('nacional').AsString);
    JsonEvento.AddPair('internacional', Query.FieldByName('internacional')
      .AsString);
    JsonEvento.AddPair('lugar', Query.FieldByName('lugar').AsString);
    JsonEvento.AddPair('youtube', Query.FieldByName('youtube').AsString);
    JsonEvento.AddPair('evidencias', Query.FieldByName('evidencias').AsString);

    Eventos.AddElement(JsonEvento);

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESULTS, Eventos);

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

function TMatematicas.seminarios: TJSONObject;
var
  Json, JsonEvento: TJSONObject;
  Eventos: TJSONArray;
  Query: TFDQuery;
  i, participantes: integer;
  fs: TFormatSettings;
  fecha: TDate;
begin
  try
    Json := TJSONObject.create;
    Query := TFDQuery.create(nil);
    Query.Connection := Conexion;

    Query.Close;
    Query.SQL.Text := 'SELECT * FROM siap_seminario ORDER BY fecha asc';
    Query.Open;

    Eventos := TJSONArray.create;

    fs := TFormatSettings.create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-mm-dd';

    for i := 1 to Query.RecordCount do
    begin

      JsonEvento := TJSONObject.create;
      JsonEvento.AddPair('idseminario', Query.FieldByName('idseminario')
        .AsString);
      JsonEvento.AddPair('semestre', Query.FieldByName('semestre').AsString);
      JsonEvento.AddPair('numero', Query.FieldByName('numero').AsString);

      fecha := Query.FieldByName('fecha').AsDateTime;
      JsonEvento.AddPair('fecha', DateToStr(fecha, fs));
      JsonEvento.AddPair('conferencista', Query.FieldByName('conferencista')
        .AsString);
      JsonEvento.AddPair('titulo', Query.FieldByName('titulo').AsString);
      JsonEvento.AddPair('resumen', Query.FieldByName('resumen').AsString);
      JsonEvento.AddPair('origen_conferencista',
        Query.FieldByName('origen_conferencista').AsString);
      JsonEvento.AddPair('grupo_dependencia',
        Query.FieldByName('grupo_dependencia').AsString);
      JsonEvento.AddPair('pais_origen', Query.FieldByName('pais_origen')
        .AsString);
      JsonEvento.AddPair('area_profundizacion',
        Query.FieldByName('area_profundizacion').AsString);
      JsonEvento.AddPair('modalidad', Query.FieldByName('modalidad').AsString);

      participantes := Query.FieldByName('graduados').AsInteger;
      JsonEvento.AddPair('graduados', Query.FieldByName('graduados').AsString);

      participantes := participantes + Query.FieldByName('estudiantes')
        .AsInteger;
      JsonEvento.AddPair('estudiantes', Query.FieldByName('estudiantes')
        .AsString);

      participantes := participantes + Query.FieldByName('nacional').AsInteger;
      JsonEvento.AddPair('nacional', Query.FieldByName('nacional').AsString);

      participantes := participantes + Query.FieldByName('internacional')
        .AsInteger;
      JsonEvento.AddPair('internacional', Query.FieldByName('internacional')
        .AsString);

      JsonEvento.AddPair('total', IntToStr(participantes));

      JsonEvento.AddPair('lugar', Query.FieldByName('lugar').AsString);
      JsonEvento.AddPair('youtube', Query.FieldByName('youtube').AsString);
      JsonEvento.AddPair('evidencias', Query.FieldByName('evidencias')
        .AsString);

      Eventos.AddElement(JsonEvento);
      Query.Next;
    end;

    Json.AddPair(JSON_STATUS, RESPONSE_CORRECTO);
    Json.AddPair(JSON_RESULTS, Eventos);

  except
    on E: Exception do
    begin
      Json.AddPair(JSON_STATUS, RESPONSE_INCORRECTO);
      Json.AddPair(JSON_RESPONSE, E.Message);
    end;
  end;

  Result := Json;
  Query.Free;
end;

procedure TMatematicas.InnerJoin(Tabla1, Tabla2, Parametro, IdBusqueda,
  Valor: string; Query: TFDQuery);
begin
  Query.Close;
  Query.SQL.Text := 'SELECT * FROM ' + Tabla1 + ' INNER JOIN ' + Tabla2 + ' ON '
    + Tabla1 + '.' + Parametro + ' = ' + Tabla2 + '.' + Parametro + ' WHERE ' +
    Tabla2 + '.' + IdBusqueda + '=' + Valor;
  escribirMensaje('InnerJoin', Query.SQL.Text);
  Query.Open;
end;

procedure TMatematicas.InnerJoin3(Tabla1, Tabla2, Tabla3, Parametro1,
  Parametro2, IdBusqueda, Valor: string; Query: TFDQuery);
begin
  Query.Close;
  Query.SQL.Text := 'SELECT * FROM ' + Tabla1 + ' INNER JOIN ' + Tabla2 + ' ON '
    + Tabla1 + '.' + Parametro1 + ' = ' + Tabla2 + '.' + Parametro1 +
    ' inner join ' + Tabla3 + ' on ' + Tabla1 + '.' + Parametro2 + ' = ' +
    Tabla3 + '.' + Parametro2 + ' WHERE ' + Tabla2 + '.' + IdBusqueda +
    '=' + Valor;
  Query.Open;
end;

procedure TMatematicas.INSERT(nombreTabla: string; Query: TFDQuery);
var
  i: integer;
  consulta: string;
begin
  consulta := 'INSERT INTO ' + nombreTabla + '(';

  for i := 1 to FParametros.Count do
  begin
    consulta := consulta + FParametros[i - 1];
    if i < FParametros.Count then
      consulta := consulta + ',';
  end;

  consulta := consulta + ') VALUES (';

  for i := 1 to FParametros.Count do
  begin
    consulta := consulta + ':' + FParametros[i - 1];
    if i < FParametros.Count then
      consulta := consulta + ',';
  end;

  consulta := consulta + ')';

  Query.SQL.Text := consulta;
end;

procedure TMatematicas.DELETE(nombreTabla, Identificador, ID: string;
  Query: TFDQuery);
begin
  Query.SQL.Text := 'DELETE FROM ' + nombreTabla + ' WHERE ' + Identificador
    + '=' + ID;
  Query.ExecSQL;
end;

procedure TMatematicas.UPDATE(nombreTabla, Identificador, ID: string;
  Query: TFDQuery);
var
  consulta: string;
  i: integer;
begin
  consulta := 'UPDATE ' + nombreTabla + ' SET ';

  for i := 1 to FParametros.Count do
  begin
    consulta := consulta + FParametros[i - 1] + '=:' + FParametros[i - 1];
    if i < FParametros.Count then
      consulta := consulta + ', ';
  end;

  consulta := consulta + ' WHERE ' + Identificador + '=' + ID;

  Query.SQL.Text := consulta;
end;

procedure TMatematicas.limpiarParametros;
begin
  FParametros.Clear;
  FTipoParametro.Clear;
end;

procedure TMatematicas.agregarParametro(Param: string; tipo: string);
begin
  FParametros.Add(Param);
  FTipoParametro.Add(tipo)
end;

function TMatematicas.crearJSON(Query: TFDQuery): TJSONObject;
var
  i: integer;
begin
  Result := TJSONObject.create;

  if Query.RecordCount > 0 then
  begin
    for i := 1 to FParametros.Count do
    begin
      Result.AddPair(FParametros[i - 1], Query.FieldByName(FParametros[i - 1])
        .AsString);
    end
  end
  else
  begin
    Result.AddPair(JsonRespuesta, 'Consulta con resultado vacio');
  end;
end;

function TMatematicas.cronogramaEMEM(IdEvento: string): TJSONObject;
begin
  Result := moduloEventoEMEM.getCronograma(IdEvento);
end;

procedure TMatematicas.asignarDatos(datos: TJSONObject; Query: TFDQuery);
var
  i: integer;
begin
  for i := 1 to FParametros.Count do
  begin
    if FTipoParametro[i - 1] = 'String' then
      Query.Params.ParamByName(FParametros[i - 1]).Value :=
        datos.GetValue(FParametros[i - 1]).Value;

    if FTipoParametro[i - 1] = 'Memo' then
      Query.Params.ParamByName(FParametros[i - 1]).AsWideMemo :=
        datos.GetValue(FParametros[i - 1]).Value;

    if FTipoParametro[i - 1] = 'Base64' then
      Query.Params.ParamByName(FParametros[i - 1]).AsWideMemo :=
        datos.GetValue(FParametros[i - 1]).Value;

    if FTipoParametro[i - 1] = 'Integer' then
      Query.Params.ParamByName(FParametros[i - 1]).Value :=
        StrToInt(datos.GetValue(FParametros[i - 1]).Value);

    if FTipoParametro[i - 1] = 'Float' then
      Query.Params.ParamByName(FParametros[i - 1]).Value :=
        StringToFloat(datos.GetValue(FParametros[i - 1]).Value);

    if FTipoParametro[i - 1] = 'Date' then
      Query.Params.ParamByName(FParametros[i - 1]).Value :=
        StrToDate(datos.GetValue(FParametros[i - 1]).Value);

    if FTipoParametro[i - 1] = 'Time' then
      Query.Params.ParamByName(FParametros[i - 1]).Value :=
        StrToTime(datos.GetValue(FParametros[i - 1]).Value);

    if FTipoParametro[i - 1] = 'Boolean' then
      Query.Params.ParamByName(FParametros[i - 1]).Value :=
        StrToBool(datos.GetValue(FParametros[i - 1]).Value);
  end;
  Query.ExecSQL;
end;

function TMatematicas.Texto(ss: string): string;
begin
  Result := chr(39) + ss + chr(39);
end;

end.
