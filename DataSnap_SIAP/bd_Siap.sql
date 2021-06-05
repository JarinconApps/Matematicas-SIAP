create table if not exists math_visitas(
	id_visita text primary key not null,
	contador text
);

create table if not exists math_usuario(
	cedula text primary key not null,
	correo text,
	nombre text,
	contra text
);

create table if not exists math_rol(
	id_rol text primary key not null,
	nombre text
);

create table if not exists math_bd_articulos(
	id_articulo text primary key not null,
	titulo text,
	resumen text,
	autores text,
	nombre_revista text,
	volumen text,
	paginas text,
	fecha text,
	objetivos text,
	metodologia text,
	conclusiones text	
);

create table if not exists math_participante_emem(
	cedula text primary key not null,
	correo text,
	nombre text,
	tipo_participacion text,
	contra text
);

create table if not exists math_resumen(
	id_resumen text primary key not null,
	titulo text,
	resumen text,
	linea text,
	tipo text,
	objetivo text,
	capacidad text,
	materiales text,
	prerequisito text,
	requiere_sala text,
	evaluado text,
	nombre_autor text,
	subtitulo text,
	salon text,
	fecha text,
	id_autor text references math_usuario(cedula)
);

create table if not exists math_palabras_clave(
	id_palabra_clave text primary key not null,
	palabra text,
	id_resumen text references math_resumen(id_resumen)
);

create table if not exists math_autor_resumen(
	cedula text primary key not null,
	nombre text,
	correo text,
	institucion text
);

create table if not exists math_resumenes_autor(
	id_resumen_autor serial primary key not null,
	cedula text references math_autor_resumen(cedula),
	id_resumen text references math_resumen(id_resumen)
);

create table if not exists math_bibliografia_resumen(
	id_bibliografia text primary key not null,
	bibliografia text,
	id_resumen text references math_resumen(id_resumen)
);

create table if not exists math_resumen_participante(
	id_participante text primary key not null,
	id_resumen text references math_resumen(id_resumen)
);

create table if not exists siap_tipo_contrato(
	idtipocontrato text primary key not null,
	contrato text
);
alter table siap_tipo_contrato add column horas text;

create table if not exists siap_categoria_docentes(
	idcategoriadocente text primary key not null,
	categoria text
);

/* Tabla de Docent es */
-- drop table siap_docentes
create table if not exists siap_docentes (
	iddocente integer primary key not null,
	nombre text,
	correo text,
	telefono text,
	vinculacion text,
	institucion text,
	idcategoriadocente text references siap_categoria_docentes(idcategoriadocente),
	idtipocontrato text references siap_tipo_contrato(idtipocontrato)
); 
alter table siap_docentes add column activo text;
alter table siap_docentes add column documento text;
alter table siap_docentes add column vinculacion text;
alter table siap_docentes add column institucion text;

create table if not exists siap_formacion (
	idformacion text primary key not null,
	titulo text,
	fechainicio text,
	fechafin text,
	institucion text,
	iddocente integer references siap_docentes(iddocente)
);

/* Tabla de Errores: Permite registrar los errores de la aplicación
   y mostrarlos mediante un servicio */
create table if not exists siap_errores(
	iderror text primary key not null,
	hora text,
	fecha text,
	procedimiento text,
	mensaje text
);

/*Tabla para Facultad*/
create table if not exists siap_facultades(
       idfacultad text primary key not null,
       facultad text,
	   color text,
	   nombrecorto text,
	   orden integer
);
-- alter table siap_facultades add column color text;
-- alter table siap_facultades add column nombrecorto text;
-- alter table siap_facultades add column orden integer;

/*Tabla para Programa*/
create table if not exists siap_programas(
       idprograma text primary key not null,
       programa text,
       idfacultad text references siap_facultades(idfacultad)
);

/*Tabla para ServicioPrograma*/
-- drop table siap_servicios_programas
create table if not exists siap_servicios_programas(
       idservicioprograma text primary key not null,
       asignatura text,
       idprograma text references siap_programas(idprograma),
       horas integer,
       aulas text,
       periodo text
);
alter table siap_servicios_programas add column jornada text;
alter table siap_servicios_programas add column grupo text;
alter table siap_servicios_programas add column semanas text;
alter table siap_servicios_programas add column tipo text;

/*Tabla para HorarioServicio*/
create table if not exists siap_horarios_servicios(
       idhorarioservicio text primary key not null,
       dia text,
       inicio text,
       fin text,
       idservicioprograma text references siap_servicios_programas(idservicioprograma)
);
alter table siap_horarios_servicios add column salon text;

/*Tabla para AgendaServicio*/
create table if not exists siap_agendas_servicios(
       idagendaservicio text primary key not null,
       iddocente integer references siap_docentes(iddocente),
       idservicioprograma text references siap_servicios_programas(idservicioprograma),
       periodo text
);
-- alter table siap_agendas_servicios add column numerocontrato text;
-- alter table siap_agendas_servicios add column actaprograma text;
-- alter table siap_agendas_servicios add column actafacultad text;
-- alter table siap_agendas_servicios add column concertada text;
-- alter table siap_agendas_servicios add column completada text;

/*Tabla para Configuracion*/
create table if not exists siap_configuraciones(
       idconfiguracion text primary key not null,
       nombredirector text,
       nombredecano text,
       semanassemestre text
);

/* Tabla de funciones de docentes */
create table if not exists siap_funciones_docentes(
	idfunciondocente text primary key not null,
	funcion text
);

/* Tabla de Actividades de Docentes */
create table if not exists siap_actividades_docentes(
	idactividaddocente text primary key not null,
	actividad text,
	idfunciondocente text references siap_funciones_docentes(idfunciondocente)
);

/* Tabla de subactividades de docentes */
create table if not exists siap_subactividades_docentes(
	idsubactividaddocente text primary key not null,
	subactividad text,
	idactividaddocente text references siap_actividades_docentes(idactividaddocente)
);

/* Tablas para el Evento Workshop EMEM*/

create table if not exists emem_afiliaciones(
	idafiliacion text primary key not null,
	afiliacion text
);

/*Tabla para Participante*/
create table if not exists emem_participantes(
       idparticipante text primary key not null,
       primernombre text,
       segundonombre text,
       primerapellido text,
       segundoapellido text,
       correo text,
       contra text,
       idafiliacion text references emem_afiliaciones(idafiliacion)
);

/*Tabla para Egresado*/
create table if not exists siap_egresados(
       idegresado text primary key not null,
       nombre text,
       celular text,
       correo text,
       esegresado text,
       fecha text,
       gradoescolaridad text,
       secretaria text,
       institucion text,
       municipio text,
       cargo text,
       nivellabora text
);

/*Tabla para GrupoInvestigacion*/
create table if not exists siap_gruposinvestigacion(
       idgrupoinvestigacion text primary key not null,
       nombre text,
       sigla text,
       iddirector integer references siap_docentes(iddocente),
       mision text,
       vision text
);

/*Tabla para Modalidad*/
create table if not exists siap_modalidades(
       idmodalidad text primary key not null,
       nombre text
);

/*Tabla para AreaProfundizacion*/
create table if not exists siap_areasprofundizacion(
       idareaprofundizacion text primary key not null,
       nombre text
);

/*Tabla para TrabajoGrado*/
create table if not exists siap_trabajosgrado(
       idtrabajogrado text primary key not null,
       titulo text,
       estudiante1 text,
       estudiante2 text,
       estudiante3 text,
	   estudiante1_tm text,
	   estudiante1_tm text,
	   estudiante1_tm text,
       idjurado1 integer references siap_docentes(iddocente),
       idjurado2 integer references siap_docentes(iddocente),
       idjurado3 integer references siap_docentes(iddocente),
       iddirector integer references siap_docentes(iddocente),
	   idcodirector integer references siap_docentes(iddocente),
       idmodalidad text references siap_modalidades(idmodalidad),
       idareaprofundizacion text references siap_areasprofundizacion(idareaprofundizacion),
       idgrupoinvestigacion text references siap_gruposinvestigacion(idgrupoinvestigacion),
       actanombramientojurados text,	   
       actapropuesta text,
	   evaluacionpropuesta text,
	   evaluaciontrabajoescrito text,
	   evaluacionsustentacion text,
       fechasustentacion text,
       calificacionfinal text,
       estudiantecedederechos text,
	   fechainicioejecucion text,
	   cantidadsemestresejecucion integer,
	   estadoproyecto text
);

/*Tabla para Periodo*/
create table if not exists siap_periodos(
       idperiodo text primary key not null,
       periodo text,
	   hormaxcarrera integer,
	   hormaxcontrato integer,
	   hormaxcatedratico integer
);
-- alter table siap_periodos add column hormaxcarrera integer;
-- alter table siap_periodos add column hormaxcontrato integer;
-- alter table siap_periodos add column hormaxcatedratico integer;

/*Tabla para ActividadFuncionDocente*/
create table if not exists siap_actividades_funciones_docente(
       idactividadprograma text primary key not null,
       idfuncion text references siap_funciones_docentes(idfunciondocente),
       idactividad text references siap_actividades_docentes(idactividaddocente),
       idsubactividad text references siap_subactividades_docentes(idsubactividaddocente),
       actividad text,
       iddocente integer references siap_docentes(iddocente),
       periodo text,
       horas integer,
	   calculada text
);
-- alter table siap_actividades_funciones_docente add column calculada text;

/*Tabla para Favorito*/
create table if not exists siap_favoritos(
       idfavorito text primary key not null,
       titulo text,
       icono text,
       ruta text,
       frecuencia integer
);

/* Tabla para los factores de calidad */
create table if not exists siap_factor_calidad_pm(
	idfactorcalidad text primary key not null,
	factor text,
	orden integer
);

-- alter table siap_factor_calidad_pm add column orden integer

/* Requisito para el plan de mejoramiento */
create table if not exists siap_requisito_pm(
	idrequisito text primary key not null,
	requisito text
);

/* Tipo de Acción en el plan de mejoramiento */
create table if not exists siap_tipo_accion_pm(
	idtipoaccion text primary key not null,
	tipo_accion text
);

/* Fuente de dónde proviene el plan de mejoramiento*/
create table if not exists siap_fuente_pm(
	idfuente text primary key not null,
	fuente text
);

/* Tabla para el plan de mejoramiento */
create table if not exists siap_plan_mejoramiento(
	idplan text primary key  not null,
	orden integer,
	idfuente text references siap_fuente_pm(idfuente),
	idfactorcalidad text references siap_factor_calidad_pm(idfactorcalidad),
	idrequisito text references siap_requisito_pm(idrequisito),
	descripcion_mejora text,
	idtipoaccion text references siap_tipo_accion_pm(idtipoaccion),
	causas_principales text,
	metas text,
	fecha_inicio date,
	fecha_fin date,
	actividades text,
	responsable_ejecucion text,
	responsable_seguimiento text,
	indicador_meta text,
	formula_indicador text,
	resultado_indicador text,
	avance_meta text,
	seguimiento text,
	observaciones text,
	estado_actual_accion text	
);

create table if not exists siap_grupos_docente(
	idgrupodocente text primary key not null,
	iddocente integer references siap_docentes(iddocente),
	idgrupoinvestigacion text references siap_gruposinvestigacion(idgrupoinvestigacion),
	fechaingreso text
);

create table if not exists siap_tipo_produccion(
	idtipo text primary key not null,
	tipo text
);

create table if not exists siap_produccion_docente(
	idproduccion text primary key not null,
	idtipo text references siap_tipo_produccion(idtipo),
	titulo text,
	isbn text,
	issn text,
	editorial text,
	revista text,
	fecha date,
	ciudad text,
	volumen text,
	numero text,
	registro text,
	fecha_inicio date,
	fecha_fin date,
	institucion text,
	iddocente integer references siap_docentes(iddocente)
);







