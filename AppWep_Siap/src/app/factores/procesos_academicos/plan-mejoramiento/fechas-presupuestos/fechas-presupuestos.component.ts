import { Component, OnInit } from '@angular/core';
import { DialogosService } from '../../../../services/dialogos.service';
import { RespuestaCRUD, FechaPresupuestoPm } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';
import { TransferService } from '../../../../services/transfer.service';

@Component({
  selector: 'app-fechas-presupuestos',
  templateUrl: './fechas-presupuestos.component.html',
  styles: []
})
export class FechasPresupuestosComponent implements OnInit {

  Fechas: FechaPresupuestoPm[] = [];

  constructor(private dlgService: DialogosService,
              private genService: GeneralService,
              private transfer: TransferService) { }

  ngOnInit() {
    this.transfer.enviarTituloAplicacion('Fechas de Presupuestos de Plan de Mejoramiento');
    this.obtenerFechas();
  }

  obtenerFechas() {
    this.genService.getFechasPresupuestoPm().subscribe((rFechas: RespuestaCRUD) => {
      console.log(rFechas);
      this.Fechas = rFechas.Results;
    });
  }

  crearFecha() {
    this.dlgService.crearEditarFechaPresupuestoPm(null).subscribe((rFecha: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rFecha.Response);
      this.obtenerFechas();
    });
  }

  editarFecha(fecha: FechaPresupuestoPm) {
    this.dlgService.crearEditarFechaPresupuestoPm(fecha).subscribe((rFecha: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rFecha.Response);
      this.obtenerFechas();
    });
  }

  eliminarFecha(fecha: FechaPresupuestoPm) {
    this.dlgService.confirmacion('¿Está seguro de eliminar ésta fecha?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deleteFechaPresupuestoPm(fecha.idfecha).subscribe((rFecha: RespuestaCRUD) => {
          this.dlgService.mostrarSnackBar(rFecha.Response);
          this.obtenerFechas();
        });
      }
    });
  }

}
