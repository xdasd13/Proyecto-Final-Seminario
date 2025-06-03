CREATE DATABASE aprendePeru;
USE aprendePeru;

-- Tabla Estudiante
CREATE TABLE Estudiante (
    idEstudiante INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL
) ENGINE = InnoDB;

-- Tabla Evaluacion
CREATE TABLE Evaluacion (
    idEvaluacion INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    tipoArea VARCHAR(50) NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    tiempoMinutos INT NOT NULL
) ENGINE = InnoDB;

-- Tabla Pregunta
CREATE TABLE Pregunta (
    idPregunta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idEvaluacion INT NOT NULL,
    enunciado TEXT NOT NULL,
    puntaje DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (idEvaluacion) REFERENCES Evaluacion(idEvaluacion)
) ENGINE = InnoDB;

-- Tabla Alternativa
CREATE TABLE Alternativa (
    idAlternativa INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idPregunta INT NOT NULL,
    texto TEXT NOT NULL,
    esCorrecta TINYINT(1) NOT NULL,
    FOREIGN KEY (idPregunta) REFERENCES Pregunta(idPregunta)
) ENGINE = InnoDB;

-- Tabla Asignacion
CREATE TABLE Asignacion (
    idAsignacion INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idEstudiante INT NOT NULL,
    idEvaluacion INT NOT NULL,
    UNIQUE(idEstudiante, idEvaluacion),
    FOREIGN KEY (idEstudiante) REFERENCES Estudiante(idEstudiante),
    FOREIGN KEY (idEvaluacion) REFERENCES Evaluacion(idEvaluacion)
) ENGINE = InnoDB;

-- Tabla Desarrollo
CREATE TABLE Desarrollo (
    idDesarrollo INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idAsignacion INT NOT NULL,
    fechaHoraInicio TIMESTAMP NOT NULL,
    fechaHoraFin TIMESTAMP NULL DEFAULT NULL,
    puntajeObtenido DECIMAL(5,2) DEFAULT NULL,
    FOREIGN KEY (idAsignacion) REFERENCES Asignacion(idAsignacion)
) ENGINE = InnoDB;

-- Tabla Respuesta
CREATE TABLE Respuesta (
    idRespuesta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    idDesarrollo INT NOT NULL,
    idPregunta INT NOT NULL,
    idAlternativaMarcada INT NOT NULL,
    FOREIGN KEY (idDesarrollo) REFERENCES Desarrollo(idDesarrollo),
    FOREIGN KEY (idPregunta) REFERENCES Pregunta(idPregunta),
    FOREIGN KEY (idAlternativaMarcada) REFERENCES Alternativa(idAlternativa)
) ENGINE = InnoDB;


-- Estudiantes
INSERT INTO Estudiante (nombre, apellidos, correo) VALUES
('Ana', 'Pérez', 'ana.perez@gmail.com'),
('Luis', 'García', 'luis.garcia@gmail.com'),
('María', 'López', 'maria.lopez@gmail.com'),
('Jorge', 'Ramírez', 'jorge.ramirez@gmail.com'),
('Sofía', 'Martínez', 'sofia.martinez@gmail.com'),
('Carlos', 'Sánchez', 'carlos.sanchez@gmail.com'),
('Lucía', 'Hernández', 'lucia.hernandez@gmail.com'),
('Pedro', 'Gómez', 'pedro.gomez@gmail.com'),
('Elena', 'Torres', 'elena.torres@gmail.com'),
('Diego', 'Flores', 'diego.flores@gmail.com');

SELECT * FROM Estudiante;

-- Inserciones para la tabla "Evaluacion"
INSERT INTO Evaluacion (titulo, tipoArea, fechaInicio, fechaFin, tiempoMinutos) VALUES
('Evaluación 1', 'Matemáticas', '2025-05-01', '2025-05-02', 45),
('Evaluación 2', 'Historia', '2025-05-03', '2025-05-04', 60),
('Evaluación 3', 'Ciencias', '2025-05-05', '2025-05-06', 30),
('Evaluación 4', 'Lenguaje', '2025-05-07', '2025-05-08', 45),
('Evaluación 5', 'Inglés', '2025-05-09', '2025-05-10', 60);

SELECT * FROM Evaluacion;

-- Evaluación 1 (Matemáticas)
INSERT INTO Pregunta (idEvaluacion, enunciado, puntaje) VALUES
(1, '¿Cuál es la raíz cuadrada de 16?', 2.0),
(1, '¿Cuánto es 7 x 6?', 2.0),
(1, '¿Cuál es el número primo más pequeño?', 2.0),
(1, '¿Cuánto es 15 dividido entre 3?', 2.0),
(1, '¿Qué número falta en la serie 2, 4, __, 8?', 2.0);

-- Evaluación 2 (Historia)
INSERT INTO Pregunta (idEvaluacion, enunciado, puntaje) VALUES
(2, '¿En qué año inició la Segunda Guerra Mundial?', 3.0),
(2, '¿Quién fue Cristóbal Colón?', 3.0),
(2, '¿Cuál es la capital de Francia?', 3.0),
(2, '¿Qué imperio construyó Machu Picchu?', 3.0),
(2, '¿Quién escribió "La Odisea"?', 3.0);

-- Evaluación 3 (Ciencias)
INSERT INTO Pregunta (idEvaluacion, enunciado, puntaje) VALUES
(3, '¿Cuál es el símbolo químico del agua?', 2.5),
(3, '¿Qué planeta es conocido como el planeta rojo?', 2.5),
(3, '¿Qué órgano bombea sangre en el cuerpo?', 2.5),
(3, '¿Qué gas respiramos para vivir?', 2.5),
(3, '¿Qué fuerza mantiene los planetas en órbita?', 2.5);

-- Evaluación 4 (Lenguaje)
INSERT INTO Pregunta (idEvaluacion, enunciado, puntaje) VALUES
(4, '¿Cuál es el sinónimo de "rápido"?', 2.0),
(4, '¿Qué es un sustantivo?', 2.0),
(4, '¿Cómo se llama la primera letra del alfabeto?', 2.0),
(4, '¿Qué tipo de palabra es "amarillo"?', 2.0),
(4, '¿Cuál es el antónimo de "feliz"?', 2.0);

-- Evaluación 5 (Inglés)
INSERT INTO Pregunta (idEvaluacion, enunciado, puntaje) VALUES
(5, 'How do you say "Hello" in Spanish?', 3.0),
(5, 'What is the past tense of "go"?', 3.0),
(5, 'What color is the sky?', 3.0),
(5, 'How many days are in a week?', 3.0),
(5, 'What is the plural of "mouse"?', 3.0);

SELECT * FROM Pregunta;

-- Alternativas
-- Matematicas
-- Pregunta 1: ¿Cuál es la raíz cuadrada de 16?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(1, '2', 0),
(1, '4', 1),   -- Correcta
(1, '8', 0),
(1, '16', 0);

-- Pregunta 2: ¿Cuánto es 7 x 6?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(2, '42', 1),  -- Correcta
(2, '36', 0),
(2, '48', 0),
(2, '40', 0);

-- Pregunta 3: ¿Cuál es el número primo más pequeño?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(3, '1', 0),
(3, '2', 1),   -- Correcta
(3, '3', 0),
(3, '4', 0);

-- Pregunta 4: ¿Cuánto es 15 dividido entre 3?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(4, '5', 1),   -- Correcta
(4, '6', 0),
(4, '4', 0),
(4, '3', 0);

-- Pregunta 5: ¿Qué número falta en la serie 2, 4, __, 8?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(5, '5', 0),
(5, '6', 1),   -- Correcta
(5, '7', 0),
(5, '8', 0);

-- Historia
-- Pregunta 6: ¿En qué año inició la Segunda Guerra Mundial?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(6, '1939', 1),  -- Correcta
(6, '1914', 0),
(6, '1945', 0),
(6, '1929', 0);

-- Pregunta 7: ¿Quién fue Cristóbal Colón?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(7, 'Explorador que descubrió América', 1),  -- Correcta
(7, 'Rey de España', 0),
(7, 'Conquistador Azteca', 0),
(7, 'Navegante portugués', 0);

-- Pregunta 8: ¿Cuál es la capital de Francia?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(8, 'Londres', 0),
(8, 'París', 1),  -- Correcta
(8, 'Madrid', 0),
(8, 'Berlín', 0);

-- Pregunta 9: ¿Qué imperio construyó Machu Picchu?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(9, 'Inca', 1),  -- Correcta
(9, 'Azteca', 0),
(9, 'Maya', 0),
(9, 'Olmeca', 0);

-- Pregunta 10: ¿Quién escribió "La Odisea"?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(10, 'Homero', 1),  -- Correcta
(10, 'Sócrates', 0),
(10, 'Platón', 0),
(10, 'Aristóteles', 0);

-- Cinecias
-- Pregunta 11: ¿Cuál es el símbolo químico del agua?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(11, 'O2', 0),
(11, 'H2O', 1),  -- Correcta
(11, 'CO2', 0),
(11, 'NaCl', 0);

-- Pregunta 12: ¿Qué planeta es conocido como el planeta rojo?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(12, 'Venus', 0),
(12, 'Marte', 1),  -- Correcta
(12, 'Júpiter', 0),
(12, 'Saturno', 0);

-- Pregunta 13: ¿Qué órgano bombea sangre en el cuerpo?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(13, 'Pulmones', 0),
(13, 'Riñones', 0),
(13, 'Corazón', 1),  -- Correcta
(13, 'Hígado', 0);

-- Pregunta 14: ¿Qué gas respiramos para vivir?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(14, 'Dióxido de carbono', 0),
(14, 'Oxígeno', 1),  -- Correcta
(14, 'Nitrógeno', 0),
(14, 'Helio', 0);

-- Pregunta 15: ¿Qué fuerza mantiene los planetas en órbita?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(15, 'Magnetismo', 0),
(15, 'Electricidad', 0),
(15, 'Gravedad', 1),  -- Correcta
(15, 'Fuerza nuclear', 0);

-- Lenguaje
-- Pregunta 16: ¿Cuál es el sinónimo de "rápido"?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(16, 'Lento', 0),
(16, 'Veloz', 1),  -- Correcta
(16, 'Fácil', 0),
(16, 'Tarde', 0);

-- Pregunta 17: ¿Qué es un sustantivo?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(17, 'Una persona, lugar o cosa', 1),  -- Correcta
(17, 'Una acción', 0),
(17, 'Un adjetivo', 0),
(17, 'Un verbo', 0);

-- Pregunta 18: ¿Cómo se llama la primera letra del alfabeto?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(18, 'B', 0),
(18, 'A', 1),  -- Correcta
(18, 'Z', 0),
(18, 'M', 0);

-- Pregunta 19: ¿Qué tipo de palabra es "amarillo"?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(19, 'Sustantivo', 0),
(19, 'Verbo', 0),
(19, 'Adjetivo', 1),  -- Correcta
(19, 'Adverbio', 0);

-- Pregunta 20: ¿Cuál es el antónimo de "feliz"?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(20, 'Contento', 0),
(20, 'Triste', 1),  -- Correcta
(20, 'Alegre', 0),
(20, 'Emocionado', 0);

-- Ingles
-- Pregunta 21: How do you say "Hello" in Spanish?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(21, 'Hola', 1),  -- Correcta
(21, 'Adiós', 0),
(21, 'Gracias', 0),
(21, 'Por favor', 0);

-- Pregunta 22: What is the past tense of "go"?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(22, 'Went', 1),  -- Correcta
(22, 'Goed', 0),
(22, 'Going', 0),
(22, 'Gone', 0);

-- Pregunta 23: What color is the sky?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(23, 'Blue', 1),  -- Correcta
(23, 'Green', 0),
(23, 'Red', 0),
(23, 'Yellow', 0);

-- Pregunta 24: How many days are in a week?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(24, '5', 0),
(24, '7', 1),  -- Correcta
(24, '10', 0),
(24, '12', 0);

-- Pregunta 25: What is the plural of "mouse"?
INSERT INTO Alternativa (idPregunta, texto, esCorrecta) VALUES
(25, 'Mouses', 0),
(25, 'Mice', 1),  -- Correcta
(25, 'Mousees', 0),
(25, 'Mousies', 0);

-- Asignaciones
-- Alumnos asignados a 3 evaluaciones (evaluaciones 1, 2 y 3)
INSERT INTO Asignacion (idEstudiante, idEvaluacion) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2), (2, 3),
(3, 1), (3, 2), (3, 3),
(4, 1), (4, 2), (4, 3);

-- Alumnos asignados a 2 evaluaciones (evaluaciones 4 y 5)
INSERT INTO Asignacion (idEstudiante, idEvaluacion) VALUES
(5, 4), (5, 5),
(6, 4), (6, 5),
(7, 4), (7, 5);

-- Alumnos 8, 9 y 10 sin asignaciones (no se insertan registros)


-- Alumno 8, idDesarrollo = 19 y 20
-- Evaluación 2 (idDesarrollo = 19), puntaje total 8.0 / 10
INSERT INTO Respuesta (idDesarrollo, idPregunta, respuestaTexto, puntaje) VALUES
(19, 4, 'Respuesta correcta A', 6.0),    -- 3.0 * 2
(19, 5, 'Respuesta correcta B', 6.0),    -- 3.0 * 2
(19, 6, 'Respuesta parcialmente correcta C', 4.0);  -- 2.0 * 2

-- Evaluación 4 (idDesarrollo = 20), puntaje total 5.0 / 10
INSERT INTO Respuesta (idDesarrollo, idPregunta, respuestaTexto, puntaje) VALUES
(20, 10, 'Respuesta incorrecta D', 2.0),  -- 1.0 * 2
(20, 11, 'Respuesta parcialmente correcta E', 4.0), -- 2.0 * 2
(20, 12, 'Respuesta incorrecta F', 4.0);  -- 2.0 * 2

-- Alumno 9, idDesarrollo = 21 y 22
-- Evaluación 2 (21), puntaje total 4.0 / 10
INSERT INTO Respuesta (idDesarrollo, idPregunta, respuestaTexto, puntaje) VALUES
(21, 4, 'Respuesta incorrecta A', 2.0),  -- 1.0 * 2
(21, 5, 'Respuesta incorrecta B', 3.0),  -- 1.5 * 2
(21, 6, 'Respuesta parcialmente correcta C', 3.0); -- 1.5 * 2

-- Evaluación 4 (22), puntaje total 3.5 / 10
INSERT INTO Respuesta (idDesarrollo, idPregunta, respuestaTexto, puntaje) VALUES
(22, 10, 'Respuesta incorrecta D', 2.0),  -- 1.0 * 2
(22, 11, 'Respuesta incorrecta E', 2.0),  -- 1.0 * 2
(22, 12, 'Respuesta parcialmente correcta F', 3.0); -- 1.5 * 2

-- Alumno 10, idDesarrollo = 23 y 24
-- Evaluación 2 (23), puntaje total 9.0 / 10
INSERT INTO Respuesta (idDesarrollo, idPregunta, respuestaTexto, puntaje) VALUES
(23, 4, 'Respuesta correcta A', 8.0),   -- 4.0 * 2
(23, 5, 'Respuesta correcta B', 7.0),   -- 3.5 * 2
(23, 6, 'Respuesta correcta C', 3.0);   -- 1.5 * 2

-- Evaluación 4 (24), puntaje total 8.5 / 10
INSERT INTO Respuesta (idDesarrollo, idPregunta, respuestaTexto, puntaje) VALUES
(24, 10, 'Respuesta correcta D', 6.0),  -- 3.0 * 2
(24, 11, 'Respuesta correcta E', 7.0),  -- 3.5 * 2
(24, 12, 'Respuesta parcialmente correcta F', 4.0); -- 2.0 * 2

-- Consultas
-- a. ¿Cuántos alumnos desaprobados tenemos en total?
SELECT COUNT(DISTINCT a.idEstudiante) AS alumnos_desaprobados
FROM Desarrollo d
JOIN Asignacion a ON d.idAsignacion = a.idAsignacion
WHERE d.puntajeObtenido < 6;


-- b. ¿Cuántos alumnos aprobados en un determinado curso tenemos?
-- Cantidad de alumnos aprobados (puntaje >= 6) en el área 'Matemáticas'
SELECT COUNT(DISTINCT a.idEstudiante) AS alumnos_aprobados
FROM Desarrollo d
JOIN Asignacion a ON d.idAsignacion = a.idAsignacion
JOIN Evaluacion e ON a.idEvaluacion = e.idEvaluacion
WHERE e.tipoArea = 'Matemáticas'
  AND d.puntajeObtenido >= 6;

  
-- c. ¿A cuántos exámenes está inscrito un alumno y cuántos están resueltos y pendientes?
-- Número total de exámenes inscritos, resueltos y pendientes de un estudiante con id = 1
SELECT
  COUNT(*) AS total_examenes_inscritos,
  SUM(CASE WHEN d.puntajeObtenido IS NOT NULL THEN 1 ELSE 0 END) AS resueltos,
  SUM(CASE WHEN d.puntajeObtenido IS NULL THEN 1 ELSE 0 END) AS pendientes
FROM Asignacion a
LEFT JOIN Desarrollo d ON a.idAsignacion = d.idAsignacion
WHERE a.idEstudiante = 1;


-- d. ¿Cuál es la mejor y peor calificación de una determinada evaluación?
-- Mejor y peor puntaje obtenido en la evaluación con id = 1
SELECT 
  MAX(d.puntajeObtenido) AS mejor_calificacion,
  MIN(d.puntajeObtenido) AS peor_calificacion
FROM Desarrollo d
JOIN Asignacion a ON d.idAsignacion = a.idAsignacion
WHERE a.idEvaluacion = 1;


-- e. ¿Cómo calcularíamos el promedio de calificaciones de un estudiante?
-- Promedio de puntajes obtenidos por el estudiante con id = 1
SELECT AVG(d.puntajeObtenido) AS promedio_calificaciones
FROM Desarrollo d
JOIN Asignacion a ON d.idAsignacion = a.idAsignacion
WHERE a.idEstudiante = 1;


