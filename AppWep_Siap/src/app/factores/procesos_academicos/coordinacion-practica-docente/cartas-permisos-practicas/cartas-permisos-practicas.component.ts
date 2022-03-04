import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../../../services/general.service';
import { Periodo, RespuestaCRUD, CartaPermiso, EstudiantePractica, Estudiante, EstudianteCarta } from '../../../../interfaces/interfaces.interfaces';
import { DialogosService } from '../../../../services/dialogos.service';
import { Router } from '@angular/router';
import { RUTA_EXPORTAR_CARTA_PERMISO } from '../../../../config/config';

@Component({
  selector: 'app-cartas-permisos-practicas',
  templateUrl: './cartas-permisos-practicas.component.html',
  styles: []
})
export class CartasPermisosPracticasComponent implements OnInit {

  periodos: Periodo[] = [];
  periodo: Periodo = {};

  cartas: CartaPermiso[] = [];

  constructor(private genService: GeneralService,
              private dlgService: DialogosService,
              private router: Router) { }

  ngOnInit() {
    this.leerSemestres();
  }

  crearCarta() {
    this.dlgService.crearEditarCartaPermiso(null, this.periodo.idperiodo).subscribe((rCarta: RespuestaCRUD) => {
      console.log(rCarta);

      this.dlgService.mostrarSnackBar(rCarta.Response);

      this.obtenerCartas();
    });
  }

  obtenerCartas() {
    this.genService.getCartasPeriodo(this.periodo.idperiodo).subscribe((rCartas: RespuestaCRUD) => {
      console.log(rCartas);
      this.cartas = rCartas.Results;
    });
  }

  leerSemestres() {
    this.genService.getPeriodos().subscribe((rPeriodos: any) => {
      this.periodos = rPeriodos.Periodos;
      this.periodo = this.periodos[this.periodos.length - 1];

      this.obtenerCartas();
    });
  }

  editar(carta: CartaPermiso) {
    this.dlgService.crearEditarCartaPermiso(carta, this.periodo.idperiodo).subscribe((rCarta: RespuestaCRUD) => {
      console.log(rCarta);
      this.dlgService.mostrarSnackBar(rCarta.Response);
      this.obtenerCartas();
    });
  }

  eliminar(carta: CartaPermiso) {
    this.dlgService.confirmacion('¿Está seguro de eliminar ésta carta?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deleteCartaPermiso(carta.IdCarta).subscribe((rCarta: RespuestaCRUD) => {
          this.dlgService.mostrarSnackBar(rCarta.Response);
          console.log(rCarta);
          this.obtenerCartas();
        });
      }
    });
  }

  agregarEstudiante(carta: CartaPermiso) {
    this.dlgService.seleccionarEstudiante(this.periodo.idperiodo).subscribe((rEstudiante: any) => {
      console.log(rEstudiante);
      const estudianteCarta: EstudianteCarta = {
        IdCarta: carta.IdCarta,
        IdEstudiante: rEstudiante.estudiante.IdEstudiante,
        Horario: rEstudiante.Horario,
        Grado: rEstudiante.Grado
      };

      console.log(estudianteCarta);

      const datos = JSON.stringify(estudianteCarta);

      this.genService.postEstudianteCarta(datos).subscribe((rEstudianteCarta: RespuestaCRUD) => {
        this.dlgService.mostrarSnackBar(rEstudianteCarta.Response);
        console.log(rEstudianteCarta);
        carta.Estudiantes.push(rEstudianteCarta.Object);
      });
    });
  }

  eliminarEstudiante(estudiante: EstudianteCarta, carta: CartaPermiso) {
    this.dlgService.confirmacion('¿Está seguro de eliminar a éste estudiante?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deleteEstudianteCarta(estudiante.IdEstudianteCarta).subscribe((rEstudianteCarta: RespuestaCRUD) => {
          console.log(rEstudianteCarta);
          this.dlgService.mostrarSnackBar(rEstudianteCarta.Response);

          const id = carta.Estudiantes.indexOf(estudiante);
          carta.Estudiantes.splice(id, 1);
        });
      }
    });
  }

  exportarCartaPermiso(carta: CartaPermiso) {
    this.router.navigate([RUTA_EXPORTAR_CARTA_PERMISO, carta.IdCarta]);
  }
}
