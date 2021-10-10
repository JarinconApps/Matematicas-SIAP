import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../Servicios/general.service';
import { RUTA_AFILIACIONES, RUTA_PARTICIPANTESEMEM } from '../../config/config';

@Component({
  selector: 'app-administrar',
  templateUrl: './administrar.component.html',
  styles: []
})
export class AdministrarComponent implements OnInit {

  Menus: any[] = [
    {Nombre: 'Afiliaciones',
     Descripcion: 'Crear/Editar las afiliaciones de los participantes',
     Imagen: 'assets/Iconos/Afiliacion.png',
     Ruta: RUTA_AFILIACIONES},
    {Nombre: 'Participantes',
     Descripcion: 'Crear/Editar participantes del Evento',
     Imagen: 'assets/Iconos/Participante.png',
     Ruta: RUTA_PARTICIPANTESEMEM}
  ];
  constructor(private genService: GeneralService) { }

  ngOnInit() {
  }

  verMenu(ruta: string) {
    this.genService.navegar(['administrar', ruta]);
  }

}
