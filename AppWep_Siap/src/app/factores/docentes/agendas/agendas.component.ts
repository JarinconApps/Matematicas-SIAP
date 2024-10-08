import { GeneralService } from './../../../services/general.service';
import { Component, OnInit } from '@angular/core';
import { TransferService } from '../../../services/transfer.service';
import { TipoContrato, Docente, AgendaServicio, ServicioPrograma, Periodo, ActividadFuncionDocente, FuncionDocente, Contrato } from '../../../interfaces/interfaces.interfaces';
import { DialogosService } from '../../../services/dialogos.service';
import { Utilidades } from '../../../utilidades/utilidades.class';
import { RUTA_FACTOR_DOCENTES, RUTA_EXPORTAR_AGENDA_DOCENTE, RUTA_EXPORTAR_AGENDAS_FACULTAD, RUTA_SERVICIOSPROGRAMA, RUTA_SERVICIOPROGRAMA, RUTA_AGENDAS, RUTA_ESTADO_AGENDAS, RUTA_ESTADISTICAS_HORAS_FACULTADES, RUTA_ESTADISTICAS_SERVICIOS_PROGRAMA, ID_DOCENTE_DEFECTO } from '../../../config/config';
import { ActivatedRoute } from '@angular/router';

interface Opcion {
  Titulo?: string;
  Icono?: string;
  Ruta?: string[];
}
@Component({
  selector: 'app-agendas',
  templateUrl: './agendas.component.html',
  styles: []
})
export class AgendasComponent implements OnInit {

  contratos: TipoContrato[] = [];
  tipoContrato = '';
  nombreContrato = '';
  buscarNombre = '';
  bDocentes: Docente[] = [];
  Docentes: Docente[] = [];
  Periodos: Periodo[] = [];
  FuncionesDocente: ActividadFuncionDocente[] = [];
  AgendasServicio: AgendaServicio[] = [];
  leyendo = false;
  soloCatedraticos = false;

  numerocontrato = '';
  actaPrograma = '';
  actaFacultad = '';
  agendaConcertada = 'no';
  agendaCompleta = 'no';

  docenteSeleccionado: Docente = {};

  periodo = '';
  termino = '';

  // Estadìsticas de horas
  iHorasRestantes = 0;
  horasRestantes = 0;
  horasSemanales = 0;
  horasSemestrales = 0;
  horasMaxContrato = 0;
  horasFunciones = 0;
  horasDocencia = 0;
  horasTotales = 0;
  reconocimientoPosgrado = 0;

  observacion = '';

  posDoc = 0;
  paramIdDocente = '';
  paramTipoContrato = '';

  Opciones: Opcion[] = [
    {
        Titulo: 'Exportar Agendas Facultad',
        Icono: 'Word.png',
        Ruta: [RUTA_FACTOR_DOCENTES, RUTA_EXPORTAR_AGENDAS_FACULTAD],
    },
    {
      Titulo: 'Estado de las Agendas',
      Icono: 'Estado.png',
      Ruta: [RUTA_FACTOR_DOCENTES, RUTA_ESTADO_AGENDAS],
    },
    {
      Titulo: 'Servicios por programa',
      Icono: 'presentacion.png',
      Ruta: [RUTA_FACTOR_DOCENTES, RUTA_ESTADISTICAS_SERVICIOS_PROGRAMA],
    },
    {
      Titulo: 'Horas por facultad',
      Icono: 'reloj.png',
      Ruta: [RUTA_FACTOR_DOCENTES, RUTA_ESTADISTICAS_HORAS_FACULTADES],
    }
  ];

  constructor(private transfer: TransferService,
              private genService: GeneralService,
              private dlgService: DialogosService,
              private activatedRoute: ActivatedRoute) { }

  ngOnInit() {
    this.transfer.enviarTituloAplicacion('Agendas');

    /* Se debe seguir una cadena para leer correctamente los datos
    1. leerPeriodos(), que llama luego a,
    2. leerContratos(), que llama luego a,
    3. leerDocentes(), que llama luego a,
    4. seleccionarDocente(), que llama luego a,
    5. leerAgendaServicios(), que llama luego a,
    6. leerActividadesFuncionesDocentes()  */

    this.activatedRoute.params.subscribe((rParams: any) => {
      console.log(rParams);
      this.paramIdDocente = rParams.idDocente;
      this.paramTipoContrato = rParams.tipoContrato;
      this.leerPeriodos();
    })
  }

  leerPeriodos() {
    this.genService.getPeriodos().subscribe((rPeriodos: any) => {
      this.Periodos = rPeriodos.Periodos;

      this.periodo = this.Periodos[this.Periodos.length - 1].periodo;

      // Los reportes necesitan del periodo, así que se agrega manualmente
      this.Opciones[0].Ruta.push(this.periodo);
      this.Opciones[1].Ruta.push(this.periodo);

      this.leerContratos();
    });
  }

  leerContratos() {
    this.leyendo = true;

    this.genService.getTiposContrato().subscribe((rContratos: any) => {
      this.contratos = rContratos.TiposContratos;

      for (const tipo of this.contratos) {
        if (tipo.contrato === this.paramTipoContrato) {
          this.tipoContrato = tipo.idtipocontrato;
        }
      }

      this.leerDocentes();
    });
  }

  cambiarTipoContrato(contrato: TipoContrato) {
    this.genService.navegar([RUTA_FACTOR_DOCENTES, RUTA_AGENDAS, contrato.contrato, ID_DOCENTE_DEFECTO]);
  }

  leerDocentes() {
    for (const cont of this.contratos) {
      if (cont.idtipocontrato === this.tipoContrato) {
        this.nombreContrato = cont.contrato;
      }
    }

    this.genService.getDocentesPorContrato(this.tipoContrato).subscribe((rDocentes: any) => {
      this.Docentes = rDocentes.Docentes;
      this.bDocentes = this.Docentes;

      this.seleccionarDocente(this.Docentes[this.posDoc]);
    });
  }

  leerAgendasServicio() {

    this.genService.getAgendasServicio(this.docenteSeleccionado.iddocente, this.periodo).subscribe((rAgendasServicio: any) => {

      console.log(rAgendasServicio);

      this.AgendasServicio = rAgendasServicio.AgendasServicios;
      if (this.AgendasServicio.length > 0) {
        this.numerocontrato = this.AgendasServicio[0].numerocontrato;
        this.actaPrograma = this.AgendasServicio[0].actaprograma;
        this.actaFacultad = this.AgendasServicio[0].actafacultad;
        this.agendaConcertada = this.AgendasServicio[0].concertada;
      }

      this.leyendo = false;

      this.horasSemanales = rAgendasServicio.horasSemanales;
      this.horasRestantes = rAgendasServicio.horasRestantes;
      this.horasSemestrales = rAgendasServicio.horasSemestrales;
      this.reconocimientoPosgrado = rAgendasServicio.reconocimientoPosgrado;

      this.observacion = rAgendasServicio.observacion;


      if (this.nombreContrato !== 'catedrático') {
        this.leerActividadesFuncionesDocente();
      }
    });
  }

  leerActividadesFuncionesDocente() {
    this.genService.getActividadesFuncionesDocente(this.docenteSeleccionado.iddocente, this.periodo).subscribe((rFunciones: any) => {

      console.log(rFunciones);

      this.horasFunciones = rFunciones.horasFunciones;
      this.horasDocencia = rFunciones.horasDocencia;
      this.horasTotales = rFunciones.horasTotales;
      this.horasRestantes = rFunciones.horasRestantes;
      this.horasMaxContrato = rFunciones.horasMaxContrato;

      this.FuncionesDocente = rFunciones.ActividadesFuncionesDocente;
    });
  }

  seleccionarDocenteLista(docente: Docente) {
    this.genService.navegar([RUTA_FACTOR_DOCENTES, RUTA_AGENDAS, this.paramTipoContrato, docente.iddocente]);
  }

  seleccionarDocente(docente: Docente) {

    if (this.paramIdDocente !== 'docente') {
      this.docenteSeleccionado = this.buscarDocenteByID(this.paramIdDocente);
    } else {
      this.soloCatedraticos = (this.tipoContrato === 'catedrático');
      this.docenteSeleccionado = docente;
    }

    this.leerAgendasServicio();
  }

  buscarDocenteByID(Id: string): Docente {
    console.log(this.Docentes);

    for (const docente of this.Docentes) {
      if (docente.iddocente === Id) {
        return docente;
      }
    }

   return this.Docentes[this.posDoc];
  }

  exportarAgenda() {
    this.genService.navegar([RUTA_FACTOR_DOCENTES, RUTA_EXPORTAR_AGENDA_DOCENTE, this.docenteSeleccionado.iddocente, this.periodo]);
  }

  guardarDatosAgenda() {
    const datosAgenda: AgendaServicio = {
      numerocontrato: this.numerocontrato,
      actafacultad: this.actaFacultad,
      actaprograma: this.actaPrograma,
      iddocente: this.docenteSeleccionado.iddocente,
      periodo: this.periodo,
      concertada: this.agendaConcertada,
      completada: this.agendaCompleta
    };

    const datos = JSON.stringify(datosAgenda);

    this.genService.putAgendaNumeroContrato(datos).subscribe((rRespuesta: any) => {

      this.dlgService.mostrarSnackBar(rRespuesta.Respuesta);
    });
  }

  agregarServicio() {
    this.dlgService.DlgAgendaServicio(this.docenteSeleccionado.iddocente, this.periodo).subscribe((rRespuesta: ServicioPrograma) => {

      if (rRespuesta !== undefined) {
        // %%%%%%% Guardar el Servicio %%%%%%%
        const agendaServicio: AgendaServicio = {
          idagendaservicio: new Utilidades().generarId(),
          idservicioprograma: rRespuesta.idservicioprograma,
          iddocente: this.docenteSeleccionado.iddocente,
          periodo: this.periodo
        };

        const datos = JSON.stringify(agendaServicio);

        this.genService.postAgendaServicio(datos).subscribe((rRespuesta2: any) => {

          this.leerAgendasServicio();
        });
      } else {
        this.leerAgendasServicio();
      }
    });
  }



  agregarFuncion() {
    this.dlgService.DlgFuncionesDocente('Crear', this.docenteSeleccionado.iddocente, '', this.periodo).subscribe((rRespuesta: any) => {

      this.leerActividadesFuncionesDocente();
    });
  }

  buscarDocente() {
    this.bDocentes = [];
    for (const docente of this.Docentes) {
      if (docente.nombre.toLowerCase().indexOf(this.termino.toLowerCase()) >= 0) {
        this.bDocentes.push(docente);
      }
    }
  }

  editarDocente(docente: Docente) {
    this.posDoc = this.Docentes.indexOf(this.docenteSeleccionado);
    this.dlgService.DlgDocente('Editar', docente.iddocente).subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar(rRespuesta);
      this.leerDocentes();
    });
  }

  editarFuncionDocente(funcion: ActividadFuncionDocente){
    this.dlgService.DlgFuncionesDocente('Editar', this.docenteSeleccionado.iddocente, funcion.idactividadprograma, this.periodo).subscribe((rRespuesta: any) => {

      this.leerActividadesFuncionesDocente();
    });
  }

  eliminarFuncionDocente(funcion: ActividadFuncionDocente){
    this.dlgService.confirmacion('¿Está seguro de eliminar esta función?').subscribe((rRespuesta: boolean) => {
      if (rRespuesta) {
        this.genService.deleteActividadFuncionDocente(funcion.idactividadprograma).subscribe((rRespuesta2: any) => {

          this.leerActividadesFuncionesDocente();
        });
      }
    });
  }

  editarServicioPrograma(IdServicio: string) {
    this.dlgService.DlgServicioPrograma('Editar', IdServicio).subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar(rRespuesta);
      this.seleccionarDocente(this.docenteSeleccionado);
    });
  }

  editarServicio(IdServicio: string) {
    this.genService.navegar([RUTA_FACTOR_DOCENTES, RUTA_SERVICIOPROGRAMA, IdServicio, RUTA_AGENDAS]);
  }

  cambiarPeriodo() {
    this.Opciones[0].Ruta[2] = this.periodo;
    this.Opciones[1].Ruta[2] = this.periodo;

    this.leerAgendasServicio();
  }

  abrirOpcion(ruta: string[]) {

    this.genService.navegar(ruta);
  }

  eliminarAgendaServicio(agenda: AgendaServicio) {
    this.genService.deleteAgendaServicio(agenda.idagendaservicio).subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar(rRespuesta.Respuesta || rRespuesta.Error);
      this.leerAgendasServicio();
    });
  }


}
