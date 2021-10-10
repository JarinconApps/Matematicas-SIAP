import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../Servicios/general.service';
import { EventoEMEM, RespuestaCRUD } from '../../Interfaces/interfaces.interface';
import { RUTA_EVENTO, RUTA_DESCRIPCION } from '../../config/config';

@Component({
  selector: 'app-inicio',
  templateUrl: './inicio.component.html',
  styles: []
})
export class InicioComponent implements OnInit {

  Eventos: EventoEMEM[] = [];

  constructor(private genService: GeneralService) { }

  ngOnInit() {
    this.obtenerEventos();
  }

  obtenerEventos() {
    this.genService.getEventosEMEM().subscribe((rEventos: RespuestaCRUD) => {

      this.Eventos = rEventos.Results;
    });
  }

  verEvento(evento: EventoEMEM) {
    this.genService.navegar([RUTA_EVENTO, RUTA_DESCRIPCION, evento.IdEvento]);
  }

}
