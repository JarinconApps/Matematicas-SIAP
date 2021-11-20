import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { GeneralService } from '../../../../Servicios/general.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ParticipanteEmem } from 'src/app/Interfaces/interfaces.interface';
import { Utilidades } from '../../../../Utilidades/utilidades.class';
import { SnackbarComponent } from '../../../../dialogos/snackbar/snackbar.component';
import { Afiliacion, RespuestaCRUD } from '../../../../Interfaces/interfaces.interface';

@Component({
  selector: 'app-dlg-participante-emem',
  templateUrl: './dlg-participante-emem.component.html',
  styles: []
})
export class DlgParticipanteEmemComponent implements OnInit {


  /* participanteEMEM: ParticipanteEmem = {
    Nombre: 'Julián Andrés Rincón Penagos',
    Correo: 'jarincon@uniquindio.edu.co',
    Institucion: 'Universidad del Quindío',
    Titulo: 'Magister en Ciencias de la Educación',
    TituloPonencia: 'Entorno para IA',
    Documento: '1098308059',
    IdEvento: '',
    IdTipoParticipante: ''
  }; */

  participanteEMEM: ParticipanteEmem = {
    Nombre: '',
    Correo: '',
    Institucion: '',
    Titulo: '',
    TituloPonencia: '',
    Documento: '',
    IdEvento: '',
    IdTipoParticipante: ''
  };

  TiposParticipantes: Afiliacion[] = [];


  guardando = false;

  constructor(public dialogRef: MatDialogRef<DlgParticipanteEmemComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService,
              private snackBar: MatSnackBar) { }

  ngOnInit() {


    this.participanteEMEM.IdEvento = this.data.IdEvento;
    this.leerTiposParticipacion();
  }

  leerTiposParticipacion() {
    this.genService.getTiposParticipacion().subscribe((rAfiliaciones: RespuestaCRUD) => {

      this.TiposParticipantes = rAfiliaciones.Results;
    });
  }

  guardarParticipanteEmem() {

    this.guardando = true;

    const datos = JSON.stringify(this.participanteEMEM);

    this.genService.postParticipanteEmem(datos).subscribe((rRespuesta: RespuestaCRUD) => {

      this.guardando = false;
      return this.dialogRef.close(rRespuesta.Response);
    });
  }

  cambioTipo(event: any) {

  }

}
