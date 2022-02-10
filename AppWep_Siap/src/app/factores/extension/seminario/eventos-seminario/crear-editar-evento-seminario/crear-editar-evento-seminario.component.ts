import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Seminario } from 'src/app/interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../../services/general.service';
import { RespuestaCRUD, AreaProfundizacion } from '../../../../../interfaces/interfaces.interfaces';

@Component({
  selector: 'app-crear-editar-evento-seminario',
  templateUrl: './crear-editar-evento-seminario.component.html',
  styles: []
})
export class CrearEditarEventoSeminarioComponent implements OnInit {

  evento: Seminario = {
    idseminario: '',
    semestre: '',
    numero: 0,
    fecha: '2020-08-20',
    conferencista: '',
    titulo: '',
    resumen: '',
    origen_conferencista: '',
    grupo_dependencia: '',
    pais_origen: '',
    area_profundizacion: '',
    modalidad: '',
    graduados: 0,
    estudiantes: 0,
    nacional: 0,
    internacional: 0,
    lugar: '',
    youtube: '',
    evidencias: '',
  };
  accion = 'Crear';

  semestre: string[] = [];
  modalidad: string[] = ['Presencial', 'Virtual'];
  areasProfundizacion: AreaProfundizacion[] = [];

  constructor(public dialogRef: MatDialogRef<CrearEditarEventoSeminarioComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              public genService: GeneralService) { }

  ngOnInit() {
    if (this.data.evento !== null) {
      this.evento = this.data.evento;
      this.accion = 'Editar';
    }

    const year = new Date().getFullYear();
    for (let i = 2010; i <= year; i++) {
      this.semestre.push(i + '-1');
      this.semestre.push(i + '-2');
    }

    this.obtenerAreasProfundizacion();
  }

  obtenerAreasProfundizacion() {
    this.genService.getAreasProfundizacion().subscribe((rAreas: any) => {

      this.areasProfundizacion = rAreas.AreasProfundizacion;
    });
  }

  guardar() {

    const datos = JSON.stringify(this.evento);

    if (this.accion === 'Crear') {
      this.genService.postSeminario(datos).subscribe((rEvento: RespuestaCRUD) => {
        this.dialogRef.close(rEvento);
      });
    } else {
      this.genService.putSeminario(datos).subscribe((rEvento: RespuestaCRUD) => {
        this.dialogRef.close(rEvento);
      });
    }
  }

}
