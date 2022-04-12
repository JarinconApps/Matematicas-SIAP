import { GeneralService } from '../../../../services/general.service';
import { Component, OnInit, Inject } from '@angular/core';
import { TrabajoGrado, Docente, Modalidad, AreaProfundizacion, GrupoInvestigacion, ActaConsejoCurricular, RespuestaCRUD } from '../../../../interfaces/interfaces.interfaces';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Utilidades } from '../../../../utilidades/utilidades.class';
import { SnackBarComponent } from '../../../../dialogos/snack-bar/snack-bar.component';
import { ActivatedRoute } from '@angular/router';
import { DialogosService } from '../../../../services/dialogos.service';
import { SeleccionarDocenteComponent } from '../../../docentes/docentes/seleccionar-docente/seleccionar-docente.component';
import { RUTA_TRABAJOSGRADO } from '../../../../config/config';
import { BehaviorSubject } from 'rxjs';

@Component({
  selector: 'app-crear-editar-trabajo-grado',
  templateUrl: './crear-editar-trabajo-grado.component.html',
  styles: []
})
export class CrearEditarTrabajoGradoComponent implements OnInit {


   trabajogrado: TrabajoGrado = {
      titulo: '',
      idtrabajogrado: '',
      estudiante1: '',
      estudiante2: '',
      estudiante3: '',
      estudiante1_tm: 'no',
      estudiante2_tm: 'no',
      estudiante3_tm: 'no',
      idjurado1: '',
      jurado1: {nombre: ''},
      jurado2: {nombre: ''},
      jurado3: {nombre: ''},
      idjurado2: '',
      idjurado3: '',
      iddirector: '',
      director: {nombre: ''},
	    idcodirector: '',
      codirector: {nombre: ''},
      idmodalidad: '',
      modalidad: {nombre: ''},
      idareaprofundizacion: '',
      areaProfundizacion: {nombre: ''},
      idgrupoinvestigacion: '',
      grupoInvestigacion: {nombre: ''},
      actanombramientojurados: '',
      actapropuesta: '',
      evaluacionpropuesta: '',
	    evaluaciontrabajoescrito: '',
	    evaluacionsustentacion: '',
      fechasustentacion: '2020-08-20',
      calificacionfinal: '',
      estudiantecedederechos: '',
	    fechainicioejecucion: '2020-08-20',
	    cantidadsemestresejecucion: {
        Dias: '',
        Meses: '',
        Anos: '',
        Semestres: ''
      },
      estadoproyecto: ''
  };

  actanombramientojurados = '';
  jurado1 = '';
  jurado2 = '';
  jurado3 = '';
  director = '';
  codirector = '';

  accion: string;
  id: string;
  contIntentos = 0;
  guardando = false;
  leyendo = false;

  Modalidades: Modalidad[] = [];
  AreasProfundizacion: AreaProfundizacion[] = [];
  GruposInvestigacion: GrupoInvestigacion[] = [];

  verCamposEstudiantes: boolean[] = [true, false, false];
  estudiantes = 1;
  estadoLectura = 0;

  private bsLecturaTerminada = new BehaviorSubject<boolean>(false);
  public obtenerEstadoLectura = this.bsLecturaTerminada.asObservable();

  constructor(private genService: GeneralService,
              private snackBar: MatSnackBar,
              private activatedRoute: ActivatedRoute,
              private dlgService: DialogosService,
              public dialog: MatDialog) { }

  ngOnInit() {
    this.obtenerParametros();

    this.obtenerEstadoLectura.subscribe((rEstado: boolean) => {
      if (rEstado) {
        if (this.id !== 'Crear') {
          this.leerTrabajoGrado();
        }
      }
    });

    this.leerDocenteNoAplica();
  }

  obtenerParametros() {
    this.activatedRoute.params.subscribe((rParams: any) => {

      this.id = rParams.Id;

      this.leerModalidades();
      this.leerAreasProfundizacion();
      this.leerGruposInvestigacion();
    });
  }

  leerModalidades() {
    this.genService.getModalidades().subscribe((RespModalidades: any) => {

      this.Modalidades = RespModalidades.Modalidades;
      this.estadoLectura++;
      this.bsLecturaTerminada.next(this.estadoLectura === 3);
    });
  }

  leerAreasProfundizacion() {
    this.genService.getAreasProfundizacion().subscribe((RespAreasProfundizacion: any) => {

      this.AreasProfundizacion = RespAreasProfundizacion.AreasProfundizacion;
      this.estadoLectura++;
      this.bsLecturaTerminada.next(this.estadoLectura === 3);
    });
  }

  leerGruposInvestigacion() {
    this.genService.getGruposInvestigacion().subscribe((RespGruposInvestigacion: RespuestaCRUD) => {
      this.GruposInvestigacion = RespGruposInvestigacion.Results;
      this.estadoLectura++;
      this.bsLecturaTerminada.next(this.estadoLectura === 3);
    });
  }

  leerTrabajoGrado() {
    this.leyendo = true;
    this.genService.getTrabajoGrado(this.id).subscribe((rTrabajoGrado: TrabajoGrado) => {

      this.trabajogrado = rTrabajoGrado;
      this.verCamposEstudiantes[1] = this.trabajogrado.estudiante2.length > 0;
      this.verCamposEstudiantes[2] = this.trabajogrado.estudiante3.length > 0;
      this.leyendo = false;
    });
  }

  generarActa() {
    this.dlgService.mostrarAcc(this.trabajogrado.actanombramientojurados).subscribe((rActa: string) => {

      this.trabajogrado.actanombramientojurados = rActa;
      this.actanombramientojurados = rActa;
    });
  }

  guardarTrabajoGrado() {

    // Validación de Jurados, Director y Codirector
    if (!this.validarJurados_y_Director()) {
      this.dlgService.mostrarMensaje('Revise los jurados, director o codirector. No pueden tener varios roles en el trabajo de grado.', 'info');
      this.guardando = false;
      return;
    }

    // Validar que esten completos los tres jurados

    this.guardando = true;

    if (this.id === 'Crear') {

      this.trabajogrado.idtrabajogrado = new Utilidades().generarId();
      this.trabajogrado.jurado1 = {};
      this.trabajogrado.jurado2 = {};
      this.trabajogrado.jurado3 = {};
      this.trabajogrado.director = {};
      this.trabajogrado.codirector = {};
      this.trabajogrado.grupoInvestigacion = {};
      this.trabajogrado.modalidad = {};
      this.trabajogrado.areaProfundizacion = {};

      if (this.trabajogrado.idcodirector.length === 0) {
        this.trabajogrado.idcodirector = this.trabajogrado.iddirector;
      }

      // Validaciones de Campo
      if (this.trabajogrado.iddirector.length === 0) {
        this.dlgService.mostrarMensaje('Debe completar el campo del director del trabajo de grado', 'info');
        this.guardando = false;
        return;
      }

      if ((this.trabajogrado.idjurado1.length === 0) &&
          (this.trabajogrado.idjurado2.length === 0) &&
          (this.trabajogrado.idjurado3.length === 0)) {
        this.dlgService.mostrarMensaje('Debe completar los campos de los jurados', 'info');
        this.guardando = false;
        return;
      }

      if (this.trabajogrado.actanombramientojurados.length === 0) {
        this.dlgService.mostrarMensaje('Debe completar el campo de acta de nombramiento de jurados', 'info');
        this.guardando = false;
        return;
      }

      const datos = JSON.stringify(this.trabajogrado);
      this.genService.postTrabajoGrado(datos).subscribe((rRespuesta: any) => {
        this.dlgService.mostrarSnackBar(rRespuesta.Respuesta || rRespuesta.Error);
        this.genService.navegar([RUTA_TRABAJOSGRADO]);
      });
    } else {

      this.trabajogrado.jurado1 = {};
      this.trabajogrado.jurado2 = {};
      this.trabajogrado.jurado3 = {};
      this.trabajogrado.director = {};
      this.trabajogrado.codirector = {};
      this.trabajogrado.grupoInvestigacion = {};
      this.trabajogrado.modalidad = {};
      this.trabajogrado.areaProfundizacion = {};

      const datos = JSON.stringify(this.trabajogrado);
      this.genService.putTrabajoGrado(datos).subscribe((rRespuesta: any) => {

        this.guardando = false;
        this.dlgService.mostrarSnackBar(rRespuesta.Respuesta || rRespuesta.Error);
        this.genService.navegar([RUTA_TRABAJOSGRADO]);
      });
    }
  }

  mostrarSnackBar(titulo: string, msg: string) {
    this.snackBar.openFromComponent(SnackBarComponent, {
      data: {Titulo: titulo, Mensaje: msg}, duration: 5000
    });
  }

  leerDocenteNoAplica() {
    this.genService.getDocente('314159265').subscribe((rDocente: Docente) => {

      this.trabajogrado.idcodirector = rDocente.iddocente;
      this.trabajogrado.codirector = rDocente;
    });
  }

  SeleccionarDocente(nJurado: number) {

    const dialogRef = this.dialog.open(SeleccionarDocenteComponent, {
      width: '60%px', height: '600px',
      data: {vinculacion: 'evaluador'}
    });

    dialogRef.afterClosed().subscribe((RespDocente: Docente) => {

      if (RespDocente) {
        if (nJurado === 1) {
          this.trabajogrado.idjurado1 = RespDocente.iddocente;
          this.trabajogrado.jurado1 = RespDocente;
          this.jurado1 = this.trabajogrado.jurado1.nombre;
        }
        if (nJurado === 2) {
          this.trabajogrado.idjurado2 = RespDocente.iddocente;
          this.trabajogrado.jurado2 = RespDocente;
          this.jurado2 = this.trabajogrado.jurado2.nombre;
        }
        if (nJurado === 3) {
          this.trabajogrado.idjurado3 = RespDocente.iddocente;
          this.trabajogrado.jurado3 = RespDocente;
          this.jurado3 = this.trabajogrado.jurado3.nombre;
        }
        if (nJurado === 4) {
          this.trabajogrado.iddirector = RespDocente.iddocente;
          this.trabajogrado.director = RespDocente;
          this.director = this.trabajogrado.director.nombre;
        }
        if (nJurado === 5) {
          this.trabajogrado.idcodirector = RespDocente.iddocente;
          this.trabajogrado.codirector = RespDocente;
          this.codirector = this.trabajogrado.codirector.nombre;
        }
      }
    });
  }

  noEditar() {
    this.jurado1 = this.trabajogrado.jurado1.nombre;
    this.jurado2 = this.trabajogrado.jurado2.nombre;
    this.jurado3 = this.trabajogrado.jurado3.nombre;
    this.director = this.trabajogrado.director.nombre;
    this.codirector = this.trabajogrado.codirector.nombre;
    this.actanombramientojurados = this.trabajogrado.actanombramientojurados;
  }

  agregarEstudiante() {
    this.estudiantes++;
    if (this.estudiantes > 3) {
      this.estudiantes = 3;
    }

    for (let i = 0; i < this.estudiantes; i++) {
      this.verCamposEstudiantes[i] = true;
    }
  }

  validarJurados_y_Director(): boolean {
    let valido = true;
    valido = valido && (this.trabajogrado.iddirector !== this.trabajogrado.idcodirector)
                    && (this.trabajogrado.iddirector !== this.trabajogrado.idjurado1)
                    && (this.trabajogrado.iddirector !== this.trabajogrado.idjurado2)
                    && (this.trabajogrado.iddirector !== this.trabajogrado.idjurado3)
                    && (this.trabajogrado.idcodirector !== this.trabajogrado.idjurado1)
                    && (this.trabajogrado.idcodirector !== this.trabajogrado.idjurado2)
                    && (this.trabajogrado.idcodirector !== this.trabajogrado.idjurado3)
                    && (this.trabajogrado.idjurado1 !== this.trabajogrado.idjurado2)
                    && (this.trabajogrado.idjurado1 !== this.trabajogrado.idjurado3)
                    && (this.trabajogrado.idjurado2 !== this.trabajogrado.idjurado3);

    return valido;
  }

}
