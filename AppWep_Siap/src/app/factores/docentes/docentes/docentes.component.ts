import { GeneralService } from './../../../services/general.service';
import { Component, OnInit } from '@angular/core';
import { DialogosService } from '../../../services/dialogos.service';
import { Docente } from 'src/app/interfaces/interfaces.interfaces';
import { RUTA_FACTOR_DOCENTES, RUTA_DOCENTE } from '../../../config/config';
import { Utilidades } from '../../../utilidades/utilidades.class';
import { TransferService } from '../../../services/transfer.service';
import { TipoContrato, CategoriaDocente } from '../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-docentes',
  templateUrl: './docentes.component.html',
  styles: []
})
export class DocentesComponent implements OnInit {

  Docentes: Docente[] = [];
  bDocentes: Docente[] = [];
  leyendo = false;
  contIntentos = 1;

  tiposContrato: TipoContrato[] = [];
  Categorias: CategoriaDocente[] = [];

  ordenarPor = 'nombre';
  termino = '';
  tipoContrato = 'Todos';
  categoriaDocente = 'Todas';
  documento = '';
  docentesActivos = 'si';
  resultados = '';

  constructor(private genService: GeneralService,
              private dlgService: DialogosService,
              private transfer: TransferService) { }

  ngOnInit() {
    this.transfer.enviarTituloAplicacion('Docentes');
    this.leerDocentes();
    this.leerTiposContrato();
    this.leerCategorias();
  }

  contarResultados() {
    this.resultados = this.bDocentes.length.toString() + ' Resultados';
  }

  cambiarTipoOrden() {
    console.log(this.ordenarPor);
    this.leerDocentes();
  }

  leerTiposContrato() {
    this.genService.getTiposContrato().subscribe((rTiposContrato: any) => {
      this.tiposContrato = rTiposContrato.TiposContratos;

    });
  }

  leerCategorias() {
    this.genService.getCategoriasDocente().subscribe((rCategorias: any) => {
      this.Categorias = rCategorias.CategoriasDocentes;

    });
  }

  buscarPorTipoContrato() {
    if (this.tipoContrato !== 'Todos') {
      this.bDocentes = [];
      for (const docente of this.Docentes) {
        if (docente.contrato.toLowerCase().indexOf(this.tipoContrato.toLowerCase()) >= 0) {
          this.bDocentes.push(docente);
        }
      }
    } else {
      this.bDocentes = this.Docentes;
    }

    this.contarResultados();
  }

  buscarPorCategoria() {
    if (this.tipoContrato !== 'Todas') {
      this.bDocentes = [];
      for (const docente of this.Docentes) {
        if (docente.categoria.toLowerCase().indexOf(this.categoriaDocente.toLowerCase()) >= 0) {
          this.bDocentes.push(docente);
        }
      }
    } else {
      this.bDocentes = this.Docentes;
    }

    this.contarResultados();
  }

  buscarPorNombre() {
    this.bDocentes = [];
    const termBusq = this.termino.toLowerCase();

    for (const docente of this.Docentes) {
      if (docente.nombre.toLowerCase().indexOf(termBusq) >= 0) {
        this.bDocentes.push(docente);
      }
    }

    this.contarResultados();
  }

  buscarPorDocumento() {
    this.bDocentes = [];

    for (const docente of this.Docentes) {
      if (docente.documento.toLowerCase().indexOf(this.documento) >= 0) {
        this.bDocentes.push(docente);
      }
    }

    this.contarResultados();
  }

  leerDocentes() {

    this.leyendo = true;

    this.genService.getDocentes(this.ordenarPor).subscribe((rDocentes: any) => {
      console.log(rDocentes);
      this.Docentes = rDocentes.Docentes;

      this.seleccionarDocentesActivos();
      this.leyendo = false;
    });
  }

  seleccionarDocentesActivos() {
    this.bDocentes = [];
    for (const docente of this.Docentes) {
      if (docente.activo === this.docentesActivos) {
        this.bDocentes.push(docente);
      }
    }

    this.contarResultados();
  }

  agregarDocente() {
    this.dlgService.DlgDocente('Crear', '').subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar(rRespuesta);
      this.leerDocentes();
    });
  }

  verDocente(docente: Docente) {
    this.genService.navegar([RUTA_FACTOR_DOCENTES, RUTA_DOCENTE, docente.iddocente]);
  }

  editarDocente(docente: Docente) {
    this.dlgService.DlgDocente('Editar', docente.iddocente).subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar(rRespuesta);
      this.leerDocentes();
    });
  }

  eliminarDocente(docente: Docente) {
    this.dlgService.confirmacion('¿Está seguro de eliminar este Docente?').subscribe((rConfirmacion: any) => {
      if (rConfirmacion) {
        this.borrarDocente(docente.iddocente);
      }
    });
  }

  borrarDocente(id: string) {
    this.genService.deleteDocente(id).subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar(rRespuesta);
      this.dlgService.mostrarSnackBar(rRespuesta.Respuesta || rRespuesta.Error);
      this.leerDocentes();
    });
  }

}
