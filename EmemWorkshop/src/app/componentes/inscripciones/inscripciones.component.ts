import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../Servicios/general.service';
import { ParticipanteEmem, RespuestaCRUD } from '../../Interfaces/interfaces.interface';
import { DialogService } from '../../Servicios/dialog.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-inscripciones',
  templateUrl: './inscripciones.component.html',
  styles: []
})
export class InscripcionesComponent implements OnInit {

  documento = '';
  token = '';
  IdEvento = '';

  mensajeInscripcion = '';

  constructor(private genService: GeneralService,
              private dlgService: DialogService,
              private actiatedRoute: ActivatedRoute) { }

  ngOnInit() {
    this.obtenerParametro();
  }

  obtenerParametro() {
    this.actiatedRoute.params.subscribe((rParams: any) => {
      this.IdEvento = rParams.IdEvento;
    });
  }

  buscarUsuario() {
    this.genService.getParticipanteEvento(this.documento, this.IdEvento).subscribe((rParticipante: any) => {

      this.dlgService.verParticipante(rParticipante);
    });
  }

  inscribirUsuario() {
    this.dlgService.DlgParticipanteEmem(this.IdEvento).subscribe((rInscripcion: any) => {

      this.dlgService.mostrarSnackBar('', rInscripcion);
      this.mensajeInscripcion = rInscripcion;
    });
  }

}
