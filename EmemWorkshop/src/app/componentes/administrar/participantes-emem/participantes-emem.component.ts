import { Component, OnInit } from '@angular/core';
import { ParticipanteEmem } from 'src/app/Interfaces/interfaces.interface';
import { GeneralService } from '../../../Servicios/general.service';
import { DialogService } from '../../../Servicios/dialog.service';

@Component({
  selector: 'app-participantes-emem',
  templateUrl: './participantes-emem.component.html',
  styles: []
})
export class ParticipantesEmemComponent implements OnInit {

  ParticipantesEmem: ParticipanteEmem[] = [];
  leyendo = false;
  contIntentos = 1;

  constructor(private genService: GeneralService,
              private dlgService: DialogService) { }

  ngOnInit() {
    this.leerParticipantesEmem();
  }

  leerParticipantesEmem() {

    this.leyendo = true;

    this.genService.getParticipantesEmem().subscribe((rParticipantesEmem: any) => {
      this.ParticipantesEmem = rParticipantesEmem.ParticipantesEmem;

      this.leyendo = false;
    });
  }

  agregarParticipanteEmem() {
    this.dlgService.DlgParticipanteEmem('Crear', '').subscribe((rRespuesta: any) => {

      this.leerParticipantesEmem();
    });
  }

  editarParticipanteEmem(participanteemem: ParticipanteEmem) {
    this.dlgService.DlgParticipanteEmem(participanteemem.IdParticipante).subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar('Información', rRespuesta);
      this.leerParticipantesEmem();
    });
  }

  eliminarParticipanteEmem(participanteemem: ParticipanteEmem) {
    this.dlgService.confirmacion('¿Está seguro de eliminar este ParticipanteEmem?').subscribe((rConfirmacion: any) => {
      if (rConfirmacion) {
        this.genService.deleteParticipanteEmem(participanteemem.IdParticipante).subscribe((rRespuesta: any) => {

          this.dlgService.mostrarSnackBar('Información', rRespuesta.Respuesta || rRespuesta.Error);
          this.leerParticipantesEmem();
        });
      }
    });
  }

}
