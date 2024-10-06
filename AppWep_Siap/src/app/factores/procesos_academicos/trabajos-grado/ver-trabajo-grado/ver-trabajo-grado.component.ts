import { Component, OnDestroy, OnInit, Inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { TrabajoGrado, RespuestaCRUD } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-ver-trabajo-grado',
  templateUrl: './ver-trabajo-grado.component.html',
  styles: []
})
export class VerTrabajoGradoComponent implements OnInit {

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
    fechasustentacion: '2000-08-20',
    calificacionfinal: '',
    estudiantecedederechos: '',
    fechainicioejecucion: '2000-08-20',
    cantidadsemestresejecucion: {
      Dias: '',
      Meses: '0',
      Anos: '',
      Semestres: ''
    },
    estadoproyecto: ''
  };

  idtrabajogrado = '';
  leyendo = false;

  constructor(public dialogRef: MatDialogRef<VerTrabajoGradoComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    this.idtrabajogrado = this.data.trabajoGrado.idtrabajogrado;

    this.leyendo = true;
    this.genService.getTrabajoGrado(this.idtrabajogrado).subscribe((rTrabajoGrado: TrabajoGrado) => {
      console.log(rTrabajoGrado);
      this.trabajogrado = rTrabajoGrado;
      this.leyendo = false;
    });
  }

}
