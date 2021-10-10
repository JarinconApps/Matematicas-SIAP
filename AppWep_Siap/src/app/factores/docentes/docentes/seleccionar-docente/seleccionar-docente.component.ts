import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA, MatDialog } from '@angular/material/dialog';
import { GeneralService } from '../../../../services/general.service';
import { Docente } from '../../../../interfaces/interfaces.interfaces';
import { DlgDocenteComponent } from '../dlg-docente/dlg-docente.component';
import { CrearDirectorJuradoComponent } from '../crear-director-jurado/crear-director-jurado.component';

@Component({
  selector: 'app-seleccionar-docente',
  templateUrl: './seleccionar-docente.component.html',
  styles: []
})
export class SeleccionarDocenteComponent implements OnInit {

  Docentes: Docente[] = [];
  bDocentes: Docente[] = [];
  leyendo = false;
  termino = '';

  tituloBoton = '';
  vinculacion = '';

  constructor(public dialogRef: MatDialogRef<SeleccionarDocenteComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService,
              public dialog: MatDialog) { }

  ngOnInit() {
    this.obtenerDocentes();

    this.vinculacion = this.data.vinculacion;
    this.tituloBoton = this.data.tituloBoton;
  }

  obtenerDocentes() {
    this.leyendo = true;
    this.genService.getDirectoresJurados().subscribe((RespDocentes: any) => {

      this.Docentes = RespDocentes.Docentes;
      this.bDocentes = this.Docentes;
      this.leyendo = false;
    });
  }

  seleccionar(docente: Docente) {

    this.dialogRef.close(docente);
  }

  buscar() {
    this.bDocentes = [];
    this.termino = this.termino.toLocaleLowerCase();
    for (const docente of this.Docentes) {
      if (docente.nombre.toLowerCase().indexOf(this.termino) >= 0) {
        this.bDocentes.push(docente);
      }
    }
  }

  agregarJuradoDirector() {
    const accion = 'Crear';
    const docente = null;

    const dialogRef = this.dialog.open(CrearDirectorJuradoComponent, {
      width: '60%',
      data: {accion, docente, tituloBoton: this.tituloBoton, vinculacion: this.vinculacion}
    });

    dialogRef.afterClosed().subscribe((rDocente: Docente) => {

      this.dialogRef.close(rDocente);
    });
  }

}
