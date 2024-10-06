import { Injectable } from '@angular/core';
import { HttpHeaders, HttpClient } from '@angular/common/http';
import { Md5 } from 'ts-md5/dist/md5';
import { Router } from '@angular/router';
import { LS_ULTIMA_RUTA } from '../config/config';
import { retry } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class GeneralService {

  letras: string[] = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
                      's', 't', 'u', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  private token = '';
  private ENCABEZADO_HTTP = 'http://';
  private IP_SERVIDOR = 'mads.uniquindio.edu.co';
  private PUERTO = ':8080';
  private GENERAL = '/datasnap/rest/tmatematicas/';

  private URL_AFILIACION = 'Afiliacion';
  private URL_TIPOS_PARTICIPACION = 'tipoParticipacion';
  private URL_PARTICIPANTEEMEM = 'ParticipanteEmem';
  private URL_PARTICIPANTESEMEM = 'ParticipantesEmem';
  private URL_EVENTOS_EMEM = 'eventosEMEM';
  private URL_EVENTO_EMEM = 'eventoEMEM';
  private URL_CONFERENCIAS_EMEM = 'conferenciasEMEM';
  private URL_PONENCIAS_EMEM = 'ponenciasEMEM';
  private URL_CRONOGRAMA_EMEM = 'cronogramaEMEM';
  private URL_ORGANIZADORES_EVENTO = 'organizadoresEvento';
  private URL_PARTICIPANTE_EVENTO = 'participanteEvento';

  private URL_TOKEN = 'token';

  headers = new HttpHeaders({
    'Content-Type': 'application/json'
  });


  constructor(private http: HttpClient,
              private router: Router) {

    this.postToken().subscribe((respuesta: any) => {
      this.token = respuesta.token;

    });
  }

  navegar(ruta: string[]) {
    this.router.navigate(ruta);
    localStorage.setItem(LS_ULTIMA_RUTA, JSON.stringify(ruta));
  }

  generarID() {

    let id = '';

    for (let i = 1; i < 9; i++) {
      const posicion = Math.round(Math.random() * (this.letras.length - 1));
      id = id + this.letras[posicion];
    }

    id = id + '-';

    for (let i = 1; i < 5; i++) {
      const posicion = Math.round(Math.random() * (this.letras.length - 1));
      id = id + this.letras[posicion];
    }

    id = id + '-';

    for (let i = 1; i < 5; i++) {
      const posicion = Math.round(Math.random() * (this.letras.length - 1));
      id = id + this.letras[posicion];
    }

    id = id + '-';

    for (let i = 1; i < 13; i++) {
      const posicion = Math.round(Math.random() * (this.letras.length - 1));
      id = id + this.letras[posicion];
    }

    return id;
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     SERVICIOS ASSETS LOCALES
     Obtiene datos de los assets
  =========================================================================================================================*/
  getConferencias() {
    const url = 'assets/datos/conferencias.json';
    return this.http.get(url);
  }

  getPonencias() {
    const url = 'assets/datos/ponencias.json';
    return this.http.get(url);
  }

  getCronograma() {
    const url = 'assets/datos/programacion.json';
    return this.http.get(url);
  }

  getContacto() {
    const url = 'assets/datos/contacto.json';
    return this.http.get(url);
  }


  // Rutas del Servidor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  dataSnap_Path(ruta: string) {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL + ruta;
  }

  parametro(dato: string) {
    return '/' + dato;
  }

  postToken() {
    const url = this.dataSnap_Path(this.URL_TOKEN);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });

    const credenciales = {
      nombre: 'jprincon',
      correo: 'jarincon@uniquindio.edu.co',
      clave: 'Donmatematicas#512519'
    };

    const datos = JSON.stringify(credenciales);

    return this.http.post(url, datos, {headers});
  }

  /* Afiliacion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postAfiliacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_AFILIACION) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getTiposParticipacion() {
    const url = this.dataSnap_Path(this.URL_TIPOS_PARTICIPACION);
    return this.http.get(url).pipe(retry(10));
  }

  getAfiliacion(id: string) {
    const url = this.dataSnap_Path(this.URL_AFILIACION) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putAfiliacion(datos: string) {
    const url = this.dataSnap_Path(this.URL_AFILIACION) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteAfiliacion(id: string) {
    const url = this.dataSnap_Path(this.URL_AFILIACION) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* ParticipanteEmem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */

  postParticipanteEmem(datos: string) {
    const url = this.dataSnap_Path(this.URL_PARTICIPANTEEMEM);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers}).pipe(retry(10));
  }

  getParticipantesEmem() {
    const url = this.dataSnap_Path(this.URL_PARTICIPANTESEMEM);
    return this.http.get(url).pipe(retry(10));
  }

  getParticipanteEmem(id: string) {
    const url = this.dataSnap_Path(this.URL_PARTICIPANTEEMEM) + this.parametro(id);
    return this.http.get(url).pipe(retry(10));
  }

  putParticipanteEmem(datos: string) {
    const url = this.dataSnap_Path(this.URL_PARTICIPANTEEMEM) + this.parametro(this.token);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.put(url, datos, {headers}).pipe(retry(10));
  }

  deleteParticipanteEmem(id: string) {
    const url = this.dataSnap_Path(this.URL_PARTICIPANTEEMEM) + this.parametro(this.token) + this.parametro(id);

    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.delete(url, {headers}).pipe(retry(10));
  }

  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Servicios Eventos
     Obtiene la lista de eventos del EMEM
  =========================================================================================================================*/

  getEventosEMEM() {
    const url = this.dataSnap_Path(this.URL_EVENTOS_EMEM);
    return this.http.get(url, {headers: this.headers});
  }

  getEventoEMEM(IdEvento: string) {
    const url = this.dataSnap_Path(this.URL_EVENTO_EMEM) + this.parametro(IdEvento);
    return this.http.get(url, {headers: this.headers});
  }

  getConferenciasEMEM(IdEvento: string) {
    const url = this.dataSnap_Path(this.URL_CONFERENCIAS_EMEM) + this.parametro(IdEvento);
    return this.http.get(url, {headers: this.headers});
  }

  getPonenciasEMEM(IdEvento: string) {
    const url = this.dataSnap_Path(this.URL_PONENCIAS_EMEM) + this.parametro(IdEvento);
    return this.http.get(url, {headers: this.headers});
  }

  getCronogramaEMEM(IdEvento: string) {
    const url = this.dataSnap_Path(this.URL_CRONOGRAMA_EMEM) + this.parametro(IdEvento);
    return this.http.get(url, {headers: this.headers});
  }

  getOrganizadoresEvento(IdEvento: string) {
    const url = this.dataSnap_Path(this.URL_ORGANIZADORES_EVENTO) + this.parametro(IdEvento);
    return this.http.get(url, {headers: this.headers});
  }

  getParticipanteEvento(Documento: string, IdEvento: string) {
    const url = this.dataSnap_Path(this.URL_PARTICIPANTE_EVENTO) + this.parametro(Documento) + this.parametro(IdEvento);
    return this.http.get(url, {headers: this.headers});
  }

}
