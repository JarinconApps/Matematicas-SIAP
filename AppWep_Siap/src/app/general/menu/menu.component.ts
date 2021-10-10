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

  version = '2.21.9.2';

  nuevosCambios = `<ol>
    <li>Se arregló el formulario para crear docentes que no estaba funcionando</li>
    <li>Se agregaron los atributos areaProfundizacion y TituloMayorFormacion al formulario de Director/Jurado</li>
    <li>Se dejaron los datos básicos del docente en dos columnas</li>
    <li>Cuando se quiere agregar un integrante al grupo de investigación, se cambió el título del botón Agregar Director/Jurado por Agregar Integrante</li>
    <li>Se agregaron dos enlaces nuevos de divulgación para los docentes</li>
    <li>Se cambio el título de la ventana de crear/editar enlace de divulgación de forma correcta</li>
    <li>Se mejoró el diseño de las tarjetas que describen los seminarios</li>
    <li>Se ordenó los seminarios por fecha de menor a mayor</li>
    <li>Se creó una vista de seminario en una ventana modal</li>
    <li>Se mejoró el diseño del editor de plan de mejoramiento</li>
    <li>Se arregló la vista de viñetas y formato en la vista del plan de mejoramiento</li>
    <li>Se creó la ventana para exportar el plan de mejoramiento a Excel</li>
    <li>Se creó el editor de fechas de presupuestos</li>
    <li>Se creó una tabla de presupuestos dinámicos para el plan de mejoramiento</li>
    <li>Se agregó la tabla de presupuestos a la vista de oportunidad de mejora</li>
    <li>Se exportaron los presupuestos en formato de Excel y se calculan los totales</li>
    <li>Se creó la opción de exportar cada oportunidad de mejora en formato Word</li>
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

    console.log(oldVer);

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
