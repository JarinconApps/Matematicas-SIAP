import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

// Angular Material
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import { MatDialogModule } from '@angular/material/dialog';
import {MatSnackBarModule} from '@angular/material/snack-bar';
import {MatCheckboxModule} from '@angular/material/checkbox';
import {MatExpansionModule} from '@angular/material/expansion';

// Graficos
import { ChartsModule } from 'ng2-charts';

import { AppComponent } from './app.component';
import { routingModule } from './app.router';


import { CapitalizadoPipe } from './Pipes/capitalizado.pipe';
import { DomSeguroPipe } from './Pipes/dom-seguro.pipe';
import { LongitudTextoPipe } from './Pipes/longitud-texto.pipe';
import { HeaderComponent } from './componentes/header/header.component';
import { FooterComponent } from './componentes/footer/footer.component';
import { NgDropFilesDirective } from './Directivas/ng-drop-files.directive';
import { InicioComponent } from './componentes/inicio/inicio.component';
import { ModalidadesComponent } from './componentes/modalidades/modalidades.component';
import { InscripcionesComponent } from './componentes/inscripciones/inscripciones.component';
import { AfiliacionesComponent } from './componentes/administrar/afiliaciones/afiliaciones.component';
import { DlgAfiliacionComponent } from './componentes/administrar/afiliaciones/dlg-afiliacion/dlg-afiliacion.component';
import { SnackbarComponent } from './dialogos/snackbar/snackbar.component';
import { ConfirmacionComponent } from './dialogos/confirmacion/confirmacion.component';
import { AdministrarComponent } from './componentes/administrar/administrar.component';
import { ParticipantesEmemComponent } from './componentes/administrar/participantes-emem/participantes-emem.component';
import { DlgParticipanteEmemComponent } from './componentes/administrar/participantes-emem/dlg-participante-emem/dlg-participante-emem.component';
import { ConcursoComponent } from './componentes/concurso/concurso.component';
import { PonenciasComponent } from './componentes/ponencias/ponencias.component';
import { ContactoComponent } from './componentes/contacto/contacto.component';
import { ProgramacionComponent } from './componentes/programacion/programacion.component';
import { EventoComponent } from './componentes/evento/evento.component';
import { DescripcionEventoComponent } from './componentes/descripcion-evento/descripcion-evento.component';
import { VerParticipanteComponent } from './componentes/inscripciones/ver-participante/ver-participante.component';


@NgModule({
  declarations: [
    AppComponent,
    CapitalizadoPipe,
    DomSeguroPipe,
    LongitudTextoPipe,
    HeaderComponent,
    FooterComponent,
    NgDropFilesDirective,
    InicioComponent,
    ModalidadesComponent,
    InscripcionesComponent,
    AfiliacionesComponent,
    DlgAfiliacionComponent,
    SnackbarComponent,
    ConfirmacionComponent,
    AdministrarComponent,
    ParticipantesEmemComponent,
    DlgParticipanteEmemComponent,
    ConcursoComponent,
    PonenciasComponent,
    ContactoComponent,
    ProgramacionComponent,
    EventoComponent,
    DescripcionEventoComponent,
    VerParticipanteComponent
  ],
  imports: [
    BrowserModule,
    routingModule,
    BrowserAnimationsModule,
    FormsModule,
    HttpClientModule,
    MatDialogModule,
    MatSnackBarModule,
    ChartsModule,
    MatCheckboxModule,
    MatExpansionModule
  ],
  entryComponents: [
    DlgAfiliacionComponent,
    DlgParticipanteEmemComponent,
    SnackbarComponent,
    VerParticipanteComponent
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
