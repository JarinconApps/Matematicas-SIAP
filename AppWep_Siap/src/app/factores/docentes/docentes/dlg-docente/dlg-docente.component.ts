import { GeneralService } from './../../../../services/general.service';
import { Component, OnInit, Inject } from '@angular/core';
import { SnackBarComponent } from '../../../../dialogos/snack-bar/snack-bar.component';
import { Utilidades } from '../../../../utilidades/utilidades.class';
import { Docente, CategoriaDocente } from 'src/app/interfaces/interfaces.interfaces';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TipoContrato } from '../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-dlg-docente',
  templateUrl: './dlg-docente.component.html',
  styles: []
})
export class DlgDocenteComponent implements OnInit {


  docente: Docente = {
    documento: '',
    nombre: '',
    telefono: '',
    correo: '',
    activo: 'si',
    institucion: '',
    vinculacion: 'docente',
    idcategoriadocente: '',
    idtipocontrato: '',
    foto: '',
    contra: '',
    areaprofundizacion: '',
    titulomayorformacion: ''
  };

  accion: string;
  id: string;
  contIntentos = 0;
  guardando = false;
  leyendo = false;

  Categorias: CategoriaDocente[] = [];
  TiposContrato: TipoContrato[] = [];

  constructor(public dialogRef: MatDialogRef<DlgDocenteComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService,
              private snackBar: MatSnackBar) { }

  ngOnInit() {
    this.accion = this.data.accion;
    this.id = this.data.iddocente;

    this.leerCategorias();
    this.leerTiposContrato();


    if (this.accion === 'Editar') {
      this.leerDocente();
    }
  }

  leerCategorias() {
    this.genService.getCategoriasDocente().subscribe((rCategorias: any) => {

      this.Categorias = rCategorias.CategoriasDocentes;
    });
  }

  leerTiposContrato() {
    this.genService.getTiposContrato().subscribe((rTiposContrato: any) => {

      this.TiposContrato = rTiposContrato.TiposContratos;
    });
  }

  leerDocente() {
    this.genService.getDocente(this.id).subscribe((rDocente: Docente) => {
      this.docente = rDocente;

    });
  }

  guardarDocente() {

    this.guardando = true;

    console.log(this.docente);

    if (this.accion === 'Crear') {

      this.docente.iddocente = this.docente.documento;
      const datos = JSON.stringify(this.docente);
      this.genService.postDocente(datos).subscribe((rRespuesta: any) => {

        return this.dialogRef.close(rRespuesta.Respuesta || rRespuesta.Error);
      });
    } else {

      const datos = JSON.stringify(this.docente);

      this.genService.putDocente(datos).subscribe((rRespuesta: any) => {

        return this.dialogRef.close(rRespuesta.Respuesta || rRespuesta.Error);
      });
    }
  }

  mostrarSnackBar(titulo: string, msg: string) {
    this.snackBar.openFromComponent(SnackBarComponent, {
      data: {Titulo: titulo, Mensaje: msg}, duration: 5000
    });
  }

}
