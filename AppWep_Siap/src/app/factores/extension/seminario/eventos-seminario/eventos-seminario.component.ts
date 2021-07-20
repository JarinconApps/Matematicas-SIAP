import { Component, OnInit } from '@angular/core';
import { Seminario } from 'src/app/interfaces/interfaces.interfaces';
import { DialogosService } from '../../../../services/dialogos.service';
import { RespuestaCRUD } from '../../../../interfaces/interfaces.interfaces';
import { GeneralService } from '../../../../services/general.service';

@Component({
  selector: 'app-eventos-seminario',
  templateUrl: './eventos-seminario.component.html',
  styles: []
})
export class EventosSeminarioComponent implements OnInit {

  eventosSeminario: Seminario[] = [];

  constructor(private dlgService: DialogosService,
              private genService: GeneralService) { }

  ngOnInit() {
    this.obtenerEventos();
  }

  obtenerEventos() {
    this.genService.getSeminarios().subscribe((rSeminarios: RespuestaCRUD) => {
      this.eventosSeminario = rSeminarios.Results;
    });
  }

  agregarEvento() {
    this.dlgService.crearEditarEventoSeminario(null).subscribe((rEvento: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rEvento.Response);
      this.obtenerEventos();
    });
  }

  editarEvento(evento: Seminario) {
    this.dlgService.crearEditarEventoSeminario(evento).subscribe((rEvento: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rEvento.Response);
      this.obtenerEventos();
    });
  }

  eliminarEvento(evento: Seminario) {
    this.dlgService.confirmacion('¿Está seguro de eliminar este evento?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deleteSeminario(evento.idseminario).subscribe((rSeminario: RespuestaCRUD) => {
          this.dlgService.mostrarSnackBar(rSeminario.Response);
        });
      }
    });
  }

}
