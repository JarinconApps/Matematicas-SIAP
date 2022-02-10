import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { PresupuestoPm, RespuestaCRUD, FechaPresupuestoPm } from '../../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../../services/general.service';

@Component({
  selector: 'app-crear-editar-presupuesto',
  templateUrl: './crear-editar-presupuesto.component.html',
  styles: []
})
export class CrearEditarPresupuestoComponent implements OnInit {

  presupuestoPm: PresupuestoPm = {
    idplan: '',
    idfecha: '',
    descripcion: '',
    valor: 0
  };

  accion = 'Crear';

  fechas: FechaPresupuestoPm[] = [];

  constructor(public dialogRef: MatDialogRef<CrearEditarPresupuestoComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              public genService: GeneralService) { }

  ngOnInit() {
    if (this.data.presupuestoPm !== null) {
      this.presupuestoPm = this.data.presupuestoPm;
      this.accion = 'Editar';
    }

    this.presupuestoPm.idplan = this.data.plan.idplan;

    this.obtenerFechas();
  }

  obtenerFechas() {
    this.genService.getFechasPresupuestoPm().subscribe((rFechas: RespuestaCRUD) => {
      this.fechas = rFechas.Results;
    });
  }

  guardar() {
    const datos = JSON.stringify(this.presupuestoPm);

    if (this.presupuestoPm.idfecha === '') {
      this.dialogRef.close({Response: 'Debe seleccionar una fecha'});
    }

    if (this.presupuestoPm.valor === 0) {
      this.dialogRef.close({Response: 'El valor no puede ser cero (0)'});
    }

    if (this.accion === 'Crear') {
      this.genService.postPresupuestoPm(datos).subscribe((rPresupuesto: RespuestaCRUD) => {
        this.dialogRef.close(rPresupuesto);
      });
    } else {
      this.genService.putPresupuestoPm(datos).subscribe((rPresupuesto: RespuestaCRUD) => {
        this.dialogRef.close(rPresupuesto);
      });
    }
  }

}
