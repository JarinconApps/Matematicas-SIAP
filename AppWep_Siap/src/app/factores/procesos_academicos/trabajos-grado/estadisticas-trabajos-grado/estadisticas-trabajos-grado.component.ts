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
  Ejemplo: Statistics;

  constructor(private genService: GeneralService) { }

  ngOnInit() {
    this.obtenerEstadisticas();

    this.Ejemplo = {
      Statistics: [{
        Label: 'Nombre',
        Count: 5,
        Percent: 20
      }],
      Labels: ['2008', '2009', '2010', '2011'],
      Data: [
        {
          data: [1, 2, 3, 4], label: '2008'
        },
        {
          data: [2, 5, 8, 9], label: '2009'
        }
      ]
    };
  }

  obtenerEstadisticas() {
    this.genService.getEstadisticasTrabajosGrado().subscribe((rEstadisticas: any) => {
      console.log(rEstadisticas);
      this.Estadisticas = rEstadisticas.Statistics;

      // Ordenar las estadísticas
      for (const est of this.Estadisticas) {
        if (est.Ordenar === 'Si') {

          /* for (let i = 0; i < est.Statistics.length; i++) {
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

                const tempDt = est.Data[0].data[i];
                est.Data[0].data[i] = est.Data[0].data[j];
                est.Data[0].data[j] = tempDt;
              }
            }
          } */
        }
      }
    });
  }

}
