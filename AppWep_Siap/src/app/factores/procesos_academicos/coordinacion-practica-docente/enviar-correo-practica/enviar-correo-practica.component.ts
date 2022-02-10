import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Correo } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';

@Component({
  selector: 'app-enviar-correo-practica',
  templateUrl: './enviar-correo-practica.component.html',
  styles: []
})
export class EnviarCorreoPracticaComponent implements OnInit {

  correo: Correo = {
    asunto: '',
    mensaje: ''
  };

  constructor(public dialogRef: MatDialogRef<EnviarCorreoPracticaComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              public genService: GeneralService) { }

  ngOnInit() {
  }

  enviarCorreo() {
    this.dialogRef.close(this.correo);
  }

}
