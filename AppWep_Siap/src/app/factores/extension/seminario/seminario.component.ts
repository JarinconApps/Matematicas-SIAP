import { Component, OnInit } from '@angular/core';
import { Menu } from '../../../general/menu/menu.component';
import { RUTA_EVENTOS_SEMINARIO, RUTA_SEMINARIO } from '../../../config/config';
import { GeneralService } from '../../../services/general.service';
import { TransferService } from '../../../services/transfer.service';

@Component({
  selector: 'app-seminario',
  templateUrl: './seminario.component.html',
  styles: []
})
export class SeminarioComponent implements OnInit {

  Menus: Menu[] = [
    {
      nombre: 'Eventos realizados',
      ruta: RUTA_EVENTOS_SEMINARIO,
      imagen: 'assets/Iconos/pendiente.png',
      descripcion: 'Crear/Editar y visualiza los eventos realizados en el seminario del programa'
    }
  ];
  constructor(private genService: GeneralService,
              private transfer: TransferService) { }

  ngOnInit() {
    this.transfer.enviarTituloAplicacion('Seminario del programa');
  }

  irMenu(menu: Menu) {
    this.genService.navegar([RUTA_SEMINARIO, menu.ruta]);
  }

}
