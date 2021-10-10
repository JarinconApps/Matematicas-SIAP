import { Directive, EventEmitter, ElementRef, HostListener, Input, Output } from '@angular/core';

@Directive({
  selector: '[appNgDropFiles]'
})
export class NgDropFilesDirective {

  @Output() mouseSobre: EventEmitter<boolean> = new EventEmitter();

  constructor() { }

  @HostListener('dragover', ['$event'])
  public onDragEnter(event: any) {
    this.mouseSobre.emit(true);
    this.prevenirDetener(event);
  }

  @HostListener('dragleave', ['$event'])
  public onDragLeave(event: any) {
    this.mouseSobre.emit(false);
  }

  @HostListener('drop', ['$event'])
  public onDrop(event: any) {


    const transferencia = this.obtenerTransferencia(event);

    if (!transferencia) {
      return;
    }

    this.extraerArchivos(transferencia.files);
    this.prevenirDetener(event);

    this.mouseSobre.emit(false);
  }

  private obtenerTransferencia(event: any) {
    return event.dataTransfer ? event.dataTransfer : event.originalEvent.dataTransfer;
  }

  private extraerArchivos(listaArchivo: FileList) {

    // tslint:disable-next-line:forin
    for (const propiedad in Object.getOwnPropertyNames(listaArchivo)) {
      const archivoTemporal = listaArchivo[propiedad];

      if (this.cargarImagen(archivoTemporal)) {

      }
    }
  }

  // Validaciones

  private cargarImagen(archivo: File): boolean {
    if (this.esImagen(archivo.type)) {
      return true;
    } else {
      return false;
    }
  }

  private prevenirDetener( event ) {
    event.preventDefault();
    event.stopPropagation();
  }

  private esImagen(tipoArchivo: string): boolean {
    return (tipoArchivo === '' || tipoArchivo === undefined) ? false : tipoArchivo.startsWith('image');
  }

}
