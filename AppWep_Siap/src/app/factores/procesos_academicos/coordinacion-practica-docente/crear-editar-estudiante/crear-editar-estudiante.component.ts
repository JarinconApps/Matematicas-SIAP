import { Component, OnInit, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Estudiante, RespuestaCRUD } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';

@Component({
  selector: 'app-crear-editar-estudiante',
  templateUrl: './crear-editar-estudiante.component.html',
  styles: []
})
export class CrearEditarEstudianteComponent implements OnInit {

  estudiante: Estudiante = {
    Correo: '',
    Direccion: '',
    Documento: '',
    Eps: '',
    EstadoCivil: '',
    Genero: '',
    IdEstudiante: '',
    Municipio: '',
    Nombre: '',
    Semestre: '',
    Telefono: '',
    TipoDocumento: ''
  };

  EstadoCivil = [
    'Soltero(a)', 'Casado(a)', 'Unión libre', 'Viudo(a)', 'Divorciado(a)'
  ];

  accion = 'Crear';

  constructor(public dialogRef: MatDialogRef<CrearEditarEstudianteComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    if (this.data.estudiante !== null) {
      this.estudiante = this.data.estudiante;
      this.accion = 'Editar';
    }
  }

  guardar() {
    const datos = JSON.stringify(this.estudiante);

    if (this.accion === 'Crear') {
      this.genService.postEstudiante(datos).subscribe((rEstudiante: RespuestaCRUD) => {
        this.dialogRef.close(rEstudiante);
      });
    } else {
      this.genService.putEstudiante(datos).subscribe((rEstudiante: RespuestaCRUD) => {
        this.dialogRef.close(rEstudiante);
      });
    }
  }

}
