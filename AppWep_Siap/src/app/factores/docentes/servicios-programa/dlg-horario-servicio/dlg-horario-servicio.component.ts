import { GeneralService } from './../../../../services/general.service';
import { Component, OnInit, Inject } from '@angular/core';
import { HorarioServicio } from '../../../../interfaces/interfaces.interfaces';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Utilidades } from '../../../../utilidades/utilidades.class';
import { SnackBarComponent } from '../../../../dialogos/snack-bar/snack-bar.component';

@Component({
  selector: 'app-dlg-horario-servicio',
  templateUrl: './dlg-horario-servicio.component.html',
  styles: []
})
export class DlgHorarioServicioComponent implements OnInit {


  horarioservicio: HorarioServicio = {
    dia: '',
    inicio: '',
    fin: '',
    idservicioprograma: '',
    salon: ''
  };

  accion: string;
  id: string;
  contIntentos = 0;
  guardando = false;
  leyendo = false;
  jornada = '';

  horario: string[] = ['7:00 a.m.', '8:00 a.m.', '9:00 a.m.', '10:00 a.m.', '11:00 a.m.', '12:00 p.m.', '1:00 p.m.', '2:00 p.m.', '3:00 p.m.',
  '4:00 p.m.', '5:00 p.m.', '6:00 p.m.', '7:00 p.m.', '8:00 p.m.', '9:00 p.m.', '10:00 p.m.'];
  horasIni: string[] = [];
  horasFin: string[] = [];
  dias: string[] = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];

  constructor(public dialogRef: MatDialogRef<DlgHorarioServicioComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService,
              private snackBar: MatSnackBar) { }

  ngOnInit() {

    this.accion = this.data.accion;
    this.id = this.data.idhorarioservicio;
    this.horarioservicio.idservicioprograma = this.data.idservicioprograma;
    this.jornada = this.data.jornada;

    this.horasIni = this.horario;
    this.horasFin = this.horario;

    if (this.accion === 'Editar') {
      this.leerHorarioServicio();
    }
  }

  leerHorarioServicio() {
    this.leyendo = true;
    this.genService.getHorarioServicio(this.id).subscribe((rHorarioServicio: HorarioServicio) => {

      this.horarioservicio = rHorarioServicio;
      this.leyendo = false;
    });
  }

  actualizarHoras() {
    const id = this.horario.indexOf(this.horarioservicio.inicio);
    this.horasFin = [];
    for (let i = id + 1; i < this.horario.length; i++) {
      this.horasFin.push(this.horario[i]);
    }
  }

  guardarHorarioServicio() {

    this.guardando = true;

    if (this.accion === 'Crear') {

      this.horarioservicio.idhorarioservicio = new Utilidades().generarId();

      const datos = JSON.stringify(this.horarioservicio);
      this.genService.postHorarioServicio(datos).subscribe((rRespuesta: any) => {

        return this.dialogRef.close(rRespuesta.Respuesta || rRespuesta.Error);
      });
    } else {
      const datos = JSON.stringify(this.horarioservicio);

      this.genService.putHorarioServicio(datos).subscribe((rRespuesta: any) => {

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
