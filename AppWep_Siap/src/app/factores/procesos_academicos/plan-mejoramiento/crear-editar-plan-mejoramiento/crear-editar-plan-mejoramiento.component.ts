import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { PlanMejoramiento } from 'src/app/interfaces/interfaces.interfaces';
import { TransferService } from '../../../../services/transfer.service';
import { FactorCalidad, Requisito, TipoAccion, Fuente, PresupuestoPm, RespuestaCRUD } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';
import { RUTA_PLAN_MEJORAMIENTO, RUTA_INICIO } from '../../../../config/config';
import { DialogosService } from '../../../../services/dialogos.service';

@Component({
  selector: 'app-crear-editar-plan-mejoramiento',
  templateUrl: './crear-editar-plan-mejoramiento.component.html',
  styles: []
})
export class CrearEditarPlanMejoramientoComponent implements OnInit {

  planMejoramiento: PlanMejoramiento = {
    orden: 0,
    descripcion_mejora: '',
    causas_principales: '',
    metas: '',
    actividades: '',
    responsable_ejecucion: '',
    responsable_seguimiento: '',
    indicador_meta: '',
    formula_indicador: '',
    resultado_indicador: '',
    avance_meta: '',
    seguimiento: '',
    observaciones: '',
    estado_actual_accion: '',
    fecha_inicio: '1900-01-01',
    fecha_fin: '1900-01-01',
    presupuestos: []
  };

  FactoresCalidad: FactorCalidad[] = [];
  Requisitos: Requisito[] = [];
  TiposAccion: TipoAccion[] = [];
  Fuentes: Fuente[] = [];

  Accion = 'Crear';

  constructor(private activatedRoute: ActivatedRoute,
              private transfer: TransferService,
              private dlgService: DialogosService,
              public genService: GeneralService) { }

  ngOnInit() {
    this.obtenerParametros();

    this.obtenerFactoresCalidad();
    this.obtenerRequisitos();
    this.obtenerTiposAccion();
    this.obtenerFuentes();
  }

  obtenerParametros() {
    this.activatedRoute.params.subscribe((rParams: any) => {

      if (rParams.Id === 'crear') {
        this.transfer.enviarTituloAplicacion('Creando plan de mejoramiento ...');
        this.Accion = 'Crear';
      } else {
        this.transfer.enviarTituloAplicacion('Editando plan de mejoramiento ...');
        this.genService.getPlanMejoramiento(rParams.Id).subscribe((rPlan: PlanMejoramiento) => {

          this.planMejoramiento = rPlan;
          this.Accion = 'Editar';

          this.actualizarTotalPresupuesto();
        });
      }
    });
  }

  mostrar(e: any) {

  }

  obtenerFactoresCalidad() {
    this.genService.getFactoresCalidad().subscribe((rFactores: any) => {

      this.FactoresCalidad = rFactores.Factores;
    });
  }

  obtenerRequisitos() {
    this.genService.getRequisitos().subscribe((rRequisitos: any) => {

      this.Requisitos = rRequisitos.Requisitos;
    });
  }

  obtenerTiposAccion() {
    this.genService.getTiposAccion().subscribe((rTiposAccion: any) => {

      this.TiposAccion = rTiposAccion.TiposAccion;
    });
  }

  obtenerFuentes() {
    this.genService.getFuentes().subscribe((rFuentes: any) => {

      this.Fuentes = rFuentes.Fuentes;
    });
  }

  guardar() {
    const datos = JSON.stringify(this.planMejoramiento);

    if (this.Accion === 'Crear') {
      this.genService.postPlanMejoramiento(datos).subscribe((rResp: any) => {

        this.dlgService.mostrarSnackBar(rResp.Respuesta);
        this.genService.navegar([RUTA_PLAN_MEJORAMIENTO]);
      });
    } else {
      this.genService.putPlanMejoramiento(datos).subscribe((rResp: any) => {

        this.dlgService.mostrarSnackBar(rResp.Respuesta);
        this.genService.navegar([RUTA_PLAN_MEJORAMIENTO, RUTA_INICIO]);
      });
    }
  }

  obtenerPresupuestos() {
    this.genService.getPresupuestoPm(this.planMejoramiento.idplan).subscribe((rPresupuestos: RespuestaCRUD) => {

      this.planMejoramiento.presupuestos = rPresupuestos.Results;

      this.actualizarTotalPresupuesto();
    });
  }

  actualizarTotalPresupuesto() {
    let suma = 0;
    for (const presupuesto of this.planMejoramiento.presupuestos) {
      suma = suma + Number(presupuesto.valor);
    }
    this.planMejoramiento.totalPresupuesto = suma;
  }

  crearPresupuesto() {
    this.dlgService.crearEditarPresupuestoPm(null, this.planMejoramiento).subscribe((rPresupuesto: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rPresupuesto.Response);
      this.obtenerPresupuestos();
    });
  }

  editarPresupuesto(presupuesto: PresupuestoPm) {
    this.dlgService.crearEditarPresupuestoPm(presupuesto, this.planMejoramiento).subscribe((rPresupuesto: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rPresupuesto.Response);

      this.actualizarTotalPresupuesto();
    });
  }

  eliminarPresupuesto(presupuesto: PresupuestoPm) {
    this.dlgService.confirmacion('¿Está seguro de eliminar éste presupuesto?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deletePresupuestoPm(presupuesto.idpresupuesto).subscribe((rPresupuesto: RespuestaCRUD) => {
          this.dlgService.mostrarSnackBar(rPresupuesto.Response);
          this.obtenerPresupuestos();
        });
      }
    });
  }


}
