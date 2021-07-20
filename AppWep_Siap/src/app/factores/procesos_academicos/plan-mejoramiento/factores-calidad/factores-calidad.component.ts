import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../../../services/general.service';
import { FactorCalidad, SubactividadDocente } from '../../../../interfaces/interfaces.interfaces';
import { TransferService } from '../../../../services/transfer.service';
import { DialogosService } from '../../../../services/dialogos.service';

@Component({
  selector: 'app-factores-calidad',
  templateUrl: './factores-calidad.component.html',
  styles: []
})
export class FactoresCalidadComponent implements OnInit {

  FactoresCalidad: FactorCalidad[] = [];
  leyendo = false;

  constructor(private genService: GeneralService,
              private transfer: TransferService,
              private dlgService: DialogosService) { }

  ngOnInit() {
    this.obtenerFactoresCalidad();
  }

  obtenerFactoresCalidad() {
    this.leyendo = true;
    this.genService.getFactoresCalidad().subscribe((rFactores: any) => {
      this.FactoresCalidad = rFactores.Factores;
      this.leyendo = false;
    });
  }

  agregarFactorCalidad() {
    this.dlgService.crearEditarFactorCalidad(null).subscribe((Resp: any) => {
      this.dlgService.mostrarSnackBar(Resp.Respuesta);

      this.obtenerFactoresCalidad();
    });
  }

  editarFactor(factor: FactorCalidad) {
    this.dlgService.crearEditarFactorCalidad(factor).subscribe((Resp: any) => {

      this.dlgService.mostrarSnackBar(Resp.Respuesta);
      this.obtenerFactoresCalidad();
    });
  }

  eliminarFactor(factor: FactorCalidad) {
    this.dlgService.confirmacion('¿Está seguro de eliminar éste factor?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deleteFactorCalidad(factor.idfactorcalidad).subscribe((rFactor: any) => {
          this.dlgService.mostrarSnackBar(rFactor.Respuesta);

          this.obtenerFactoresCalidad();
        });
      }
    });
  }

}
