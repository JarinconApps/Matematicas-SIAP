export interface Periodo {
  IdPeriodo?: string;
  Periodo?: string;
}

export interface RespuestaCRUD {
  Status?: string;
  Response?: string;
  Results?: any[];
  Object?: any;
}

export interface Estudiante {
  IdEstudiante?: string;
  Nombre?: string;
  Documento?: string;
  Correo?: string;
  Telefono?: string;
  TipoDocumento?: string;
  Genero?: string;
  Direccion?: string;
  Municipio?: string;
  Semestre?: string;
  Eps?: string;
  EstadoCivil?: string;
  Codigo?: string;
  AntecedentesDisciplinarios?: any;
  AntecedentesJudiciales?: any;
  AntecedentesFiscales?: any;
  MedidasCorrectivas?: any;
  DocumentoIdentidad?: any;
  CertificadoEPS?: any;
  EspacioAcademico?: string;
  Periodo?: string;
}

export interface PracticaDocente {
  IdRegistro?: string;
  IdPeriodo?: string;
  IdEstudiante?: string;
  EspacioAcademico?: string;
}
