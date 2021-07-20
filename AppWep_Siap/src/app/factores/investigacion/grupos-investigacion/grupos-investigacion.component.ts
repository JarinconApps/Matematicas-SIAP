import { GeneralService } from './../../../services/general.service';
import { Component, OnInit } from '@angular/core';
import { GrupoInvestigacion, RespuestaCRUD } from '../../../interfaces/interfaces.interfaces';
import { DialogosService } from '../../../services/dialogos.service';
import { TransferService } from '../../../services/transfer.service';
import { RUTA_GRUPO_INVESTIGACION } from '../../../config/config';

@Component({
  selector: 'app-grupos-investigacion',
  templateUrl: './grupos-investigacion.component.html',
  styles: []
})
export class GruposInvestigacionComponent implements OnInit {

  GruposInvestigacion: GrupoInvestigacion[] = [];
  leyendo = false;
  contIntentos = 1;

  constructor(private genService: GeneralService,
              private dlgService: DialogosService,
              private transfer: TransferService) { }

  ngOnInit() {
    this.transfer.enviarTituloAplicacion('Grupos de Investigación');
    this.leerGruposInvestigacion();
  }

  leerGruposInvestigacion() {

    this.leyendo = true;

    this.genService.getGruposInvestigacion().subscribe((rGruposInvestigacion: RespuestaCRUD) => {
      console.log(rGruposInvestigacion);
      this.GruposInvestigacion = rGruposInvestigacion.Results;

      this.leyendo = false;
    });
  }

  agregarGrupoInvestigacion() {
    this.dlgService.DlgGrupoInvestigacion(null).subscribe((rRespuesta: any) => {

      this.leerGruposInvestigacion();
    });
  }

  editarGrupoInvestigacion(grupoinvestigacion: GrupoInvestigacion) {
    this.dlgService.DlgGrupoInvestigacion(grupoinvestigacion).subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar(rRespuesta);
      this.leerGruposInvestigacion();
    });
  }

  eliminarGrupoInvestigacion(grupoinvestigacion: GrupoInvestigacion) {
    this.dlgService.confirmacion('¿Está seguro de eliminar este GrupoInvestigacion?').subscribe((rConfirmacion: any) => {
      if (rConfirmacion) {
        this.genService.deleteGrupoInvestigacion(grupoinvestigacion.idgrupoinvestigacion).subscribe((rRespuesta: any) => {

          this.dlgService.mostrarSnackBar(rRespuesta.Respuesta || rRespuesta.Error);
          this.leerGruposInvestigacion();
        });
      }
    });
  }

  verPagina(grupo: GrupoInvestigacion) {
    this.genService.navegar([RUTA_GRUPO_INVESTIGACION, grupo.idgrupoinvestigacion]);
  }

}
