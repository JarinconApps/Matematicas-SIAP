import { GeneralService } from './../services/general.service';
import { Component, OnInit } from '@angular/core';
import { TransferService } from '../services/transfer.service';
import { MenuFactores, BotonMenu, Favorito } from '../interfaces/interfaces.interfaces';
import { Utilidades } from '../utilidades/utilidades.class';
import { RUTA_FACTOR_DOCENTES, RUTA_DOCENTES, RUTA_SERVICIOSPROGRAMA, RUTA_PROGRAMAS, RUTA_AGENDAS, RUTA_FACULTADES, RUTA_PERIODOS, RUTA_FUNCIONESDOCENTE, RUTA_ESTADISTICAS_FACTOR_DOCENTES, RUTA_TRABAJOSGRADO, RUTA_ACERCA, RUTA_ACTUALIZACIONES, RUTA_MANUAL_AYUDA, RUTA_TAREAS_PENDIENTES, RUTA_GESTION_ERRORES, RUTA_PLAN_MEJORAMIENTO, RUTA_ADMINISTRADOR, RUTA_ADMIN_USUARIO, RUTA_ADMIN_CONFIGURACIONES, RUTA_ADMIN_TIPO_PRODUCCION, RUTA_ESTADISTICAS, RUTA_ESTADISTICAS_TRABAJOS_GRADO, RUTA_ESTADISTICAS_SERVICIOS_PROGRAMA, RUTA_ESTADISTICAS_HORAS_FACULTADES, RUTA_DOCENTES_DIRECCION_TRABAJOS_GRADO, RUTA_REPORTE_DIRECCION_JURADO, RUTA_GRUPOSINVESTIGACION, RUTA_SEMINARIO, RUTA_EVENTOS_SEMINARIO, RUTA_COORDINACION_PRACTICA_DOCENTE, TIPO_CONTRATO_DEFECTO, ID_DOCENTE_DEFECTO } from '../config/config';

@Component({
  selector: 'app-factores',
  templateUrl: './factores.component.html',
  styles: []
})
export class FactoresComponent implements OnInit {


  // Crear un menu dinámico
  Menus: MenuFactores[] = [
    {
      Titulo: 'Procesos Académicos',
      Botones: [
        {
          IdBoton: 'pro-aca-tra-gra',
          Titulo: 'Trabajos de Grado',
           Icono: 'trabajosgrado.png',
           Ruta: [RUTA_TRABAJOSGRADO]
        },
        {
           Titulo: 'Plan de Mejoramiento',
           Icono: 'plan_mejoramiento.png',
           Ruta: [RUTA_PLAN_MEJORAMIENTO],
           IdBoton: 'pro-aca-plan-mejora'
        },
        {
           Titulo: 'Actualización de Documentos',
           Icono: 'ActualizacionDocumentos.png',
           Ruta: [''],
           IdBoton: 'pro-aca-actualiza-doc'
        },
        {
           Titulo: 'Coordinación de Práctica Docente',
           Icono: 'PracticaProfesional.png',
           Ruta: [RUTA_COORDINACION_PRACTICA_DOCENTE],
           IdBoton: 'pro-aca-coord-pra-doc'
        },
        {
           Titulo: 'Virtualización',
           Icono: 'Virtualizacion.png',
           Ruta: [''],
           IdBoton: 'pro-aca-virtualiz'
        }
      ]
     },
    // ESTUDIANTES
    {
      Titulo: 'Estudiantes',
      Botones: [
        {
           Titulo: '  Pruebas Saber PRO',
           Icono: 'PruebaSaverPRO.png',
           Ruta: [''],
           IdBoton: 'est-prueba-sab-pro'
        },
        {
          Titulo: 'Comité de Apoyo Estudiantil',
          Icono: 'ComiteApoyo.png',
          Ruta: [''],
          IdBoton: 'est-com-apoy-est'
        },
        {
          Titulo: 'Propuesta de Evaluación por Nucleos',
          Icono: 'PropuestaEvaluacionPorNucleos.png',
          Ruta: [''],
          IdBoton: 'est-pro-eva-nucleos'
        }
      ]
     },
     // DOCENTES
     {
      Titulo: 'Docentes',
      Botones: [
        {
          Titulo: 'Docentes',
          Icono: 'docentes.svg',
          Ruta: [RUTA_FACTOR_DOCENTES, RUTA_DOCENTES],
          IdBoton: 'doc-docentes'
        },
        {
           Titulo: 'Programas',
           Icono: 'programas.png',
           Ruta: [RUTA_FACTOR_DOCENTES, RUTA_PROGRAMAS],
           IdBoton: 'doc-programas'
        },
        {
          Titulo: 'Facultades',
          Icono: 'facultades.png',
          Ruta: [RUTA_FACTOR_DOCENTES, RUTA_FACULTADES],
          IdBoton: 'doc-facultades'
        },
        {
          Titulo: 'Periodos',
          Icono: 'periodos.png',
          Ruta: [RUTA_FACTOR_DOCENTES, RUTA_PERIODOS],
          IdBoton: 'doc-periodos'
       },
        {
          Titulo: 'Servicios de Programa',
          Icono: 'servicios.png',
          Ruta: [RUTA_FACTOR_DOCENTES, RUTA_SERVICIOSPROGRAMA],
          IdBoton: 'doc-ser-program'
        },
        {
          Titulo: 'Funciones de Docencia',
          Icono: 'funcionesdocencia.png',
          Ruta: [RUTA_FACTOR_DOCENTES, RUTA_FUNCIONESDOCENTE],
          IdBoton: 'doc-func-docencia'
        },
        {
          Titulo: 'Agendas',
          Icono: 'agendas.png',
          Ruta: [RUTA_FACTOR_DOCENTES, RUTA_AGENDAS, TIPO_CONTRATO_DEFECTO, ID_DOCENTE_DEFECTO],
          IdBoton: 'doc-agendas'
        }
      ]
     },

     // INTERNACIONALIZACIÓN
     {
      Titulo: 'Internacionalización',
      Botones: [
        {
           Titulo: 'RED Clema',
           Icono: 'RedClema.png',
           Ruta: [''],
           IdBoton: 'inter-red-clema'
        },
        {
          Titulo: 'Capacitaciones para Convocatorias',
          Icono: 'CapacitacionParaConvocatorias.png',
          Ruta: [''],
          IdBoton: 'inter-cap-convo'
        },
        {
          Titulo: 'Proyectos de Doble Titulación',
          Icono: 'ProyectosDobleTitulacion.png',
          Ruta: [''],
          IdBoton: 'inter-pro-doble-tit'
        },
        {
          Titulo: 'Participación en Eventos Científicos',
          Icono: 'ParticipacionEventosCientificos.png',
          Ruta: [''],
          IdBoton: 'inter-par-event-cientif'
        }
      ]
     },

     // INVESTIGACIÓN
     {
      Titulo: 'Investigación',
      Botones: [
        {
           Titulo: 'Representante Ante el CIFE',
           Icono: 'RepresentanteCIFE.png',
           Ruta: [''],
           IdBoton: 'invest-rep-cife'
        },
        {
          Titulo: 'Revisión de Proyectos de Investigación',
          Icono: 'RevisionProyectosInvestigacion.png',
          Ruta: [''],
          IdBoton: 'invest-rev-pro-invest'
        },
        {
          Titulo: 'Semillero de Investigación de la Facultad',
          Icono: 'SemilleroFacultad.png',
          Ruta: [''],
          IdBoton: 'invest-sem-inv-fac'
        },
        {
          Titulo: 'Representante de Investigaciones',
          Icono: 'RepresentanteInvestigaciones.png',
          Ruta: [''],
          IdBoton: 'invest-rep-invest'
        },
        {
          Titulo: 'Grupos de Investigación',
          Icono: 'grupos_investigacion.png',
          Ruta: [RUTA_GRUPOSINVESTIGACION],
          IdBoton: 'invest-grup-invest'
       }
      ]
     },

     // EXTENSIÓN Y GESTIÓN DE GRADUADO
     {
      Titulo: 'Extensión y Gestión del Graduado',
      Botones: [
        {
           Titulo: 'MADS - Laboratorio de Matemática Aplicada y Desarrollo de Software',
           Icono: 'MADS.png',
           Ruta: [''],
           IdBoton: 'egg-mads'
        },
        {
          Titulo: 'Coordinación de Comunicaciones del Programa',
          Icono: 'RepresentanteComunaciones.png',
          Ruta: [''],
          IdBoton: 'egg-coord-com-pro'
        },
        {
          Titulo: 'Proyecto: Laboratorio de Didáctica de la Matemática',
          Icono: 'LaboratorioMatematicas.png',
          Ruta: [''],
          IdBoton: 'egg-lab-didact-mat'
        },
        {
          Titulo: 'Seminario interno del programa',
          Icono: 'Seminario.png',
          Ruta: [RUTA_SEMINARIO, RUTA_EVENTOS_SEMINARIO],
          IdBoton: 'egg-seminario-interno'
        },
        {
          Titulo: 'Graduados',
          Icono: 'graduados.png',
          Ruta: ['graduados'],
          IdBoton: 'egg-egresados'
        }
      ]
     },

     // ACERCA DE ...
     {
      Titulo: 'Acerca de ...',
      Botones: [
        {
           Titulo: '¿Qué es SIAP?',
           Icono: 'Acerca_de.png',
           Ruta: [''],
           IdBoton: 'acerca-que-siap'
        },
        {
          Titulo: 'Actualizaciones',
          Icono: 'Actualizaciones.png',
          Ruta: [RUTA_ACERCA, RUTA_ACTUALIZACIONES],
          IdBoton: 'acerca-actualiza'
        },
        {
          Titulo: 'Manual de Ayuda',
          Icono: 'ManualAyuda.png',
          Ruta: [RUTA_ACERCA, RUTA_MANUAL_AYUDA],
          IdBoton: 'acerca-man-ayu'
        },
        {
          Titulo: 'Gestión de Errores',
          Icono: 'GestionErrores.png',
          Ruta: [RUTA_ACERCA, RUTA_GESTION_ERRORES],
          IdBoton: 'acerca-gestion-err'
        },
        {
          Titulo: 'Tareas Pendientes',
          Icono: 'TareasPendientes.png',
          Ruta: [RUTA_ACERCA, RUTA_TAREAS_PENDIENTES],
          IdBoton: 'acerca-gestion-err'
        }
      ]
     },

     // ADMINISTRADOR
     {
      Titulo: 'Administración de la Plataforma',
      Botones: [
        {
           Titulo: 'Usuarios',
           Icono: 'Usuarios.png',
           Ruta: [RUTA_ADMINISTRADOR, RUTA_ADMIN_USUARIO],
           IdBoton: 'admin-usuarios'
        },
        {
          Titulo: 'Configuración General',
          Icono: 'Configuracion.png',
          Ruta: [RUTA_ADMINISTRADOR, RUTA_ADMIN_CONFIGURACIONES],
          IdBoton: 'admin-config-gen'
        },
        {
          Titulo: 'Tipos de Producción',
          Icono: 'TiposProductos.png',
          Ruta: [RUTA_ADMINISTRADOR, RUTA_ADMIN_TIPO_PRODUCCION],
          IdBoton: 'admin-config-gen'
        }
      ]
     }
  ];

  Favoritos: Favorito[] = [];

  constructor(private genService: GeneralService,
              private transfer: TransferService) { }

  ngOnInit() {
    this.transfer.enviarTituloAplicacion('');
    this.obtenerFavoritos();
    window.scrollTo(0, 0);
  }

  obtenerFavoritos() {
    this.genService.getFavoritos().subscribe((rFavoritos: any) => {

      this.Favoritos = rFavoritos.Favoritos;
    });
  }

  abrirMenu2(favorito: Favorito) {

    const boton: BotonMenu = {
      IdBoton: favorito.idfavorito,
      Titulo: favorito.titulo,
      Icono: favorito.icono,
      Ruta: favorito.ruta.split(',')
    };

    this.abrirMenu(boton);
  }

  abrirMenu(boton: BotonMenu) {
    // Registrar el evento en favoritos
    const favorito: Favorito = {
      idfavorito: boton.IdBoton,
      titulo: boton.Titulo,
      icono: boton.Icono,
      ruta: boton.Ruta.toString(),
      frecuencia: '1'
    };

    const datos = JSON.stringify(favorito);
    this.genService.postFavorito(datos).subscribe((rFavorito: any) => {

      this.genService.navegar(boton.Ruta);
    });

  }

}
