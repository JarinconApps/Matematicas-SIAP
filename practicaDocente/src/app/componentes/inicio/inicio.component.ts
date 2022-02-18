import { Component, OnInit } from '@angular/core';
import { GeneralService } from '../../servicios/general.service';
import { RespuestaCRUD, Periodo, Estudiante, PracticaDocente } from '../../interfaces/interfaces';

@Component({
  selector: 'app-inicio',
  templateUrl: './inicio.component.html',
  styles: [
  ]
})
export class InicioComponent implements OnInit {

  Periodos: Periodo[] = [];
  estudiante: Estudiante = {
    Nombre: '',
    Documento: '',
    Correo: '',
    Telefono: '',
    TipoDocumento: '',
    Genero: '',
    Direccion: '',
    Municipio: '',
    Semestre: '',
    Eps: '',
    EstadoCivil: '',
    Codigo: '',
    AntecedentesDisciplinarios: '',
    AntecedentesFiscales: '',
    AntecedentesJudiciales: '',
    CertificadoEPS: '',
    DocumentoIdentidad: '',
    MedidasCorrectivas: ''
  }

  Materia: PracticaDocente = {
    IdPeriodo: '',
    IdEstudiante: '',
    IdRegistro: '',
    EspacioAcademico: ''
  };
  Semestres: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  periodo: Periodo = {};
  EstadoCivil = [
    'Soltero(a)', 'Casado(a)', 'Unión libre', 'Viudo(a)', 'Divorciado(a)'
  ];
  rutaDocumentos = '';

  Materias: String[] = [
    'Práctica Pedagógica I (Plan nuevo 652)',
    'Práctica Pedagógica II (Plan nuevo 652)',
    'Práctica Pedagógica III (Plan nuevo 652)',
    'Práctica Docente I (Plan antiguo 66)',
    'Práctica Docente II (Plan antiguo 66)'
  ];

  mostrarDatos = false;
  mostrarRespuesta = false;
  respuesta = '';

  constructor(private genService: GeneralService) { }

  ngOnInit(): void {
    this.obtenerPeriodos();

    this.rutaDocumentos = this.genService.getRutaDocumentos();
  }

  obtenerPeriodos() {
    this.genService.getPeriodos().subscribe((rPeriodos: RespuestaCRUD) => {
      this.Periodos = rPeriodos.Results;
      console.log(rPeriodos);

      this.periodo = this.Periodos[this.Periodos.length-1];
    });
  }

  buscarEstudiante() {
    this.genService.buscarEstudiante(this.estudiante.Documento, this.periodo.IdPeriodo).subscribe((rEstudiante: RespuestaCRUD) => {
      console.log(rEstudiante);
      this.estudiante = rEstudiante.Object;

      this.estudiante.Codigo = this.estudiante.IdEstudiante;

      if (this.estudiante.Documento) {
        this.mostrarDatos = true;
      } else {
        this.mostrarDatos = false;
      }

      this.mostrarRespuesta = false;

    });
  }

  guardar() {
    this.estudiante.Periodo = this.periodo.IdPeriodo;
    const datos = JSON.stringify(this.estudiante);
    console.log(this.estudiante);

    this.genService.guardarEstudiante(datos).subscribe((rEstudiante: RespuestaCRUD) => {
      console.log(rEstudiante);
      this.mostrarDatos = false;
      this.mostrarRespuesta = true;
      this.respuesta = rEstudiante.Response;
    });
  }

  seleccionarArchivo( archivo: any, tipo: string) {

    if (!archivo) {
      return;
    }

    archivo = archivo.target.files[0];

    // %%%%%%% Subir Archivo %%%%%%%
    const reader = new FileReader();
    reader.readAsDataURL(archivo);
    reader.onload = () => {
      console.log(reader.result);

      if (tipo === 'AntecedentesDisciplinarios') {
        this.estudiante.AntecedentesDisciplinarios = reader.result;
      }

      if (tipo === 'AntecedentesFiscales') {
        this.estudiante.AntecedentesFiscales = reader.result;
      }

      if (tipo === 'AntecedentesJudiciales') {
        this.estudiante.AntecedentesJudiciales = reader.result;
      }

      if (tipo === 'MedidasCorrectivas') {
        this.estudiante.MedidasCorrectivas = reader.result;
      }

      if (tipo === 'DocumentoIdentidad') {
        this.estudiante.DocumentoIdentidad = reader.result;
      }

      if (tipo === 'CertificadoEPS') {
        this.estudiante.CertificadoEPS = reader.result;
      }
    };

    reader.onerror = (error) => {
      // console.log('Error: ', error);
    };

  }

}
