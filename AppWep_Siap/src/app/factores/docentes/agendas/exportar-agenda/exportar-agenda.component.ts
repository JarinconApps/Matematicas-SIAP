import { GeneralService } from './../../../../services/general.service';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { TransferService } from '../../../../services/transfer.service';
import { Periodo, AgendaServicio, ActividadFuncionDocente, Docente, Configuracion } from '../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-exportar-agenda',
  templateUrl: './exportar-agenda.component.html',
  styles: []
})
export class ExportarAgendaComponent implements OnInit {

  IdDocente: string;
  Periodo: string;

  AgendasServicio: AgendaServicio[] = [];
  FuncionesDocente: ActividadFuncionDocente[] = [];

  docenciaDirecta = 0;
  horasRestantes = 0;
  horasTotales = 0;
  horasFunciones = 0;
  horasDocencia = 0;
  reconocimientoPosgrado = 0;
  horasSemanales = 0;
  horasSemestrales = 0;
  nombreContrato = '';
  observacion = '';
  horasMaxContrato = 0;

  leyendo = false;
  numerocontrato = '';

  configuracion: Configuracion = {
    nombredecano: '',
    nombredirector: ''
  };
  Configuraciones: Configuracion[] = [];

  docente: Docente = {};

  constructor(private activateRoute: ActivatedRoute,
              private transfer: TransferService,
              private genService: GeneralService) { }

  ngOnInit() {
    this.obtenerParametros();

    this.transfer.enviarTituloAplicacion('');

    // Obtener los datos del decano y del director
    this.genService.getConfiguraciones().subscribe((rConfiguraciones: any) => {
      this.Configuraciones = rConfiguraciones.Configuraciones;
      if (this.Configuraciones.length > 0) {
        this.configuracion = this.Configuraciones[0];
      }
    });
  }

  obtenerDocente() {
    this.genService.getDocente(this.IdDocente).subscribe((rDocente: any) => {
      this.docente = rDocente;
      this.nombreContrato = this.docente.contrato;

      document.title = 'SIAP (Agenda) - ' + this.docente.nombre.toUpperCase() + ' - (' + this.Periodo + ')';

      this.leerAgendasServicio();
    });
  }

  obtenerParametros() {
    this.activateRoute.params.subscribe((rParams: any) => {
      this.IdDocente = rParams.id;
      this.Periodo = rParams.periodo;

      this.obtenerDocente();
    });
  }

  leerAgendasServicio() {

    this.genService.getAgendasServicio(this.IdDocente, this.Periodo).subscribe((rAgendasServicio: any) => {


      this.AgendasServicio = rAgendasServicio.AgendasServicios;
      if (this.AgendasServicio.length > 0) {
        this.numerocontrato = this.AgendasServicio[0].numerocontrato;
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
    this.genService.getActividadesFuncionesDocente(this.IdDocente, this.Periodo).subscribe((rFunciones: any) => {

      this.horasFunciones = rFunciones.horasFunciones;
      this.horasDocencia = rFunciones.horasDocencia;
      this.horasTotales = rFunciones.horasTotales;
      this.horasRestantes = rFunciones.horasRestantes;
      this.horasMaxContrato = rFunciones.horasMaxContrato;

      this.FuncionesDocente = rFunciones.ActividadesFuncionesDocente;

      // window.print();
    });
  }


}
