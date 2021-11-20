import { Component, Input, OnChanges, OnInit, SimpleChange, SimpleChanges } from '@angular/core';
import { AngularEditorConfig } from '@kolkov/angular-editor';
import { ChartOptions, ChartType, ChartDataSets } from 'chart.js';
import { Label } from 'ng2-charts';
import { Utilidades } from '../../utilidades/utilidades.class';
import { CapitalizadoPipe } from '../../pipes/capitalizado.pipe';
import { Data } from '../../interfaces/interfaces.interfaces';
import * as pluginDataLabels from 'chartjs-plugin-datalabels';

@Component({
  selector: 'app-visor-grafica',
  templateUrl: './visor-grafica.component.html',
  styles: []
})
export class VisorGraficaComponent implements OnInit, OnChanges {

  @Input() Titulo = '';
  @Input() IdGrafica = '';

  public opciones: ChartOptions = {
    legend: {
      position: 'top'
    },
    responsive: true,
    scales: { xAxes: [], yAxes: [] },
    showLines: true,
    plugins: {
      datalabels: {
        formatter: (value, ctx) => {
          const label = value;
          return label;
        },
        anchor: 'end',
        align: 'end'
      },
    }
  };
  public tipo = 'bar';
  public subtipo = '';
  public leyendas = true;
  public tiposGrafica: string[] = ['line', 'bar', 'pie', 'doughnut', 'radar', 'polarArea', 'stacked'];
  public graficaPlugins = [pluginDataLabels];

  @Input() public Etiquetas: Label[] = ['2006', '2007', '2008', '2009', '2010', '2011', '2012'];
  @Input() public Datos: ChartDataSets[] = [
    { data: [65, 59, 80, 81, 56, 55, 40], label: 'Series A' },
    { data: [25, 19, 20, 51, 36, 35, 20], label: 'Series B' }
  ];
  public Colores = [
    {
      backgroundColor: ['rgba(255,0,0,0.3)', 'rgba(0,255,0,0.3)', 'rgba(0,0,255,0.3)']
    }
  ];

  capital = new CapitalizadoPipe();
  tipoOrden: string;

  constructor() { }


  ngOnChanges(changes: { [property: string]: SimpleChange }): void {
    console.log(changes.Etiquetas);
    this.Etiquetas = changes.Etiquetas.currentValue;

    for (let i = 0; i < this.Etiquetas.length; i++) {
      this.Etiquetas[i] = this.capital.transform(this.Etiquetas[i].toString());
    }
  }

  ngOnInit() {

    this.cambiarColores();
  }

  cambiarTipoGrafica() {

    this.subtipo = '';

    if ((this.tipo === 'line') || (this.tipo === 'bar')) {
      this.opciones = {
        legend: {
          position: 'top'
        },
        responsive: true,
        scales: { xAxes: [{}], yAxes: [{ticks: {beginAtZero: true}}] },
        showLines: true,
        plugins: {
          datalabels: {
            formatter: (value, ctx) => {
              const label = value;
              return label;
            },
            anchor: 'end',
            align: 'end'
          },
        }
      };
      this.cambiarColores();
      return;
    }

    if ((this.tipo === 'pie') || (this.tipo === 'doughnut') || (this.tipo === 'radar') || (this.tipo === 'polarArea')) {
      this.opciones = {
        responsive: true,
        legend: {
          position: 'top'
        },
        plugins: {
          datalabels: {
            formatter: (value, ctx) => {
              const label = ctx.chart.data.labels[ctx.dataIndex] + ' (' + value + ')';
              return label;
            },
            color: 'rgb(0,0,0)',
            font: {
              size: 12
            },
            anchor: 'center',
            align: 'end'
          },
        }
      };

      this.cambiarColores();
      return;
    }

    this.tipo = 'bar';
    this.subtipo = 'stacked';
    this.opciones = {
      legend: {
        position: 'top'
      },
      responsive: true,
      scales: { xAxes: [{stacked: true}], yAxes: [{ticks: {beginAtZero: true}, stacked: true}] },
      showLines: true,
      plugins: {
        datalabels: {
          formatter: (value, ctx) => {
            const label = value;
            return label;
          }
        },
      }
    };
    this.cambiarColores();
  }

  cambiarColores() {
    if (this.subtipo === 'stacked') {
      this.Colores = [];
      for (const etiqueta of this.Etiquetas) {

        const backgroundColor: string[] = [];
        this.Colores.push({backgroundColor});

        const selColor = new Utilidades().generarColor();
        for (let i = 1; i <= this.Datos[0].data.length; i++) {
          backgroundColor.push(selColor);
        }
      }
    } else {
      this.Colores = [];
      for (const etiqueta of this.Etiquetas) {

        const backgroundColor: string[] = [];
        this.Colores.push({backgroundColor});

        for (let i = 1; i <= this.Datos[0].data.length; i++) {
          backgroundColor.push(new Utilidades().generarColor());
        }
      }
    }


  }

  ordenar(value: string) {
    console.log(value);

    for (let i = 0; i < this.Etiquetas.length; i++ ) {
      for (let j = i; j < this.Etiquetas.length; j++ ) {

        const countI = Number(this.Datos[0].data[i]);
        const countJ = Number(this.Datos[0].data[j]);

        if (value === 'MenToMay') {
          if (countJ < countI) {
            const tempDt = this.Datos[0].data[i];
            this.Datos[0].data[i] = this.Datos[0].data[j];
            this.Datos[0].data[j] = tempDt;

            const tempLb = this.Etiquetas[i];
            this.Etiquetas[i] = this.Etiquetas[j];
            this.Etiquetas[j] = tempLb;
          }
        } else {
          if (countJ > countI) {
            const tempDt = this.Datos[0].data[i];
            this.Datos[0].data[i] = this.Datos[0].data[j];
            this.Datos[0].data[j] = tempDt;

            const tempLb = this.Etiquetas[i];
            this.Etiquetas[i] = this.Etiquetas[j];
            this.Etiquetas[j] = tempLb;
          }
        }
      }
    }
  }

  descargarGrafica() {

    const canvas: any = document.getElementById('canvas-' + this.IdGrafica);
    console.log(canvas);

    if (canvas.msToBlob) { // para internet explorer
      const blob = canvas.msToBlob();
      window.navigator.msSaveBlob(blob, this.Titulo + '.png' ); // la extensión de preferencia pon jpg o png
    } else {
      try {
        const link: any = document.getElementById(this.IdGrafica);
        link.href = canvas.toDataURL(); // Extensión .png ("image/png") --- Extension .jpg ("image/jpeg")
        link.download = this.Titulo;
      } catch {
        console.log('Errorcito');
      }
    }
  }

}
