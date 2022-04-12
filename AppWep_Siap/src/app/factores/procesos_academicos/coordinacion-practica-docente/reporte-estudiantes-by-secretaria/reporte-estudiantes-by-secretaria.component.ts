import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../../../services/general.service';
import { Periodo, SecretariaPractica } from '../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-reporte-estudiantes-by-secretaria',
  templateUrl: './reporte-estudiantes-by-secretaria.component.html',
  styles: []
})
export class ReporteEstudiantesBySecretariaComponent implements OnInit {

  periodos: Periodo[] = [];
  periodo: Periodo = {};
  secretarias: SecretariaPractica[] = [];

  constructor(private genService: GeneralService) { }

  ngOnInit() {
    this.leerSemestres();
  }

  leerSemestres() {
    this.genService.getPeriodos().subscribe((rPeriodos: any) => {

      this.periodos = rPeriodos.Periodos;
      this.periodo = this.periodos[this.periodos.length - 1];

      this.obtenerReporte();
    });


  }

  obtenerReporte() {
    this.genService.getEstudiantesBySecretaria(this.periodo.idperiodo).subscribe((rSecretarias: any) => {
      this.secretarias = rSecretarias.Results;
    });
  }

}
