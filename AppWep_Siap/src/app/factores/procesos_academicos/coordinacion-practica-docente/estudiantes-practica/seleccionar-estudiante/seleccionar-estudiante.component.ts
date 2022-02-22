import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { GeneralService } from '../../../../../services/general.service';
import { RespuestaCRUD, Estudiante } from '../../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-seleccionar-estudiante',
  templateUrl: './seleccionar-estudiante.component.html',
  styles: []
})
export class SeleccionarEstudianteComponent implements OnInit {

  IdPeriodo = '';
  estudiantes: Estudiante[] = [];

  constructor(public dialogRef: MatDialogRef<SeleccionarEstudianteComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    this.IdPeriodo = this.data.IdPeriodo;

    this.obtenerEstudiantes();
  }

  obtenerEstudiantes() {
    this.genService.getEstudiantesByPeriodo(this.IdPeriodo).subscribe((rEstudiantes: RespuestaCRUD) => {
      console.log(rEstudiantes);
      this.estudiantes = rEstudiantes.Results;
    });
  }

  seleccionarEstudiante(estudiante: Estudiante) {
    this.dialogRef.close(estudiante);
  }

}
