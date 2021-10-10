import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { EventoEMEM, RespuestaCRUD } from '../../Interfaces/interfaces.interface';
import { GeneralService } from '../../Servicios/general.service';

@Component({
  selector: 'app-modalidades',
  templateUrl: './modalidades.component.html',
  styles: []
})
export class ModalidadesComponent implements OnInit {

  Evento: EventoEMEM = {
    Titulo: '',
    Descripcion: '',
    IdEvento: 'evento-2020'
  };

  constructor(private genService: GeneralService,
              private activatedRoute: ActivatedRoute) { }

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
    });
  }

}
