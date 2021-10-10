import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

@Component({
  selector: 'app-ver-participante',
  templateUrl: './ver-participante.component.html',
  styles: []
})
export class VerParticipanteComponent implements OnInit {

  Participante: any = {};

  constructor(public dialogRef: MatDialogRef<VerParticipanteComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
    this.Participante = this.data.Participante;
  }

  cerrar() {
    this.dialogRef.close();
  }

}
