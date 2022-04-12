import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { GeneralService } from '../../../../services/general.service';
import { RespuestaCRUD, EstudiantePractica, Periodo } from '../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-estadisticas-practica-docente',
  templateUrl: './estadisticas-practica-docente.component.html',
  styles: []
})
export class EstadisticasPracticaDocenteComponent implements OnInit {

  periodos: Periodo[] = [];
  periodo: Periodo = {};
  EstudiantesPractica: EstudiantePractica[] = [];

  constructor(private genService: GeneralService) { }

  ngOnInit() {
    this.leerSemestres();
  }

  leerSemestres() {
    this.genService.getPeriodos().subscribe((rPeriodos: any) => {
      this.periodos = rPeriodos.Periodos;
      this.periodo = this.periodos[this.periodos.length - 1];

      this.leerDatos();
    });
  }

  leerDatos() {
    this.genService.getEstadisticasPeriodo(this.periodo.idperiodo).subscribe((rEstadisticas: RespuestaCRUD) => {
      this.EstudiantesPractica = rEstadisticas.Results;
    });
  }

  exportarTabla() {

  }

}
