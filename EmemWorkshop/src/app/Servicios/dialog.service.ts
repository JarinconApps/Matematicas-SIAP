import { Injectable } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { DlgAfiliacionComponent } from '../componentes/administrar/afiliaciones/dlg-afiliacion/dlg-afiliacion.component';
import { SnackbarComponent } from '../dialogos/snackbar/snackbar.component';
import { ConfirmacionComponent } from '../dialogos/confirmacion/confirmacion.component';
import { DlgParticipanteEmemComponent } from '../componentes/administrar/participantes-emem/dlg-participante-emem/dlg-participante-emem.component';
import { ParticipanteEmem } from '../Interfaces/interfaces.interface';
import { VerParticipanteComponent } from '../componentes/inscripciones/ver-participante/ver-participante.component';

@Injectable({
  providedIn: 'root'
})
export class DialogService {

  constructor(public dialog: MatDialog,
              private snackBar: MatSnackBar) { }


  DlgAfiliacion(accion: string, idafiliacion: string) {
    const dialogRef = this.dialog.open(DlgAfiliacionComponent, {
      width: '60%',
      data: {accion, idafiliacion}
    });

    return dialogRef.afterClosed();
  }

  mostrarSnackBar(titulo: string, msg: string) {
    this.snackBar.openFromComponent(SnackbarComponent, {
      data: {Titulo: titulo, Mensaje: msg}, duration: 5000
    });
  }

  confirmacion(msg: string) {
    const dialogRef = this.dialog.open(ConfirmacionComponent, {
      width: '60%',
      data: {mensaje: msg}
    });

    return dialogRef.afterClosed();
  }

  DlgParticipanteEmem(IdEvento: string) {
    const dialogRef = this.dialog.open(DlgParticipanteEmemComponent, {
      width: '60%',
      data: {IdEvento}
    });

    return dialogRef.afterClosed();
  }

  verParticipante(Participante: any) {
    const dialogRef = this.dialog.open(VerParticipanteComponent, {
      width: '600px', height: '600px',
      data: {Participante}
    });

    return dialogRef.afterClosed();
  }
}
