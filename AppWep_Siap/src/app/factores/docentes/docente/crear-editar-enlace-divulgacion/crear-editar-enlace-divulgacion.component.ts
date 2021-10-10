import { Component, OnInit, Inject } from '@angular/core';
import { EnlaceDivulgacion, RespuestaCRUD } from '../../../../interfaces/interfaces.interfaces';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { GeneralService } from '../../../../services/general.service';

@Component({
  selector: 'app-crear-editar-enlace-divulgacion',
  templateUrl: './crear-editar-enlace-divulgacion.component.html',
  styles: []
})
export class CrearEditarEnlaceDivulgacionComponent implements OnInit {

  enlaceDivulgacion: EnlaceDivulgacion = {
    iddocente: '',
    iddivulgacion: '',
    nombre: '',
    direccion: ''
  };
  accion = 'Crear';

  enlaces: string[] = ['Cvlac', 'Orcid', 'Scopus', 'Google Académico', 'Mendeley', 'Research Gate'];

  constructor(public dialogRef: MatDialogRef<CrearEditarEnlaceDivulgacionComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    if (this.data.enlace !== null) {
      this.enlaceDivulgacion = this.data.enlace;
      this.accion = 'Editar';
    }

    this.enlaceDivulgacion.iddocente = this.data.iddocente;
  }

  guardar() {
    const datos = JSON.stringify(this.enlaceDivulgacion);

    if (this.accion === 'Crear') {
      this.genService.postEnlaceDivulgacion(datos).subscribe((rEnlace: RespuestaCRUD) => {
        this.dialogRef.close(rEnlace);
      });
    } else {
      this.genService.putEnlaceDivulgacion(datos).subscribe((rEnlace: RespuestaCRUD) => {
        this.dialogRef.close(rEnlace);
      });
    }
  }

}
