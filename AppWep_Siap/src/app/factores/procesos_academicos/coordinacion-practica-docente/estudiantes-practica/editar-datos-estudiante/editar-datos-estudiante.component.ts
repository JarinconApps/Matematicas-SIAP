import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { GeneralService } from '../../../../../services/general.service';
import { RespuestaCRUD } from '../../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-editar-datos-estudiante',
  templateUrl: './editar-datos-estudiante.component.html',
  styles: []
})
export class EditarDatosEstudianteComponent implements OnInit {

  IdEstudianteCarta = '';

  constructor(public dialogRef: MatDialogRef<EditarDatosEstudianteComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    this.IdEstudianteCarta = this.data.IdEstudianteCarta;
  }

  guardar() {
    /* this.genService.putEstudianteCarta().subscribe((rEstudiante: RespuestaCRUD) => {
      console.log(rEstudiante);

    }); */
  }

}
