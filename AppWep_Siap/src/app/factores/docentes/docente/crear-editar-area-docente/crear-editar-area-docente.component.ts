import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AreaProfundizacion, RespuestaCRUD } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';

@Component({
  selector: 'app-crear-editar-area-docente',
  templateUrl: './crear-editar-area-docente.component.html',
  styles: []
})
export class CrearEditarAreaDocenteComponent implements OnInit {

  areaDocente: AreaProfundizacion = {
    iddocente: '',
    idareaprofundizacion: ''
  };

  areasProfundizacion: AreaProfundizacion[] = [];

  constructor(public dialogRef: MatDialogRef<CrearEditarAreaDocenteComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    this.leerAreasProfundizacion();

    this.areaDocente.iddocente = this.data.iddocente;
  }

  leerAreasProfundizacion() {
    this.genService.getAreasProfundizacion().subscribe((rAreas: any) => {

      this.areasProfundizacion = rAreas.AreasProfundizacion;
    });
  }

  guardar() {
    const datos = JSON.stringify(this.areaDocente);

    this.genService.postAreaDocente(datos).subscribe((rAreadocente: RespuestaCRUD) => {
      this.dialogRef.close(rAreadocente);
    });
  }

}
