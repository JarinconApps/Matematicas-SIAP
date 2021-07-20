import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { GeneralService } from './general.service';
import { TransferService } from './transfer.service';

@Injectable({
  providedIn: 'root'
})
export class RutaNavegarService {

  constructor(private genService: GeneralService) {

  }

  canActivate() {
    return true;
    return this.genService.obtenerPermisoNavegar();
  }
}
