import { Component, OnInit } from '@angular/core';
import { TransferenciaService } from '../../Servicios/transferencia.service';
import { Router } from '@angular/router';
import { GeneralService } from '../../Servicios/general.service';
import { RUTA_CONCURSO, RUTA_PONENCIAS_CONFERENCIAS, RUTA_PARTICIPANTESEMEM, RUTA_MODALIDADES, RUTA_INSCRIPCION, RUTA_INICIO, RUTA_CONTACTO, RUTA_PROGRAMACION } from '../../config/config';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styles: []
})
export class HeaderComponent implements OnInit {

  nombreUsuario = '';
  mostrarUsuario = false;
  esAdministrador = false;

  _RUTA_CONCURSO = RUTA_CONCURSO;
  _RUTA_PONENCIAS_CONFERENCIAS = RUTA_PONENCIAS_CONFERENCIAS;
  _RUTA_PARTICIPANTESEMEM = RUTA_PARTICIPANTESEMEM;
  _RUTA_MODALIDADES = RUTA_MODALIDADES;
  _RUTA_INSCRIPCION = RUTA_INSCRIPCION;
  _RUTA_INICIO = RUTA_INICIO;
  _RUTA_CONTACTO = RUTA_CONTACTO;
  _RUTA_PROGRAMACION = RUTA_PROGRAMACION;

  constructor(private router: Router,
              private transferencia: TransferenciaService,
              private genService: GeneralService) { }


  ngOnInit() {
    this.transferencia.obtenerMuestraUsuario.subscribe((rMuestraUsuario: boolean) => {
      this.mostrarUsuario = rMuestraUsuario;
    });

    this.transferencia.obtenerPermisoAdministrador.subscribe((rEsAdministrador: boolean) => {
      this.esAdministrador = rEsAdministrador;
    });

    this.transferencia.obtenerNombreUsuario.subscribe((rNombreUsuario: string) => {
      this.nombreUsuario = rNombreUsuario;
    });
  }

  salir() {

    if (localStorage.getItem('Usuario')) {
      localStorage.removeItem('Usuario');
      this.router.navigate(['inicio']);
    }

    if (localStorage.getItem('Clave')) {
      localStorage.removeItem('Clave');
    }

    this.router.navigate(['inicio']);

    this.transferencia.enviarMuestraUsuario(false);
  }

  verMenu(ruta: string) {
    this.genService.navegar([ruta]);
  }

}
