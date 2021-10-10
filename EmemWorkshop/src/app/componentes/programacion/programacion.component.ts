import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../Servicios/general.service';
import { RespuestaCRUD, EventoEMEM } from '../../Interfaces/interfaces.interface';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-programacion',
  templateUrl: './programacion.component.html',
  styles: []
})
export class ProgramacionComponent implements OnInit {

  Programacion: any[] = [];
  Evento: EventoEMEM = {
    IdEvento: 'evento-2020'
  };

  constructor(private genService: GeneralService,
              private activatedRoute: ActivatedRoute) { }

  ngOnInit() {
    this.obtenerParametros();
  }

  obtenerParametros() {
    this.activatedRoute.params.subscribe((rParams: any) => {
      this.Evento.IdEvento = rParams.IdEvento;
      this.obtenerProgramacion();
    });
  }

  obtenerProgramacion() {
    this.genService.getCronogramaEMEM(this.Evento.IdEvento).subscribe((rProgramacion: RespuestaCRUD) => {

      this.Programacion = rProgramacion.Results;
    });
  }

}
