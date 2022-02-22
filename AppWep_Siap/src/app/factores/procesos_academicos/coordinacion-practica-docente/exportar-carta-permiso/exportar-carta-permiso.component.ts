import { Component, OnInit } from '@angular/core';
import { CartaPermiso, RespuestaCRUD } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-exportar-carta-permiso',
  templateUrl: './exportar-carta-permiso.component.html',
  styles: []
})
export class ExportarCartaPermisoComponent implements OnInit {

  carta: CartaPermiso = {};
  IdCarta = '';

  constructor(private genService: GeneralService,
              private activatedRoute: ActivatedRoute) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe((rParams: any) => {
      console.log(rParams);
      this.IdCarta = rParams.Id;

      this.obtenerCarta();
    });
  }

  obtenerCarta() {
    this.genService.getCartaPermiso(this.IdCarta).subscribe((rCarta: RespuestaCRUD) => {
      console.log(rCarta);
      this.carta = rCarta.Object;

      let titulo = '';
      for (const estudiante of this.carta.Estudiantes) {
        titulo = titulo + estudiante.Nombre + ' - ';
      }

      document.title = titulo;
    });
  }

}
