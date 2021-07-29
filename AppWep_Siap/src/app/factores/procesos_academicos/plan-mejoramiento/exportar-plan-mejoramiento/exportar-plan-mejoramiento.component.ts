import { Component, OnInit, Inject } from '@angular/core';
import { PlanMejoramiento, FechaPresupuestoPm, RespuestaCRUD } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-exportar-plan-mejoramiento',
  templateUrl: './exportar-plan-mejoramiento.component.html',
  styles: []
})
export class ExportarPlanMejoramientoComponent implements OnInit {

  planesMejoramiento: PlanMejoramiento[] = [];
  Fechas: FechaPresupuestoPm[] = [];

  constructor(public dialogRef: MatDialogRef<ExportarPlanMejoramientoComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    this.obtenerPlanesMejoramiento();
    this.obtenerFechas();
  }

  obtenerPlanesMejoramiento() {
    this.genService.getPlanesMejoramiento().subscribe((rPlanes: any) => {
      console.log(rPlanes);
      this.planesMejoramiento = rPlanes.Planes;

      this.calcularTotalPorFecha();
    });
  }

  obtenerFechas() {
    this.genService.getFechasPresupuestoPm().subscribe((rFechas: RespuestaCRUD) => {
      this.Fechas = rFechas.Results;
    });
  }

  calcularTotalPorFecha() {

    for (const fecha of this.Fechas) {
      fecha.total = 0;
    }

    for (const planMejoramiento of this.planesMejoramiento) {
      for (const fecha of planMejoramiento.fechas) {

        const id = planMejoramiento.fechas.indexOf(fecha);

        for (const presupuesto of fecha.presupuestos) {
          this.Fechas[id].total =  this.Fechas[id].total + Number(presupuesto.valor);
        }
      }
    }

    console.log(this.planesMejoramiento);
  }

}
