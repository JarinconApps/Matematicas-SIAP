import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { GeneralService } from '../../Servicios/general.service';
import { RespuestaCRUD, EventoEMEM } from '../../Interfaces/interfaces.interface';
import { RUTA_INICIO, RUTA_EVENTO, RUTA_MODALIDADES, RUTA_PONENCIAS_CONFERENCIAS, RUTA_PROGRAMACION, RUTA_CONTACTO, RUTA_CONCURSO, RUTA_INSCRIPCION } from '../../config/config';
import { TransferenciaService } from '../../Servicios/transferencia.service';

@Component({
  selector: 'app-evento',
  templateUrl: './evento.component.html',
  styles: []
})
export class EventoComponent implements OnInit {

  Evento: EventoEMEM = {
    Titulo: '',
    Descripcion: '',
    IdEvento: 'evento-2020'
  };

  constructor(private genService: GeneralService,
              private transfer: TransferenciaService) { }

  ngOnInit() {
    this.transfer.obtenerEventoEMEM.subscribe((rEvento: EventoEMEM) => {

      if (rEvento) {
        this.Evento = rEvento;
      }
    });
  }

  irInicio() {
    this.genService.navegar([RUTA_INICIO]);
  }

  irModalidades() {
    this.genService.navegar([RUTA_EVENTO, RUTA_MODALIDADES, this.Evento.IdEvento]);
  }

  irPonenciasConferencias() {
    this.genService.navegar([RUTA_EVENTO, RUTA_PONENCIAS_CONFERENCIAS, this.Evento.IdEvento]);
  }

  irProgramacion() {
    this.genService.navegar([RUTA_EVENTO, RUTA_PROGRAMACION, this.Evento.IdEvento]);
  }

  irContacto() {
    this.genService.navegar([RUTA_EVENTO, RUTA_CONTACTO, this.Evento.IdEvento]);
  }

  irConcurso() {
    this.genService.navegar([RUTA_EVENTO, RUTA_CONCURSO, this.Evento.IdEvento]);
  }

  irPreinscripciones() {
    this.genService.navegar([RUTA_EVENTO, RUTA_INSCRIPCION, this.Evento.IdEvento]);
  }

}
