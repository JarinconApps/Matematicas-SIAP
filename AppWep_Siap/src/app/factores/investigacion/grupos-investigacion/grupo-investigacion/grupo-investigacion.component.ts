import { Component, OnInit } from '@angular/core';
import { GrupoInvestigacion, RespuestaCRUD, Docente, GrupoDocente } from '../../../../interfaces/interfaces.interfaces';
import { ActivatedRoute } from '@angular/router';
import { GeneralService } from '../../../../services/general.service';
import { DialogosService } from '../../../../services/dialogos.service';
import { RUTA_FACTOR_DOCENTES, RUTA_DOCENTE } from '../../../../config/config';

@Component({
  selector: 'app-grupo-investigacion',
  templateUrl: './grupo-investigacion.component.html'
})
export class GrupoInvestigacionComponent implements OnInit {

  grupo: GrupoInvestigacion = {
    nombre: '',
    logo: '',
    director: {
      nombre: ''
    },
    mision: '',
    vision: '',
    idgrupoinvestigacion: ''
  };

  integrantes: Docente[] = [];

  constructor(private activatedRoute: ActivatedRoute,
              private genService: GeneralService,
              private dlgService: DialogosService) { }

  ngOnInit() {
    this.obtenerParametros();
  }

  obtenerParametros() {
    this.activatedRoute.params.subscribe((rParams: any) => {

      this.grupo.idgrupoinvestigacion = rParams.IdGrupo;

      this.obtenerGrupoInvestigacion();
      this.obtenerIntegrantes();
    });
  }

  obtenerGrupoInvestigacion() {
    this.genService.getGrupoInvestigacion(this.grupo.idgrupoinvestigacion).subscribe((rGrupo: RespuestaCRUD) => {

      this.grupo = rGrupo.Results[0];
    });
  }

  obtenerIntegrantes() {
    this.genService.getDocentesGrupoInvestigacion(this.grupo.idgrupoinvestigacion).subscribe((rDocentes: RespuestaCRUD) => {

      this.integrantes = rDocentes.Results;
    });
  }

  agregarDocente() {
    this.dlgService.SeleccionarDocente('Agregar Integrante', 'integrante-grupo').subscribe((rDocente: Docente) => {

      const integrante: GrupoDocente = {
        idgrupoinvestigacion: this.grupo.idgrupoinvestigacion,
        iddocente: rDocente.iddocente,
        fechaingreso: '2021-08-20'
      };
      const datos = JSON.stringify(integrante);
      this.genService.postGrupoInvestigacionDocente(datos).subscribe((rIntegrante: RespuestaCRUD) => {
        this.dlgService.mostrarSnackBar(rIntegrante.Response);

        this.obtenerIntegrantes();
      });
    });
  }

  verPerfilDocente(docente: Docente) {
    this.genService.navegar([RUTA_FACTOR_DOCENTES, RUTA_DOCENTE, docente.iddocente]);
  }

}
