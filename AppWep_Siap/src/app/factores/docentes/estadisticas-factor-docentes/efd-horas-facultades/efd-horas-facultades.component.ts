import { GeneralService } from './../../../../services/general.service';
import { Component, OnInit } from '@angular/core';
import { ContratoEFD, Periodo, Contrato, Estadisticas, AfinidadContrato, AfinidadDocente, Docente } from '../../../../interfaces/interfaces.interfaces';
import { TransferService } from '../../../../services/transfer.service';
import { Label } from 'ng2-charts';
import { ChartDataSets, ChartOptions, ChartType } from 'chart.js';
import { DialogosService } from '../../../../services/dialogos.service';
import { Utilidades } from '../../../../utilidades/utilidades.class';

@Component({
  selector: 'app-efd-horas-facultades',
  templateUrl: './efd-horas-facultades.component.html',
  styles: []
})
export class EfdHorasFacultadesComponent implements OnInit {

  Contratos: ContratoEFD[] = [];
  leyendo = false;
  Periodos: Periodo[] = [];
  periodo = '';

  tabGraficas = false;
  tabReporteFacultad = false;
  tabAnalisisHoras = false;

  descripcionGeneral = '';
  tituloGeneral = '';

  MenusEstadisticas: any[] = [
    {
      Titulo: 'Horas de docencia sin factor por tipo de contrato',
      Descripcion: 'Esta gráfica muestra la distribución de horas de docencia sin factor por cada uno de los tipos de contrato',
      Tipo: 'hordoc-tipcon'
    },
    {
      Titulo: 'Distribución de horas en los ejes misionales',
      Descripcion: 'Esta gráfica muestra la distribución de horas totales de las tres categorias de tipo de contrato. El propósito es conocer como se distribuyen las horas en cada uno de los ejes misionales de la Universidad',
      Tipo: 'ejes-misionales'
    },
    {
      Titulo: 'Distribución de horas en los ejes misionales por tipo de contrato',
      Descripcion: 'Esta gráfica muestra la distribución de horas en las tres categorias de tipo de contrato. En ésta gráfica se conoce cómo se distribuyen las horas de cada uno de los ejes misionales en cada uno de los tipos de contrato.',
      Tipo: 'ejes-misionales-tipo-contrato'
    },
    {
      Titulo: 'Distribución de horas por facultad y tipo de contrato',
      Descripcion: 'Esta gráfica muestra la distribución de horas por cada una de las facultades y por los tres tipos de contrato.',
      Tipo: 'horas-por-facultad-contrato'
    }
  ];

  afinidadContratos: AfinidadContrato[] = [];

  nombreExcel = 'Reporte de Horas por Facultad (2021-1).xls';

  public barChartOptions: ChartOptions = {
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
  public barChartType: ChartType = 'bar';
  public barChartLegend = true;

  public lbFacultadesDocencia: Label[] = ['2006', '2007', '2008', '2009', '2010', '2011', '2012'];
  public datosFacultadesDocencia: ChartDataSets[] = [
    { data: [65, 59, 80, 81, 56, 55, 40], label: 'Series A' },
    { data: [28, 48, 40, 19, 86, 27, 90], label: 'Series B' }
  ];

  public lbEstadisticasFunciones: Label[] = ['2006', '2007', '2008', '2009', '2010', '2011', '2012'];
  public datosEstadisticasFunciones: ChartDataSets[] = [
    { data: [65, 59, 80, 81, 56, 55, 40], label: 'Series A' },
    { data: [28, 48, 40, 19, 86, 27, 90], label: 'Series B' }
  ];

  public pieChartOptions: ChartOptions = {
    responsive: true,
    legend: {
      position: 'left',
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

  public generalChartOptions: ChartOptions = {
    responsive: true,
    legend: {
      position: 'left',
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

  public pieChartType: ChartType = 'pie';
  public pieChartLegend = true;
  public pieChartColors = [
    {
      backgroundColor: ['rgba(255,0,0,0.3)', 'rgba(0,255,0,0.3)', 'rgba(0,0,255,0.3)'],
    },
  ];

  public generalChartType: ChartType = 'radar';
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

  constructor(private genService: GeneralService,
              private transfer: TransferService,
              private dlgService: DialogosService) { }

  ngOnInit() {

    this.transfer.enviarTituloAplicacion('Reporte de Horas por Facultad');
    // this.obtenerReporteHorasFacultad();
    this.obtenerPeriodos();
  }

  obtenerPeriodos() {
    this.genService.getPeriodos().subscribe((rPeriodos: any) => {

      this.Periodos = rPeriodos.Periodos;
      if (this.Periodos.length > 0) {
        this.periodo = this.Periodos[this.Periodos.length - 1].periodo;
        this.obtenerReporteHorasFacultad();
      }
    });
  }

  obtenerReporteHorasFacultad() {
    this.leyendo = true;
    this.genService.getReporteHorasFacultad(this.periodo).subscribe((rReporte: any) => {

      this.Contratos = rReporte.Contratos;

      this.cambiarPestana(this.Contratos[0]);

      // Formatear las gráficas
      this.generarGraficas();
      this.generarReporteAfinidad();

      this.leyendo = false;
    });
  }

  generarReporteAfinidad() {
    // Generar los colores
    const colores: string[] = [];
    for (const facultad of this.Contratos[0].Docentes[0].Facultades) {
      colores.push(facultad.Color);
    }
    this.pieChartColors = [{backgroundColor: colores}];

    this.afinidadContratos = [];

    for (const contrato of this.Contratos) {

      const aDocentes: AfinidadDocente[] = [];

      for (const docente of contrato.Docentes) {

        const totalHorasSinFactor = new Utilidades().StrToFloat(docente.totalHorasSinFactor);
        const aDocente: AfinidadDocente = {
          Docente: docente.Nombre,
          Etiquetas: [],
          Datos: []
        };

        for (const facultad of docente.Facultades) {

          const porc = Math.round(10000 * (Number(facultad.TotalHoras) / new Utilidades().StrToFloat(docente.totalHorasSinFactor))) / 100;

          aDocente.Etiquetas.push('( ' + porc + '% ) ' + facultad.Nombre);
          aDocente.Datos.push(porc);
        }

        aDocentes.push(aDocente);
      }

      this.afinidadContratos.push({Nombre: contrato.Contrato, Docentes: aDocentes});
    }

  }

  generarGraficas() {
    // Estadísticas de Facultades
    this.lbFacultadesDocencia = [];
    for (const facultad of this.Contratos[0].Facultades) {
      this.lbFacultadesDocencia.push(facultad.NombreCorto);
    }

    this.datosFacultadesDocencia = [];
    for (const contrato of this.Contratos) {
      const datos: number[] = [];
      for (const facultad of contrato.Facultades) {
        datos.push(Number(facultad.TotalHoras));
      }
      this.datosFacultadesDocencia.push({data: datos, label: contrato.Contrato.toUpperCase()});
    }

    // Estadísticas de Funciones
    this.lbEstadisticasFunciones = [];
    for (const estadistica of this.Contratos[0].Estadisticas) {
      this.lbEstadisticasFunciones.push(estadistica.Nombre);
    }

    this.datosEstadisticasFunciones = [];
    for (const contrato of this.Contratos) {
      const datos: number[] = [];
      for (const estadistica of contrato.Estadisticas) {
        datos.push(new Utilidades().StrToFloat(estadistica.Horas));
      }
      this.datosEstadisticasFunciones.push({data: datos, label: contrato.Contrato.toUpperCase()});
    }
  }

  crearGrafica(menuEst: any) {
    this.lbDatosGeneral = [];
    this.datosGeneral = [];

    this.tituloGeneral = menuEst.Titulo;
    this.descripcionGeneral = menuEst.Descripcion;

    // %%%%%%% Horas de Docencia Directa por Tipo de Contrato %%%%%%%
    if (menuEst.Tipo === 'hordoc-tipcon') {
      const datos: number[] = [];
      for (const contrato of this.Contratos) {
        datos.push(new Utilidades().StrToFloat(contrato.Estadisticas[0].Horas));
        this.lbDatosGeneral.push(contrato.Contrato.toUpperCase());
      }
      this.datosGeneral.push({data: datos, label: 'Horas de docencia sin factor'});
    }

    // %%%%%%% Número de Horas por ejes misionales %%%%%%%
    if (menuEst.Tipo === 'ejes-misionales') {
      const datos: number[] = [0, 0, 0, 0, 0];
      for (const contrato of this.Contratos) {
        datos[0] = datos[0] + new Utilidades().StrToFloat(contrato.Estadisticas[0].Horas);
        datos[1] = datos[1] + new Utilidades().StrToFloat(contrato.Estadisticas[1].Horas);
        datos[2] = datos[2] + new Utilidades().StrToFloat(contrato.Estadisticas[2].Horas);
        datos[3] = datos[3] + new Utilidades().StrToFloat(contrato.Estadisticas[3].Horas);
        datos[4] = datos[4] + new Utilidades().StrToFloat(contrato.Estadisticas[4].Horas);
      }

      for (const estadista of this.Contratos[0].Estadisticas) {
        this.lbDatosGeneral.push(estadista.Nombre);
      }
      this.datosGeneral.push({data: datos, label: menuEst.Titulo});
    }

    // %%%%%%% Número de Horas por ejes misionales por tipo de contrato %%%%%%%
    if (menuEst.Tipo === 'ejes-misionales-tipo-contrato') {

      for (const estadista of this.Contratos[0].Estadisticas) {
        this.lbDatosGeneral.push(estadista.Nombre);
      }

      for (const contrato of this.Contratos) {
        const datos: number[] = [];

        for (const estadistica of contrato.Estadisticas) {
          datos.push(new Utilidades().StrToFloat(estadistica.Horas));
        }

        this.datosGeneral.push({data: datos, label: contrato.Contrato.toUpperCase()});
      }
    }

    // %%%%%%% Horas por tipo de contrato por facultad %%%%%%%
    if (menuEst.Tipo === 'horas-por-facultad-contrato') {
      // Crear las etiquetas para las facultades
      for (const facultad of this.Contratos[0].Facultades) {
        this.lbDatosGeneral.push(facultad.NombreCorto);
      }

      // Datos de horas por cada contrato por cada facultad
      for (const contrato of this.Contratos) {
        const datos: number[] = [];

        for (const facultad of contrato.Facultades) {
          datos.push(Number(facultad.TotalHoras));
        }

        this.datosGeneral.push({data: datos, label: contrato.Contrato.toUpperCase()});
      }
    }
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

  Descargar() {

  }

  cambiarPestana(contrato: ContratoEFD) {
    for (const cont of this.Contratos) {
      cont.Activo = false;
    }
    contrato.Activo = true;

    this.tabGraficas = false;
    this.tabReporteFacultad = false;
  }

  cambiarOtraPestana(tipo: string) {
    for (const cont of this.Contratos) {
      cont.Activo = false;
    }

    this.tabGraficas = (tipo === 'graficos');
    this.tabReporteFacultad = (tipo === 'reporte-afinidad-facultad');
    this.tabAnalisisHoras = (tipo === 'analisis-horas');

    if (this.tabAnalisisHoras) {
      const menuEst: any = {Tipo: 'hordoc-tipcon'};
      this.crearGrafica(menuEst);
    }
  }

  verGrafica(nombre: string) {
    if (nombre === 'horas-facultades') {
      this.dlgService.mostrarGrafica(this.datosFacultadesDocencia, this.lbFacultadesDocencia, this.barChartType,
        'Cantidad de horas de prestación de servicios (Docencia si Factor) por facultad y tipo de contrato');
    }

    if (nombre === 'ejes-misionales') {
      this.dlgService.mostrarGrafica(this.datosEstadisticasFunciones, this.lbEstadisticasFunciones, this.barChartType,
        'Ejes misionales por tipo de contrato');
    }
  }

}
