import { GeneralService } from './../../../../services/general.service';
import { Component, OnInit } from '@angular/core';
import { Programa, ReporteServicio, Periodo, EstadisticaPrograma } from '../../../../interfaces/interfaces.interfaces';
import { TransferService } from '../../../../services/transfer.service';
import { CapitalizadoPipe } from '../../../../pipes/capitalizado.pipe';
import { ChartType, ChartDataSets, ChartOptions } from 'chart.js';
import { Label } from 'ng2-charts';
import { Utilidades } from '../../../../utilidades/utilidades.class';

@Component({
  selector: 'app-efd-servicios-programa',
  templateUrl: './efd-servicios-programa.component.html',
  styles: []
})
export class EfdServiciosProgramaComponent implements OnInit {

  filtroProgrma = '';
  bProgramas: Programa[] = [];
  Programas: Programa[] = [];
  ReportesServicios: ReporteServicio[] = [];
  periodo = '2021-1';
  Periodos: Periodo[] = [];
  nombreDoc = '';
  nombreExcel = '';
  nombrePDF = '';

  vista: boolean[] = [true, false];

  public generalChartOptions: ChartOptions = {
    responsive: true,
    legend: {
      position: 'top',
    },
    plugins: {
      datalabels: {
        formatter: (value, ctx) => {
          const label = ctx.chart.data.labels[ctx.dataIndex];
          return label;
        },
      },
    }
  };

  public generalChartType: ChartType = 'bar';
  public generalChartLegend = true;
  public generalChartColors = [
    {
      backgroundColor: ['rgba(255,0,0,0.3)', 'rgba(0,255,0,0.3)', 'rgba(0,0,255,0.3)'],
    },
  ];

  public lbDatosGeneral: Label[] = ['2006', '2007', '2008', '2009', '2010', '2011', '2012'];
  public datosGeneral: ChartDataSets[] = [
    { data: [65, 59, 80, 81, 56, 55, 40], label: 'Series A' },
    { data: [28, 48, 40, 19, 86, 27, 90], label: 'Series B' }
  ];

  EstadisticasPrograma: EstadisticaPrograma[] = [];

  constructor(private genService: GeneralService,
              private transfer: TransferService) { }

  ngOnInit() {
    this.transfer.enviarTituloAplicacion('Reporte de Servicios por Programa');
    this.obtenerProgramas();

    this.obtenerAgendasPorPrograma();
  }

  obtenerReportePrograma(IdPrograma: string, periodo: string) {
    this.genService.getReporteProgramasServicios(IdPrograma, periodo).subscribe((rServicios: any) => {

      this.ReportesServicios = rServicios.Servicios;
    });
  }

  obtenerAgendasPorPrograma() {
    this.genService.getAgendasPorPrograma(this.periodo).subscribe((rEstadistica: any) => {
      this.EstadisticasPrograma = rEstadistica.Estadisticas;
      const datos: number[] = [];
      this.lbDatosGeneral = [];
      this.datosGeneral = [];
      const colores: string[] = [];

      for (const estd of this.EstadisticasPrograma) {
        datos.push(estd.Cantidad);
        this.lbDatosGeneral.push(estd.Programa);
        colores.push(new Utilidades().generarColor());
      }

      // Ordenar los datos de mayor a menor
      for (let i = 0; i < datos.length; i++) {
        for (let j = i; j < datos.length; j++) {
          if (Number(datos[i]) > Number(datos[j])) {
            const tempDato = datos[i];
            datos[i] = datos[j];
            datos[j] = tempDato;

            const tempEtiqueta = this.lbDatosGeneral[i];
            this.lbDatosGeneral[i] = this.lbDatosGeneral[j];
            this.lbDatosGeneral[j] = tempEtiqueta;
          }
        }
      }
      console.log('Todo ordendo');
      console.log(datos);

      this.datosGeneral.push({data: datos, label: 'Programas'});
      this.generalChartColors[0].backgroundColor = colores;
    });
  }

  borrarBusqueda() {
    this.filtroProgrma = '';
    this.bProgramas = this.Programas;
  }

  obtenerPeriodos() {
    this.genService.getPeriodos().subscribe((rPeriodos: any) => {
      this.Periodos = rPeriodos.Periodos;

      this.periodo = this.Periodos[this.Periodos.length - 1].periodo;
    });
  }

  obtenerProgramas() {
    this.genService.getProgramas().subscribe((rProgramas: any) => {

      this.Programas = rProgramas.Programas;
      this.bProgramas = this.Programas;

      this.obtenerPeriodos();
    });
  }

  buscarProgramas() {
    this.bProgramas = [];

    if (this.filtroProgrma.length === 0) {
      this.bProgramas = this.Programas;
      return;
    }

    for (const programa of this.Programas) {
      if (programa.programa.indexOf(this.filtroProgrma) > 0) {
        this.bProgramas.push(programa);
      }
    }
  }

  seleccionarPrograma(programa: Programa) {

    this.nombreDoc = 'Reporte de Servicios - ' + programa.programa.toUpperCase() + ' - (' + this.periodo + ').doc';
    this.nombreExcel = 'Reporte de Servicios - ' + programa.programa.toUpperCase() + ' - (' + this.periodo + ').xls';
    this.nombrePDF = 'Reporte de Servicios - ' + programa.programa.toUpperCase() + ' - (' + this.periodo + ').pdf';

    this.transfer.enviarTituloAplicacion('Reporte de Servicios por Programa (' + programa.programa.toUpperCase() + ')');
    this.obtenerReportePrograma(programa.idprograma, this.periodo);
  }

  cambiarOpciones() {
    const colores: string[] = [];
    for (const datos of this.datosGeneral[0].data) {
      colores.push(new Utilidades().generarColor());
    }
    this.generalChartColors = [{backgroundColor: colores}];

    if ((this.generalChartType === 'bar') || (this.generalChartType === 'line')) {
      this.generalChartOptions = {
        responsive: true,
        // We use these empty structures as placeholders for dynamic theming.
        scales: { xAxes: [{}], yAxes: [{}] },
        plugins: {
          datalabels: {
            anchor: 'end',
            align: 'end',
          }
        }
      };

    } else {
      this.generalChartOptions = {
        responsive: true,
        legend: {
          position: 'top',
        },
        plugins: {
          datalabels: {
            formatter: (value, ctx) => {
              const label = ctx.chart.data.labels[ctx.dataIndex];
              return label;
            },
          },
        }
      };
    }
  }

}
