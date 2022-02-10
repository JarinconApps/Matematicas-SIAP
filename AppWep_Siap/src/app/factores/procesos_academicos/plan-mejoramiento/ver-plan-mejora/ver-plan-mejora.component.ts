import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { PlanMejoramiento } from '../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-ver-plan-mejora',
  templateUrl: './ver-plan-mejora.component.html',
  styles: []
})
export class VerPlanMejoraComponent implements OnInit {

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
    estado_actual_accion: ''
  };

  constructor(public dialogRef: MatDialogRef<VerPlanMejoraComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
    this.planMejoramiento = this.data.planMejoramiento;

    let suma = 0;
    for (const presupuesto of this.planMejoramiento.presupuestos) {
      suma = suma + Number(presupuesto.valor);
    }
    this.planMejoramiento.totalPresupuesto = suma;
  }

}
