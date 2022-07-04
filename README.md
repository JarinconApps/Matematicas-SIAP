# SIAP: Sistema de información de autoevaluación del programa

Esta aplicación contiene sistemas para organizar la información del programa de licenciatura en matemáticas

## Tareas

1. Ordenar los intervalos de menor a mayor quitas los datos externos o los que no tienen valor y disminuir los meses de duración de trabajos de grado.
2. crear el módulo de exportación de certificados del EMEM
3. Revisar estudiante en transito.
	<p>Los datos que necesita son:</p>
	<ul>
		 <li>postgrado</li>
		 <li>materias una por cada registro, y la nota que se obtiene</li>
		 <li>fecha de inicio</li>
		 <li>fecha de sustentación = fecha de finalización</li>
		 <li>área de profundización</li>
		 <li>agregar la opción de grupo de investigación ninguno</li>
		 <li>Incluir en las gráficas de trabajos de grado</li>
	</ul>
4. Mejorar la combinación de celdas en la exportación a Excel
5. En la exportación PDF reducir el espaciado
6. En la exportación del perfil docente organizar foto, solo poner la fecha de graduación. También agregar Scopus Elsevier
7. Cuando un estudiante se gradua, relacionarlo y enviar la información a la base de datos de graduados.
8. Crear un formato único para todas las pantallas que siempre se pueda encontrar la información de forma fácil
9. Mostrar estados de alerta en trabajos de grado mediante botones.
	<p>Que saque un listado de los trabajos de grado que estan pendientes por entregar el trabajo finalizado.</p>

10. crear el módulo para subir archivos.
	<ul>
	   <li>Sillabus</li>
	   <li>Plan maestro</li>
	   <li>Otros</li>
	   <li>Tesis</li>
	</ul>

	Campos:

	Archivo
	Nombre
	Fecha de Actualización
	Publico?
	Autores

	hacer búsqueda desde trabajos de grado y que se pueda descargar el archivo en formato PDF.

	si no hay archivo, no hay problema con el formulario.
11. Quitar del grafico de trabajos de grado clasificados por calificación final con barras agrupadas por año. Quitar la categoría pendiente.
12. En los reportes mostrar los últimos cuatro semestres.
13. En el gráfico de los ejes misionales por tipo de control quitar la docencia con factor
14. En las barras apiladas en el gráfica (Análisis de Horas) y quitar la docente con factor.
15. En las gráficas quitar la palabra facultad de ... y dejar con mayúscula inicial utilizando en las barras los colores de las facultades.
16. Crear una gráfica para acumulación de porcentajes por semestre y por docente.
17. Ubicar las estadísticas dentro del módulo de trabajos de grado con un botón.
18.    Unificar el estilo de todos los botones de la aplicación
19. Crear un reporte o filtro de trabajos de grado por una ventana de tiempo en los filtros de trabajos de grado.
20. Crear un grafo por área de profundización
21. agregar un botón para activar o desactivar los docentes de los grupos de investigación
22. agregar otro mat-accordion para la producción del grupo, agregar, libros, artículos y demás producción
23. Agregar un botón para descargar la agenda del docente en un periodo de tiempo determinado, que lo puedo redirigir al componente que ya hay para exportar agendas y dejar la opción de firmas al final con un estado booleano
24. en la tabla de seminario hay que agregar las opciones de asistencia:
	<ul>
	   <li>Estudiante nacional, internacional</li>
	   <li>Profesor nacional,internacional</li>
	   <li>Graduados</li>
	   <li></li>
	   <li></li>
	</ul>
25. Descargar el seminario a formato word o excel desde la vista de tabla que se abra desde una ventana de dialogo
26. xportar cada oportunidad del plan de mejoramiento a word, excel y pdf.
27. Agregar los filtros y estadísticas al seminario de licenciatura
28. Crear un reporte de docentes de carrera y contrato con las actividades complementarias que estan desarrollando. Este informe se puede sacar en el menú de agendas. Es un reporte que pone en una tabla a cada profesor con sus respectivos datos y al frente un campo en el cual se puede ingresar un seguimiento. Lo puedo hacer con un modal en el cual pueda editar con el editor-quill
30. Grafo del docente con datos de perfil del docente y una pequeña red de profesionales. 
31. En el componente de gráficos agregar un dialogo para configurar toda la gráfica que se empiecen a agregar muchos tipos de funciones y estoy pensando en crear un el delphi el componente de tipos de gráficas v2.0 para que se exporten y se expongan como servicios y que se puedan descargar o mostrar en vez o en complemento a ng2charts
32. En el grupo de investigación poner las líneas de investigación y dejas así: misión, líneas  y director.
33. En el diagrama de pastel poner los colores y las leyendas en la gráfica, que se vean las etiquetas a la hora de exportar
34. Definir un nuevo formulario para estudiantes en transito y los de prácticas profesionales. Hablar al futuro sobre este cambio con el profesor Hernán Dario.
35. La fuente de las barras de los grupos de investigación en mayúsculas y quitar las barras o estadísticas que estan en cero
36. en las estadísticas de trabajos de grado, permitir descargar cada una de las tablas en formato Word y Excel. Dar el formato de colores y lineas que se le dio al plan de mejoramiento.
37. Crear los roles y los permisos para las personas que entran a la plataforma, que pueden ver y que no
38. En las estadísticas de docentes falta agregar la producción:
	<ul>
		 <li>Artículos</li>
		 <li>Libros</li>
		 <li>Software</li>
		 <li>Proyectos de Extensión</li>
		 <li>Proyectos de Investigación</li>
	</ul>  
39. Crear opción para descargar una copia de seguridad así como se hizo en la plataforma de Olimpiadas
40. Activar de nuevo el botón de exportar trabajos de grado como excel haciendo un método en delphi que lleve todos los datos usando una superconsulta de SQL.
42. A partir del 2022-1  se debe modificar los factores de la agenda de docentes docencia directa 1.0 preparación 1.5, posgrado d.d 1.0 PEA 1.5 y bonificación 2.0. En los ocasionales lo mismo pero la escala es d.d 1.0, PEA 1.0 y Bonificación 2.0
43. ¿Agenda completa no esta guardando?
44. En Cesar no se esta guardando el # del contrato
46. Agregar las nuevas funciones a los docentes (en agendas anteriores conservar las funciones)
47. Cuando se inactiva un docente no se puede exportar los periodos del docente


48. Copiar las funciones del semestre anterior. Pregunar por el docente en un diálogo.
49. Crear una base de datos de prestamos y hacer el inventario de todo lo que hay.
50. En trabajos de grado crear una columna y relacionar con el # del trabajo de grado en físico.
51. Agregar la opción de subir los PDF de los trabajos de grado.
52. Crear tabla en base de datos para la evaluación docente y determinar cuáles son los docentes que necesitan ser evaluados.
53. Hacer un estudio de los estudiantes mediante el PRAEX, el estudio se realiza por cohortes.
54. Subir la productividad de los docentes.
55. Crear página dinámica del EMEM adminstrable desde el SIAP.
56. Actualizar proyecto.

## Actualizaciones

### 3 de Julio de 2022

1. Se arreglo la columna de las aulas en la opción de exportar agenda de docente.
2. Se arreglo el error: Cuando se exporta la agenda de un docente y se regresa siempre empezaba por el primero en la lista (Carlos Alberto Abello Muñoz) se agrego a la ruta de búsqueda el tipo de contrato y el ID del docente.
3. Se arreglo la búsqueda de programas en el Reporte de Servicios por Programa.
4. Se agregaron bordes a las tablas exportadas de Word para el Reporte de Servicios por Programa.
5. En el menú de Reporte de Servicios por Programa se arreglo la opción de que al hacer clic en una materia que esta muy abajo, automáticamente se muestra la parte superior de la página.
6. Se ocultaron los docentes activos y se creó un filtro para la búsqueda.
7. Se organizo la tabla de docentes poniendo debajo de la foto de perfil tres iconos para la edición rápida.

### 11 de Abril de 2022

1. Se arreglo el problema para crear trabajos de grado
2. Se optimizó la búsqueda y lectura de los trabajos de grado.

