import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-nuevos-cambios',
  templateUrl: './nuevos-cambios.component.html',
  styles: []
})
export class NuevosCambiosComponent implements OnInit {

  nuevosCambios = '';

  constructor(public dialogRef: MatDialogRef<NuevosCambiosComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
    this.nuevosCambios = this.data.nuevosCambios;
  }

  cerrar() {
    this.dialogRef.close();
  }

}
