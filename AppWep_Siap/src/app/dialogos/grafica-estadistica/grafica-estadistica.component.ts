import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ChartDataSets, ChartOptions, ChartType } from 'chart.js';
import { Label } from 'ng2-charts';
import { Estadisticas } from '../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-grafica-estadistica',
  templateUrl: './grafica-estadistica.component.html',
  styles: []
})
export class GraficaEstadisticaComponent implements OnInit {


  titulo = '';

  public opciones: ChartOptions = {
    responsive: true,
    scales: { xAxes: [{}], yAxes: [{}] },
    plugins: {
      datalabels: {
        anchor: 'end',
        align: 'end',
      }
    }
  };
  public tipo: ChartType = 'bar';
  public leyendas = true;

  public etiquetas: Label[] = ['2006', '2007', '2008', '2009', '2010', '2011', '2012'];
  public datos: ChartDataSets[] = [
    { data: [65, 59, 80, 81, 56, 55, 40], label: 'Series A' },
    { data: [28, 48, 40, 19, 86, 27, 90], label: 'Series B' }
  ];

  constructor(public dialogRef: MatDialogRef<GraficaEstadisticaComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
    this.tipo = this.data.tipo;
    this.etiquetas = this.data.etiquetas;
    this.datos = this.data.datos;
    this.titulo = this.data.titulo;
  }

}
