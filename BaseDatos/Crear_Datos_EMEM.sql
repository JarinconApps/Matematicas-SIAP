-- Crear conferencista
INSERT INTO emen_conferencistas (IdConferencista, Nombre, Correo, Institucion) VALUES (
	'6kUat3wL-FVNr-comA-VpXoFMb37I1C',
	'Dra. Liliana Mabel Tauber',
	'estadisticamatematicafhuc@gmail.com',
	'Universidad Nacional del Litoral - Argentina'
);

-- Crear Biografia
INSERT INTO emem_biografia_conferencista (IdBiografia, Biografia, Orden, IdConferencista) VALUES (
	'lR4cLQBo-d5dI-zmYD-rs9lUAJCX9sD',
	'Profesora en Matemática Universidad Nacional del Litoral - Argentina',
	2,
	'6kUat3wL-FVNr-comA-VpXoFMb37I1C'
);

-- Crear conferencia
INSERT INTO emem_conferencias (IdConferencia, Titulo, IdConferencista, Resumen, IdEvento, IdModalidad, Tipo) VALUES (
	'v2UemK7s-oeh3-KvJI-4RId7li8f4N1',
	'Propuestas para la formación de ciudadanos estadísticamente cultos',
	'6kUat3wL-FVNr-comA-VpXoFMb37I1C',
	'En las últimas décadas, la enseñanza de la Estocástica ha sufrido diversas transformaciones como consecuencia de la evolución de las nuevas tecnologías que aceleraron los procesos de análisis de datos a gran escala. De manera contradictoria, estos avances no quedan plasmados aún de manera adecuada en las reformas educativas del Nivel Secundario y en la formación de profesores, ya que el enfoque que se propone deja de lado el estudio de las ideas fundamentales de la Estadística, como lo son los datos, la variación y la aleatoriedad. Es así que en esta charla, pretendo mostrar algunas situaciones de aula que permiten procesos de enseñanza y de aprendizaje de la Estadística, desde un enfoque centrado en el desarrollo de las ideas fundamentales y en la formación de ciudadanos críticos. ',
	'evento-2020',
	'F7OgnLzn-UR2F-TVgk-53PdR5mymQKU',
	'PONENCIA'
);

-- Ver Conferencistas
SELECT * FROM emen_conferencistas

-- Ver Biografia
SELECT * FROM emem_biografia_conferencista WHERE IdConferencista='N8Kf0hJO-ttAQ-kn16-l3POBpVBceN5' ORDER BY Orden

-- Ver Conferencias
SELECT * FROM emem_conferencias

-- Ver Modalidades
SELECT * FROM emem_modalidades