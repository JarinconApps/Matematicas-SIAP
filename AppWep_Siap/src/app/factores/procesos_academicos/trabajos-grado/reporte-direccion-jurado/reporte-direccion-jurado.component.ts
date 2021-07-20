import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../../../services/general.service';
import { Docente, ReporteDireccionJurado } from '../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-reporte-direccion-jurado',
  templateUrl: './reporte-direccion-jurado.component.html',
  styles: []
})
export class ReporteDireccionJuradoComponent implements OnInit {

  nombreDocente = '';
  bDocentes: Docente[] = [];
  Docentes: Docente[] = [];
  leyendo = false;
  leyendoTrabajos = false;

  docenteSeleccionado: Docente = null;
  TrabajosGrado: ReporteDireccionJurado = {
    Dirigidos: {
      Terminados: [],
      NoTerminados: []
    },
    Jurado: []
  };

  constructor(private genService: GeneralService) { }

  ngOnInit() {
    this.leerDocentes();
  }

  leerDocentes() {
    this.leyendo = true;
    this.genService.getDocentes('Nombre').subscribe((rDocentes: any) => {
      console.log(rDocentes);

      this.Docentes = rDocentes.Docentes;
      this.bDocentes = this.Docentes;
      this.leyendo = false;
    });
  }

  leerTrabajoGrado(docente: Docente) {
    this.docenteSeleccionado = docente;
    this.leyendoTrabajos = true;
    this.genService.getDireccionJuradoDocente(docente.iddocente).subscribe((rTrabajos: any) => {
      console.log(rTrabajos);
      this.TrabajosGrado = rTrabajos;
      this.leyendoTrabajos = false;
    });
  }

  eliminarFiltro() {
    this.nombreDocente = '';

    this.bDocentes = this.Docentes;
  }

  buscarDocente() {
    this.bDocentes = [];
    this.nombreDocente = this.nombreDocente.toLowerCase();

    for (const docente of this.Docentes) {
      if (docente.nombre.indexOf(this.nombreDocente) >= 0) {
        this.bDocentes.push(docente);
      }
    }
  }

}
