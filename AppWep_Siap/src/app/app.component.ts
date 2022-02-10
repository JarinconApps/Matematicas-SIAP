import { Component } from '@angular/core';
import { GeneralService } from './services/general.service';
import { TransferService } from './services/transfer.service';
import { Router } from '@angular/router';
import { Concurrencia, RespuestaCRUD, Usuario } from './interfaces/interfaces.interfaces';
import { LS_USUARIO, LS_CLAVE, RUTA_INICIO } from './config/config';
import { Md5 } from 'ts-md5/dist/md5';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html'
})
export class AppComponent {

  constructor(private genService: GeneralService) {

    if (!localStorage.getItem('Usuario') && !localStorage.getItem('Token')) {

      localStorage.removeItem('Token');
      localStorage.removeItem('Usuario');
      localStorage.removeItem('ultima-ruta');
      genService.navegar([RUTA_INICIO]);

      return;
    }

    const Token = localStorage.getItem('Token').toString();
    genService.establecerToken(Token);

    genService.getValidarToken(Token).subscribe((rValidacion: RespuestaCRUD) => {

      if (rValidacion.Status === 'Incorrecto') {
        localStorage.removeItem('Token');
        localStorage.removeItem('Usuario');
        localStorage.removeItem('ultima-ruta');

        genService.navegar([RUTA_INICIO]);
      } else {
        const usuario: Usuario = JSON.parse(localStorage.getItem('Usuario'));
        genService.usuario = usuario;
        genService.establecerToken(Token);
      }
    });

  }
}
