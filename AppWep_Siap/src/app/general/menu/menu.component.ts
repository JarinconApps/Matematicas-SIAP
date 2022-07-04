import { GeneralService } from './../../services/general.service';
import { Component, OnInit } from '@angular/core';
import { RUTA_DOCENTES, RUTA_LISTADO_DOCENTES, RUTA_TIPO_CONTRATO, RUTA_ACTUALIZACIONES, RUTA_CATEGORIA_DOCENTE, RUTA_FACTOR_DOCENTES, RUTA_ERRORES, RUTA_AGENDAS, RUTA_FACULTADES, RUTA_PROGRAMAS, RUTA_SERVICIOSPROGRAMA, RUTA_ADMINISTRADOR, RUTA_TAREAS_PENDIENTES, RUTA_FUNCIONESDOCENTE, RUTA_EGRESADOS, RUTA_GRUPOSINVESTIGACION, RUTA_MODALIDADES, RUTA_AREASPROFUNDIZACION, RUTA_TRABAJOSGRADO, RUTA_PERIODOS, RUTA_DOCENTE, RUTA_INICIO } from '../../config/config';
import { TransferService } from '../../services/transfer.service';
import { DialogosService } from '../../services/dialogos.service';

export interface SubMenu {
  nombre?: string;
  ruta?: string;
  habilitado?: boolean;
}

export interface Menu {
  nombre?: string;
  ruta?: string;
  habilitado?: boolean;
  tieneSubMenu?: boolean;
  subMenu?: SubMenu[];
  imagen?: string;
  descripcion?: string;
}

export interface MenuPrincipal {
  nombre?: string;
  menu: Menu[];
}
@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styles: []
})
export class MenuComponent implements OnInit {

  // %%%%%%% Listado de Constantes %%%%%%%
  _RUTA_DOCENTES = RUTA_DOCENTES;
  _RUTA_FACTOR_DOCENTES = RUTA_FACTOR_DOCENTES;

  _RUTA_LISTADO_DOCENTES = RUTA_LISTADO_DOCENTES;
  _RUTA_TIPO_CONTRATO = RUTA_TIPO_CONTRATO;
  _RUTA_ACTUALIZACIONES = RUTA_ACTUALIZACIONES;
  _RUTA_CATEGORIA_DOCENTE = RUTA_CATEGORIA_DOCENTE;
  _RUTA_ERRORES = RUTA_ERRORES;
  _RUTA_AGENDAS = RUTA_AGENDAS;
  _RUTA_FACULTADES = RUTA_FACULTADES;
  _RUTA_PROGRAMAS = RUTA_PROGRAMAS;
  _RUTA_SERVICIOSPROGRAMA = RUTA_SERVICIOSPROGRAMA;
  _RUTA_TAREAS_PENDIENTES = RUTA_TAREAS_PENDIENTES;
  _RUTA_FUNCIONESDOCENTE = RUTA_FUNCIONESDOCENTE;
  _RUTA_EGRESADOS = RUTA_EGRESADOS;
  _RUTA_GRUPOSINVESTIGACION = RUTA_GRUPOSINVESTIGACION;
  _RUTA_MODALIDADES = RUTA_MODALIDADES;
  _RUTA_AREASPROFUNDIZACION = RUTA_AREASPROFUNDIZACION;
  _RUTA_TRABAJOSGRADO = RUTA_TRABAJOSGRADO;
  _RUTA_PERIODOS = RUTA_PERIODOS;

  _RUTA_ADMINISTRAR = RUTA_ADMINISTRADOR;

  Grupos: any[] = [
    {nombre: 'GEDES - Grupo de Estudio y Desarrollo de Software'},
    {nombre: 'GEMAUQ - Grupo de Educación Matemática'},
    {nombre: 'GEDIMA - Grupo en Didáctica de la Matemática' },
    {nombre: 'GMME - Grupo de Modelación Matemática en Epidemiología'},
    {nombre: 'Grupo de Investigación y Asesoría en Estadística'},
    {nombre: 'EIB - Escuela de Investigación en Biomatemáticas'},
    {nombre: 'SIGMA - Seminario Interdisciplinario y Grupo de Matemática Aplicada'}
  ];

  version = '3.22.7.3.1832';

  nuevosCambios = `<ol>
    <li>Se arreglo la columna de las aulas en la opción de exportar agenda de docente.</li>
    <li>Se arreglo el error: Cuando se exporta la agenda de un docente y se regresa siempre empezaba por el primero en la lista (Carlos Alberto Abello Muñoz) se agrego a la ruta de búsqueda el tipo de contrato y el ID del docente.</li>
    <li>Se arreglo la búsqueda de programas en el Reporte de Servicios por Programa.</li>
    <li>Se agregaron bordes a las tablas exportadas de Word para el Reporte de Servicios por Programa.</li>
    <li>En el menú de Reporte de Servicios por Programa se arreglo la opción de que al hacer clic en una materia que esta muy abajo, automáticamente se muestra la parte superior de la página.</li>
    <li>Se ocultaron los docentes activos y se creó un filtro para la búsqueda.</li>
    <li>Se organizo la tabla de docentes poniendo debajo de la foto de perfil tres iconos para la edición rápida.</li>
  </ol>`;

  permisoNavegar = false;

  constructor(public genService: GeneralService,
              private dlgService: DialogosService) { }

  ngOnInit() {
    this.avisarNuevosCambios();
  }

  avisarNuevosCambios() {
    let oldVer = '';

    if (localStorage.getItem('oldVer')) {
      oldVer = localStorage.getItem('oldVer').toString();
    }

    if (oldVer !== this.version) {
      this.dlgService.nuevosCambios(this.nuevosCambios).subscribe(() => {
        localStorage.setItem('oldVer', this.version);
      });
    }
  }

  irAMenu(ruta: string) {
    this.genService.navegar([ruta]);
  }

  verMenu(rutas: string[]) {

    this.genService.navegar(rutas);
  }

  configurarHojaVida() {
    this.genService.navegar([RUTA_FACTOR_DOCENTES, RUTA_DOCENTE, this.genService.usuario.cedula]);
  }

  cerrarSesion() {
    localStorage.removeItem('Usuario');
    localStorage.removeItem('Token');
    this.genService.usuario = null;

    this.genService.navegar([RUTA_INICIO]);
  }


}
