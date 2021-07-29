import { Component, OnInit, Inject } from '@angular/core';
import { FechaPresupuestoPm, RespuestaCRUD } from '../../../../../interfaces/interfaces.interfaces';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { GeneralService } from '../../../../../services/general.service';

@Component({
  selector: 'app-crear-editar-fecha',
  templateUrl: './crear-editar-fecha.component.html',
  styles: []
})
export class CrearEditarFechaComponent implements OnInit {

  fechaPresupuestoPm: FechaPresupuestoPm = {
    fecha: ''
  };

  accion = 'Crear';

  constructor(public dialogRef: MatDialogRef<CrearEditarFechaComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    if (this.data.fechaPresupuestoPm !== null) {
      this.fechaPresupuestoPm = this.data.fechaPresupuestoPm;
      this.accion = 'Editar';
    }
  }

  guardar() {
    const datos = JSON.stringify(this.fechaPresupuestoPm);

    if (this.accion === 'Crear') {
      this.genService.postFechaPresupuestoPm(datos).subscribe((rFecha: RespuestaCRUD) => {
        this.dialogRef.close(rFecha);
      });
    } else {
      this.genService.putFechaPresupuestoPm(datos).subscribe((rFecha: RespuestaCRUD) => {
        this.dialogRef.close(rFecha);
      });
    }
  }

}
