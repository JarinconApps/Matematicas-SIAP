import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../../../services/general.service';
import { Label } from 'ng2-charts';
import { ChartDataSets } from 'chart.js';
import { Statistic, Statistics } from '../../../../interfaces/interfaces.interfaces';
import { count } from 'rxjs/operators';

@Component({
  selector: 'app-estadisticas-trabajos-grado',
  templateUrl: './estadisticas-trabajos-grado.component.html',
  styles: []
})
export class EstadisticasTrabajosGradoComponent implements OnInit {

  Estadisticas: Statistics[] = [];

  constructor(private genService: GeneralService) { }

  ngOnInit() {
    this.obtenerEstadisticas();
  }

  obtenerEstadisticas() {
    this.genService.getEstadisticasTrabajosGrado().subscribe((rEstadisticas: any) => {
      console.log(rEstadisticas);

      this.Estadisticas = rEstadisticas.Statistics;
      console.log(this.Estadisticas);

      // Ordenar las estadísticas
      for (const est of this.Estadisticas) {
        if (est.Ordenar === 'Si') {

          for (let i = 0; i < est.Statistics.length; i++) {
            for (let j = i; j < est.Statistics.length; j++) {

              const countI = Number(est.Statistics[i].Count);
              const countJ = Number(est.Statistics[j].Count);

              if (countJ < countI) {
                const tempSt = est.Statistics[i];
                est.Statistics[i] = est.Statistics[j];
                est.Statistics[j] = tempSt;

                const tempLb = est.Labels[i];
                est.Labels[i] = est.Labels[j];
                est.Labels[j] = tempLb;

                const tempDt = est.Data.data[i];
                est.Data.data[i] = est.Data.data[j];
                est.Data.data[j] = tempDt;
              }
            }
          }
        }
      }

      console.log(this.Estadisticas);
    });
  }

}
