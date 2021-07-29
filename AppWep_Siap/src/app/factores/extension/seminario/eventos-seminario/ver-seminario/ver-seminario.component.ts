import { Component, OnInit, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Seminario } from '../../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-ver-seminario',
  templateUrl: './ver-seminario.component.html',
  styles: []
})
export class VerSeminarioComponent implements OnInit {

  seminario: Seminario = {

  };

  constructor(public dialogRef: MatDialogRef<VerSeminarioComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
    this.seminario = this.data.seminario;
  }

}
