import { Component, Input, OnInit, Output, EventEmitter, SimpleChange, OnChanges } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Component({
  selector: 'app-date-picker',
  templateUrl: './date-picker.component.html',
  styles: []
})
export class DatePickerComponent implements OnInit, OnChanges {

  Dias: string[] = ['01', '02', '03', '04', '05', '06', '07', '08', '09'];
  Meses: any[] = [
    {mes: 'Enero', id: '01'},
    {mes: 'Febrero', id: '02'},
    {mes: 'Marzo', id: '03'},
    {mes: 'Abril', id: '04'},
    {mes: 'Mayo', id: '05'},
    {mes: 'Junio', id: '06'},
    {mes: 'Julio', id: '07'},
    {mes: 'Agosto', id: '08'},
    {mes: 'Septiembre', id: '09'},
    {mes: 'Octubre', id: '10'},
    {mes: 'Noviembre', id: '11'},
    {mes: 'Diciembre', id: '12'}];

  Anos: string[] = [];

  dd = '20';
  mm: any = {mes: 'Agosto', id: '08'};
  aa = '2000';

  @Input() Fecha = '2000-08-20';
  @Output() CambioFecha: EventEmitter<string> = new EventEmitter<string>();

  constructor() { }

  ngOnInit() {
    for (let i = 10; i < 32; i++) {
      this.Dias.push(i.toString());
    }

    for (let i = 1980; i < 2099; i++) {
      this.Anos.push(i.toString());
    }
  }

  formatearFecha() {

    this.Fecha = this.aa + '-' + this.mm.id + '-' + this.dd;

    this.CambioFecha.emit(this.Fecha);
  }

  ngOnChanges(changes: { [property: string]: SimpleChange }) {

    console.log(changes.Fecha.currentValue);
    if (changes.Fecha.currentValue === undefined) {
      this.Fecha = '2020-08-20';
    } else {
      this.Fecha = changes.Fecha.currentValue;
    }

    const datos: string[] = this.Fecha.split('-');
    this.dd = datos[2];

    for (const mes of this.Meses) {
      if (mes.id === datos[1]) {
        this.mm = mes;
      }
    }

    this.aa = datos[0];
  }

}
