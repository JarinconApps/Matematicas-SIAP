import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Estudiante } from '../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-ver-lista-correos',
  templateUrl: './ver-lista-correos.component.html',
  styles: []
})
export class VerListaCorreosComponent implements OnInit {

  estudiantes: Estudiante[] = [];
  listaEstudiantes = '';

  constructor(public dialogRef: MatDialogRef<VerListaCorreosComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
    this.estudiantes = this.data.estudiantes;

    for (const estudiante of this.estudiantes) {
      this.listaEstudiantes = this.listaEstudiantes + estudiante.Correo + ';'
    }
  }

  cerrar() {
    this.dialogRef.close();
  }

}
