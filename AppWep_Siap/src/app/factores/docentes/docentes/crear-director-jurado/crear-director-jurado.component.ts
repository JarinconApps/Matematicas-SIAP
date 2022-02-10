import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { GeneralService } from '../../../../services/general.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { CategoriaDocente, TipoContrato, Docente } from '../../../../interfaces/interfaces.interfaces';
import { SnackBarComponent } from '../../../../dialogos/snack-bar/snack-bar.component';

@Component({
  selector: 'app-crear-director-jurado',
  templateUrl: './crear-director-jurado.component.html',
  styles: []
})
export class CrearDirectorJuradoComponent implements OnInit {

  docente: Docente = {
    documento: '',
    nombre: '',
    telefono: '',
    correo: '',
    activo: 'no',
    institucion: '',
    vinculacion: 'jurado',
    idcategoriadocente: 'jurado',
    idtipocontrato: 'jurado',
    contra: '',
    areaprofundizacion: '',
    foto: '',
    titulomayorformacion: '',
  };

  accion: string;
  id: string;
  contIntentos = 0;
  guardando = false;
  leyendo = false;

  tituloBoton = 'Agregar Jurado/Director';

  Categorias: CategoriaDocente[] = [];
  TiposContrato: TipoContrato[] = [];

  constructor(public dialogRef: MatDialogRef<CrearDirectorJuradoComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService,
              private snackBar: MatSnackBar) { }

  ngOnInit() {
    this.accion = this.data.accion;
    this.id = this.data.iddocente;

    if (this.data.vinculacion) {
      this.docente.vinculacion = this.data.vinculacion;
    }
    this.tituloBoton = this.data.tituloBoton;

    this.leerCategorias();
    this.leerTiposContrato();


    if (this.accion === 'Editar') {
      this.leerDocente();
    }
  }

  leerCategorias() {
    this.genService.getCategoriasDocente().subscribe((rCategorias: any) => {

      this.Categorias = rCategorias.CategoriasDocentes;
      this.docente.idcategoriadocente = this.Categorias[0].idcategoriadocente;
    });
  }

  leerTiposContrato() {
    this.genService.getTiposContrato().subscribe((rTiposContrato: any) => {

      this.TiposContrato = rTiposContrato.TiposContratos;
      this.docente.idtipocontrato = this.TiposContrato[0].idtipocontrato;
    });
  }

  leerDocente() {
    this.genService.getDocente(this.id).subscribe((rDocente: Docente) => {
      this.docente = rDocente;
    });
  }

  guardarDocente() {

    this.guardando = true;

    if (this.accion === 'Crear') {

      this.docente.iddocente = this.docente.documento;

      const datos = JSON.stringify(this.docente);
      this.genService.postDocente(datos).subscribe((rRespuesta: any) => {

        this.mostrarSnackBar(rRespuesta.Respuesta || rRespuesta.Error);
        return this.dialogRef.close(this.docente);
      });
    } else {

      const datos = JSON.stringify(this.docente);
      this.genService.putDocente(datos).subscribe((rRespuesta: any) => {
        this.mostrarSnackBar(rRespuesta.Respuesta || rRespuesta.Error);
        return this.dialogRef.close(this.docente);
      });
    }
  }

  mostrarSnackBar(msg: string) {
      this.snackBar.openFromComponent(SnackBarComponent, {
        data: {Titulo: 'SIAP dice ...', Mensaje: msg}, duration: 5000
      });
  }

}
