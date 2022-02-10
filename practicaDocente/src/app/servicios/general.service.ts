import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { map, retry } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class GeneralService {

  private ENCABEZADO_HTTP = 'http://';
  private IP_SERVIDOR = 'mads.uniquindio.edu.co';
  // private IP_SERVIDOR = 'localhost';
  private PUERTO = ':8080';
  private GENERAL = '/datasnap/rest/tmatematicas/';

  private URL_PERIODOS_PRACTICA = 'PeriodosPractica';
  private URL_ESTUDIANTE = 'Estudiante';


  constructor(private http: HttpClient) { }

  dataSnap_Route(ruta: string) {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + this.PUERTO + this.GENERAL + ruta;
  }

  parametro(dato: string) {
    return '/' + dato;
  }

  getRutaDocumentos() {
    return this.ENCABEZADO_HTTP + this.IP_SERVIDOR + '/siap/DocumentosPractica/';
  }

  getPeriodos() {
    const url = this.dataSnap_Route(this.URL_PERIODOS_PRACTICA);
    return this.http.get(url);
  }

  buscarEstudiante(Documento, Periodo: string) {
    const url = this.dataSnap_Route(this.URL_ESTUDIANTE) + this.parametro(Documento) + this.parametro(Periodo);
    return this.http.get(url);
  }

  guardarEstudiante(datos: string) {
    const url = this.dataSnap_Route(this.URL_ESTUDIANTE);
    const headers = new HttpHeaders({
      'Content-Type': 'application/json'
    });
    return this.http.post(url, datos, {headers});
  }
}
