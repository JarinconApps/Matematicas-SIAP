import { PerfilDocente } from './../../../interfaces/interfaces.interfaces';
import { GeneralService } from './../../../services/general.service';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Docente, CategoriaDocente, TipoContrato, HistoricoAgenda, Formacion, GrupoInvestigacion, GrupoDocente, TipoProduccion, Producto, AreaProfundizacion, RespuestaCRUD, EnlaceDivulgacion } from '../../../interfaces/interfaces.interfaces';
import { DialogosService } from '../../../services/dialogos.service';
import { TransferService } from '../../../services/transfer.service';
import { CapitalizadoPipe } from '../../../pipes/capitalizado.pipe';

@Component({
  selector: 'app-docente',
  templateUrl: './docente.component.html',
  styles: []
})
export class DocenteComponent implements OnInit {

  docente: Docente = {
    iddocente: '',
    nombre: '',
    telefono: '',
    correo: '',
    idcategoriadocente: '',
    idtipocontrato: '',
    foto: ''
  };

  expandirTodo = false;
  expandFormacion = false;
  expandAreasProf = false;
  expandEnlacesDiv = false;
  expandGruposInv = false;
  expandTrabaGradoDir = false;
  expandTrabaGradoEva = false;
  expandProduccion = false;
  expandHistoricoAgendas = false;

  Categorias: CategoriaDocente[] = [];
  TiposContrato: TipoContrato[] = [];
  TiposProduccion: TipoProduccion[] = [];
  AreasProfundizacion: AreaProfundizacion[] = [];
  EnlacesDivulgacion: EnlaceDivulgacion[] = [];

  imagenSubir: File;

  guardando = false;
  leyendo = false;

  perfilDocente: PerfilDocente;
  HistoricoAgendas: HistoricoAgenda[] = [];
  Formaciones: Formacion[] = [];
  GruposInvestigacion: GrupoDocente[] = [];

  constructor(private activatedRoute: ActivatedRoute,
              private genService: GeneralService,
              private dlgService: DialogosService,
              private transfer: TransferService) { }

  ngOnInit() {
    this.leerTiposContrato();
    this.leerCategorias();
    this.obtenerDocente();
    this.leerHistoricoAgendas();
    this.leerFormacion();
    this.leerGruposInvestigacion();
    this.obtenerProductosDocente();
    this.obtenerEnlacesDivulgacionDocente();

    this.transfer.enviarTituloAplicacion('Perfil del Docente');
  }

  // %%%%%%% Docente %%%%%%%
  obtenerDocente() {
    this.leyendo = true;
    this.activatedRoute.params.subscribe((rParam: any) => {
      this.docente.iddocente = rParam.id;

      this.leerAreasProfundizacion();

      this.genService.getDocente(this.docente.iddocente).subscribe((rDocente: Docente) => {
        this.docente = rDocente;

        this.genService.getPerfilDocente(this.docente.iddocente).subscribe((rPerfilDocente: any) => {

          this.perfilDocente = rPerfilDocente;
          this.leyendo = false;
        });
      });
    });
  }

  /** ### agregarAreaProfundizacion
   * Agrega un área de profundización al docente
   */
   agregarAreaProfundizacion() {
    this.dlgService.crearEditarAreaDocente(this.docente.iddocente).subscribe((rAreaDocente: RespuestaCRUD) => {
      console.log(rAreaDocente);
      this.leerAreasProfundizacion();
    });
   }

  /** ### leerAreasProfundizacion
   * Leer las áreas de profundización del docente
   */
  leerAreasProfundizacion() {
    this.genService.getAreasDocente(this.docente.iddocente).subscribe((rAreas: RespuestaCRUD) => {
      console.log(rAreas);
      this.AreasProfundizacion = rAreas.Results;
    });
  }

  /** ## desvincularAreaProfundizacion
   * Eliminar el área de profundización del docente
   */
  desvincularAreaProfundizacion(area: AreaProfundizacion) {
    this.genService.deleteAreaDocente(area.idareadocente).subscribe((rArea: RespuestaCRUD) => {
      console.log(rArea);
      this.dlgService.mostrarSnackBar(rArea.Response);
      this.leerAreasProfundizacion();
    });
  }

  leerCategorias() {
    this.genService.getCategoriasDocente().subscribe((rCategorias: any) => {

      this.Categorias = rCategorias.CategoriasDocentes;
    });
  }

  leerTiposContrato() {
    this.genService.getTiposContrato().subscribe((rTiposContrato: any) => {

      this.TiposContrato = rTiposContrato.TiposContratos;
    });
  }

  seleccionImagen( archivo: File) {

    if (!archivo) {
      this.imagenSubir = null;
      return;
    }

    this.imagenSubir = archivo;

    // %%%%%%% Subir Archivo %%%%%%%
    const reader = new FileReader();
    reader.readAsDataURL(this.imagenSubir);
    reader.onload = () => {

      this.docente.foto = reader.result.toString();

      const datos = JSON.stringify(this.docente);
      this.genService.putFotoDocente(datos).subscribe((rRespuesta: any) => {
        this.dlgService.mostrarSnackBar(rRespuesta.Respuesta || rRespuesta.Error);
      });
    };

    reader.onerror = (error) => {

    };

  }

  guardarDocente() {

    this.guardando = true;

    const datos = JSON.stringify(this.docente);

    this.genService.putDocente(datos).subscribe((rRespuesta: any) => {
      this.dlgService.mostrarSnackBar(rRespuesta.Respuesta || rRespuesta.Error);
    });
  }

  // %%%%%%% Histórico de Agendas %%%%%%%
  leerHistoricoAgendas() {
    this.genService.getAgendasPorPeriodoDocente(this.docente.iddocente).subscribe((rPeriodos: any) => {

      this.HistoricoAgendas = rPeriodos.Periodos;
    });
  }

  // %%%%%%% Formación del Docente %%%%%%%

  agregarFormacion() {
    this.dlgService.crearEditarFormacion(null, this.docente).subscribe((rResp: any) => {

      this.dlgService.mostrarSnackBar(rResp.Respuesta);
      this.leerFormacion();
    });
  }

  leerFormacion() {
    this.genService.getFormacion(this.docente.iddocente).subscribe((rFormacion: any) => {

      this.Formaciones = rFormacion.Formaciones;
    });
  }

  editarFormacion(formacion: Formacion) {
    this.dlgService.crearEditarFormacion(formacion, this.docente).subscribe((rResp: any) => {

      this.dlgService.mostrarSnackBar(rResp.Respuesta);
      this.leerFormacion();
    });
  }

  eliminarFormacion(formacion: Formacion) {
    this.dlgService.confirmacion('¿Está seguro de eliminar la formación?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deleteFormacion(formacion.idformacion).subscribe((rResp: any) => {

          this.dlgService.mostrarSnackBar(rResp);
          this.leerFormacion();
        });
      }
    });
  }

  // %%%%%%% Grupos de Investigación %%%%%%%

  agregarGrupoInvestigacion() {
    this.dlgService.seleccionarGrupoInvestigacion().subscribe((rGrupo: GrupoInvestigacion) => {

      const grupoDocente: GrupoDocente = {
        iddocente: this.docente.iddocente,
        idgrupoinvestigacion: rGrupo.idgrupoinvestigacion,
        fechaingreso: ''
      };
      const datos = JSON.stringify(grupoDocente);
      this.genService.postGrupoInvestigacionDocente(datos).subscribe((rResp: any) => {

        this.leerGruposInvestigacion();
      });
    });
  }

  leerGruposInvestigacion() {
    this.genService.getGruposInvestigacionDocente(this.docente.iddocente).subscribe((rGrupos: any) => {

      this.GruposInvestigacion = rGrupos.Grupos;
    });
  }

  desvincularGrupo(grupo: GrupoDocente) {
    this.dlgService.confirmacion('¿Está seguro de desvincularse del grupo de investigación?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deleteGrupoInvestigacionDocente(grupo.idgrupodocente).subscribe((rResp: any) => {
          this.dlgService.mostrarSnackBar(rResp.Respuesta);
          this.leerGruposInvestigacion();
        });
      }
    });
  }

  // %%%%%%% Productos %%%%%%%
  agregarProducto() {
    this.dlgService.crearEditarProducto(null).subscribe((rProducto: any) => {

      this.dlgService.mostrarSnackBar(rProducto.Respuesta);

    });
  }

  obtenerProductosDocente() {
    this.genService.getProductosPorDocente(this.docente.iddocente).subscribe((rProductos: any) => {

      this.TiposProduccion = rProductos.Tipos;
    });
  }

  editarProducto(producto: Producto) {
    this.dlgService.crearEditarProducto(producto).subscribe((rProducto: any) => {

      this.dlgService.mostrarSnackBar(rProducto.Respuesta);
      this.obtenerProductosDocente();
    });
  }

  eliminarProducto(producto: Producto) {
    this.dlgService.confirmacion('¿Está seguro de eliminar éste producto?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deleteProducto(producto.idproduccion).subscribe((rResp: any) => {

          this.dlgService.mostrarSnackBar(rResp.Respuesta);
          this.obtenerProductosDocente();
        });
      }
    });
  }

  obtenerEnlacesDivulgacionDocente() {
    this.genService.getEnlacesDivulgacion(this.docente.iddocente).subscribe((rEnlaces: RespuestaCRUD) => {
      this.EnlacesDivulgacion = rEnlaces.Results;
    });
  }

  agregarEnlace() {
    this.dlgService.crearEditarEnlaceDocente(this.docente.iddocente, null).subscribe((rEnlace: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rEnlace.Response);
      this.obtenerEnlacesDivulgacionDocente();
    });
  }

  editarEnlace(enlaces: EnlaceDivulgacion) {
    this.dlgService.crearEditarEnlaceDocente(this.docente.iddocente, enlaces).subscribe((rEnlace: RespuestaCRUD) => {
      this.dlgService.mostrarSnackBar(rEnlace.Response);
      this.obtenerEnlacesDivulgacionDocente();
    });
  }

  eliminarEnlace(enlaces: EnlaceDivulgacion) {
    this.dlgService.confirmacion('¿Está seguro de eliminar éste enlace?').subscribe((rEliminar: boolean) => {
      if (rEliminar) {
        this.genService.deleteEnlaceDivulgalcion(enlaces.iddivulgacion).subscribe((rEnlaces: RespuestaCRUD) => {
          this.dlgService.mostrarSnackBar(rEnlaces.Response);
          this.obtenerEnlacesDivulgacionDocente();
        });
      }
    });
  }

  exportarPerfil() {
    document.title = new CapitalizadoPipe().transform(this.docente.nombre);

    this.expandirTodo = true;
    this.expandFormacion = true;
    this.expandAreasProf = true;
    this.expandEnlacesDiv = true;
    this.expandGruposInv = true;
    this.expandTrabaGradoDir = true;
    this.expandTrabaGradoEva = true;
    this.expandProduccion = true;
    this.expandHistoricoAgendas = true;

    setTimeout(() => {
      window.print();
    }, 100);
  }


}
