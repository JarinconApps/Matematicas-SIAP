import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'tiempo'
})
export class TiempoPipe implements PipeTransform {

  transform(value: number): string {
    if (value < 1000) {
      return value + ' ms';
    } else {
      return (value / 1000) + ' s';
    }
  }

}
