import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { GeneralService } from '../../Servicios/general.service';
import { Modalidad, RespuestaCRUD } from '../../Interfaces/interfaces.interface';

@Component({
  selector: 'app-ponencias',
  templateUrl: './ponencias.component.html',
  styles: []
})
export class PonenciasComponent implements OnInit {

  Conferencias: Modalidad[] = [];
  Ponencias: Modalidad[] = [];
  Contacto: any[] = [];

  constructor(private genService: GeneralService,
              private activatedRoute: ActivatedRoute) { }

  ngOnInit() {
    this.obtenerParametro();
    this.obtenerContacto();
  }

  obtenerParametro() {
    this.activatedRoute.params.subscribe((rParams: any) => {

      this.obtenerConferencias(rParams.IdEvento);
    });
  }

  obtenerConferencias(IdEvento: string) {

    this.genService.getConferenciasEMEM(IdEvento).subscribe((rConferencias: RespuestaCRUD) => {

      this.Conferencias = rConferencias.Results;

      this.obtenerPonencias(IdEvento);
    });
  }

  obtenerPonencias(IdEvento: string) {

    this.genService.getPonenciasEMEM(IdEvento).subscribe((rPonencias: RespuestaCRUD) => {

      this.Ponencias = rPonencias.Results;
    });
  }

  obtenerContacto() {
    this.genService.getContacto().subscribe((rContacto: any) => {

      this.Contacto = rContacto;
    });
  }

}
