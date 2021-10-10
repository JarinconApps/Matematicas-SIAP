export interface Usuario {
  idusuario?: string;
}

export interface Afiliacion {
  IdTipoParticipante?: string;
  Nombre?: string;
}
export interface ParticipanteEmem {
  IdParticipante?: string;
  Nombre?: string;
  Documento?: string;
  Correo?: string;
  Institucion?: string;
  Titulo?: string;
  IdEvento?: string;
  IdTipoParticipante?: string;
  TituloPonencia?: string;
}

export interface EventoEMEM {
  Dias?: string;
  Fecha?: string;
  IdEvento?: string;
  Nombre?: string;
  Visible?: string;
  Descripcion?: string;
  Titulo?: string;
  Modalidades?: string;
}

export interface RespuestaCRUD {
  Response?: string;
  Status?: string;
  Results?: any[];
}

export interface Modalidad {
  IdModalidad?: string;
  Modalidad?: string;
  Conferencias?: Conferencia[];
}

export interface Conferencia {
  Conferencista?: Conferencista;
  IdConferencia?: string;
  IdConferencista?: string;
  IdEvento?: string;
  IdModalidad?: string;
  Resumen?: string;
  Titulo?: string;
}

export interface Conferencista {
  Biografia?: Biografia[];
  Correo?: string;
  IdConferencista?: string;
  Institucion?: string;
  Nombre?: string;
}

export interface Biografia {
  Biografia?: string;
  IdBiografia?: string;
  IdConferencista?: string;
  Orden?: string;
}
