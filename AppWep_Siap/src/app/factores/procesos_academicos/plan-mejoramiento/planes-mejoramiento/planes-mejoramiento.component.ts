import { Component, OnInit } from '@angular/core';
import { PlanMejoramiento } from '../../../../interfaces/interfaces.interfaces';
import { TransferService } from '../../../../services/transfer.service';
import { GeneralService } from '../../../../services/general.service';
import { DialogosService } from '../../../../services/dialogos.service';
import { RUTA_CREAR_EDITAR_PLAN_MEJORAMIENTO, RUTA_PLAN_MEJORAMIENTO } from '../../../../config/config';

@Component({
  selector: 'app-planes-mejoramiento',
  templateUrl: './planes-mejoramiento.component.html',
  styles: []
})
export class PlanesMejoramientoComponent implements OnInit {

  PlanesMejoramiento: PlanMejoramiento[] = [];
  leyendo = false;

  constructor(private transfer: TransferService,
              private genService: GeneralService,
              private dlgService: DialogosService) { }

  ngOnInit() {
    this.transfer.enviarTituloAplicacion('Plan de Mejoramiento');

    this.obtenerPlanesMejoramiento();
  }

  obtenerPlanesMejoramiento() {
    this.leyendo = true;
    this.genService.getPlanesMejoramiento().subscribe((rPlanes: any) => {

      this.PlanesMejoramiento = rPlanes.Planes;
      this.leyendo = false;
    });
  }

  agregarPlanMejoramiento() {
    this.genService.navegar([RUTA_PLAN_MEJORAMIENTO, RUTA_CREAR_EDITAR_PLAN_MEJORAMIENTO, 'crear']);
  }

  verPlan(plan: PlanMejoramiento) {
    this.dlgService.mostrarPlanMejoramiento(plan);
  }

  editarPlan(plan: PlanMejoramiento) {
    this.genService.navegar([RUTA_PLAN_MEJORAMIENTO, RUTA_CREAR_EDITAR_PLAN_MEJORAMIENTO, plan.idplan]);
  }

  eliminarPlan(plan: PlanMejoramiento) {
    this.dlgService.confirmacion('¿Está seguro de eliminar éste plan de mejoramiento?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deletePlanMejoramiento(plan.idplan).subscribe((rResp: any) => {
          this.dlgService.mostrarSnackBar(rResp.Respuesta);
          this.obtenerPlanesMejoramiento();
        });
      }
    });
  }

  exportarPlanMejoramiento() {
    this.dlgService.exportarPlanesMejoramiento();
  }

}
