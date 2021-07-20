import { Component, OnInit } from '@angular/core';
import { TransferService } from '../../../services/transfer.service';
import { GeneralService } from '../../../services/general.service';
import { RUTA_CREAR_EDITAR_PLAN_MEJORAMIENTO, RUTA_FACTORES_CALIDAD, RUTA_PLAN_MEJORAMIENTO } from '../../../config/config';
import { PlanMejoramiento } from '../../../interfaces/interfaces.interfaces';
import { DialogosService } from '../../../services/dialogos.service';
import { Menu } from '../../../general/menu/menu.component';

@Component({
  selector: 'app-plan-mejoramiento',
  templateUrl: './plan-mejoramiento.component.html',
  styles: []
})
export class PlanMejoramientoComponent implements OnInit {

  Menus: Menu[] = [
    {
      nombre: 'Crear factor de Calidad',
      ruta: RUTA_FACTORES_CALIDAD,
      descripcion: 'Muestra la lista de los factores de calidad para el plan de mejoramiento',
      imagen: 'assets/Iconos/pendiente.png'
    },
    {
      nombre: 'Ver oportunidades de mejora',
      ruta: RUTA_PLAN_MEJORAMIENTO  ,
      descripcion: 'Muestra la lista de los planes de mejoramiento',
      imagen: 'assets/Iconos/pendiente.png'
    }
  ];

  constructor(private genService: GeneralService) {

  }

  ngOnInit() {

  }

  abrirRuta(menu: Menu) {
    this.genService.navegar([RUTA_PLAN_MEJORAMIENTO, menu.ruta]);
  }

}
