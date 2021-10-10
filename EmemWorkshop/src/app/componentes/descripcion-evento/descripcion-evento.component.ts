import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { EventoEMEM, RespuestaCRUD } from '../../Interfaces/interfaces.interface';
import { GeneralService } from '../../Servicios/general.service';
import { TransferenciaService } from '../../Servicios/transferencia.service';

@Component({
  selector: 'app-descripcion-evento',
  templateUrl: './descripcion-evento.component.html',
  styles: []
})
export class DescripcionEventoComponent implements OnInit {

  Evento: EventoEMEM = {
    Titulo: '',
    Descripcion: '',
    IdEvento: 'evento-2020'
  };

  constructor(private genService: GeneralService,
              private activatedRoute: ActivatedRoute,
              private transfer: TransferenciaService) { }

  ngOnInit() {
    this.obtenerParametro();
  }

  obtenerParametro() {
    this.activatedRoute.params.subscribe((rParam: any) => {


      this.obtenerEvento(rParam.IdEvento);
    });
  }

  obtenerEvento(IdEvento: string) {
    this.genService.getEventoEMEM(IdEvento).subscribe((rEvento: RespuestaCRUD) => {

      this.Evento = rEvento.Results[0];

      this.transfer.enviarEvento(this.Evento);
    });
  }

}
