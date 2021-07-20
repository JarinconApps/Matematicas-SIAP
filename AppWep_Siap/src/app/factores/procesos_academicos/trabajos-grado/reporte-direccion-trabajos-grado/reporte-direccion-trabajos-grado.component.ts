import { Component, OnInit } from '@angular/core';
import { ReporteTrabajoGrado } from 'src/app/interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';
import { Docente } from '../../../../interfaces/interfaces.interfaces';
import { Menu } from '../../../../general/menu/menu.component';
import { Label } from 'ng2-charts';
import { ChartDataSets } from 'chart.js';
import { CapitalizadoPipe } from '../../../../pipes/capitalizado.pipe';

@Component({
  selector: 'app-reporte-direccion-trabajos-grado',
  templateUrl: './reporte-direccion-trabajos-grado.component.html',
  styles: []
})
export class ReporteDireccionTrabajosGradoComponent implements OnInit {

  ReportesTrabajosGrado: ReporteTrabajoGrado[] = [];
  bReportesTrabajosGrado: ReporteTrabajoGrado[] = [];
  TrabajosEvaluados: ReporteTrabajoGrado[] = [];
  bTrabajosEvaluados: ReporteTrabajoGrado[] = [];
  Directores: Docente[] = [];
  noDirectores: Docente[] = [];
  Evaluadores: Docente[] = [];
  noEvaluadores: Docente[] = [];

  Menus: Menu[] = [
    {
      nombre: 'Directores por Tipo de Contrato',
      descripcion: 'Muestra la lista de directores de trabajos de grado por tipo de contrato',
      ruta: 'directores-tipo-contrato'
    },
    {
      nombre: 'Docentes con Dirección de Trabajos de Grado',
      descripcion: 'Muestra la lista de docentes que estan y no dirigiendo trabajos de grado',
      ruta: 'directores-no-directores'
    },
    {
      nombre: 'Evaluadores de Trabajos de Grado por Tipo de Contrato',
      descripcion: 'Muestra la lista de docentes que estan evaluando trabajos de grado',
      ruta: 'evaluadores-tipo-contrato'
    },
    {
      nombre: 'Docentes con Evaluación de Trabajos de Grado',
      descripcion: 'Muestra la lista de docentes que estan y no evaluando trabajos de grado',
      ruta: 'evaluadores-no-evaluadores'
    },
    {
      nombre: 'Cantidad de trabajos de grado dirigidos por docente',
      descripcion: 'Muestra un gráfico de la cantidad de trabajos de grado dirigidos por docente',
      ruta: 'cantidad-de-trabajos'
    },
  ];

  Vistas: boolean[] = [
    true,  // directores por tipo de contrato
    false, // todos los directores y no directores
    false, // para los trabajos evaluados
    false, // todos los evaluadores y no evaluadores
    false // estadística trabajos
  ];

  public Etiquetas: Label[] = ['2006', '2007', '2008', '2009', '2010', '2011', '2012'];
  public Datos: ChartDataSets[] = [
    { data: [65, 59, 80, 81, 56, 55, 40], label: 'Series A' }
  ];

  tablaReporte: any[] = [];

  constructor(private genService: GeneralService) { }

  ngOnInit() {
    this.obtenerReporte();
  }

  verMenu(menu: Menu) {
    this.Vistas = [false, false, false, false, false];

    if (menu.ruta === 'directores-tipo-contrato') {
      this.Vistas[0] = true;
    }

    if (menu.ruta === 'directores-no-directores') {
      this.Vistas[1] = true;
    }

    if (menu.ruta === 'evaluadores-tipo-contrato') {
      this.Vistas[2] = true;
    }

    if (menu.ruta === 'evaluadores-no-evaluadores') {
      this.Vistas[3] = true;
    }

    if (menu.ruta === 'cantidad-de-trabajos') {
      this.Vistas[4] = true;
    }
  }

  obtenerReporte() {
    this.genService.getDirectoresTrabajosGrado().subscribe((rContratos: any) => {
      console.log(rContratos);
      this.ReportesTrabajosGrado = rContratos.Contratos;

      this.Directores = [];
      this.noDirectores = [];

      this.bReportesTrabajosGrado = [];
      this.Datos[0].data = [];
      this.Datos[0].label = 'Cantidad de Trabajos de Grado por Docente';
      this.Etiquetas = [];
      const datos: number[] = [];

      for (const contrato of this.ReportesTrabajosGrado) {
        for (const docente of contrato.Docentes ) {

          const trabajos = docente.Terminados.length + docente.noTerminados.length;
          if (trabajos > 0) {
            datos.push(trabajos);
            this.Etiquetas.push(new CapitalizadoPipe().transform(docente.nombre));

            this.tablaReporte.push({
              docente: docente.nombre,
              cantidad: trabajos
            });
          }

          if ((docente.Terminados.length === 0) && (docente.noTerminados.length === 0)) {
            this.noDirectores.push(docente);
          } else {
            if (docente.noTerminados.length === 0) {
              this.noDirectores.push(docente);
            } else {
              this.Directores.push(docente);
            }
          }
        }
      }

      // Ordenar de menor a mayor
      for (let i = 0; i < datos.length; i++) {
        for (let j = i; j < datos.length; j++) {
          if (datos[i] < datos[j]) {
            const tempDato = datos[i];
            datos[i] = datos[j];
            datos[j] = tempDato;

            const tempEtiqueta = this.Etiquetas[i];
            this.Etiquetas[i] = this.Etiquetas[j];
            this.Etiquetas[j] = tempEtiqueta;

            const tempDocente = this.tablaReporte[i];
            this.tablaReporte[i] = this.tablaReporte[j];
            this.tablaReporte[j] = tempDocente;
          }
        }
      }

      this.Datos[0].data = datos;
    });

    this.genService.getEvaluadoresTrabajosGrado().subscribe((rContratos: any) => {
      console.log(rContratos);
      this.TrabajosEvaluados = rContratos.Contratos;

      this.Evaluadores = [];
      this.noEvaluadores = [];

      for (const contrato of this.TrabajosEvaluados) {
        for (const docente of contrato.Docentes ) {
          if ((docente.Terminados.length === 0) && (docente.noTerminados.length === 0)) {
            this.noEvaluadores.push(docente);
          } else {
            if (docente.noTerminados.length === 0) {
              this.noEvaluadores.push(docente);
            } else {
              this.Evaluadores.push(docente);
            }
          }
        }
      }
    });
  }

  DirectoresPorTipoContrato() {

  }

}
