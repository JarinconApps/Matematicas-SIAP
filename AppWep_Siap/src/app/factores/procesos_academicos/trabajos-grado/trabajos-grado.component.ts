import { GeneralService } from "./../../../services/general.service";
import { Component, OnInit } from "@angular/core";
import {
  TrabajoGrado,
  Modalidad,
  AreaProfundizacion,
  GrupoInvestigacion,
  Paginacion,
  FiltroBusquedaTrabajosGrado,
} from "../../../interfaces/interfaces.interfaces";
import { DialogosService } from "../../../services/dialogos.service";
import { TransferService } from "../../../services/transfer.service";
import {
  RUTA_CREAR_EDITAR_TRABAJO_GRADO,
  RUTA_MODALIDADES,
  RUTA_AREASPROFUNDIZACION,
  RUTA_GRUPOSINVESTIGACION,
  RUTA_FACTOR_DOCENTES,
  RUTA_DIRECTORES_JURADOS_TRABAJO_GRADO,
  RUTA_VER_TRABAJO_GRADO,
  RUTA_EXPORTAR_TRABAJOS_GRADO,
  RUTA_DOCENTES_DIRECCION_TRABAJOS_GRADO,
  RUTA_ESTADISTICAS_TRABAJOS_GRADO,
} from "../../../config/config";
import { Menu } from "../../../general/menu/menu.component";

@Component({
  selector: "app-trabajos-grado",
  templateUrl: "./trabajos-grado.component.html",
  styles: [],
})
export class TrabajosGradoComponent implements OnInit {
  TrabajosGrado: TrabajoGrado[] = [];
  bTrabajosGrado: TrabajoGrado[] = [];
  leyendo = false;
  contIntentos = 1;

  trabajoGrado: TrabajoGrado = {
    titulo: "",
    idtrabajogrado: "",
    estudiante1: "",
    estudiante2: "",
    estudiante3: "",
    idjurado1: "",
    jurado1: { nombre: "" },
    jurado2: { nombre: "" },
    jurado3: { nombre: "" },
    idjurado2: "",
    idjurado3: "",
    iddirector: "",
    director: { nombre: "" },
    idcodirector: "",
    codirector: { nombre: "" },
    idmodalidad: "",
    modalidad: { nombre: "" },
    idareaprofundizacion: "j",
    areaProfundizacion: { nombre: "" },
    idgrupoinvestigacion: "",
    grupoInvestigacion: { nombre: "" },
    actanombramientojurados: "",
    actapropuesta: "",
    evaluacionpropuesta: "",
    evaluaciontrabajoescrito: "",
    evaluacionsustentacion: "",
    fechasustentacion: "",
    calificacionfinal: "",
    estudiantecedederechos: "",
    fechainicioejecucion: "",
    cantidadsemestresejecucion: {
      Dias: "",
      Meses: "",
      Semestres: "",
      Anos: "",
    },
    estadoproyecto: "",
  };

  filtroBusqueda: FiltroBusquedaTrabajosGrado = {
    titulo: "Enseñanza",
    estudiante: "",
    paginacion: {
      todos: "no",
      contenido: [],
      desde: 1,
      cantidad: 15,
      resultado: "",
    },
  };

  verLista = false;
  verTarjetas = false;
  verDescripciones = true;
  tiempo = 0;

  Modalidades: Modalidad[] = [];
  AreasProfundizacion: AreaProfundizacion[] = [];
  GruposInvestigacion: GrupoInvestigacion[] = [];

  Menus: Menu[] = [
    {
      nombre: "Ver Descripciones",
      ruta: "ver-descripciones",
      imagen: "assets/Iconos/descripcion.png",
      descripcion:
        "Vista de los trabajos como una lista de descripciones (Incluye la mayoría de los atributos)",
    },
    {
      nombre: "Ver Lista",
      ruta: "ver-lista",
      imagen: "assets/Iconos/lista.png",
      descripcion: "Vista de los trabajos como una lista de elementos",
    },
    {
      nombre: "Ver Tarjetas",
      ruta: "ver-tarjetas",
      imagen: "assets/Iconos/tarjetas.png",
      descripcion: "Vista de los trabajos como tarjetas organizadas",
    },
    {
      nombre: "Exportar",
      ruta: "exportar-trabajos",
      imagen: "assets/Iconos/Excel.png",
      descripcion: "Permite exportar los trabajos de grado a formato Excel",
    },
    {
      nombre: "Reporte Docentes con Dirección de Trabajos de Grado",
      ruta: "reporte-trabajos-grado",
      imagen: "assets/Iconos/Ver.png",
      descripcion:
        "Genera un reporte de los trabajos de grado que esta dirigiendo cada docente",
    },
    {
      nombre: "Grupos de Investigación",
      ruta: "ver-grupos-investigacion",
      imagen: "assets/Iconos/pendiente.png",
      descripcion: "Gestión de los grupos de investigación",
    },
    {
      nombre: "Modalidades de Trabajo de Grado",
      ruta: "ver-modalidades",
      imagen: "assets/Iconos/pendiente.png",
      descripcion: "Gestión de los tipos de modalidad para trabajos de grado",
    },
    {
      nombre: "Áreas de profundización",
      ruta: "ver-areas-profundizacion",
      imagen: "assets/Iconos/pendiente.png",
      descripcion: "Gestión de los tipos de áreas de profundización",
    },
    {
      nombre: "Directores y Jurados",
      ruta: "ver-directores-jurados",
      imagen: "assets/Iconos/pendiente.png",
      descripcion:
        "Gestión de la lista de docentes que son directores y jurados.",
    },
    {
      nombre: "Estadísticas de trabajos de grado",
      imagen: "assets/Iconos/estadisticas.png",
      ruta: RUTA_ESTADISTICAS_TRABAJOS_GRADO,
      descripcion: "Análisis de los datos de trabajos de grado",
    },
  ];

  bTitulo = "";

  constructor(
    private genService: GeneralService,
    private dlgService: DialogosService,
    private transfer: TransferService
  ) {}

  ngOnInit() {
    this.leerTrabajosGrado();

    this.leerGruposInvestigacion();
    this.leerModalidades();
    this.leerAreasProfundizacion();
  }

  abrirMenu(menu: Menu) {
    if (menu.ruta === "ver-modalidades") {
      this.genService.navegar([RUTA_MODALIDADES]);
    }

    if (menu.ruta === RUTA_ESTADISTICAS_TRABAJOS_GRADO) {
      this.genService.navegar([RUTA_ESTADISTICAS_TRABAJOS_GRADO]);
    }

    if (menu.ruta === "exportar-trabajos") {
      this.genService.navegar([RUTA_EXPORTAR_TRABAJOS_GRADO]);
    }

    if (menu.ruta === "ver-areas-profundizacion") {
      this.genService.navegar([RUTA_AREASPROFUNDIZACION]);
    }

    if (menu.ruta === "reporte-trabajos-grado") {
      this.genService.navegar([RUTA_DOCENTES_DIRECCION_TRABAJOS_GRADO]);
    }

    if (menu.ruta === "ver-grupos-investigacion") {
      this.genService.navegar([RUTA_GRUPOSINVESTIGACION]);
    }

    if (menu.ruta === "ver-directores-jurados") {
      this.genService.navegar([
        RUTA_FACTOR_DOCENTES,
        RUTA_DIRECTORES_JURADOS_TRABAJO_GRADO,
      ]);
    }

    if (menu.ruta === "ver-lista") {
      this.verLista = true;
      this.verDescripciones = false;
      this.verTarjetas = false;
    }

    if (menu.ruta === "ver-descripciones") {
      this.verLista = false;
      this.verDescripciones = true;
      this.verTarjetas = false;
    }

    if (menu.ruta === "ver-tarjetas") {
      this.verLista = false;
      this.verDescripciones = false;
      this.verTarjetas = true;
    }
  }

  leerTrabajosGrado() {
    const t1 = new Date();
    this.leyendo = true;

    console.log(this.filtroBusqueda);

    const datos = JSON.stringify(this.filtroBusqueda);

    this.genService
      .getTrabajosGrado(datos)
      .subscribe((rTrabajosGrado: FiltroBusquedaTrabajosGrado) => {
        this.leyendo = false;

        this.filtroBusqueda = rTrabajosGrado;
        this.TrabajosGrado = rTrabajosGrado.paginacion.contenido;
        this.bTrabajosGrado = this.TrabajosGrado;

        const t2 = new Date();

        this.tiempo = Number(Number(t2) - Number(t1));
      });
  }

  cambiarPagina(delta: number) {
    this.filtroBusqueda.paginacion.desde =
      Number(this.filtroBusqueda.paginacion.desde) +
      Number(this.filtroBusqueda.paginacion.cantidad) * delta;

    if (this.filtroBusqueda.paginacion.desde < 0) {
      this.filtroBusqueda.paginacion.desde = 1;
    }
    if (
      Number(this.filtroBusqueda.paginacion.desde) +
        Number(this.filtroBusqueda.paginacion.cantidad) >
      Number(this.filtroBusqueda.paginacion.total)
    ) {
      this.filtroBusqueda.paginacion.desde =
        Number(this.filtroBusqueda.paginacion.total) -
        Number(this.filtroBusqueda.paginacion.cantidad) + 1;
    }
    this.leerTrabajosGrado();
  }

  leerModalidades() {
    this.genService.getModalidades().subscribe((rModalidades: any) => {
      this.Modalidades = rModalidades.Modalidades;
    });
  }

  leerAreasProfundizacion() {
    this.genService
      .getAreasProfundizacion()
      .subscribe((rAreasProfundizacion: any) => {
        this.AreasProfundizacion = rAreasProfundizacion.AreasProfundizacion;
      });
  }

  leerGruposInvestigacion() {
    this.genService
      .getGruposInvestigacion()
      .subscribe((rGruposInvestigacion: any) => {
        this.GruposInvestigacion = rGruposInvestigacion.GruposInvestigacion;
      });
  }

  agregarTrabajoGrado() {
    this.genService.navegar([RUTA_CREAR_EDITAR_TRABAJO_GRADO, "Crear"]);
  }

  editarTrabajoGrado(trabajogrado: TrabajoGrado) {
    this.genService.navegar([
      RUTA_CREAR_EDITAR_TRABAJO_GRADO,
      trabajogrado.idtrabajogrado,
    ]);
  }

  eliminarTrabajoGrado(trabajogrado: TrabajoGrado) {
    this.dlgService
      .confirmacion("¿Está seguro de eliminar este TrabajoGrado?")
      .subscribe((rConfirmacion: any) => {
        if (rConfirmacion) {
          this.genService
            .deleteTrabajoGrado(trabajogrado.idtrabajogrado)
            .subscribe((rRespuesta: any) => {
              this.dlgService.mostrarSnackBar(
                rRespuesta.Respuesta || rRespuesta.Error
              );
              this.leerTrabajosGrado();
            });
        }
      });
  }

  verTrabajoGrado(trabajoGrado: TrabajoGrado) {
    this.dlgService.verTrabajoGrado(trabajoGrado);
  }

  eliminarFiltro() {
    this.filtroBusqueda = {
      titulo: "",
      estudiante: "",
      director: "",
      idModalidad: "",
      idAreaProfundizacion: "",
      idGrupoInvestigacion: "",
      estadoProyecto: "",
      fechaInicio: "2008-08-20",
      fechaFin: "2021-08-20",
      paginacion: {
        todos: "no",
        contenido: [],
        desde: 1,
        cantidad: 15,
        resultado: "",
      },
    };

    this.leerTrabajosGrado();
  }

  verExcel() {
    this.dlgService.exportarTrabajosGrado(this.TrabajosGrado);
  }
}
