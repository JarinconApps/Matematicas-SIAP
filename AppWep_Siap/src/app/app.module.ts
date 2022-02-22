import { BrowserModule } from '@angular/platform-browser';
import { NgModule, NO_ERRORS_SCHEMA } from '@angular/core';
import {HttpClientModule} from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

// %%%%%%% Material Angular %%%%%%%
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {MatDialogModule} from '@angular/material/dialog';
import {MatSnackBarModule} from '@angular/material/snack-bar';
import {MatMenuModule} from '@angular/material/menu';
import {MatExpansionModule} from '@angular/material/expansion';
import {MatSlideToggleModule} from '@angular/material/slide-toggle';
import {MatFormFieldModule} from '@angular/material/form-field';

import { AngularEditorModule } from '@kolkov/angular-editor';

import { ChartsModule } from 'ng2-charts';

// %%%%%%% Routing Module %%%%%%%
import { routingModule } from './app.routes';

// %%%%%%% Pipes %%%%%%%
import { CapitalizadoPipe } from './pipes/capitalizado.pipe';
import { ReducirTextoPipe } from './pipes/reducir-texto.pipe';

// %%%%%%% Dialogos %%%%%%%
import { ConfirmacionComponent } from './dialogos/confirmacion/confirmacion.component';
import { MensajeComponent } from './dialogos/mensaje/mensaje.component';
import { UnValorComponent } from './dialogos/un-valor/un-valor.component';
import { SnackBarComponent } from './dialogos/snack-bar/snack-bar.component';
import { EsperaComponent } from './dialogos/espera/espera.component';
import { MostrarParticipanteComponent } from './dialogos/mostrar-participante/mostrar-participante.component';
import { EvaluarResumenEmemComponent } from './dialogos/evaluar-resumen-emem/evaluar-resumen-emem.component';

// %%%%%%% Componentes Generales %%%%%%%
import { AppComponent } from './app.component';
import { MenuComponent } from './general/menu/menu.component';
import { InicioComponent } from './general/inicio/inicio.component';
import { PiePaginaComponent } from './general/pie-pagina/pie-pagina.component';
import { NoPaginaComponent } from './general/no-pagina/no-pagina.component';

// %%%%%%% Componentes de Admnistrador %%%%%%%
import { AdministradorComponent } from './administrador/administrador/administrador.component';
import { AdminInicioComponent } from './administrador/admin-inicio/admin-inicio.component';
import { AdminUsuarioComponent } from './administrador/admin-usuario/admin-usuario.component';
import { AdminEditarusuarioComponent } from './administrador/admin-editarusuario/admin-editarusuario.component';
import { ResumenesEmemComponent } from './administrador/resumenes-emem/resumenes-emem.component';
import { PruebasComponent } from './administrador/pruebas/pruebas.component';
import { MenuWorkshopEmemComponent } from './administrador/menu-workshop-emem/menu-workshop-emem.component';
import { ParticpantesEmemComponent } from './administrador/menu-workshop-emem/particpantes-emem/particpantes-emem.component';
import { ListaPostersComponent } from './administrador/menu-workshop-emem/lista-posters/lista-posters.component';

/* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FACTORES
Importación de los componentes de los factores
=========================================================================================================================*/
import { FactoresComponent } from './factores/factores.component';

// %%%%%%% Factor de Internacinoalización %%%%%%%
import { FintConveniosComponent } from './factores/internacionalizacion/fint-convenios/fint-convenios.component';

// %%%%%%% Factor de Extensión %%%%%%%
import { ExtensionComponent } from './factores/extension/extension.component';
import { EmemWorkShopComponent } from './factores/extension/emem-work-shop/emem-work-shop.component';
import { InscripcionesEmemComponent } from './factores/extension/emem-work-shop/inscripciones-emem/inscripciones-emem.component';
import { CertificadosEmemComponent } from './factores/extension/emem-work-shop/certificados-emem/certificados-emem.component';
import { CursilloEmemComponent } from './factores/extension/emem-work-shop/cursillo-emem/cursillo-emem.component';
import { PostersEmemComponent } from './factores/extension/emem-work-shop/posters-emem/posters-emem.component';
import { ResumenesComponent } from './factores/extension/emem-work-shop/resumenes/resumenes.component';
import { VerResumenComponent } from './factores/extension/emem-work-shop/ver-resumen/ver-resumen.component';
import { CrearResumenComponent } from './factores/extension/emem-work-shop/crear-resumen/crear-resumen.component';
import { CronogramaEmemComponent } from './factores/extension/emem-work-shop/cronograma-emem/cronograma-emem.component';
import { PaginaInicioComponent } from './factores/extension/emem-work-shop/pagina-inicio/pagina-inicio.component';
import { CursillosEmemComponent } from './factores/extension/emem-work-shop/cursillos-emem/cursillos-emem.component';

// %%%%%%% Factor de Docentes %%%%%%%
import { FactorDocentesComponent } from './factores/docentes/factor-docentes.component';

// %%%%%%% Factor de Estudiantes %%%%%%%
import { EstudiantesComponent } from './factores/estudiantes/estudiantes.component';

// %%%%%%% Factor de Procesos Académicos %%%%%%%

// %%%%%%% Factor de Investigación %%%%%%%
import { InvestigacionComponent } from './factores/investigacion/investigacion.component';

// %%%%%%% Manual de la Aplicación %%%%%%%
import { ManualDesarrolloComponent } from './acerca/manual-desarrollo/manual-desarrollo.component';
import { InternacionalizacionComponent } from './factores/internacionalizacion/internacionalizacion.component';
import { ProcesosAcademicosComponent } from './factores/procesos_academicos/procesos-academicos.component';
import { TituloMenuComponent } from './general/titulo-menu/titulo-menu.component';
import { TiposContratoComponent } from './factores/docentes/tipos-contrato/tipos-contrato.component';
import { DlgTipoContratoComponent } from './factores/docentes/tipos-contrato/dlg-tipo-contrato/dlg-tipo-contrato.component';
import { ActualizacionesComponent } from './acerca/actualizaciones/actualizaciones.component';
import { CategoriasDocentesComponent } from './factores/docentes/categorias-docentes/categorias-docentes.component';
import { DlgCategoriaDocenteComponent } from './factores/docentes/categorias-docentes/dlg-categoria-docente/dlg-categoria-docente.component';
import { DocentesComponent } from './factores/docentes/docentes/docentes.component';
import { DlgDocenteComponent } from './factores/docentes/docentes/dlg-docente/dlg-docente.component';
import { NoImagenPipe } from './pipes/no-imagen.pipe';
import { DocenteComponent } from './factores/docentes/docente/docente.component';
import { ErroresComponent } from './acerca/errores/errores.component';
import { AgendasComponent } from './factores/docentes/agendas/agendas.component';
import { FacultadesComponent } from './factores/docentes/facultades/facultades.component';
import { DlgFacultadComponent } from './factores/docentes/facultades/dlg-facultad/dlg-facultad.component';
import { ProgramasComponent } from './factores/docentes/programas/programas.component';
import { DlgProgramaComponent } from './factores/docentes/programas/dlg-programa/dlg-programa.component';
import { ServiciosProgramaComponent } from './factores/docentes/servicios-programa/servicios-programa.component';
import { DlgServicioProgramaComponent } from './factores/docentes/servicios-programa/dlg-servicio-programa/dlg-servicio-programa.component';
import { DlgHorarioServicioComponent } from './factores/docentes/servicios-programa/dlg-horario-servicio/dlg-horario-servicio.component';
import { DlgAgendaServicioComponent } from './factores/docentes/agendas/dlg-agenda-servicio/dlg-agenda-servicio.component';
import { ConfiguracionesComponent } from './administrador/configuraciones/configuraciones.component';
import { ServicioProgramaComponent } from './factores/docentes/servicios-programa/servicio-programa/servicio-programa.component';
import { TareasPendientesComponent } from './acerca/tareas-pendientes/tareas-pendientes.component';
import { FuncionesDocenteComponent } from './factores/docentes/funciones-docente/funciones-docente.component';
import { DlgFuncionDocenteComponent } from './factores/docentes/funciones-docente/dlg-funcion-docente/dlg-funcion-docente.component';
import { DlgActividadDocenteComponent } from './factores/docentes/funciones-docente/dlg-actividad-docente/dlg-actividad-docente.component';
import { DlgSubactividadDocenteComponent } from './factores/docentes/funciones-docente/dlg-subactividad-docente/dlg-subactividad-docente.component';
import { EgresadosComponent } from './factores/extension/egresados/egresados.component';
import { DlgEgresadoComponent } from './factores/extension/egresados/dlg-egresado/dlg-egresado.component';
import { GruposInvestigacionComponent } from './factores/investigacion/grupos-investigacion/grupos-investigacion.component';
import { DlgGrupoInvestigacionComponent } from './factores/investigacion/grupos-investigacion/dlg-grupo-investigacion/dlg-grupo-investigacion.component';
import { ModalidadesComponent } from './factores/procesos_academicos/trabajos-grado/modalidades/modalidades.component';
import { DlgModalidadComponent } from './factores/procesos_academicos/trabajos-grado/modalidades/dlg-modalidad/dlg-modalidad.component';
import { AreasProfundizacionComponent } from './factores/procesos_academicos/trabajos-grado/areas-profundizacion/areas-profundizacion.component';
import { DlgAreaProfundizacionComponent } from './factores/procesos_academicos/trabajos-grado/areas-profundizacion/dlg-area-profundizacion/dlg-area-profundizacion.component';
import { TrabajosGradoComponent } from './factores/procesos_academicos/trabajos-grado/trabajos-grado.component';
import { CrearEditarTrabajoGradoComponent } from './factores/procesos_academicos/trabajos-grado/crear-editar-trabajo-grado/crear-editar-trabajo-grado.component';
import { PeriodosComponent } from './factores/docentes/periodos/periodos.component';
import { DlgPeriodoComponent } from './factores/docentes/periodos/dlg-periodo/dlg-periodo.component';
import { DlgFuncionesDocenteComponent } from './factores/docentes/agendas/dlg-funciones-docente/dlg-funciones-docente.component';
import { ExportarAgendaComponent } from './factores/docentes/agendas/exportar-agenda/exportar-agenda.component';
import { ExportarAgendasFacultadComponent } from './factores/docentes/agendas/exportar-agendas-facultad/exportar-agendas-facultad.component';
import { EstadoAgendasComponent } from './factores/docentes/agendas/estado-agendas/estado-agendas.component';
import { EstadisticasFactorDocentesComponent } from './factores/docentes/estadisticas-factor-docentes/estadisticas-factor-docentes.component';
import { EfdServiciosProgramaComponent } from './factores/docentes/estadisticas-factor-docentes/efd-servicios-programa/efd-servicios-programa.component';
import { EfdHorasFacultadesComponent } from './factores/docentes/estadisticas-factor-docentes/efd-horas-facultades/efd-horas-facultades.component';
import { SeleccionarDocenteComponent } from './factores/docentes/docentes/seleccionar-docente/seleccionar-docente.component';
import { TituloDialogoComponent } from './general/titulo-dialogo/titulo-dialogo.component';
import { GraficaEstadisticaComponent } from './dialogos/grafica-estadistica/grafica-estadistica.component';
import { ActaProgramaComponent } from './factores/procesos_academicos/trabajos-grado/acta-programa/acta-programa.component';
import { CrearDirectorJuradoComponent } from './factores/docentes/docentes/crear-director-jurado/crear-director-jurado.component';
import { DirectoresJuradosComponent } from './factores/docentes/docentes/directores-jurados/directores-jurados.component';
import { CoordinacionPracticaDocenteComponent } from './factores/procesos_academicos/coordinacion-practica-docente/coordinacion-practica-docente.component';
import { AcercaComponent } from './acerca/acerca.component';
import { PlanMejoramientoComponent } from './factores/procesos_academicos/plan-mejoramiento/plan-mejoramiento.component';
import { CrearEditarPlanMejoramientoComponent } from './factores/procesos_academicos/plan-mejoramiento/crear-editar-plan-mejoramiento/crear-editar-plan-mejoramiento.component';
import { VerPlanMejoraComponent } from './factores/procesos_academicos/plan-mejoramiento/ver-plan-mejora/ver-plan-mejora.component';
import { PlanesMejoramientoComponent } from './factores/procesos_academicos/plan-mejoramiento/planes-mejoramiento/planes-mejoramiento.component';
import { FactoresCalidadComponent } from './factores/procesos_academicos/plan-mejoramiento/factores-calidad/factores-calidad.component';
import { CrearEditarFactorCalidadComponent } from './factores/procesos_academicos/plan-mejoramiento/crear-editar-factor-calidad/crear-editar-factor-calidad.component';
import { DatePickerComponent } from './comunes/date-picker/date-picker.component';
import Counter from './counter';
import { CrearEditarFormacionComponent } from './factores/docentes/docente/crear-editar-formacion/crear-editar-formacion.component';
import { SeleccionarGrupoComponent } from './factores/investigacion/grupos-investigacion/seleccionar-grupo/seleccionar-grupo.component';
import { AdminTiposProduccionComponent } from './administrador/admin-tipos-produccion/admin-tipos-produccion.component';
import { CrearEditarTipoProduccionComponent } from './administrador/admin-tipos-produccion/crear-editar-tipo-produccion/crear-editar-tipo-produccion.component';
import { CrearEditarProductoComponent } from './factores/docentes/docente/crear-editar-producto/crear-editar-producto.component';
import { VerTrabajoGradoComponent } from './factores/procesos_academicos/trabajos-grado/ver-trabajo-grado/ver-trabajo-grado.component';
import { ExportarTrabajosGradoComponent } from './factores/procesos_academicos/trabajos-grado/exportar-trabajos-grado/exportar-trabajos-grado.component';
import { ReporteDireccionTrabajosGradoComponent } from './factores/procesos_academicos/trabajos-grado/reporte-direccion-trabajos-grado/reporte-direccion-trabajos-grado.component';
import { VisorGraficaComponent } from './comunes/visor-grafica/visor-grafica.component';
import { EstadisticasTrabajosGradoComponent } from './factores/procesos_academicos/trabajos-grado/estadisticas-trabajos-grado/estadisticas-trabajos-grado.component';
import { EstadisticasComponent } from './estadisticas/estadisticas.component';
import { TiempoPipe } from './pipes/tiempo.pipe';
import { ReporteDireccionJuradoComponent } from './factores/procesos_academicos/trabajos-grado/reporte-direccion-jurado/reporte-direccion-jurado.component';
import { CrearEditarAreaDocenteComponent } from './factores/docentes/docente/crear-editar-area-docente/crear-editar-area-docente.component';
import { GrupoInvestigacionComponent } from './factores/investigacion/grupos-investigacion/grupo-investigacion/grupo-investigacion.component';
import { CrearEditarEnlaceDivulgacionComponent } from './factores/docentes/docente/crear-editar-enlace-divulgacion/crear-editar-enlace-divulgacion.component';
import { SeminarioComponent } from './factores/extension/seminario/seminario.component';
import { EventosSeminarioComponent } from './factores/extension/seminario/eventos-seminario/eventos-seminario.component';
import { CrearEditarEventoSeminarioComponent } from './factores/extension/seminario/eventos-seminario/crear-editar-evento-seminario/crear-editar-evento-seminario.component';
import { VerSeminarioComponent } from './factores/extension/seminario/eventos-seminario/ver-seminario/ver-seminario.component';
import { ExportarPlanMejoramientoComponent } from './factores/procesos_academicos/plan-mejoramiento/exportar-plan-mejoramiento/exportar-plan-mejoramiento.component';
import { FechasPresupuestosComponent } from './factores/procesos_academicos/plan-mejoramiento/fechas-presupuestos/fechas-presupuestos.component';
import { CrearEditarFechaComponent } from './factores/procesos_academicos/plan-mejoramiento/fechas-presupuestos/crear-editar-fecha/crear-editar-fecha.component';
import { CrearEditarPresupuestoComponent } from './factores/procesos_academicos/plan-mejoramiento/crear-editar-plan-mejoramiento/crear-editar-presupuesto/crear-editar-presupuesto.component';
import { NuevosCambiosComponent } from './general/menu/nuevos-cambios/nuevos-cambios.component';
import { CrearEditarEstudianteComponent } from './factores/procesos_academicos/coordinacion-practica-docente/crear-editar-estudiante/crear-editar-estudiante.component';
import { EnviarCorreoPracticaComponent } from './factores/procesos_academicos/coordinacion-practica-docente/enviar-correo-practica/enviar-correo-practica.component';
import { VerListaCorreosComponent } from './factores/procesos_academicos/coordinacion-practica-docente/ver-lista-correos/ver-lista-correos.component';
import { EstadisticasPracticaDocenteComponent } from './factores/procesos_academicos/coordinacion-practica-docente/estadisticas-practica-docente/estadisticas-practica-docente.component';
import { EstudiantesPracticaComponent } from './factores/procesos_academicos/coordinacion-practica-docente/estudiantes-practica/estudiantes-practica.component';
import { CartasPermisosPracticasComponent } from './factores/procesos_academicos/coordinacion-practica-docente/cartas-permisos-practicas/cartas-permisos-practicas.component';
import { CrearEditarCartaComponent } from './factores/procesos_academicos/coordinacion-practica-docente/cartas-permisos-practicas/crear-editar-carta/crear-editar-carta.component';
import { SeleccionarEstudianteComponent } from './factores/procesos_academicos/coordinacion-practica-docente/estudiantes-practica/seleccionar-estudiante/seleccionar-estudiante.component';
import { ExportarCartaPermisoComponent } from './factores/procesos_academicos/coordinacion-practica-docente/exportar-carta-permiso/exportar-carta-permiso.component';




@NgModule({
  declarations: [

    // %%%%%%% Pipes %%%%%%%
    CapitalizadoPipe,
    ReducirTextoPipe,

    // %%%%%%% Dialogos %%%%%%%
    ConfirmacionComponent,
    MensajeComponent,
    UnValorComponent,
    SnackBarComponent,
    EsperaComponent,

    // %%%%%%% Componentes Generales %%%%%%%
    AppComponent,
    MenuComponent,
    InicioComponent,
    PiePaginaComponent,
    NoPaginaComponent,

    // %%%%%%% Componentes de Administrador %%%%%%%
    AdministradorComponent,
    AdminInicioComponent,
    AdminUsuarioComponent,
    AdminEditarusuarioComponent,

    /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       Factores
       Componentes de Factores
    =========================================================================================================================*/
    FactoresComponent,

    // %%%%%%% Factor de Internacionalización %%%%%%%
    FintConveniosComponent,

    // %%%%%%% Factor de Extensión %%%%%%%
    ExtensionComponent,
    EmemWorkShopComponent,
    PaginaInicioComponent,
    InscripcionesEmemComponent,
    CronogramaEmemComponent,
    CursillosEmemComponent,
    PostersEmemComponent,
    CertificadosEmemComponent,
    CursilloEmemComponent,
    ResumenesComponent,
    CrearResumenComponent,
    VerResumenComponent,
    ResumenesEmemComponent,
    MenuWorkshopEmemComponent,
    ParticpantesEmemComponent,
    MostrarParticipanteComponent,
    EvaluarResumenEmemComponent,
    ListaPostersComponent,

    // %%%%%%% Factor de Docentes %%%%%%%
    FactorDocentesComponent,

    // %%%%%%% Factor de Estudiantes %%%%%%%
    EstudiantesComponent,

    // %%%%%%% Factor de Investigación %%%%%%%
    InvestigacionComponent,


    // %%%%%%% Manual de la Aplicación %%%%%%%
    ManualDesarrolloComponent,

    // %%%%%%% Componentes de Pruebas %%%%%%%
    PruebasComponent,

    InternacionalizacionComponent,

    ProcesosAcademicosComponent,

    TituloMenuComponent,

    TiposContratoComponent,

    DlgTipoContratoComponent,

    ActualizacionesComponent,

    CategoriasDocentesComponent,

    DlgCategoriaDocenteComponent,

    DocentesComponent,

    DlgDocenteComponent,

    NoImagenPipe,

    DocenteComponent,

    ErroresComponent,

    AgendasComponent,

    FacultadesComponent,

    DlgFacultadComponent,

    ProgramasComponent,

    DlgProgramaComponent,

    ServiciosProgramaComponent,

    DlgServicioProgramaComponent,

    DlgHorarioServicioComponent,

    DlgAgendaServicioComponent,

    ConfiguracionesComponent,

    ServicioProgramaComponent,

    TareasPendientesComponent,

    FuncionesDocenteComponent,

    DlgFuncionDocenteComponent,

    DlgActividadDocenteComponent,

    DlgSubactividadDocenteComponent,

    EgresadosComponent,

    DlgEgresadoComponent,

    GruposInvestigacionComponent,

    DlgGrupoInvestigacionComponent,

    ModalidadesComponent,

    DlgModalidadComponent,

    AreasProfundizacionComponent,

    DlgAreaProfundizacionComponent,

    TrabajosGradoComponent,

    CrearEditarTrabajoGradoComponent,

    PeriodosComponent,

    DlgPeriodoComponent,

    DlgFuncionesDocenteComponent,

    ExportarAgendaComponent,

    ExportarAgendasFacultadComponent,

    EstadoAgendasComponent,

    EstadisticasFactorDocentesComponent,

    EfdServiciosProgramaComponent,

    EfdHorasFacultadesComponent,

    SeleccionarDocenteComponent,

    TituloDialogoComponent,

    GraficaEstadisticaComponent,

    ActaProgramaComponent,

    CrearDirectorJuradoComponent,

    DirectoresJuradosComponent,

    CoordinacionPracticaDocenteComponent,

    AcercaComponent,

    PlanMejoramientoComponent,

    CrearEditarPlanMejoramientoComponent,

    VerPlanMejoraComponent,

    PlanesMejoramientoComponent,

    FactoresCalidadComponent,

    CrearEditarFactorCalidadComponent,

    DatePickerComponent,

    VisorGraficaComponent,

    CrearEditarFormacionComponent,

    SeleccionarGrupoComponent,

    AdminTiposProduccionComponent,

    CrearEditarTipoProduccionComponent,

    CrearEditarProductoComponent,

    VerTrabajoGradoComponent,

    ExportarTrabajosGradoComponent,

    ReporteDireccionTrabajosGradoComponent,

    EstadisticasTrabajosGradoComponent,

    EstadisticasComponent,

    TiempoPipe,

    ReporteDireccionJuradoComponent,

    CrearEditarAreaDocenteComponent,

    GrupoInvestigacionComponent,

    CrearEditarEnlaceDivulgacionComponent,

    SeminarioComponent,

    EventosSeminarioComponent,

    CrearEditarEventoSeminarioComponent,

    VerSeminarioComponent,

    ExportarPlanMejoramientoComponent,

    FechasPresupuestosComponent,

    CrearEditarFechaComponent,

    CrearEditarPresupuestoComponent,

    NuevosCambiosComponent,

    CrearEditarEstudianteComponent,

    EnviarCorreoPracticaComponent,

    VerListaCorreosComponent,

    EstadisticasPracticaDocenteComponent,

    EstudiantesPracticaComponent,

    CartasPermisosPracticasComponent,

    CrearEditarCartaComponent,

    SeleccionarEstudianteComponent,

    ExportarCartaPermisoComponent,


  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    routingModule,
    HttpClientModule,
    FormsModule,
    MatDialogModule,
    MatSnackBarModule,
    MatMenuModule,
    MatExpansionModule,
    MatSlideToggleModule,
    ChartsModule,
    MatFormFieldModule,
    AngularEditorModule
  ],
  providers: [],
  entryComponents: [
    MensajeComponent,
    ConfirmacionComponent,
    UnValorComponent,
    EsperaComponent,
    MostrarParticipanteComponent,
    EvaluarResumenEmemComponent,
    SnackBarComponent,
    DlgTipoContratoComponent,
    DlgCategoriaDocenteComponent,
    DlgDocenteComponent,
    DlgFacultadComponent,
    DlgProgramaComponent,
    DlgServicioProgramaComponent,
    DlgHorarioServicioComponent,
    DlgAgendaServicioComponent,
    DlgFuncionDocenteComponent,
    DlgActividadDocenteComponent,
    DlgSubactividadDocenteComponent,
    DlgEgresadoComponent,
    DlgGrupoInvestigacionComponent,
    DlgModalidadComponent,
    DlgAreaProfundizacionComponent,
    CrearEditarTrabajoGradoComponent,
    DlgPeriodoComponent,
    DlgFuncionesDocenteComponent,
    SeleccionarDocenteComponent,
    GraficaEstadisticaComponent,
    ActaProgramaComponent,
    CrearDirectorJuradoComponent,
    VerPlanMejoraComponent,
    CrearEditarFactorCalidadComponent,
    CrearEditarFormacionComponent,
    SeleccionarGrupoComponent,
    CrearEditarTipoProduccionComponent,
    CrearEditarProductoComponent,
    ExportarTrabajosGradoComponent,
    VerTrabajoGradoComponent,
    CrearEditarAreaDocenteComponent,
    CrearEditarEnlaceDivulgacionComponent,
    CrearEditarEventoSeminarioComponent,
    VerSeminarioComponent,
    ExportarPlanMejoramientoComponent,
    CrearEditarFechaComponent,
    CrearEditarPresupuestoComponent,
    NuevosCambiosComponent,
    CrearEditarEstudianteComponent,
    EnviarCorreoPracticaComponent,
    VerListaCorreosComponent,
    EstadisticasPracticaDocenteComponent,
    CrearEditarCartaComponent,
    SeleccionarEstudianteComponent
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
