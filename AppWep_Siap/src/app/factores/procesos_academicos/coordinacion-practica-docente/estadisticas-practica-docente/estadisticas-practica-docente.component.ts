import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { GeneralService } from '../../../../services/general.service';
import { RespuestaCRUD, EstudiantePractica } from '../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-estadisticas-practica-docente',
  templateUrl: './estadisticas-practica-docente.component.html',
  styles: []
})
export class EstadisticasPracticaDocenteComponent implements OnInit {

  IdPeriodo: string;
  EstudiantesPractica: EstudiantePractica[] = [];

  constructor(public dialogRef: MatDialogRef<EstadisticasPracticaDocenteComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    this.IdPeriodo = this.data.IdPeriodo;

    this.leerDatos();
  }

  leerDatos() {
    this.genService.getEstadisticasPeriodo(this.IdPeriodo).subscribe((rEstadisticas: RespuestaCRUD) => {
      console.log(rEstadisticas);
      this.EstudiantesPractica = rEstadisticas.Results;
    });
  }

  exportarTabla() {

  }

}
