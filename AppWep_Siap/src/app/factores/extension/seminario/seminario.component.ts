import { Component, OnInit } from '@angular/core';
import { Menu } from '../../../general/menu/menu.component';
import { RUTA_EVENTOS_SEMINARIO, RUTA_SEMINARIO, ACCION_ACTUALIZAR_NUMEROS_SEMINARIO } from '../../../config/config';
import { GeneralService } from '../../../services/general.service';
import { TransferService } from '../../../services/transfer.service';
import { RespuestaCRUD } from '../../../interfaces/interfaces.interfaces';
import { DialogosService } from '../../../services/dialogos.service';

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
    },
    {
      nombre: 'Actualizar números de cada evento',
      ruta: ACCION_ACTUALIZAR_NUMEROS_SEMINARIO,
      imagen: 'assets/Iconos/pendiente.png',
      descripcion: 'Ordena todos los eventos del seminario por la fecha y les reasigna un número según sea su posición ordenado por la fecha'
    }
  ];
  constructor(private genService: GeneralService,
              private transfer: TransferService,
              private dlgServide: DialogosService) { }

  ngOnInit() {
    this.transfer.enviarTituloAplicacion('Seminario del programa');
  }

  irMenu(menu: Menu) {

    if (menu.ruta === ACCION_ACTUALIZAR_NUMEROS_SEMINARIO) {
      this.genService.actualizarNumerosSeminarios().subscribe((rActualizacion: RespuestaCRUD) => {

        this.dlgServide.mostrarSnackBar(rActualizacion.Response);
      });
      return;
    }

    this.genService.navegar([RUTA_SEMINARIO, menu.ruta]);
  }

}
