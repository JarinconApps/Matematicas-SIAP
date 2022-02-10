import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { RUTA_INICIO } from './config/config';
import { InicioComponent } from './componentes/inicio/inicio.component';

const routes: Routes = [
  {path: RUTA_INICIO, component: InicioComponent},
  {path: '**', pathMatch: 'full', redirectTo: RUTA_INICIO}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
