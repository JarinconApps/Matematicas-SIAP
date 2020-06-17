import { GeneralService } from './../../../../services/general.service';
import { Component, OnInit, Inject } from '@angular/core';
import { TransferService } from '../../../../services/transfer.service';
import { DialogosService } from '../../../../services/dialogos.service';
import { ServicioPrograma } from '../../../../interfaces/interfaces.interfaces';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-dlg-agenda-servicio',
  templateUrl: './dlg-agenda-servicio.component.html',
  styles: []
})
export class DlgAgendaServicioComponent implements OnInit {

  leyendo = false;
  ordenarPor = 'programa';
  periodo = '';
  iddocente = '';
  ServiciosPrograma: ServicioPrograma[] = [];
  bServiciosPrograma: ServicioPrograma[] = [];

  terminoAsignatura = '';
  terminoPrograma = '';

  verServicios = '';

  constructor(public dialogRef: MatDialogRef<DlgAgendaServicioComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    this.periodo = this.data.periodo;
    this.iddocente = this.data.iddocente;

    this.leerServiciosPrograma();
  }

  mostrarServicios() {

    this.bServiciosPrograma = [];

    if (this.verServicios === 'Todas') {
      this.bServiciosPrograma = this.ServiciosPrograma;
      return;
    }

    for (const servicio of this.ServiciosPrograma) {
      if (servicio.observacion.length === 0) {
        this.bServiciosPrograma.push(servicio);
      }
    }
  }

  leerServiciosPrograma() {

    this.leyendo = true;

    this.genService.getServiciosProgramaDocente(this.iddocente, this.periodo).subscribe((rServiciosPrograma: any) => {
      this.ServiciosPrograma = rServiciosPrograma.ServiciosProgramas;
      this.bServiciosPrograma = this.ServiciosPrograma;
      console.log(this.ServiciosPrograma);
      this.leyendo = false;
    });
  }

  seleccionar(servicio: ServicioPrograma) {
    this.dialogRef.close(servicio);
  }

  buscarAsignatura() {
    this.bServiciosPrograma = [];
    const termino = this.terminoAsignatura.toLowerCase();

    for (const servicio of this.ServiciosPrograma) {
        const nombre = servicio.asignatura.toLowerCase();

        if (nombre.indexOf(termino) >= 0) {
          this.bServiciosPrograma.push(servicio);
        }
    }
  }

  buscarPrograma() {
    this.bServiciosPrograma = [];
    const termino = this.terminoPrograma.toLowerCase();

    for (const servicio of this.ServiciosPrograma) {
        const nombre = servicio.programa.toLowerCase();

        if (nombre.indexOf(termino) >= 0) {
          this.bServiciosPrograma.push(servicio);
        }
    }
  }

  borrarBusquedaAsignatura() {
    this.terminoAsignatura = '';
    this.bServiciosPrograma = this.ServiciosPrograma;
  }

  borrarBusquedaPrograma() {
    this.terminoPrograma = '';
    this.bServiciosPrograma = this.ServiciosPrograma;
  }


}
