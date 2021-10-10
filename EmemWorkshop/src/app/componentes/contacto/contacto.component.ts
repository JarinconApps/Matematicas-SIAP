import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../Servicios/general.service';
import { ActivatedRoute } from '@angular/router';
import { RespuestaCRUD } from '../../Interfaces/interfaces.interface';

@Component({
  selector: 'app-contacto',
  templateUrl: './contacto.component.html',
  styles: []
})
export class ContactoComponent implements OnInit {

  constructor(private genService: GeneralService,
              private activatedRoute: ActivatedRoute) { }

  Contactos: any[] = [];

  ngOnInit() {
    this.obtenerParametros();
  }

  obtenerParametros() {
    this.activatedRoute.params.subscribe((rParams: any) => {

      this.obtenerContacto(rParams.IdEvento);
    });
  }

  obtenerContacto(IdEvento: string) {
    this.genService.getOrganizadoresEvento(IdEvento).subscribe((rContacto: RespuestaCRUD) => {

      this.Contactos = rContacto.Results;
    });
  }

}
