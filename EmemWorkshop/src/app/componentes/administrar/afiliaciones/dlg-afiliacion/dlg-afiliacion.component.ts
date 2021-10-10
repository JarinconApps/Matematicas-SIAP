import { Component, Inject, OnInit } from '@angular/core';
import { SnackbarComponent } from '../../../../dialogos/snackbar/snackbar.component';
import { ConfirmacionComponent } from '../../../../dialogos/confirmacion/confirmacion.component';
import { Afiliacion } from '../../../../Interfaces/interfaces.interface';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { GeneralService } from '../../../../Servicios/general.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Utilidades } from '../../../../Utilidades/utilidades.class';

@Component({
  selector: 'app-dlg-afiliacion',
  templateUrl: './dlg-afiliacion.component.html',
  styles: []
})
export class DlgAfiliacionComponent implements OnInit {


  afiliacion: Afiliacion = {
    Nombre: ''
  };

  accion: string;
  id: string;
  contIntentos = 0;
  guardando = false;
  leyendo = false;

  constructor(public dialogRef: MatDialogRef<DlgAfiliacionComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService,
              private snackBar: MatSnackBar) { }

  ngOnInit() {
    this.accion = this.data.accion;
    this.id = this.data.idafiliacion;


    if (this.accion === 'Editar') {
      this.leerAfiliacion();
    }
  }

  leerAfiliacion() {
      this.genService.getAfiliacion(this.id).subscribe((rAfiliacion: Afiliacion) => {
        this.afiliacion = rAfiliacion;
      });
  }

  guardarAfiliacion() {

    this.guardando = true;

    if (this.accion === 'Crear') {

      this.afiliacion.IdTipoParticipante = new Utilidades().generarId();

      const datos = JSON.stringify(this.afiliacion);
      this.genService.postAfiliacion(datos).subscribe((rRespuesta: any) => {
        return this.dialogRef.close(rRespuesta.Respuesta || rRespuesta.Error);
      });
    } else {
      const datos = JSON.stringify(this.afiliacion);

      this.genService.putAfiliacion(datos).subscribe((rRespuesta: any) => {
        return this.dialogRef.close(rRespuesta.Respuesta || rRespuesta.Error);
      });
    }
  }

  mostrarSnackBar(titulo: string, msg: string) {
    this.snackBar.openFromComponent(ConfirmacionComponent, {
      data: {Titulo: titulo, Mensaje: msg}, duration: 5000
    });
  }

}
