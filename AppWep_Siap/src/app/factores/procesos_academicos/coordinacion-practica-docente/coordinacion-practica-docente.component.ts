import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../../services/general.service';
import { RespuestaCRUD, Periodo, Estudiante, Correo } from '../../../interfaces/interfaces.interfaces';
import { DialogosService } from '../../../services/dialogos.service';
import { restoreView } from '@angular/core/src/render3';
import { Router } from '@angular/router';
import { RUTA_COORDINACION_PRACTICA_DOCENTE, RUTA_ESTUDIANTES_PRACTICA, RUTA_ESTADISTICAS_PRACTICA, RUTA_CARTAS_PERMISOS_PRACTICA, RUTA_REPORTE_ESTUDIANTES_PRACTICA_BY_SECRETARIA } from '../../../config/config';

@Component({
  selector: 'app-coordinacion-practica-docente',
  templateUrl: './coordinacion-practica-docente.component.html',
  styles: []
})
export class CoordinacionPracticaDocenteComponent implements OnInit {

  constructor(private router: Router,
              private genService: GeneralService,
              private dlgService: DialogosService) { }


  ngOnInit() {
  }

  verEstudiantesPractica() {
    this.router.navigate([RUTA_COORDINACION_PRACTICA_DOCENTE, RUTA_ESTUDIANTES_PRACTICA]);
  }

  verCorreosEstudiantes() {
    this.genService.getEstudiantes().subscribe((rEstudiantes: RespuestaCRUD) => {
      const estudiantes = rEstudiantes.Results;
      this.dlgService.verListaCorreos(estudiantes);
    });
  }

  verEstadisticasPractica() {
    this.router.navigate([RUTA_COORDINACION_PRACTICA_DOCENTE, RUTA_ESTADISTICAS_PRACTICA]);
  }

  verCartasPermisos() {
    this.router.navigate([RUTA_COORDINACION_PRACTICA_DOCENTE, RUTA_CARTAS_PERMISOS_PRACTICA]);
  }

  verReporteBySecretarias() {
    this.router.navigate([RUTA_COORDINACION_PRACTICA_DOCENTE, RUTA_REPORTE_ESTUDIANTES_PRACTICA_BY_SECRETARIA]);
  }

}
