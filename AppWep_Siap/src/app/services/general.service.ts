import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { LS_ULTIMA_RUTA } from '../config/config';
import { map, retry } from 'rxjs/operators';
import { Periodo, Usuario, Login } from '../interfaces/interfaces.interfaces';
import { AngularEditorConfig } from '@kolkov/angular-editor';

@Injectable({
  providedIn: 'root'
})
export class GeneralService {

  letras: string[] = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
                      's', 't', 'u', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  private token = '';
  private ENCABEZADO_HTTP = 'http://';
  private IP_SERVIDOR = '201.185.240.142';
  private PUERTO = ':1952';
  private GENERAL = '/datasnap/rest/tmatematicas/';

  private URL_USUARIO = 'usuario';
  private URL_PARTICPANTE = 'participante';
  private URL_RESUMEN = 'resumen';
  private URL_BORRAR_RESUMEN = 'borrarResumen';
  private URL_TOKEN = 'token';
  private URL_RESUMENES_AUTOR = 'resumenesAutor';
  private URL_PALABRA_CLAVE = 'palabraClave';
  private URL_PALABRA_CLAVE_RESUMEN = 'palabraClaveResumen';
  private URL_AUTOR_RESUMEN = 'autorResumen';
  private URL_AGREGAR_AUTOR_RESUMEN = 'agregarAutorResumen';
  private URL_AUTORES_RESUMEN = 'autoresResumen';
  private URL_REFERENCIA_RESUMEN = 'referenciaResumen';
  private URL_REFERENCIAS_RESUMEN = 'referenciasResumen';
  private URL_CONCURRENCIA = 'concurrencia';
  private URL_ENVIAR_CORREO = 'enviarCorreo';
  private URL_DESCARGAR_RESUMEN = 'descargarResumenEmem';
  private URL_AUTOR_POR_CEDULA = 'autorPorCedula';
  private URL_RESUMEN_POR_TIPO = 'resumenPorTipo';
  private URL_TIPOCONTRATO = 'TipoContrato';
  private URL_TIPOSCONTRATO = 'TiposContrato';
  private URL_CATEGORIADOCENTE = 'CategoriaDocente';
  private URL_CATEGORIASDOCENTE = 'CategoriasDocente';
  private URL_DOCENTE = 'Docente';
  private URL_FOTO_DOCENTE = 'FotoDocente';
  private URL_DOCENTES = 'Docentes';
  private URL_DIRECTORES_JURADOS = 'DirectoresJurados';
  private URL_DOCENTES_POR_CONTRATO = 'DocentesPorContrato';
  private URL_ERROR = 'Error';
  private URL_ERROR_POR_MENSAJE = 'ErrorPorMensaje';
  private URL_ERRORES = 'Errores';
  private URL_FACULTAD = 'Facultad';
  private URL_FACULTADES = 'Facultades';
  private URL_PROGRAMA = 'Programa';
  private URL_PROGRAMAS = 'Programas';
  private URL_SERVICIOPROGRAMA = 'ServicioPrograma';
  private URL_SERVICIOSPROGRAMA = 'ServiciosPrograma';
  private URL_SERVICIOSPROGRAMADOCENTE = 'ServiciosProgramaDocente';
  private URL_HORARIOSERVICIO = 'HorarioServicio';
  private URL_HORARIOSSERVICIO = 'HorariosServicio';
  private URL_AGENDASERVICIO = 'AgendaServicio';
  private URL_AGENDANUMEROCONTRATO = 'AgendaNumeroContrato';
  private URL_AGENDASSERVICIO = 'AgendasServicio';
  private URL_AGENDAS_POR_PROGRAMA = 'AgendasPorPrograma';
  private URL_AGENDAS_POR_DOCENTE = 'AgendasPorDocente';
  private URL_ESTADO_AGENDAS = 'EstadoAgendas';
  private URL_AGENDASPORPERIODO = 'AgendasPorPeriodo';
  private URL_DESASOCIAR_AGENDASSERVICIO = 'DesasociarAgenda';
  private URL_CONFIGURACION = 'Configuracion';
  private URL_CONFIGURACIONES = 'Configuraciones';
  private URL_FUNCIONDOCENTE = 'FuncionDocente';
  private URL_FUNCIONESDOCENTE = 'FuncionesDocente';
  private URL_ACTIVIDADDOCENTE = 'ActividadDocente';
  private URL_ACTIVIDADESDOCENTE = 'ActividadesDocente';
  private URL_SUBACTIVIDADDOCENTE = 'SubactividadDocente';
  private URL_SUBACTIVIDADESDOCENTE = 'SubactividadesDocente';
  private URL_EGRESADO = 'Egresado';
  private URL_EGRESADOS = 'Egresados';
  private URL_GRUPOINVESTIGACION = 'GrupoInvestigacion';
  private URL_GRUPOSINVESTIGACION = 'GruposInvestigacion';
  private URL_MODALIDAD = 'Modalidad';
  private URL_MODALIDADES = 'Modalidades';
  private URL_AREAPROFUNDIZACION = 'AreaProfundizacion';
  private URL_AREASPROFUNDIZACION = 'AreasProfundizacion';
  private URL_AREA_DOCENTE = 'AreaDocente';
  private URL_AREAS_DOCENTE = 'AreasDocente';
  private URL_TRABAJOGRADO = 'TrabajoGrado';
  private URL_TRABAJOSGRADO = 'TrabajosGrado';
  private URL_ESTADISTICAS_TRABAJOS_GRADO = 'EstadisticasTrabajoGrado';
  private URL_DIRECTORES_TRABAJOS_GRADO = 'DirectoresTrabajosGrado';
  private URL_EVALUADORES_TRABAJOS_GRADO = 'EvaluadoresTrabajosGrado';
  private URL_PERIODO = 'Periodo';
  private URL_PERIODOS = 'Periodos';
  private URL_ACTIVIDADFUNCIONDOCENTE = 'ActividadFuncionDocente';
  private URL_ACTIVIDADESFUNCIONESDOCENTE = 'ActividadesFuncionesDocente';
  private URL_FAVORITO = 'Favorito';
  private URL_FAVORITOS = 'Favoritos';
  private URL_REPORTE_PROGRAMA_SERVICIOS = 'ReporteProgramaServicios';
  private URL_REPORTE_HORAS_POR_FACULTAD = 'ReporteHorasFacultad';
  private URL_LOGIN_USUARIO = 'LoginUsuario';
  private URL_PERFIL_DOCENTE = 'PerfilDocente';
  private URL_FACTORES_CALIDAD = 'factoresCalidad';
  private URL_FACTOR_CALIDAD = 'factorCalidad';
  private URL_REQUISITOS = 'Requisitos';
  private URL_TIPOS_ACCION = 'TiposAccion';
  private URL_FUENTES = 'Fuentes';
  private URL_PLAN_MEJORAMIENTO = 'PlanMejoramiento';
  private URL_PLANES_MEJORAMIENTO = 'PlanesMejoramiento';
  private URL_FORMACION = 'formacion';
  private URL_FORMACIONES = 'formaciones';
  private URL_GRUPOINV_DOCENTE = 'GrupoInvDocente';
  private URL_DOCENTES_GRUPO_INVESTIGACION = 'DocentesGrupoInvestigacion';
  private URL_TIPO_PRODUCCION = 'TipoProduccion';
  private URL_TIPOS_PRODUCCION = 'TiposProduccion';
  private URL_PRODUCTO = 'Producto';
  private URL_PRODUCTOS_DOCENTE = 'ProductosDocente';
  private URL_PRODUCTOS = 'Productos';
  private URL_DIRECCION_JURADO_DOCENTE = 'DireccionJuradoDocente';
  private URL_VALIDAR_TOKEN = 'validarToken';
  private URL_ENLACE_DIVULGACION = 'EnlaceDivulgacion';
  private URL_ENLACES_DIVULGACION = 'EnlacesDivulgacion';
  private URL_SEMINARIO = 'Seminario';
  private URL_SEMINARIOS = 'Seminarios';

  private headers = new HttpHeaders({
    'Content-Type': 'application/json',
    Autorizacion: ''
  });

  usuario: Usuario = null;

  constructor(private http: HttpClient,
              private router: Router) {

    this.token = '';
  }

  editorConfig: AngularEditorConfig = {
    editable: true,
      spellcheck: true,
      height: '200px',
      minHeight: '0',
      maxHeight: 'auto',
      width: 'auto',
      minWidth: '0',
      translate: 'yes',
      enableToolbar: true,
      showToolbar: true,
      placeholder: 'Enter text here...',
      defaultParagraphSeparator: '',
      defaultFontName: '',
      defaultFontSize: '',
      fonts: [
        {class: 'arial', name: 'Arial'},
        {class: 'times-new-roman', name: 'Times New Roman'},
        {class: 'calibri', name: 'Calibri'},
        {class: 'comic-sans-ms', name: 'Comic Sans MS'}
      ],
      customClasses: [
      {
        name: 'quote',
        class: 'quote',
      },
      {
        name: 'redText',
        class: 'redText'
      },
      {
        name: 'titleText',
        class: 'titleText',
        tag: 'h1',
      },
    ],
    uploadUrl: 'v1/image',
    sanitize: true,
    toolbarPosition: 'top'
};

  navegar(rutas: string[]) {
    this.router.navigate(rutas);

    localStorage.setItem(LS_ULTIMA_RUTA, JSON.stringify(rutas));
  }

  restaurarRutas() {
    if (localStorage.getItem(LS_ULTIMA_RUTA)) {
      this.router.navigate(JSON.parse(localStorage.getItem(LS_ULTIMA_RUTA).toString()));
    } else {
      this.router.navigate(['menu-principal']);
    }
  }

  dataSnap_Route(ruta: string) {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL + ruta;
  }

  dataSnap_Token() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_TOKEN;
  }

  dataSnap_Usuario() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_USUARIO;
  }

  dataSnap_Participante() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_PARTICPANTE;
  }

  dataSnap_Resumen() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_RESUMEN;
  }

  dataSnap_BorrarResumen() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_BORRAR_RESUMEN;
  }

  dataSnap_PalabraClave() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_PALABRA_CLAVE;
  }

  dataSnap_PalabraClaveResumen() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_PALABRA_CLAVE_RESUMEN;
  }

  dataSnap_ResumenesAutor() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_RESUMENES_AUTOR;
  }

  dataSnap_ResumenePorTipo() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_RESUMEN_POR_TIPO;
  }

  dataSnap_AutorResumen() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_AUTOR_RESUMEN;
  }

  dataSnap_AgregarAutorResumen() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_AGREGAR_AUTOR_RESUMEN;
  }

  dataSnap_AutoresResumen() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_AUTORES_RESUMEN;
  }

  dataSnap_AutorPorCedula() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_AUTOR_POR_CEDULA;
  }

  dataSnap_ReferenciaResumen() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_REFERENCIA_RESUMEN;
  }

  dataSnap_ReferenciasResumen() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_REFERENCIAS_RESUMEN;
  }

  dataSnap_Concurrencia() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_CONCURRENCIA;
  }

  dataSnap_EnviarCorreo() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_ENVIAR_CORREO;
  }

  dataSnap_DescargarResumen() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL +
    this.URL_DESCARGAR_RESUMEN;
  }

  dataSnap_Path(path: string) {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL + path;
  }

  parametro(dato: string) {
    return '/' + dato;
  }

  obtenerPermisoNavegar(): boolean {
    return this.token.length > 0;
  }

  getManualAyuda() {
    const url = 'assets/Ayuda/Ayuda.json';
    return this.http.get(url);
  }

  generarID() {

    let id = '';

    for (let i = 1; i < 9; i++) {
      const posicion = Math.round(Math.random() * (this.letras.length - 1));
      id = id + this.letras[posicion];
    }

    id = id + '-';

    for (let i = 1; i < 5; i++) {
      const posicion = Math.round(Math.random() * (this.letras.length - 1));
      id = id + this.letras[posicion];
    }

    id = id + '-';

    for (let i = 1; i < 5; i++) {
      const posicion = Math.round(Math.random() * (this.letras.length - 1));
      id = id + this.letras[posicion];
    }

    id = id + '-';

    for (let i = 1; i < 13; i++) {
      const posicion = Math.round(Math.random() * (this.letras.length - 1));
      id = id + this.letras[posicion];
    }

    return id;
  }

  descargarResumen(idResumen: string) {
    const url = this.dataSnap_DescargarResumen() + this.parametro(idResumen);
    return this.http.get(url);
  }

  // MÉTODOS USUARIOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  getUsuario(cedula: string) {
    const url = this.dataSnap_Usuario() + this.parametro(cedula);
    return this.http.get(url);
  }

  getUsuarios() {
    const url = this.dataSnap_Usuario() + this.parametro('all');
    return this.http.get(url);
  }

  getValidarToken(token: string) {
    const url = this.dataSnap_Route(this.URL_VALIDAR_TOKEN) + this.parametro(token);
    return this.http.get(url);
  }

  postUsuario(datos: string) {
    const url = this.dataSnap_Usuario() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  establecerToken(token: string) {
    this.token = token;

    this.headers = new HttpHeaders({
      'Content-Type': 'application/json',
      Autorizacion: this.token
    });
  }

  postLoginUsuario(datos: string) {
    const url = this.dataSnap_Route(this.URL_LOGIN_USUARIO);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(
      map((RespLogin: Login) => {

        if (RespLogin.Respuesta === 'Acceso-Correcto') {

          this.establecerToken(RespLogin.Token);

          this.usuario = RespLogin.Usuario;
          localStorage.setItem('Usuario', JSON.stringify(this.usuario));
          localStorage.setItem('Token', this.token);
        }

        return RespLogin;
      })
    );
  }

  putUsuario(datos: string) {
    const url = this.dataSnap_Usuario() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers});
  }

  deleteUsuario(cedula: string) {
    const url = this.dataSnap_Usuario() + this.parametro(cedula) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers});
  }

  // MÉTODOS PARTICIPANTES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  getParticipantes() {
    const url = this.dataSnap_Participante() + this.parametro('all');
    return this.http.get(url);
  }

  getParticipante(idParticipante: string) {
    const url = this.dataSnap_Participante() + this.parametro(idParticipante);
    return this.http.get(url);
  }

  getObtenerCertificados(datos: string) {
    const url = this.dataSnap_Path('obtenerCertificados');
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  getDescargarCertificadosUnificados(fecha: string) {
    const url = this.dataSnap_Path('descargarCertificadosUnificados') + this.parametro(fecha);
    return this.http.get(url);
  }

  postParticipante(datos: string) {
    const url = this.dataSnap_Participante() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  putParticipante(datos: string) {
    const url = this.dataSnap_Participante()+ this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers});
  }

  deleteParticipante(idParticipante: string) {
    const url = this.dataSnap_Participante() + + this.parametro(idParticipante) + this.parametro(this.token);
    return this.http.delete(url);
  }

  // MÉTODOS RESUMENES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  getResumenes() {
    const url = this.dataSnap_Resumen() + this.parametro('all');
    return this.http.get(url);
  }

  getResumenesAutor(cedula: string) {
    const url = this.dataSnap_ResumenesAutor() + this.parametro(cedula);
    return this.http.get(url);
  }

  getResumen(idResumen: string) {
    const url = this.dataSnap_Resumen() + this.parametro(idResumen);
    return this.http.get(url);
  }

  getResumenPorTipo(tipo: string){
    const url = this.dataSnap_ResumenePorTipo() + this.parametro(tipo);
    return this.http.get(url);
  }

  postResumen(datos: string) {

    const url = this.dataSnap_Resumen() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  putResumen(datos: string) {
    const url = this.dataSnap_Resumen() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers});
  }

  deleteResumen(idResumen: string) {
    const url = this.dataSnap_BorrarResumen() + this.parametro(idResumen) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers});
  }


  // MÉTODOS PALABRAS CLAVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  getPalabrasClaveResumen(idResumen) {
    const url = this.dataSnap_PalabraClaveResumen() + this.parametro(idResumen);
    return this.http.get(url);
  }

  getPalabraClave(idPalabra: string) {
    const url = this.dataSnap_PalabraClave() + this.parametro(idPalabra);
    return this.http.get(url);
  }

  postPalabraClave(datos: string) {
    const url = this.dataSnap_PalabraClave() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  putPalabraClave(datos: string) {
    const url = this.dataSnap_PalabraClave() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers});
  }

  deletePalabraClave(idPalabra: string) {
    const url = this.dataSnap_PalabraClave() + this.parametro(idPalabra) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers});
  }

  // MÉTODOS AUTORES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  getAutores(idResumen) {
    const url = this.dataSnap_AutoresResumen() + this.parametro(idResumen);
    return this.http.get(url);
  }

  getAutorPorCedula(cedula) {
    const url = this.dataSnap_AutorPorCedula() + this.parametro(cedula);
    return this.http.get(url);
  }

  getAutor(idPalabra: string) {
    const url = this.dataSnap_AutorResumen() + this.parametro(idPalabra);
    return this.http.get(url);
  }

  postAutor(datos: string) {
    const url = this.dataSnap_AutorResumen() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  agregarAutorResumen(datos: string) {
    const url = this.dataSnap_AgregarAutorResumen() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  putAutor(datos: string) {
    const url = this.dataSnap_AutorResumen() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers});
  }

  deleteAutor(cedula: string, idResumen: string) {
    const url = this.dataSnap_AutorResumen() + this.parametro(cedula) + this.parametro(idResumen) + this.parametro(this.token);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers});
  }

  // MÉTODOS REFERENCIAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  getReferencias(idResumen) {
    const url = this.dataSnap_ReferenciasResumen() + this.parametro(idResumen);
    return this.http.get(url);
  }

  getReferencia(idPalabra: string) {
    const url = this.dataSnap_ReferenciaResumen() + this.parametro(idPalabra);
    return this.http.get(url);
  }

  postReferencia(datos: string) {

    const url = this.dataSnap_ReferenciaResumen() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  putReferencia(datos: string) {
    const url = this.dataSnap_ReferenciaResumen() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers});
  }

  deleteReferencia(idPalabra: string) {
    const url = this.dataSnap_ReferenciaResumen() + this.parametro(idPalabra) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers});
  }

  // Comunicación con los usuarios

  postEnviarCorreo(datos: string) {
    const url = this.dataSnap_EnviarCorreo() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  // INSCRIPCIÓN A LOS TALLERES

  getEstadisticas(idResumen: string) {
    const url = this.dataSnap_Path('estadisticasTaller') + this.parametro(idResumen);
    return this.http.get(url);
  }

  getObtenerTallerParticipante(cedula: string) {
    const url = this.dataSnap_Path('obtenerTallerParticipante') + this.parametro(cedula);
    return this.http.get(url);
  }

  getObtenerListaTalleres() {
    const url = this.dataSnap_Path('obtenerListasTalleres');
    return this.http.get(url);
  }

  getObtenerListaPosters() {
    const url = this.dataSnap_Path('listaPosters');
    return this.http.get(url);
  }

  postInscribirseTaller(datos: string) {
    const url = this.dataSnap_Path('inscribirTaller') + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  deleteSalirDelTaller(cedula: string) {
    const url = this.dataSnap_Path('salirDelTaller') + this.parametro(cedula) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers});
  }

  // MÉTODOS CONCURRENCIAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  getContador(idVisita: string) {
    const url = this.dataSnap_Concurrencia() + this.parametro(idVisita);
    return this.http.get(url);
  }

  putContador(datos: string) {
    const url = this.dataSnap_Concurrencia() + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers});
  }

  getPermiteCrearResumenes() {
    const url = this.dataSnap_Path('permiteCrearResumenes');
    return this.http.get(url);
  }

  getPermiteInscribirseTalleres() {
    const url = this.dataSnap_Path('permiteInscribirseTalleres');
    return this.http.get(url);
  }

  getCronograma() {
    return this.http.get('assets/pruebas/cronograma.json');
  }

  getCursillo(id: string) {
    return this.http.get('assets/pruebas/cursillos.json');
  }

  getCursillos() {

  }

  getNoticias() {
    return this.http.get('assets/pruebas/noticias.json');
  }

  // %%%%%%% Tipos de Contrato %%%%%%%

  postTipoContrato(datos: string) {
    const url = this.dataSnap_Path(this.URL_TIPOCONTRATO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getTiposContrato() {
    const url = this.dataSnap_Path(this.URL_TIPOSCONTRATO);
    return this.http.get(url).pipe(retry(10));
  }

  getTipoContrato(id: string) {
    const url = this.dataSnap_Path(this.URL_TIPOCONTRATO) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putTipoContrato(datos: string) {
    const url = this.dataSnap_Path(this.URL_TIPOCONTRATO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteTipoContrato(id: string) {
    const url = this.dataSnap_Path(this.URL_TIPOCONTRATO) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* CategoriaDocente %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postCategoriaDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_CATEGORIADOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getCategoriasDocente() {
    const url = this.dataSnap_Path(this.URL_CATEGORIASDOCENTE);
    return this.http.get(url).pipe(retry(10));
  }

  getCategoriaDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_CATEGORIADOCENTE) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putCategoriaDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_CATEGORIADOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteCategoriaDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_CATEGORIADOCENTE) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* Docente %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_DOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getDocentes(ordenarPor: string) {
    const url = this.dataSnap_Path(this.URL_DOCENTES) + this.parametro(ordenarPor);
    return this.http.get(url).pipe(retry(10));
  }

  getDireccionJuradoDocente(IdDocente: string) {
    const url = this.dataSnap_Path(this.URL_DIRECCION_JURADO_DOCENTE) + this.parametro(IdDocente);
    return this.http.get(url, {headers: this.headers}).pipe(retry(10));
  }

  getDirectoresJurados() {
    const url = this.dataSnap_Path(this.URL_DIRECTORES_JURADOS);
    return this.http.get(url).pipe(retry(10));
  }

  getDocentesPorContrato(IdContrato: string) {
    const url = this.dataSnap_Path(this.URL_DOCENTES_POR_CONTRATO) + this.parametro(IdContrato);
    return this.http.get(url).pipe(retry(10));
  }

  getDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_DOCENTE) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_DOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  putFotoDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_FOTO_DOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_DOCENTE) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* Error %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postError(datos: string) {
    const url = this.dataSnap_Path(this.URL_ERROR) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getErrores() {
    const url = this.dataSnap_Path(this.URL_ERRORES);
    return this.http.get(url).pipe(retry(10));
  }

  getError(id: string) {
    const url = this.dataSnap_Path(this.URL_ERROR) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putError(datos: string) {
    const url = this.dataSnap_Path(this.URL_ERROR) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteError(id: string) {
    const url = this.dataSnap_Path(this.URL_ERROR) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  deleteErrorPorMensaje(msg: string) {
    const url = this.dataSnap_Path(this.URL_ERROR_POR_MENSAJE) + this.parametro(this.token) + this.parametro(msg);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* Facultad %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postFacultad(datos: string) {
    const url = this.dataSnap_Path(this.URL_FACULTAD) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getFacultades() {
    const url = this.dataSnap_Path(this.URL_FACULTADES);
    return this.http.get(url).pipe(retry(10));
  }

  getFacultad(id: string) {
    const url = this.dataSnap_Path(this.URL_FACULTAD) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putFacultad(datos: string) {
    const url = this.dataSnap_Path(this.URL_FACULTAD) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteFacultad(id: string) {
    const url = this.dataSnap_Path(this.URL_FACULTAD) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* Programa %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postPrograma(datos: string) {
    const url = this.dataSnap_Path(this.URL_PROGRAMA) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getProgramas() {
    const url = this.dataSnap_Path(this.URL_PROGRAMAS);
    return this.http.get(url).pipe(retry(10));
  }

  getPrograma(id: string) {
    const url = this.dataSnap_Path(this.URL_PROGRAMA) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putPrograma(datos: string) {
    const url = this.dataSnap_Path(this.URL_PROGRAMA) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deletePrograma(id: string) {
    const url = this.dataSnap_Path(this.URL_PROGRAMA) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* ServicioPrograma %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postServicioPrograma(datos: string) {
    const url = this.dataSnap_Path(this.URL_SERVICIOPROGRAMA) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getServiciosPrograma(ordenarPor: string, periodo: string) {
    const url = this.dataSnap_Path(this.URL_SERVICIOSPROGRAMA) + this.parametro(ordenarPor) + this.parametro(periodo);
    return this.http.get(url).pipe(retry(10));
  }

  getServiciosProgramaDocente(IdDocente: string, periodo: string) {
    const url = this.dataSnap_Path(this.URL_SERVICIOSPROGRAMADOCENTE) + this.parametro(IdDocente) + this.parametro(periodo);
    return this.http.get(url).pipe(retry(10));
  }

  getServicioPrograma(id: string) {
    const url = this.dataSnap_Path(this.URL_SERVICIOPROGRAMA) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putServicioPrograma(datos: string) {
    const url = this.dataSnap_Path(this.URL_SERVICIOPROGRAMA) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteServicioPrograma(id: string) {
    const url = this.dataSnap_Path(this.URL_SERVICIOPROGRAMA) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* HorarioServicio %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postHorarioServicio(datos: string) {
    const url = this.dataSnap_Path(this.URL_HORARIOSERVICIO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getHorariosServicio(IdServicioPrograma: string) {
    const url = this.dataSnap_Path(this.URL_HORARIOSSERVICIO) + this.parametro(IdServicioPrograma);
    return this.http.get(url).pipe(retry(10));
  }

  getHorarioServicio(id: string) {
    const url = this.dataSnap_Path(this.URL_HORARIOSERVICIO) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putHorarioServicio(datos: string) {
    const url = this.dataSnap_Path(this.URL_HORARIOSERVICIO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteHorarioServicio(id: string) {
    const url = this.dataSnap_Path(this.URL_HORARIOSERVICIO) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* AgendaServicio %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postAgendaServicio(datos: string) {
    const url = this.dataSnap_Path(this.URL_AGENDASERVICIO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getAgendasServicio(IdDocente: string, Periodo: string) {
    const url = this.dataSnap_Path(this.URL_AGENDASSERVICIO) + this.parametro(IdDocente) + this.parametro(Periodo);

    return this.http.get(url).pipe(retry(10));
  }

  getAgendasPorPrograma(Periodo: string) {
    const url = this.dataSnap_Path(this.URL_AGENDAS_POR_PROGRAMA) + this.parametro(Periodo);

    return this.http.get(url).pipe(retry(10));
  }

  getAgendasPorPeriodoDocente(IdDocente: string) {
    const url = this.dataSnap_Path(this.URL_AGENDAS_POR_DOCENTE) + this.parametro(IdDocente);

    return this.http.get(url).pipe(retry(10));
  }

  getEstadoAgendas(Periodo: string) {
    const url = this.dataSnap_Path(this.URL_ESTADO_AGENDAS) + this.parametro(Periodo);

    return this.http.get(url);
  }

  getAgendasPorPeriodo(Periodo: string) {
    const url = this.dataSnap_Path(this.URL_AGENDASPORPERIODO) + this.parametro(Periodo);
    return this.http.get(url);
  }

  getAgendaServicio(id: string) {
    const url = this.dataSnap_Path(this.URL_AGENDASERVICIO) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putAgendaServicio(datos: string) {
    const url = this.dataSnap_Path(this.URL_AGENDASERVICIO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  putAgendaNumeroContrato(datos: string) {
    const url = this.dataSnap_Path(this.URL_AGENDANUMEROCONTRATO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteDesasociarAgendaServicio(id: string) {
    const url = this.dataSnap_Path(this.URL_DESASOCIAR_AGENDASSERVICIO) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  deleteAgendaServicio(id: string) {
    const url = this.dataSnap_Path(this.URL_AGENDASERVICIO) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* Configuracion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postConfiguracion(datos: string) {
    const url = this.dataSnap_Path(this.URL_CONFIGURACION) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getConfiguraciones() {
    const url = this.dataSnap_Path(this.URL_CONFIGURACIONES);
    return this.http.get(url).pipe(retry(10));
  }

  getConfiguracion(id: string) {
    const url = this.dataSnap_Path(this.URL_CONFIGURACION) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putConfiguracion(datos: string) {
    const url = this.dataSnap_Path(this.URL_CONFIGURACION) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteConfiguracion(id: string) {
    const url = this.dataSnap_Path(this.URL_CONFIGURACION) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* FuncionDocente %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postFuncionDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_FUNCIONDOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getFuncionesDocente() {
    const url = this.dataSnap_Path(this.URL_FUNCIONESDOCENTE);
    return this.http.get(url).pipe(retry(10));
  }

  getFuncionDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_FUNCIONDOCENTE) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putFuncionDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_FUNCIONDOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteFuncionDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_FUNCIONDOCENTE) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* ActividadDocente %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postActividadDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADDOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getActividadesDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADESDOCENTE) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  getActividadDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADDOCENTE) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putActividadDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADDOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteActividadDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADDOCENTE) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* SubactividadDocente %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postSubactividadDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_SUBACTIVIDADDOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getSubactividadesDocente(IdActividadDocente: string) {
    const url = this.dataSnap_Path(this.URL_SUBACTIVIDADESDOCENTE) + this.parametro(IdActividadDocente);
    return this.http.get(url).pipe(retry(10));
  }

  getSubactividadDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_SUBACTIVIDADDOCENTE) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putSubactividadDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_SUBACTIVIDADDOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteSubactividadDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_SUBACTIVIDADDOCENTE) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* Egresado %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postEgresado(datos: string) {
    const url = this.dataSnap_Path(this.URL_EGRESADO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getEgresados() {
    const url = this.dataSnap_Path(this.URL_EGRESADOS);
    return this.http.get(url).pipe(retry(10));
  }

  getEgresado(id: string) {
    const url = this.dataSnap_Path(this.URL_EGRESADO) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putEgresado(datos: string) {
    const url = this.dataSnap_Path(this.URL_EGRESADO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteEgresado(id: string) {
    const url = this.dataSnap_Path(this.URL_EGRESADO) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* GrupoInvestigacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postGrupoInvestigacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_GRUPOINVESTIGACION) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getGruposInvestigacion() {
    const url = this.dataSnap_Path(this.URL_GRUPOSINVESTIGACION);
    return this.http.get(url).pipe(retry(10));
  }

  getGrupoInvestigacion(id: string) {
    const url = this.dataSnap_Path(this.URL_GRUPOINVESTIGACION) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putGrupoInvestigacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_GRUPOINVESTIGACION) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteGrupoInvestigacion(id: string) {
    const url = this.dataSnap_Path(this.URL_GRUPOINVESTIGACION) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* Modalidad %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postModalidad(datos: string) {
    const url = this.dataSnap_Path(this.URL_MODALIDAD) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getModalidades() {
    const url = this.dataSnap_Path(this.URL_MODALIDADES);
    return this.http.get(url).pipe(retry(10));
  }

  getModalidad(id: string) {
    const url = this.dataSnap_Path(this.URL_MODALIDAD) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putModalidad(datos: string) {
    const url = this.dataSnap_Path(this.URL_MODALIDAD) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteModalidad(id: string) {
    const url = this.dataSnap_Path(this.URL_MODALIDAD) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* AreaProfundizacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postAreaProfundizacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_AREAPROFUNDIZACION) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getAreasProfundizacion() {
    const url = this.dataSnap_Path(this.URL_AREASPROFUNDIZACION);
    return this.http.get(url).pipe(retry(10));
  }

  getAreaProfundizacion(id: string) {
    const url = this.dataSnap_Path(this.URL_AREAPROFUNDIZACION) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putAreaProfundizacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_AREAPROFUNDIZACION) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteAreaProfundizacion(id: string) {
    const url = this.dataSnap_Path(this.URL_AREAPROFUNDIZACION) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /** ## Áreas de Profundización Docentes
   * Contiene los servicios para manejar las áreas de profundización de los docentes
   */

  /** ###  postAreaDocente
   * Registrar un área de profundización al docente
   */
  postAreaDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_AREA_DOCENTE);
    return this.http.post(url, datos, {headers: this.headers}).pipe(retry(10));
  }

  /** ##  getAreasDocente
   * Obtiene las áreas de profundización del docente
   */
  getAreasDocente(IdDocente: string) {
    const url = this.dataSnap_Path(this.URL_AREAS_DOCENTE) + this.parametro(IdDocente);
    return this.http.get(url, {headers: this.headers}).pipe(retry(10));
  }

  /** ### deleteAreaDocente
   * Elimina el área de profundización del docente
   */
  deleteAreaDocente(idareadocente: string) {
    const url = this.dataSnap_Path(this.URL_AREA_DOCENTE) + this.parametro(idareadocente);
    return this.http.delete(url, {headers: this.headers}).pipe(retry(10));
  }

  /* TrabajoGrado %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postTrabajoGrado(datos: string) {
    const url = this.dataSnap_Path(this.URL_TRABAJOGRADO);
    const headers = this.headers;
    return this.http.post(url, datos, {headers});
  }

  getTrabajosGrado(paginacion: string) {
    const url = this.dataSnap_Path(this.URL_TRABAJOSGRADO);
    const headers = this.headers;
    return this.http.post(url, paginacion, {headers}).pipe(retry(10));
  }

  getDirectoresTrabajosGrado() {
    const url = this.dataSnap_Path(this.URL_DIRECTORES_TRABAJOS_GRADO);
    const headers = this.headers;
    return this.http.get(url, {headers}).pipe(retry(10));
  }

  getEvaluadoresTrabajosGrado() {
    const url = this.dataSnap_Path(this.URL_EVALUADORES_TRABAJOS_GRADO);
    const headers = this.headers;
    return this.http.get(url, {headers}).pipe(retry(10));
  }

  getTrabajoGrado(id: string) {
    const url = this.dataSnap_Path(this.URL_TRABAJOGRADO) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putTrabajoGrado(datos: string) {
    const url = this.dataSnap_Path(this.URL_TRABAJOGRADO);
    const headers = this.headers;
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteTrabajoGrado(id: string) {
    const url = this.dataSnap_Path(this.URL_TRABAJOGRADO) + this.parametro(id);
    const headers = this.headers;
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  getEstadisticasTrabajosGrado() {
    const url = this.dataSnap_Path(this.URL_ESTADISTICAS_TRABAJOS_GRADO);
    const headers = this.headers;
    return this.http.get(url, {headers}).pipe(retry(10));
  }

  /* Periodo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postPeriodo(datos: string) {
    const url = this.dataSnap_Path(this.URL_PERIODO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getPeriodos() {
    const url = this.dataSnap_Path(this.URL_PERIODOS);
    return this.http.get(url).pipe(retry(10));
  }

  getPeriodo(id: string) {
    const url = this.dataSnap_Path(this.URL_PERIODO) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putPeriodo(datos: string) {
    const url = this.dataSnap_Path(this.URL_PERIODO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deletePeriodo(id: string) {
    const url = this.dataSnap_Path(this.URL_PERIODO) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* ActividadFuncionDocente %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postActividadFuncionDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADFUNCIONDOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getActividadesFuncionesDocente(IdDocente: string, Periodo: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADESFUNCIONESDOCENTE) + this.parametro(IdDocente) + this.parametro(Periodo);
    return this.http.get(url).pipe(retry(10));
  }

  getActividadFuncionDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADFUNCIONDOCENTE) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putActividadFuncionDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADFUNCIONDOCENTE) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteActividadFuncionDocente(id: string) {
    const url = this.dataSnap_Path(this.URL_ACTIVIDADFUNCIONDOCENTE) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* Favorito %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postFavorito(datos: string) {
    const url = this.dataSnap_Path(this.URL_FAVORITO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getFavoritos() {
    const url = this.dataSnap_Path(this.URL_FAVORITOS);
    return this.http.get(url).pipe(retry(10));
  }

  getFavorito(id: string) {
    const url = this.dataSnap_Path(this.URL_FAVORITO) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putFavorito(datos: string) {
    const url = this.dataSnap_Path(this.URL_FAVORITO) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteFavorito(id: string) {
    const url = this.dataSnap_Path(this.URL_FAVORITO) + this.parametro(this.token) + this.parametro(id);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  getReporteProgramasServicios(IdPrograma: string, periodo: string) {
    const url = this.dataSnap_Path(this.URL_REPORTE_PROGRAMA_SERVICIOS) + this.parametro(IdPrograma) + this.parametro(periodo);
    return this.http.get(url).pipe(retry(10));
  }

  getReporteHorasFacultad(periodo: string) {
    const url = this.dataSnap_Path(this.URL_REPORTE_HORAS_POR_FACULTAD) + this.parametro(periodo);
    return this.http.get(url).pipe(retry(10));
  }

  // %%%%%%% Perfil del Docente %%%%%%%

  getPerfilDocente(IdDocente: string) {
    const url = this.dataSnap_Path(this.URL_PERFIL_DOCENTE) + this.parametro(IdDocente);
    return this.http.get(url).pipe(retry(10));
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Plan de Mejoramiento
     Contiene todos los servicios para el plan de mejoramiento
  =========================================================================================================================*/
  getFactoresCalidad() {
    const url = this.dataSnap_Path(this.URL_FACTORES_CALIDAD);
    return this.http.get(url);
  }

  postFactorCalidad(datos: string) {
    const url = this.dataSnap_Path(this.URL_FACTOR_CALIDAD);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  putFactorCalidad(datos: string) {
    const url = this.dataSnap_Path(this.URL_FACTOR_CALIDAD);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put (url, datos, {headers});
  }

  deleteFactorCalidad(id: string) {
    const url = this.dataSnap_Path(this.URL_FACTOR_CALIDAD) + this.parametro(id);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  getRequisitos() {
    const url = this.dataSnap_Path(this.URL_REQUISITOS);
    return this.http.get(url);
  }

  getTiposAccion() {
    const url = this.dataSnap_Path(this.URL_TIPOS_ACCION);
    return this.http.get(url);
  }

  getFuentes() {
    const url = this.dataSnap_Path(this.URL_FUENTES);
    return this.http.get(url);
  }

  getPlanesMejoramiento() {
    const url = this.dataSnap_Path(this.URL_PLANES_MEJORAMIENTO);
    return this.http.get(url);
  }

  getPlanMejoramiento(IdPlan: string) {
    const url = this.dataSnap_Path(this.URL_PLAN_MEJORAMIENTO) + this.parametro(IdPlan);
    return this.http.get(url);
  }

  deletePlanMejoramiento(IdPlan: string) {
    const url = this.dataSnap_Path(this.URL_PLAN_MEJORAMIENTO) + this.parametro(IdPlan);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url,  {headers});
  }

  postPlanMejoramiento(datos: string) {
    const url = this.dataSnap_Path(this.URL_PLAN_MEJORAMIENTO);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }

  putPlanMejoramiento(datos: string) {
    const url = this.dataSnap_Path(this.URL_PLAN_MEJORAMIENTO);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers});
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     CRUD
     Formación del Docente
  =========================================================================================================================*/

  getFormaciones() {
    const url = this.dataSnap_Path(this.URL_FORMACIONES);
    return this.http.get(url);
  }

  getFormacion(IdDocente: string) {
    const url = this.dataSnap_Path(this.URL_FORMACION) + this.parametro(IdDocente);
    return this.http.get(url);
  }

  deleteFormacion(IdPlan: string) {
    const url = this.dataSnap_Path(this.URL_FORMACION) + this.parametro(IdPlan);
    const headers = this.headers;
    return this.http.delete(url,  {headers});
  }

  postFormacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_FORMACION);
    const headers = this.headers;
    return this.http.post(url, datos, {headers});
  }

  putFormacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_FORMACION);
    const headers = this.headers;
    return this.http.put(url, datos, {headers});
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     CRUD
     Grupos de Investigación Docente
  =========================================================================================================================*/

  getGruposInvestigacionDocente(IdDocente: string) {
    const url = this.dataSnap_Path(this.URL_GRUPOINV_DOCENTE) + this.parametro(IdDocente);
    const headers = this.headers;
    return this.http.get(url, {headers});
  }

  getDocentesGrupoInvestigacion(IdGrupo: string) {
    const url = this.dataSnap_Path(this.URL_DOCENTES_GRUPO_INVESTIGACION) + this.parametro(IdGrupo);
    const headers = this.headers;
    return this.http.get(url, {headers});
  }

  deleteGrupoInvestigacionDocente(IdGrupoDocente: string) {
    const url = this.dataSnap_Path(this.URL_GRUPOINV_DOCENTE) + this.parametro(IdGrupoDocente);
    const headers = this.headers;
    return this.http.delete(url,  {headers});
  }

  postGrupoInvestigacionDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_GRUPOINV_DOCENTE);
    const headers = this.headers;
    return this.http.post(url, datos, {headers});
  }

  putGrupoInvestigacionDocente(datos: string) {
    const url = this.dataSnap_Path(this.URL_GRUPOINV_DOCENTE);
    const headers = this.headers;
    return this.http.put(url, datos, {headers});
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     CRUD
     Tipos de Producción
  =========================================================================================================================*/

  getTiposProduccion() {
    const url = this.dataSnap_Path(this.URL_TIPOS_PRODUCCION);
    const headers = this.headers;
    return this.http.get(url, {headers});
  }

  getTipoProduccion(IdTipo: string) {
    const url = this.dataSnap_Path(this.URL_TIPO_PRODUCCION) + this.parametro(IdTipo);
    const headers = this.headers;
    return this.http.get(url, {headers});
  }

  deleteTipoProduccio(IdPlan: string) {
    const url = this.dataSnap_Path(this.URL_TIPO_PRODUCCION) + this.parametro(IdPlan);
    const headers = this.headers;
    return this.http.delete(url,  {headers});
  }

  postTipoProduccio(datos: string) {
    const url = this.dataSnap_Path(this.URL_TIPO_PRODUCCION);
    const headers = this.headers;
    return this.http.post(url, datos, {headers});
  }

  putTipoProduccio(datos: string) {
    const url = this.dataSnap_Path(this.URL_TIPO_PRODUCCION);
    const headers = this.headers;
    return this.http.put(url, datos, {headers});
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     CRUD
     Productos
  =========================================================================================================================*/

  getProductos() {
    const url = this.dataSnap_Path(this.URL_PRODUCTOS);
    const headers = this.headers;
    return this.http.get(url, {headers});
  }

  getProductosPorDocente(IdDocente: string) {
    const url = this.dataSnap_Path(this.URL_PRODUCTOS_DOCENTE) + this.parametro(IdDocente);
    const headers = this.headers;
    return this.http.get(url, {headers});
  }

  deleteProducto(IdPlan: string) {
    const url = this.dataSnap_Path(this.URL_PRODUCTO) + this.parametro(IdPlan);
    const headers = this.headers;
    return this.http.delete(url,  {headers});
  }

  postProducto(datos: string) {
    const url = this.dataSnap_Path(this.URL_PRODUCTO);
    const headers = this.headers;
    return this.http.post(url, datos, {headers});
  }

  putProducto(datos: string) {
    const url = this.dataSnap_Path(this.URL_PRODUCTO);
    const headers = this.headers;
    return this.http.put(url, datos, {headers});
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     CRUD
     Enlaces divulgación
  =========================================================================================================================*/

  getEnlacesDivulgacion(IdDocente: string) {
    const url = this.dataSnap_Path(this.URL_ENLACES_DIVULGACION) + this.parametro(IdDocente);
    const headers = this.headers;
    return this.http.get(url, {headers});
  }

  deleteEnlaceDivulgalcion(IdEnlace: string) {
    const url = this.dataSnap_Path(this.URL_ENLACE_DIVULGACION) + this.parametro(IdEnlace);
    const headers = this.headers;
    return this.http.delete(url,  {headers});
  }

  postEnlaceDivulgacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_ENLACE_DIVULGACION);
    const headers = this.headers;
    return this.http.post(url, datos, {headers});
  }

  putEnlaceDivulgacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_ENLACE_DIVULGACION);
    const headers = this.headers;
    return this.http.put(url, datos, {headers});
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     CRUD
     Eventos del Seminario del programa
  =========================================================================================================================*/

  getSeminario(IdSeminario: string) {
    const url = this.dataSnap_Path(this.URL_SEMINARIO) + this.parametro(IdSeminario);
    const headers = this.headers;
    return this.http.get(url, {headers});
  }

  getSeminarios() {
    const url = this.dataSnap_Path(this.URL_SEMINARIOS);
    const headers = this.headers;
    return this.http.get(url, {headers});
  }

  deleteSeminario(IdSeminario: string) {
    const url = this.dataSnap_Path(this.URL_SEMINARIO) + this.parametro(IdSeminario);
    const headers = this.headers;
    return this.http.delete(url,  {headers});
  }

  postSeminario(datos: string) {
    const url = this.dataSnap_Path(this.URL_SEMINARIO);
    const headers = this.headers;
    return this.http.post(url, datos, {headers});
  }

  putSeminario(datos: string) {
    const url = this.dataSnap_Path(this.URL_SEMINARIO);
    const headers = this.headers;
    return this.http.put(url, datos, {headers});
  }
}
