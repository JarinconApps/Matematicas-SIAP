import { Component, OnInit } from '@angular/core';
import { Afiliacion } from '../../../Interfaces/interfaces.interface';
import { GeneralService } from '../../../Servicios/general.service';
import { DialogService } from '../../../Servicios/dialog.service';

@Component({
  selector: 'app-afiliaciones',
  templateUrl: './afiliaciones.component.html',
  styles: []
})
export class AfiliacionesComponent implements OnInit {

  Afiliaciones: Afiliacion[] = [];
  leyendo = false;
  contIntentos = 1;

  constructor(private genService: GeneralService,
              private dlgService: DialogService) { }

  ngOnInit() {
    this.leerAfiliaciones();
  }

  leerAfiliaciones() {

    this.leyendo = true;

    this.genService.getTiposParticipacion().subscribe((rAfiliaciones: any) => {
      this.Afiliaciones = rAfiliaciones.Afiliaciones;
      this.leyendo = false;
    });
  }

  agregarAfiliacion() {
    this.dlgService.DlgAfiliacion('Crear', '').subscribe((rRespuesta: any) => {
      this.leerAfiliaciones();
    });
  }

  editarAfiliacion(afiliacion: Afiliacion) {
    this.dlgService.DlgAfiliacion('Editar', afiliacion.IdTipoParticipante).subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar('Información', rRespuesta);
      this.leerAfiliaciones();
    });
  }

  eliminarAfiliacion(afiliacion: Afiliacion) {
    this.dlgService.confirmacion('¿Está seguro de eliminar este Afiliacion?').subscribe((rConfirmacion: any) => {
      if (rConfirmacion) {
        this.genService.deleteAfiliacion(afiliacion.IdTipoParticipante).subscribe((rRespuesta: any) => {
          this.dlgService.mostrarSnackBar('Información', rRespuesta.Respuesta || rRespuesta.Error);
          this.leerAfiliaciones();
        });
      }
    });
  }

}
