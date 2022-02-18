import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../../services/general.service';
import { RespuestaCRUD, Periodo, Estudiante, Correo } from '../../../interfaces/interfaces.interfaces';
import { DialogosService } from '../../../services/dialogos.service';
import { restoreView } from '@angular/core/src/render3';

@Component({
  selector: 'app-coordinacion-practica-docente',
  templateUrl: './coordinacion-practica-docente.component.html',
  styles: []
})
export class CoordinacionPracticaDocenteComponent implements OnInit {

  periodos: Periodo[] = [];
  periodo: Periodo = {};
  estudiantes: Estudiante[] = [];
  enviando = false;

  constructor(private genService: GeneralService,
              private dlgService: DialogosService) { }

  ngOnInit() {

    this.leerSemestres();
    this.leerEstudiantes();
  }

  leerSemestres() {
    this.genService.getPeriodos().subscribe((rPeriodos: any) => {
      this.periodos = rPeriodos.Periodos;
      this.periodo = this.periodos[this.periodos.length - 1];
    });
  }

  leerEstudiantes() {
    this.genService.getEstudiantes().subscribe((rEstudiantes: RespuestaCRUD) => {
      this.estudiantes = rEstudiantes.Results;
    });
  }

  crearEstudiante() {
    this.dlgService.crearEditarEstudiante(null).subscribe((rEstudiante: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rEstudiante.Response);
      this.leerEstudiantes();
    });
  }

  ver(estudiante: Estudiante) {

  }

  enviarCorreo() {
    this.dlgService.enviarCorreoPractica().subscribe((rDatos: Correo) => {
      const correos: Estudiante[] = [];
      for (const estudiante of this.estudiantes) {
        if (estudiante.Seleccionado) {
          correos.push(estudiante);
        }
      }

      const datosCorreo = {
        Asunto: rDatos.asunto,
        Mensaje: rDatos.mensaje,
        Correos: JSON.stringify(correos)
      };

      const datos = JSON.stringify(datosCorreo);

      this.enviando = true;
      this.genService.postEnviarCorreoPractica(datos).subscribe((rCorreo: RespuestaCRUD) => {
        this.enviando = false;
        this.dlgService.mostrarSnackBar(rCorreo.Response);
      });
    });
  }

  editar(estudiante: Estudiante) {
    this.dlgService.crearEditarEstudiante(estudiante).subscribe((rEstudiante: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rEstudiante.Response);
      this.leerEstudiantes();
    });
  }

  eliminar(estudiante: Estudiante) {
    this.dlgService.confirmacion('¿Está seguro de eliminar éste estudiante?').subscribe((Resp: boolean) => {
      this.genService.deleteEstudiante(estudiante.IdEstudiante).subscribe((rEstudiante: RespuestaCRUD) => {
        this.dlgService.mostrarSnackBar(rEstudiante.Response);
        this.leerEstudiantes();
      });
    });
  }

  seleccionarTodos() {
    for (const estudiante of this.estudiantes) {
      estudiante.Seleccionado = true;
    }
  }

  obtenerListaCorreos() {
    this.dlgService.verListaCorreos(this.estudiantes);
  }

  estadisticasPractica() {
    this.dlgService.verEstadisticasPractica(this.periodo.idperiodo);
  }

}
