# README - Base de Datos AprendePeru

## Descripción

Este proyecto contiene la estructura y datos iniciales para una base de datos llamada **aprendePeru**, diseñada para gestionar evaluaciones académicas de estudiantes. La base de datos incluye tablas para estudiantes, evaluaciones, preguntas, alternativas de respuesta, asignaciones de evaluaciones a estudiantes, desarrollos (intentos de evaluación) y respuestas.

---

## Estructura de la base de datos

- **Estudiante:** Información básica de los estudiantes (id, nombre, apellidos, correo).

- **Evaluacion:** Detalles de las evaluaciones (id, título, área, fechas y tiempo).

- **Pregunta:** Preguntas asociadas a cada evaluación, con puntaje asignado.

- **Alternativa:** Opciones de respuesta para cada pregunta, indicando cuál es correcta.

- **Asignacion:** Relación de qué evaluaciones están asignadas a qué estudiantes.

- **Desarrollo:** Registro de cada intento de un estudiante en una evaluación, con puntaje obtenido.

- **Respuesta:** Respuestas dadas por los estudiantes en cada desarrollo.

---

## Requisitos previos

- MySQL o MariaDB instalado.

- Permisos para crear bases de datos y tablas.

- Cliente para ejecutar comandos SQL (MySQL Workbench, terminal, etc.).

---

## Cómo levantar la base de datos

1. Abrir un cliente MySQL.

2. Ejecutar el script SQL proporcionado para crear la base de datos y todas las tablas.

3. Insertar los datos de ejemplo para estudiantes, evaluaciones, preguntas, alternativas y asignaciones.

4. Consultar las tablas para verificar la correcta creación e inserción de datos.

---

## Consultas útiles incluidas

- Contar alumnos desaprobados (puntaje < 6).

- Contar alumnos aprobados en un área específica.

- Obtener resumen de exámenes inscritos, resueltos y pendientes por estudiante.

- Encontrar mejor y peor calificación de una evaluación.

- Calcular promedio de calificaciones de un estudiante.

### Ejemplo de consulta para contar alumnos desaprobados:

```sql
SELECT COUNT(DISTINCT a.idEstudiante) AS alumnos_desaprobados
FROM Desarrollo d
JOIN Asignacion a ON d.idAsignacion = a.idAsignacion
WHERE d.puntajeObtenido < 6;

