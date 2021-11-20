import { Routes, RouterModule } from '@angular/router';

// %%%%%%% Rutas Generales %%%%%%%
import { InicioComponent } from './general/inicio/inicio.component';

// %%%%%%% Ruta de Adminstrador %%%%%%%
import { AdministradorComponent } from './administrador/administrador/administrador.component';
import { RUTAS_ADMINISTRADOR } from './administrador/administrador.routes';

// %%%%%%% Guard-Service %%%%%%%
import { RutaAdminService } from './services/ruta-admin.service';
import { RutaNavegarService } from './services/ruta-navegar.service';

// %%%%%%% Rutas Factor Internacionalización %%%%%%%

// %%%%%%% Rutas Factor Extension %%%%%%%
import { ExtensionComponent } from './factores/extension/extension.component';
import { EmemWorkShopComponent } from './factores/extension/emem-work-shop/emem-work-shop.component';
import { RUTAS_EMEMWORKSHOP } from './factores/extension/emem-work-shop/ememworkshop.routes';

// %%%%%%% Rutas Factor Docentes %%%%%%%
import { FactorDocentesComponent } from './factores/docentes/factor-docentes.component';

// %%%%%%% Rutas Factor Estudinates %%%%%%%
import { EstudiantesComponent } from './factores/estudiantes/estudiantes.component';

// %%%%%%% Rutas Procesos Académicos %%%%%%%

// %%%%%%% Rutas Investigación %%%%%%%
import { InvestigacionComponent } from './factores/investigacion/investigacion.component';

// %%%%%%% Rutas de Acceso Público %%%%%%%
import { ManualDesarrolloComponent } from './acerca/manual-desarrollo/manual-desarrollo.component';
import { NoPaginaComponent } from './general/no-pagina/no-pagina.component';
import { FactoresComponent } from './factores/factores.component';
import { InternacionalizacionComponent } from './factores/internacionalizacion/internacionalizacion.component';
import { ProcesosAcademicosComponent } from './factores/procesos_academicos/procesos-academicos.component';
import { TiposContratoComponent } from './factores/docentes/tipos-contrato/tipos-contrato.component';
import { ActualizacionesComponent } from './acerca/actualizaciones/actualizaciones.component';
import { CategoriasDocentesComponent } from './factores/docentes/categorias-docentes/categorias-docentes.component';
import { DocentesComponent } from './factores/docentes/docentes/docentes.component';
import { DocenteComponent } from './factores/docentes/docente/docente.component';
import { ErroresComponent } from './acerca/errores/errores.component';
import { AgendasComponent } from './factores/docentes/agendas/agendas.component';

import { RUTA_DOCENTES, RUTA_TIPO_CONTRATO, RUTA_CATEGORIA_DOCENTE, RUTA_FACTOR_DOCENTES, RUTA_DOCENTE, RUTA_ERRORES, RUTA_AGENDAS,
         RUTA_FACULTADES, RUTA_PROGRAMAS, RUTA_SERVICIOSPROGRAMA, RUTA_SERVICIOPROGRAMA, RUTA_ACTUALIZACIONES, RUTA_TAREAS_PENDIENTES,
         RUTA_FUNCIONESDOCENTE, RUTA_EGRESADOS, RUTA_FACTOR_EXTENSION, RUTA_GRUPOSINVESTIGACION, RUTA_MODALIDADES, RUTA_AREASPROFUNDIZACION,
         RUTA_TRABAJOSGRADO, RUTA_PERIODOS, RUTA_EXPORTAR_AGENDA_DOCENTE, RUTA_EXPORTAR_AGENDAS_FACULTAD, RUTA_ESTADO_AGENDAS,
         RUTA_ESTADISTICAS_FACTOR_DOCENTES, RUTA_ESTADISTICAS_SERVICIOS_PROGRAMA, RUTA_SEMINARIO } from './config/config';

import { FacultadesComponent } from './factores/docentes/facultades/facultades.component';
import { ProgramasComponent } from './factores/docentes/programas/programas.component';
import { ServiciosProgramaComponent } from './factores/docentes/servicios-programa/servicios-programa.component';
import { ServicioProgramaComponent } from './factores/docentes/servicios-programa/servicio-programa/servicio-programa.component';
import { TareasPendientesComponent } from './acerca/tareas-pendientes/tareas-pendientes.component';
import { FuncionesDocenteComponent } from './factores/docentes/funciones-docente/funciones-docente.component';
import { EgresadosComponent } from './factores/extension/egresados/egresados.component';
import { GruposInvestigacionComponent } from './factores/investigacion/grupos-investigacion/grupos-investigacion.component';
import { ModalidadesComponent } from './factores/procesos_academicos/trabajos-grado/modalidades/modalidades.component';
import { AreasProfundizacionComponent } from './factores/procesos_academicos/trabajos-grado/areas-profundizacion/areas-profundizacion.component';
import { TrabajosGradoComponent } from './factores/procesos_academicos/trabajos-grado/trabajos-grado.component';
import { PeriodosComponent } from './factores/docentes/periodos/periodos.component';
import { ExportarAgendaComponent } from './factores/docentes/agendas/exportar-agenda/exportar-agenda.component';
import { ExportarAgendasFacultadComponent } from './factores/docentes/agendas/exportar-agendas-facultad/exportar-agendas-facultad.component';
import { EstadoAgendasComponent } from './factores/docentes/agendas/estado-agendas/estado-agendas.component';
import { EstadisticasFactorDocentesComponent } from './factores/docentes/estadisticas-factor-docentes/estadisticas-factor-docentes.component';
import { EfdServiciosProgramaComponent } from './factores/docentes/estadisticas-factor-docentes/efd-servicios-programa/efd-servicios-programa.component';
import { EfdHorasFacultadesComponent } from './factores/docentes/estadisticas-factor-docentes/efd-horas-facultades/efd-horas-facultades.component';
import { RUTA_ESTADISTICAS_HORAS_FACULTADES, RUTA_FACTORES, RUTA_CREAR_EDITAR_TRABAJO_GRADO, RUTA_DIRECTORES_JURADOS_TRABAJO_GRADO,
   RUTA_ADMINISTRADOR, RUTA_NOT_PAGE_FOUND, RUTA_ACERCA, RUTA_MANUAL_AYUDA, RUTA_GESTION_ERRORES, RUTA_PLAN_MEJORAMIENTO,
   RUTA_CREAR_EDITAR_PLAN_MEJORAMIENTO, RUTA_INICIO, RUTA_FACTORES_CALIDAD, RUTA_VER_TRABAJO_GRADO, RUTA_EXPORTAR_TRABAJOS_GRADO,
   RUTA_DOCENTES_DIRECCION_TRABAJOS_GRADO, RUTA_ESTADISTICAS_TRABAJOS_GRADO, RUTA_ESTADISTICAS, RUTA_REPORTE_DIRECCION_JURADO,
   RUTA_GRUPO_INVESTIGACION, RUTA_EVENTOS_SEMINARIO, RUTA_FECHAS_PRESUPUESTOS } from './config/config';
import { CrearEditarTrabajoGradoComponent } from './factores/procesos_academicos/trabajos-grado/crear-editar-trabajo-grado/crear-editar-trabajo-grado.component';
import { DirectoresJuradosComponent } from './factores/docentes/docentes/directores-jurados/directores-jurados.component';
import { AcercaComponent } from './acerca/acerca.component';
import { PlanMejoramientoComponent } from './factores/procesos_academicos/plan-mejoramiento/plan-mejoramiento.component';
import { CrearEditarPlanMejoramientoComponent } from './factores/procesos_academicos/plan-mejoramiento/crear-editar-plan-mejoramiento/crear-editar-plan-mejoramiento.component';
import { PlanesMejoramientoComponent } from './factores/procesos_academicos/plan-mejoramiento/planes-mejoramiento/planes-mejoramiento.component';
import { FactoresCalidadComponent } from './factores/procesos_academicos/plan-mejoramiento/factores-calidad/factores-calidad.component';
import { VerTrabajoGradoComponent } from './factores/procesos_academicos/trabajos-grado/ver-trabajo-grado/ver-trabajo-grado.component';
import { ExportarTrabajosGradoComponent } from './factores/procesos_academicos/trabajos-grado/exportar-trabajos-grado/exportar-trabajos-grado.component';
import { ReporteDireccionTrabajosGradoComponent } from './factores/procesos_academicos/trabajos-grado/reporte-direccion-trabajos-grado/reporte-direccion-trabajos-grado.component';
import { EstadisticasTrabajosGradoComponent } from './factores/procesos_academicos/trabajos-grado/estadisticas-trabajos-grado/estadisticas-trabajos-grado.component';
import { EstadisticasComponent } from './estadisticas/estadisticas.component';
import { ReporteDireccionJuradoComponent } from './factores/procesos_academicos/trabajos-grado/reporte-direccion-jurado/reporte-direccion-jurado.component';
import { GrupoInvestigacionComponent } from './factores/investigacion/grupos-investigacion/grupo-investigacion/grupo-investigacion.component';
import { SeminarioComponent } from './factores/extension/seminario/seminario.component';
import { EventosSeminarioComponent } from './factores/extension/seminario/eventos-seminario/eventos-seminario.component';
import { FechasPresupuestosComponent } from './factores/procesos_academicos/plan-mejoramiento/fechas-presupuestos/fechas-presupuestos.component';

const routes: Routes = [

  // %%%%%%% Rutas de Acceso Público %%%%%%%
  {path: 'inicio', component: InicioComponent},
  {path: 'manual-desarrollo', component: ManualDesarrolloComponent},


  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     FACTORES
     Rutas para los factores
  =========================================================================================================================*/
  {path: RUTA_FACTORES, component: FactoresComponent, canActivate: [RutaNavegarService]},

  // %%%%%%% Rutas Procesos Académicos %%%%%%%
  {path: 'procesos-academicos', component: ProcesosAcademicosComponent, canActivate: [RutaNavegarService]},
  {path: RUTA_AREASPROFUNDIZACION, component: AreasProfundizacionComponent},
  {path: RUTA_MODALIDADES, component: ModalidadesComponent},
  {path: RUTA_TRABAJOSGRADO, component: TrabajosGradoComponent},
  {path: RUTA_REPORTE_DIRECCION_JURADO, component: ReporteDireccionJuradoComponent},
  {path: RUTA_ESTADISTICAS_TRABAJOS_GRADO, component: EstadisticasTrabajosGradoComponent},
  {path: RUTA_EXPORTAR_TRABAJOS_GRADO, component: ExportarTrabajosGradoComponent},
  {path: RUTA_ESTADISTICAS_TRABAJOS_GRADO, component: EstadisticasTrabajosGradoComponent},
  {path: RUTA_DOCENTES_DIRECCION_TRABAJOS_GRADO, component: ReporteDireccionTrabajosGradoComponent},
  {path: RUTA_VER_TRABAJO_GRADO + '/:IdTrabajoGrado', component: VerTrabajoGradoComponent},
  {path: RUTA_CREAR_EDITAR_TRABAJO_GRADO + '/:Id', component: CrearEditarTrabajoGradoComponent},

  // %%%%%%% FACTORES - PROCESOS ACADÉMICOS %%%%%%%
  {path: RUTA_PLAN_MEJORAMIENTO, component: PlanMejoramientoComponent,
   children: [
     {path: RUTA_INICIO, component: PlanesMejoramientoComponent},
     {path: RUTA_CREAR_EDITAR_PLAN_MEJORAMIENTO + '/:Id', component: CrearEditarPlanMejoramientoComponent},
     {path: RUTA_CREAR_EDITAR_PLAN_MEJORAMIENTO, component: CrearEditarPlanMejoramientoComponent},
     {path: RUTA_FACTORES_CALIDAD, component: FactoresCalidadComponent},
     {path: RUTA_FECHAS_PRESUPUESTOS, component: FechasPresupuestosComponent},
     {path: '**', pathMatch: 'full', redirectTo: RUTA_INICIO}
   ]},

  // %%%%%%% FACTORES - ESTUDIANTES %%%%%%%

  {path: 'estudiantes', component: EstudiantesComponent, canActivate: [RutaNavegarService]},

  // %%%%%%% FACTORES - DOCENTES %%%%%%%

  {path: RUTA_FACTOR_DOCENTES, component: FactorDocentesComponent, canActivate: [RutaNavegarService],
    children: [
      {path: RUTA_TIPO_CONTRATO, component: TiposContratoComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_CATEGORIA_DOCENTE, component: CategoriasDocentesComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_PERIODOS, component: PeriodosComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_DOCENTES, component: DocentesComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_DIRECTORES_JURADOS_TRABAJO_GRADO, component: DirectoresJuradosComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_DOCENTE + '/:id', component: DocenteComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_FACULTADES, component: FacultadesComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_PROGRAMAS, component: ProgramasComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_SERVICIOSPROGRAMA, component: ServiciosProgramaComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_SERVICIOPROGRAMA + '/:id/:donde', component: ServicioProgramaComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_AGENDAS, component: AgendasComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_ESTADISTICAS_FACTOR_DOCENTES, component: EstadisticasFactorDocentesComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_ESTADISTICAS_SERVICIOS_PROGRAMA, component: EfdServiciosProgramaComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_ESTADISTICAS_HORAS_FACULTADES, component: EfdHorasFacultadesComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_EXPORTAR_AGENDA_DOCENTE + '/:id/:periodo', component: ExportarAgendaComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_EXPORTAR_AGENDAS_FACULTAD + '/:periodo', component: ExportarAgendasFacultadComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_ESTADO_AGENDAS + '/:periodo', component: EstadoAgendasComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_FUNCIONESDOCENTE, component: FuncionesDocenteComponent, canActivate: [RutaNavegarService]},
      {path: '**', pathMatch: 'full', redirectTo: RUTA_DOCENTES}
    ]
  },

  // %%%%%%% FACTORES - INTERNACIONALIZACIÓN %%%%%%%

  {path: 'internacionalizacion', component: InternacionalizacionComponent, canActivate: [RutaNavegarService]},

  // %%%%%%% FACTORES - INVESTIGACION %%%%%%%

  {path: 'investigacion', component: InvestigacionComponent, canActivate: [RutaNavegarService]},
  {path: RUTA_GRUPOSINVESTIGACION, component: GruposInvestigacionComponent},
  {path: RUTA_GRUPO_INVESTIGACION + '/:IdGrupo', component: GrupoInvestigacionComponent},

  // %%%%%%% FACTORES - EXTENSIÓN Y GESTIÓN DEL GRADUADO %%%%%%%

  {path: RUTA_FACTOR_EXTENSION, component: ExtensionComponent, canActivate: [RutaNavegarService]},
  {path: RUTA_EGRESADOS, component: EgresadosComponent},
  {path: RUTA_SEMINARIO, component: SeminarioComponent, children: [
    {path: RUTA_EVENTOS_SEMINARIO, component: EventosSeminarioComponent},
  ]},

  // %%%%%%% MENU - ACERCA DE %%%%%%%
  {path: RUTA_ACERCA, component: AcercaComponent,
    children: [
      {path: RUTA_ACTUALIZACIONES, component: ActualizacionesComponent},
      {path: RUTA_TAREAS_PENDIENTES, component: TareasPendientesComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_MANUAL_AYUDA, component: ManualDesarrolloComponent, canActivate: [RutaNavegarService]},
      {path: RUTA_GESTION_ERRORES, component: ErroresComponent, canActivate: [RutaNavegarService]}
    ]},

  // %%%%%%% MENU - ADMINISTRACIÓN DE LA PLATAFORMA %%%%%%%
  {
    path: RUTA_ADMINISTRADOR,
    component: AdministradorComponent,
    children: RUTAS_ADMINISTRADOR,
    canActivate: [RutaAdminService]
  },

  // %%%%%%% Ruta de Página no encontrada %%%%%%%
  {path: RUTA_NOT_PAGE_FOUND, component: NoPaginaComponent},
  {path: '**', pathMatch: 'full', redirectTo: RUTA_NOT_PAGE_FOUND}
];

export const routingModule = RouterModule.forRoot(routes, {useHash: true});
