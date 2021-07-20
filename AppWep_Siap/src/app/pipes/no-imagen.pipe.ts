import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'noImagen'
})
export class NoImagenPipe implements PipeTransform {

  transform(value: string): string {

    if (!value || value === 'El Archivo No Existe') {
      return 'assets/Imagenes/noImagen.jpg';
    } else {
      return value;
    }
  }

}
