import { Component, OnInit, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { CartaPermiso, RespuestaCRUD, SecretariaPractica } from '../../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../../services/general.service';

@Component({
  selector: 'app-crear-editar-carta',
  templateUrl: './crear-editar-carta.component.html',
  styles: []
})
export class CrearEditarCartaComponent implements OnInit {

  IdPeriodo: string;
  accion = 'Crear';
  carta: CartaPermiso = {
    Rector: '',
    Institucion: '',
    Ciudad: 'Armenia, Quindío',
    Fecha: '',
    IdPeriodo: '',
    IdSecretaria: ''
  };

  secretarias: SecretariaPractica[] = [];

  constructor(public dialogRef: MatDialogRef<CrearEditarCartaComponent>,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private genService: GeneralService) { }

  ngOnInit() {
    this.IdPeriodo = this.data.IdPeriodo;

    if (this.data.carta !== null) {
      this.carta = this.data.carta;
      this.accion = 'Editar';
    }

    this.carta.IdPeriodo = this.IdPeriodo;

    this.genService.getSecretarias().subscribe((rSecretarias: RespuestaCRUD) => {
      this.secretarias = rSecretarias.Results;
    });
  }

  guardar() {
    const datos = JSON.stringify(this.carta);

    if (this.accion === 'Crear') {
      this.genService.postCartaPermiso(datos).subscribe((rCarta: RespuestaCRUD) => {
        this.dialogRef.close(rCarta);
      });
    } else {
      this.genService.putCartaPermiso(datos).subscribe((rCarta: RespuestaCRUD) => {
        this.dialogRef.close(rCarta);
      });
    }
  }

}
