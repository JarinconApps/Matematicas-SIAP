import { Component, OnInit } from '@angular/core';
import { Usuario, Noticia } from '../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../services/general.service';
import { Md5 } from 'ts-md5/dist/md5';
import { TransferService } from '../../services/transfer.service';
import { DialogosService } from '../../services/dialogos.service';
import { Router } from '@angular/router';
import { LS_USUARIO, LS_CLAVE, RUTA_FACTORES } from '../../config/config';

@Component({
  selector: 'app-inicio',
  templateUrl: './inicio.component.html',
  styles: []
})
export class InicioComponent implements OnInit {

  usuario: Usuario = {};
  noticias: Noticia[] = [];

  constructor(private genService: GeneralService,
              private transfer: TransferService,
              private dlgService: DialogosService,
              private router: Router) { }

  ngOnInit() {

  }


  // %%%%%%% Inciar Sesión %%%%%%%
  ingresar() {
    const datos =  JSON.stringify(this.usuario);
    this.genService.postLoginUsuario(datos).subscribe((RespLogin: any) => {

      if (RespLogin.Respuesta === 'Acceso-Correcto') {
        this.genService.navegar([RUTA_FACTORES]);
      } else {
        this.dlgService.mostrarSnackBar(RespLogin.Respuesta || RespLogin.Error);
      }
    });
  }

}
