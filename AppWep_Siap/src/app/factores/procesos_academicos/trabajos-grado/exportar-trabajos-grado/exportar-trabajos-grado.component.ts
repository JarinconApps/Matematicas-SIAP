import { Component, OnInit, Inject } from '@angular/core';
import { TrabajoGrado, Paginacion } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-exportar-trabajos-grado',
  templateUrl: './exportar-trabajos-grado.component.html',
  styles: []
})
export class ExportarTrabajosGradoComponent implements OnInit {

  TrabajosGrado: TrabajoGrado[] = [];

  constructor(public dialogRef: MatDialogRef<ExportarTrabajosGradoComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
   this.TrabajosGrado = this.data.TrabajosGrado;
  }

}
