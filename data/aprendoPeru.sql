CREATE DATABASE aprendePeru;
USE aprendePeru;

CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol ENUM('estudiante', 'administrador') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tipos_evaluacion (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE evaluaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo_evaluacion_id INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    tiempo_desarrollo INT NOT NULL COMMENT 'Tiempo en minutos',
    puntaje_total DECIMAL(4,2) DEFAULT 20.00 COMMENT 'Sistema vigesimal',
    activo BOOLEAN DEFAULT TRUE,
    creado_por INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (tipo_evaluacion_id) REFERENCES tipos_evaluacion(id),
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
);

CREATE TABLE preguntas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    evaluacion_id INT NOT NULL,
    enunciado TEXT NOT NULL,
    puntaje DECIMAL(4,2) NOT NULL,
    numero_pregunta INT NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (evaluacion_id) REFERENCES evaluaciones(id) ON DELETE CASCADE
);

CREATE TABLE alternativas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pregunta_id INT NOT NULL,
    texto TEXT NOT NULL,
    letra CHAR(1) NOT NULL COMMENT 'A, B, C, D, etc.',
    es_correcta BOOLEAN DEFAULT FALSE,
    activo BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id) ON DELETE CASCADE
);

CREATE TABLE asignaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    estudiante_id INT NOT NULL,
    evaluacion_id INT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (estudiante_id) REFERENCES usuarios(id),
    FOREIGN KEY (evaluacion_id) REFERENCES evaluaciones(id),
    UNIQUE KEY unico_estudiante_evaluacion (estudiante_id, evaluacion_id)
);

CREATE TABLE intentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    estudiante_id INT NOT NULL,
    evaluacion_id INT NOT NULL,
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP NULL,
    puntaje_obtenido DECIMAL(4,2) NULL,
    estado ENUM('iniciado', 'completado', 'abandonado') DEFAULT 'iniciado',
    tiempo_usado INT NULL COMMENT 'Tiempo en minutos',
    
    FOREIGN KEY (estudiante_id) REFERENCES usuarios(id),
    FOREIGN KEY (evaluacion_id) REFERENCES evaluaciones(id),
    UNIQUE KEY unico_intento_por_evaluacion (estudiante_id, evaluacion_id)
);

CREATE TABLE respuestas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    intento_id INT NOT NULL,
    pregunta_id INT NOT NULL,
    alternativa_id INT NOT NULL,
    es_correcta BOOLEAN NOT NULL,
    puntaje_pregunta DECIMAL(4,2) NOT NULL,
    fecha_respuesta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (intento_id) REFERENCES intentos(id) ON DELETE CASCADE,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id),
    FOREIGN KEY (alternativa_id) REFERENCES alternativas(id),
    UNIQUE KEY una_respuesta_por_pregunta (intento_id, pregunta_id)
);

-- 1. INSERTAR TIPOS DE EVALUACIÓN
INSERT INTO tipos_evaluacion (nombre, descripcion) VALUES
('Matemáticas', 'Evaluaciones del área de matemáticas básica y avanzada'),
('Comunicación', 'Evaluaciones de comprensión lectora y gramática'),
('Ciencias', 'Evaluaciones de ciencias naturales y biología'),
('Historia', 'Evaluaciones de historia del Perú y universal'),
('Inglés', 'Evaluaciones de idioma inglés básico e intermedio');

-- 2. INSERTAR ADMINISTRADOR
INSERT INTO usuarios (nombre, apellidos, email, password, rol) VALUES
('Carlos', 'Mendoza Ruiz', 'admin@aprendeperu.com', 'admin123', 'administrador');

-- 3. INSERTAR 10 ALUMNOS
INSERT INTO usuarios (nombre, apellidos, email, password, rol) VALUES
('Ana María', 'García López', 'ana.garcia@estudiante.com', 'est123', 'estudiante'),
('Luis Carlos', 'Rodríguez Pérez', 'luis.rodriguez@estudiante.com', 'est123', 'estudiante'),
('María Elena', 'Torres Vásquez', 'maria.torres@estudiante.com', 'est123', 'estudiante'),
('José Manuel', 'Flores Castillo', 'jose.flores@estudiante.com', 'est123', 'estudiante'),
('Carmen Rosa', 'Díaz Herrera', 'carmen.diaz@estudiante.com', 'est123', 'estudiante'),
('Roberto', 'Silva Mendoza', 'roberto.silva@estudiante.com', 'est123', 'estudiante'),
('Lucía', 'Morales Santos', 'lucia.morales@estudiante.com', 'est123', 'estudiante'),
('Fernando', 'Ramos Gutiérrez', 'fernando.ramos@estudiante.com', 'est123', 'estudiante'),
('Patricia', 'Campos Vargas', 'patricia.campos@estudiante.com', 'est123', 'estudiante'),
('Miguel Ángel', 'Rojas Fernández', 'miguel.rojas@estudiante.com', 'est123', 'estudiante');

-- 4. INSERTAR 5 EVALUACIONES
INSERT INTO evaluaciones (titulo, descripcion, tipo_evaluacion_id, fecha_inicio, fecha_fin, tiempo_desarrollo, puntaje_total, creado_por) VALUES
('Evaluación de Álgebra Básica', 'Evaluación sobre operaciones algebraicas y ecuaciones lineales', 1, '2025-06-10 08:00:00', '2025-06-10 18:00:00', 60, 20.00, 1),
('Comprensión Lectora Nivel 1', 'Evaluación de comprensión de textos narrativos y expositivos', 2, '2025-06-12 09:00:00', '2025-06-12 17:00:00', 45, 20.00, 1),
('Biología Celular', 'Evaluación sobre estructura y función de las células', 3, '2025-06-14 10:00:00', '2025-06-14 16:00:00', 50, 20.00, 1),
('Historia del Perú Antiguo', 'Evaluación sobre civilizaciones preincaicas e inca', 4, '2025-06-16 08:30:00', '2025-06-16 17:30:00', 55, 20.00, 1),
('English Grammar Basics', 'Evaluación de gramática básica del idioma inglés', 5, '2025-06-18 11:00:00', '2025-06-18 15:00:00', 40, 20.00, 1);


-- 5. INSERTAR PREGUNTAS Y ALTERNATIVAS
-- EVALUACIÓN 1: ÁLGEBRA BÁSICA
-- Pregunta 1
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(1, '¿Cuál es el resultado de 2x + 3x = 15?', 4.00, 1);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(1, 'x = 2', 'A', FALSE),
(1, 'x = 3', 'B', TRUE),
(1, 'x = 4', 'C', FALSE),
(1, 'x = 5', 'D', FALSE);

-- Pregunta 2
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(1, 'Si a² = 25, ¿cuáles son los valores posibles de a?', 4.00, 2);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(2, 'a = 5', 'A', FALSE),
(2, 'a = -5', 'B', FALSE),
(2, 'a = 5 y a = -5', 'C', TRUE),
(2, 'a = 25', 'D', FALSE);

-- Pregunta 3
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(1, '¿Cuál es la pendiente de la recta y = 3x + 2?', 4.00, 3);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(3, 'm = 2', 'A', FALSE),
(3, 'm = 3', 'B', TRUE),
(3, 'm = 5', 'C', FALSE),
(3, 'm = -3', 'D', FALSE);

-- Pregunta 4
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(1, 'Factoriza: x² - 9', 4.00, 4);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(4, '(x + 3)(x - 3)', 'A', TRUE),
(4, '(x + 9)(x - 1)', 'B', FALSE),
(4, '(x - 3)²', 'C', FALSE),
(4, 'x(x - 9)', 'D', FALSE);

-- Pregunta 5
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(1, 'Si 3x - 7 = 14, entonces x es igual a:', 4.00, 5);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(5, 'x = 6', 'A', FALSE),
(5, 'x = 7', 'B', TRUE),
(5, 'x = 8', 'C', FALSE),
(5, 'x = 9', 'D', FALSE);

-- EVALUACIÓN 2: COMPRENSIÓN LECTORA
-- Pregunta 1
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(2, 'En el texto "El sol brillaba intensamente", ¿qué función cumple la palabra "intensamente"?', 4.00, 1);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(6, 'Sustantivo', 'A', FALSE),
(6, 'Adjetivo', 'B', FALSE),
(6, 'Adverbio', 'C', TRUE),
(6, 'Verbo', 'D', FALSE);

-- Pregunta 2
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(2, '¿Cuál es el antónimo de "generoso"?', 4.00, 2);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(7, 'Bondadoso', 'A', FALSE),
(7, 'Tacaño', 'B', TRUE),
(7, 'Amable', 'C', FALSE),
(7, 'Cortés', 'D', FALSE);

-- Pregunta 3
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(2, 'En la oración "María compró frutas en el mercado", el sujeto es:', 4.00, 3);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(8, 'frutas', 'A', FALSE),
(8, 'María', 'B', TRUE),
(8, 'mercado', 'C', FALSE),
(8, 'compró', 'D', FALSE);

-- Pregunta 4
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(2, '¿Qué tipo de texto es una receta de cocina?', 4.00, 4);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(9, 'Narrativo', 'A', FALSE),
(9, 'Descriptivo', 'B', FALSE),
(9, 'Instructivo', 'C', TRUE),
(9, 'Argumentativo', 'D', FALSE);

-- Pregunta 5
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(2, 'La palabra "bibliografía" está formada por:', 4.00, 5);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(10, 'Dos morfemas', 'A', FALSE),
(10, 'Tres morfemas', 'B', TRUE),
(10, 'Cuatro morfemas', 'C', FALSE),
(10, 'Un morfema', 'D', FALSE);

-- EVALUACIÓN 3: BIOLOGÍA CELULAR
-- Pregunta 1
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(3, '¿Cuál es la función principal del núcleo celular?', 4.00, 1);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(11, 'Producir energía', 'A', FALSE),
(11, 'Controlar las actividades celulares', 'B', TRUE),
(11, 'Digerir sustancias', 'C', FALSE),
(11, 'Transportar materiales', 'D', FALSE);

-- Pregunta 2
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(3, '¿Qué organelo es conocido como "la central energética de la célula"?', 4.00, 2);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(12, 'Núcleo', 'A', FALSE),
(12, 'Mitocondria', 'B', TRUE),
(12, 'Ribosoma', 'C', FALSE),
(12, 'Vacuola', 'D', FALSE);

-- Pregunta 3
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(3, '¿Cuál es la diferencia principal entre célula animal y vegetal?', 4.00, 3);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(13, 'La célula animal tiene núcleo', 'A', FALSE),
(13, 'La célula vegetal tiene pared celular', 'B', TRUE),
(13, 'La célula animal es más grande', 'C', FALSE),
(13, 'No hay diferencias', 'D', FALSE);

-- Pregunta 4
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(3, '¿Dónde se realiza la fotosíntesis en las plantas?', 4.00, 4);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(14, 'En las mitocondrias', 'A', FALSE),
(14, 'En los cloroplastos', 'B', TRUE),
(14, 'En el núcleo', 'C', FALSE),
(14, 'En los ribosomas', 'D', FALSE);

-- Pregunta 5
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(3, '¿Qué es la membrana plasmática?', 4.00, 5);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(15, 'El centro de la célula', 'A', FALSE),
(15, 'La cubierta externa de la célula', 'B', TRUE),
(15, 'Un organelo interno', 'C', FALSE),
(15, 'El material genético', 'D', FALSE);

-- EVALUACIÓN 4: HISTORIA DEL PERÚ ANTIGUO
-- Pregunta 1
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(4, '¿Cuál fue la primera civilización del Perú antiguo?', 4.00, 1);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(16, 'Inca', 'A', FALSE),
(16, 'Caral', 'B', TRUE),
(16, 'Chavín', 'C', FALSE),
(16, 'Moche', 'D', FALSE);

-- Pregunta 2
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(4, '¿En qué región se desarrolló la cultura Nazca?', 4.00, 2);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(17, 'Costa norte', 'A', FALSE),
(17, 'Costa sur', 'B', TRUE),
(17, 'Sierra norte', 'C', FALSE),
(17, 'Selva', 'D', FALSE);

-- Pregunta 3
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(4, '¿Cuál era la capital del Imperio Inca?', 4.00, 3);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(18, 'Machu Picchu', 'A', FALSE),
(18, 'Cusco', 'B', TRUE),
(18, 'Ollantaytambo', 'C', FALSE),
(18, 'Sacsayhuamán', 'D', FALSE);

-- Pregunta 4
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(4, '¿Qué cultura es famosa por sus líneas en el desierto?', 4.00, 4);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(19, 'Moche', 'A', FALSE),
(19, 'Nazca', 'B', TRUE),
(19, 'Chimú', 'C', FALSE),
(19, 'Paracas', 'D', FALSE);

-- Pregunta 5
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(4, '¿Cómo se llamaba el sistema de trabajo comunitario inca?', 4.00, 5);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(20, 'Mita', 'A', FALSE),
(20, 'Ayni', 'B', TRUE),
(20, 'Ayllu', 'C', FALSE),
(20, 'Quipu', 'D', FALSE);

-- EVALUACIÓN 5: ENGLISH GRAMMAR BASICS
-- Pregunta 1
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(5, 'What is the correct form: "She _____ to school every day"', 4.00, 1);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(21, 'go', 'A', FALSE),
(21, 'goes', 'B', TRUE),
(21, 'going', 'C', FALSE),
(21, 'gone', 'D', FALSE);

-- Pregunta 2
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(5, 'Which is the plural of "child"?', 4.00, 2);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(22, 'childs', 'A', FALSE),
(22, 'children', 'B', TRUE),
(22, 'childrens', 'C', FALSE),
(22, 'child', 'D', FALSE);

-- Pregunta 3
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(5, 'Complete: "I _____ English for two years"', 4.00, 3);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(23, 'study', 'A', FALSE),
(23, 'have studied', 'B', TRUE),
(23, 'studied', 'C', FALSE),
(23, 'am studying', 'D', FALSE);

-- Pregunta 4
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(5, 'What is the past tense of "buy"?', 4.00, 4);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(24, 'buyed', 'A', FALSE),
(24, 'bought', 'B', TRUE),
(24, 'buied', 'C', FALSE),
(24, 'buying', 'D', FALSE);

-- Pregunta 5
INSERT INTO preguntas (evaluacion_id, enunciado, puntaje, numero_pregunta) VALUES
(5, 'Choose the correct article: "_____ apple is red"', 4.00, 5);

INSERT INTO alternativas (pregunta_id, texto, letra, es_correcta) VALUES
(25, 'A', 'A', FALSE),
(25, 'An', 'B', TRUE),
(25, 'The', 'C', FALSE),
(25, 'No article needed', 'D', FALSE);


-- 6. ASIGNAR EVALUACIONES A TODOS LOS ESTUDIANTES
INSERT INTO asignaciones (estudiante_id, evaluacion_id) VALUES
-- Estudiante 1 (Ana María García)
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5),
-- Estudiante 2 (Luis Carlos Rodríguez)
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5),
-- Estudiante 3 (María Elena Torres)
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5),
-- Estudiante 4 (José Manuel Flores)
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5),
-- Estudiante 5 (Carmen Rosa Díaz)
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5),
-- Estudiante 6 (Roberto Silva)
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5),
-- Estudiante 7 (Lucía Morales)
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5),
-- Estudiante 8 (Fernando Ramos)
(9, 1), (9, 2), (9, 3), (9, 4), (9, 5),
-- Estudiante 9 (Patricia Campos)
(10, 1), (10, 2), (10, 3), (10, 4), (10, 5),
-- Estudiante 10 (Miguel Ángel Rojas)
(11, 1), (11, 2), (11, 3), (11, 4), (11, 5);



-- GRUPO A: 4 alumnos asignados a 3 exámenes cada uno (IDs: 2,3,4,5)
-- Ana María García (ID:2) - Exámenes: 1,2,3
INSERT INTO asignaciones (estudiante_id, evaluacion_id) VALUES
(2, 1), (2, 2), (2, 3);

-- Luis Carlos Rodríguez (ID:3) - Exámenes: 1,4,5  
INSERT INTO asignaciones (estudiante_id, evaluacion_id) VALUES
(3, 1), (3, 4), (3, 5);

-- María Elena Torres (ID:4) - Exámenes: 2,3,4
INSERT INTO asignaciones (estudiante_id, evaluacion_id) VALUES
(4, 2), (4, 3), (4, 4);

-- José Manuel Flores (ID:5) - Exámenes: 3,4,5
INSERT INTO asignaciones (estudiante_id, evaluacion_id) VALUES
(5, 3), (5, 4), (5, 5);

-- GRUPO B: 3 alumnos asignados a 2 exámenes cada uno (IDs: 6,7,8)
-- Carmen Rosa Díaz (ID:6) - Exámenes: 1,5
INSERT INTO asignaciones (estudiante_id, evaluacion_id) VALUES
(6, 1), (6, 5);

-- Roberto Silva (ID:7) - Exámenes: 2,4
INSERT INTO asignaciones (estudiante_id, evaluacion_id) VALUES
(7, 2), (7, 4);

-- Lucía Morales (ID:8) - Exámenes: 3,5
INSERT INTO asignaciones (estudiante_id, evaluacion_id) VALUES
(8, 3), (8, 5);

-- GRUPO C: 3 alumnos sin asignaciones (IDs: 9,10,11)
-- Fernando Ramos (ID:9) - Sin asignaciones
-- Patricia Campos (ID:10) - Sin asignaciones  
-- Miguel Ángel Rojas (ID:11) - Sin asignaciones




-- SIMULACIÓN PARA ANA MARÍA GARCÍA (ID:2) - Buen rendimiento
-- Examen 1: Álgebra Básica (APROBADO - 16.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(2, 1, '2025-06-10 08:15:00', '2025-06-10 09:05:00', 16.00, 'completado', 50);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(1, 1, 2, TRUE, 4.00),   -- Pregunta 1: Correcta
(1, 2, 6, TRUE, 4.00),   -- Pregunta 2: Correcta  
(1, 3, 7, TRUE, 4.00),   -- Pregunta 3: Correcta
(1, 4, 13, TRUE, 4.00),  -- Pregunta 4: Correcta
(1, 5, 17, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- Examen 2: Comprensión Lectora (APROBADO - 12.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(2, 2, '2025-06-12 09:10:00', '2025-06-12 09:50:00', 12.00, 'completado', 40);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(2, 6, 18, TRUE, 4.00),   -- Pregunta 1: Correcta
(2, 7, 23, TRUE, 4.00),   -- Pregunta 2: Correcta
(2, 8, 28, TRUE, 4.00),   -- Pregunta 3: Correcta
(2, 9, 31, FALSE, 0.00),  -- Pregunta 4: Incorrecta
(2, 10, 34, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- Examen 3: Biología Celular (APROBADO - 15.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(2, 3, '2025-06-14 10:20:00', '2025-06-14 11:05:00', 15.00, 'completado', 45);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(3, 11, 43, TRUE, 4.00),  -- Pregunta 1: Correcta
(3, 12, 48, TRUE, 4.00),  -- Pregunta 2: Correcta
(3, 13, 53, TRUE, 4.00),  -- Pregunta 3: Correcta
(3, 14, 58, TRUE, 3.00),  -- Pregunta 4: Parcialmente correcta
(3, 15, 59, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- SIMULACIÓN PARA LUIS CARLOS RODRÍGUEZ (ID:3) - Rendimiento bajo (DESAPROBADO)
-- Examen 1: Álgebra Básica (DESAPROBADO - 8.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(3, 1, '2025-06-10 08:20:00', '2025-06-10 09:20:00', 8.00, 'completado', 60);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(4, 1, 1, FALSE, 0.00),   -- Pregunta 1: Incorrecta
(4, 2, 6, TRUE, 4.00),    -- Pregunta 2: Correcta
(4, 3, 9, FALSE, 0.00),   -- Pregunta 3: Incorrecta
(4, 4, 13, TRUE, 4.00),   -- Pregunta 4: Correcta
(4, 5, 18, FALSE, 0.00);  -- Pregunta 5: Incorrecta

-- Examen 4: Historia del Perú (APROBADO - 12.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(3, 4, '2025-06-16 08:45:00', '2025-06-16 09:35:00', 12.00, 'completado', 50);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(5, 16, 64, TRUE, 4.00),  -- Pregunta 1: Correcta
(5, 17, 68, TRUE, 4.00),  -- Pregunta 2: Correcta
(5, 18, 73, TRUE, 4.00),  -- Pregunta 3: Correcta
(5, 19, 76, FALSE, 0.00), -- Pregunta 4: Incorrecta
(5, 20, 80, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- Examen 5: English Grammar (APROBADO - 16.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(3, 5, '2025-06-18 11:15:00', '2025-06-18 11:50:00', 16.00, 'completado', 35);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(6, 21, 83, TRUE, 4.00),  -- Pregunta 1: Correcta
(6, 22, 88, TRUE, 4.00),  -- Pregunta 2: Correcta
(6, 23, 93, TRUE, 4.00),  -- Pregunta 3: Correcta
(6, 24, 98, TRUE, 4.00),  -- Pregunta 4: Correcta
(6, 25, 101, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- SIMULACIÓN PARA MARÍA ELENA TORRES (ID:4) - Buen rendimiento
-- Examen 2: Comprensión Lectora (APROBADO - 18.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(4, 2, '2025-06-12 09:15:00', '2025-06-12 09:55:00', 18.00, 'completado', 40);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(7, 6, 18, TRUE, 4.00),   -- Pregunta 1: Correcta
(7, 7, 23, TRUE, 4.00),   -- Pregunta 2: Correcta
(7, 8, 28, TRUE, 4.00),   -- Pregunta 3: Correcta
(7, 9, 33, TRUE, 4.00),   -- Pregunta 4: Correcta
(7, 10, 38, TRUE, 2.00);  -- Pregunta 5: Parcialmente correcta

-- Examen 3: Biología Celular (APROBADO - 14.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(4, 3, '2025-06-14 10:30:00', '2025-06-14 11:20:00', 14.00, 'completado', 50);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(8, 11, 43, TRUE, 4.00),  -- Pregunta 1: Correcta
(8, 12, 48, TRUE, 4.00),  -- Pregunta 2: Correcta
(8, 13, 51, FALSE, 0.00), -- Pregunta 3: Incorrecta
(8, 14, 58, TRUE, 4.00),  -- Pregunta 4: Correcta
(8, 15, 63, TRUE, 2.00);  -- Pregunta 5: Parcialmente correcta

-- Examen 4: Historia del Perú (DESAPROBADO - 8.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(4, 4, '2025-06-16 09:00:00', '2025-06-16 10:00:00', 8.00, 'completado', 55);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(9, 16, 65, FALSE, 0.00), -- Pregunta 1: Incorrecta
(9, 17, 68, TRUE, 4.00),  -- Pregunta 2: Correcta
(9, 18, 71, FALSE, 0.00), -- Pregunta 3: Incorrecta
(9, 19, 78, TRUE, 4.00),  -- Pregunta 4: Correcta
(9, 20, 79, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- SIMULACIÓN PARA JOSÉ MANUEL FLORES (ID:5) - Rendimiento mixto
-- Examen 3: Biología Celular (APROBADO - 16.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(5, 3, '2025-06-14 10:45:00', '2025-06-14 11:30:00', 16.00, 'completado', 45);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(10, 11, 43, TRUE, 4.00), -- Pregunta 1: Correcta
(10, 12, 48, TRUE, 4.00), -- Pregunta 2: Correcta
(10, 13, 53, TRUE, 4.00), -- Pregunta 3: Correcta
(10, 14, 58, TRUE, 4.00), -- Pregunta 4: Correcta
(10, 15, 61, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- Examen 4: Historia del Perú (APROBADO - 12.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(5, 4, '2025-06-16 09:15:00', '2025-06-16 10:05:00', 12.00, 'completado', 50);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(11, 16, 64, TRUE, 4.00),  -- Pregunta 1: Correcta
(11, 17, 67, FALSE, 0.00), -- Pregunta 2: Incorrecta
(11, 18, 73, TRUE, 4.00),  -- Pregunta 3: Correcta
(11, 19, 78, TRUE, 4.00),  -- Pregunta 4: Correcta
(11, 20, 79, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- Examen 5: English Grammar (APROBADO - 14.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(5, 5, '2025-06-18 11:30:00', '2025-06-18 12:05:00', 14.00, 'completado', 35);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(12, 21, 83, TRUE, 4.00),  -- Pregunta 1: Correcta
(12, 22, 88, TRUE, 4.00),  -- Pregunta 2: Correcta
(12, 23, 91, FALSE, 0.00), -- Pregunta 3: Incorrecta
(12, 24, 98, TRUE, 4.00),  -- Pregunta 4: Correcta
(12, 25, 103, TRUE, 2.00); -- Pregunta 5: Parcialmente correcta

-- SIMULACIÓN PARA CARMEN ROSA DÍAZ (ID:6) - Rendimiento bajo
-- Examen 1: Álgebra Básica (APROBADO - 12.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(6, 1, '2025-06-10 08:30:00', '2025-06-10 09:25:00', 12.00, 'completado', 55);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(13, 1, 2, TRUE, 4.00),   -- Pregunta 1: Correcta
(13, 2, 5, FALSE, 0.00),  -- Pregunta 2: Incorrecta
(13, 3, 7, TRUE, 4.00),   -- Pregunta 3: Correcta
(13, 4, 13, TRUE, 4.00),  -- Pregunta 4: Correcta
(13, 5, 18, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- Examen 5: English Grammar (DESAPROBADO - 6.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(6, 5, '2025-06-18 11:45:00', '2025-06-18 12:20:00', 6.00, 'completado', 35);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(14, 21, 81, FALSE, 0.00), -- Pregunta 1: Incorrecta
(14, 22, 88, TRUE, 4.00),  -- Pregunta 2: Correcta
(14, 23, 91, FALSE, 0.00), -- Pregunta 3: Incorrecta
(14, 24, 98, TRUE, 2.00),  -- Pregunta 4: Parcialmente correcta
(14, 25, 101, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- SIMULACIÓN PARA ROBERTO SILVA (ID:7) - Buen rendimiento
-- Examen 2: Comprensión Lectora (APROBADO - 16.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(7, 2, '2025-06-12 09:20:00', '2025-06-12 10:00:00', 16.00, 'completado', 40);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(15, 6, 18, TRUE, 4.00),  -- Pregunta 1: Correcta
(15, 7, 23, TRUE, 4.00),  -- Pregunta 2: Correcta
(15, 8, 28, TRUE, 4.00),  -- Pregunta 3: Correcta
(15, 9, 33, TRUE, 4.00),  -- Pregunta 4: Correcta
(15, 10, 36, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- Examen 4: Historia del Perú (APROBADO - 15.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(7, 4, '2025-06-16 09:30:00', '2025-06-16 10:20:00', 15.00, 'completado', 50);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(16, 16, 64, TRUE, 4.00),  -- Pregunta 1: Correcta
(16, 17, 68, TRUE, 4.00),  -- Pregunta 2: Correcta
(16, 18, 73, TRUE, 4.00),  -- Pregunta 3: Correcta
(16, 19, 78, TRUE, 3.00),  -- Pregunta 4: Parcialmente correcta
(16, 20, 79, FALSE, 0.00); -- Pregunta 5: Incorrecta

-- SIMULACIÓN PARA LUCÍA MORALES (ID:8) - Rendimiento mixto
-- Examen 3: Biología Celular (APROBADO - 13.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(8, 3, '2025-06-14 11:00:00', '2025-06-14 11:45:00', 13.00, 'completado', 45);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(17, 11, 43, TRUE, 4.00),  -- Pregunta 1: Correcta
(17, 12, 46, FALSE, 0.00), -- Pregunta 2: Incorrecta
(17, 13, 53, TRUE, 4.00),  -- Pregunta 3: Correcta
(17, 14, 58, TRUE, 4.00),  -- Pregunta 4: Correcta
(17, 15, 63, TRUE, 1.00);  -- Pregunta 5: Parcialmente correcta

-- Examen 5: English Grammar (APROBADO - 11.00)
INSERT INTO intentos (estudiante_id, evaluacion_id, fecha_inicio, fecha_fin, puntaje_obtenido, estado, tiempo_usado) VALUES
(8, 5, '2025-06-18 12:00:00', '2025-06-18 12:30:00', 11.00, 'completado', 30);

INSERT INTO respuestas (intento_id, pregunta_id, alternativa_id, es_correcta, puntaje_pregunta) VALUES
(18, 21, 83, TRUE, 4.00),  -- Pregunta 1: Correcta
(18, 22, 86, FALSE, 0.00), -- Pregunta 2: Incorrecta
(18, 23, 93, TRUE, 4.00),  -- Pregunta 3: Correcta
(18, 24, 98, TRUE, 3.00),  -- Pregunta 4: Parcialmente correcta
(18, 25, 101, FALSE, 0.00); -- Pregunta 5: Incorrecta


-- CONSULTAS DE VERIFICACIÓN
-- Verificar distribución de asignaciones
SELECT 
    u.nombre, 
    u.apellidos,
    COUNT(a.evaluacion_id) as num_evaluaciones_asignadas
FROM usuarios u
LEFT JOIN asignaciones a ON u.id = a.estudiante_id
WHERE u.rol = 'estudiante'
GROUP BY u.id, u.nombre, u.apellidos
ORDER BY num_evaluaciones_asignadas DESC, u.nombre;

-- Verificar resultados de exámenes con estado de aprobación
SELECT 
    u.nombre + ' ' + u.apellidos as estudiante,
    e.titulo as evaluacion,
    i.puntaje_obtenido,
    CASE 
        WHEN i.puntaje_obtenido >= 11.00 THEN 'APROBADO'
        ELSE 'DESAPROBADO'
    END as estado,
    i.tiempo_usado as tiempo_minutos,
    i.fecha_fin
FROM intentos i
JOIN usuarios u ON i.estudiante_id = u.id
JOIN evaluaciones e ON i.evaluacion_id = e.id
ORDER BY u.nombre, e.titulo;

-- Resumen estadístico
SELECT 
    'ESTADÍSTICAS GENERALES' as resumen,
    COUNT(DISTINCT i.estudiante_id) as estudiantes_que_rindieron,
    COUNT(*) as total_examenes_rendidos,
    AVG(i.puntaje_obtenido) as promedio_general,
    SUM(CASE WHEN i.puntaje_obtenido >= 11.00 THEN 1 ELSE 0 END) as aprobados,
    SUM(CASE WHEN i.puntaje_obtenido < 11.00 THEN 1 ELSE 0 END) as desaprobados
FROM intentos i;

-- CONSULTAS ANALÍTICAS - BASE DE DATOS aprendePeru
-- A. ¿CUÁNTOS ALUMNOS DESAPROBADOS TENEMOS EN TOTAL?

-- Opción 1: Alumnos que tienen al menos un examen desaprobado
SELECT 
    'Alumnos con al menos un examen desaprobado' as descripcion,
    COUNT(DISTINCT i.estudiante_id) as total_alumnos_desaprobados
FROM intentos i
WHERE i.puntaje_obtenido < 11.00 
  AND i.estado = 'completado';

-- B. ¿CUÁNTOS ALUMNOS APROBADOS EN UN DETERMINADO CURSO TENEMOS?
-- Por cada evaluación/curso específico
SELECT 
    e.titulo as curso,
    te.nombre as tipo_evaluacion,
    COUNT(CASE WHEN i.puntaje_obtenido >= 11.00 THEN 1 END) as alumnos_aprobados,
    COUNT(CASE WHEN i.puntaje_obtenido < 11.00 THEN 1 END) as alumnos_desaprobados,
    COUNT(*) as total_alumnos_evaluados,
    ROUND(
        (COUNT(CASE WHEN i.puntaje_obtenido >= 11.00 THEN 1 END) * 100.0 / COUNT(*)), 2
    ) as porcentaje_aprobacion
FROM evaluaciones e
JOIN tipos_evaluacion te ON e.tipo_evaluacion_id = te.id
LEFT JOIN intentos i ON e.id = i.evaluacion_id AND i.estado = 'completado'
WHERE i.id IS NOT NULL  -- Solo evaluaciones que tienen intentos
GROUP BY e.id, e.titulo, te.nombre
ORDER BY porcentaje_aprobacion DESC;



-- C. ¿A CUÁNTOS EXÁMENES ESTÁ INSCRITO UN ALUMNO Y CUÁNTOS DE ELLOS 
--    ESTÁN RESUELTOS Y PENDIENTES?
-- Estado general de todos los alumnos
SELECT 
    u.nombre + ' ' + u.apellidos as alumno,
    COUNT(a.evaluacion_id) as examenes_asignados,
    COUNT(i.id) as examenes_resueltos,
    (COUNT(a.evaluacion_id) - COUNT(i.id)) as examenes_pendientes,
    CASE 
        WHEN COUNT(a.evaluacion_id) = 0 THEN 'Sin asignaciones'
        WHEN COUNT(i.id) = COUNT(a.evaluacion_id) THEN 'Todos completados'
        WHEN COUNT(i.id) = 0 THEN 'Ninguno resuelto'
        ELSE 'En progreso'
    END as estado_general
FROM usuarios u
LEFT JOIN asignaciones a ON u.id = a.estudiante_id AND a.activo = TRUE
LEFT JOIN intentos i ON u.id = i.estudiante_id 
    AND i.evaluacion_id = a.evaluacion_id 
    AND i.estado = 'completado'
WHERE u.rol = 'estudiante'
GROUP BY u.id, u.nombre, u.apellidos
ORDER BY examenes_asignados DESC, u.nombre;



-- D. ¿CUÁL ES LA MEJOR Y PEOR CALIFICACIÓN DE UNA DETERMINADA EVALUACIÓN?
-- Estadísticas por evaluación
SELECT 
    e.titulo as evaluacion,
    MAX(i.puntaje_obtenido) as mejor_calificacion,
    MIN(i.puntaje_obtenido) as peor_calificacion,
    AVG(i.puntaje_obtenido) as promedio_evaluacion,
    COUNT(*) as total_estudiantes,

    -- Estudiante con mejor calificación
    (SELECT u2.nombre + ' ' + u2.apellidos 
     FROM intentos i2 
     JOIN usuarios u2 ON i2.estudiante_id = u2.id
     WHERE i2.evaluacion_id = e.id 
       AND i2.puntaje_obtenido = MAX(i.puntaje_obtenido)
       AND i2.estado = 'completado'
     LIMIT 1) as mejor_estudiante,
     
    -- Estudiante con peor calificación  
    (SELECT u3.nombre + ' ' + u3.apellidos 
     FROM intentos i3 
     JOIN usuarios u3 ON i3.estudiante_id = u3.id
     WHERE i3.evaluacion_id = e.id 
       AND i3.puntaje_obtenido = MIN(i.puntaje_obtenido)
       AND i3.estado = 'completado'
     LIMIT 1) as peor_estudiante
FROM evaluaciones e
JOIN intentos i ON e.id = i.evaluacion_id
WHERE i.estado = 'completado'
GROUP BY e.id, e.titulo
ORDER BY promedio_evaluacion DESC;


-- E. ¿CÓMO CALCULARÍAMOS EL PROMEDIO DE CALIFICACIONES DE UN ESTUDIANTE?
-- Promedio por estudiante (todos los exámenes completados)
SELECT 
    u.nombre + ' ' + u.apellidos as estudiante,
    COUNT(i.id) as examenes_rendidos,
    ROUND(AVG(i.puntaje_obtenido), 2) as promedio_general,
    MIN(i.puntaje_obtenido) as nota_minima,
    MAX(i.puntaje_obtenido) as nota_maxima,
    CASE 
        WHEN AVG(i.puntaje_obtenido) >= 16.00 THEN 'EXCELENTE'
        WHEN AVG(i.puntaje_obtenido) >= 13.00 THEN 'BUENO'
        WHEN AVG(i.puntaje_obtenido) >= 11.00 THEN 'REGULAR'
        ELSE 'DEFICIENTE'
    END as nivel_promedio
FROM usuarios u
JOIN intentos i ON u.id = i.estudiante_id
WHERE u.rol = 'estudiante' 
  AND i.estado = 'completado'
GROUP BY u.id, u.nombre, u.apellidos
ORDER BY promedio_general DESC;