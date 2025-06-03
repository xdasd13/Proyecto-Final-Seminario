<?php
require_once __DIR__ . '/../config/db.php';

class Pregunta
{
    private $conn;
    private $table_name = "Preguntas";

    // Propiedades de la tabla
    public $id;
    public $evaluacion_id;
    public $texto_pregunta;
    public $puntaje;
    public $orden;

    public function __construct()
    {
        $database = new DatabaseConfig();
        $this->conn = $database->getConnection();
    }

    // Crear nueva pregunta
    public function create()
    {
        $query = "INSERT INTO " . $this->table_name . " 
                  (evaluacion_id, texto_pregunta, puntaje, orden) 
                  VALUES 
                  (:evaluacion_id, :texto_pregunta, :puntaje, :orden)";

        $stmt = $this->conn->prepare($query);

        // Limpiar datos
        $this->evaluacion_id = htmlspecialchars(strip_tags($this->evaluacion_id));
        $this->texto_pregunta = htmlspecialchars(strip_tags($this->texto_pregunta));
        $this->puntaje = htmlspecialchars(strip_tags($this->puntaje));
        $this->orden = htmlspecialchars(strip_tags($this->orden));

        // Vincular parámetros
        $stmt->bindParam(":evaluacion_id", $this->evaluacion_id);
        $stmt->bindParam(":texto_pregunta", $this->texto_pregunta);
        $stmt->bindParam(":puntaje", $this->puntaje);
        $stmt->bindParam(":orden", $this->orden);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }

        return false;
    }

    // Obtener todas las preguntas
    public function getAll()
    {
        $query = "SELECT 
                    p.id,
                    p.evaluacion_id,
                    e.nombre as evaluacion_nombre,
                    p.texto_pregunta,
                    p.puntaje,
                    p.orden
                  FROM " . $this->table_name . " p
                  LEFT JOIN Evaluaciones e ON p.evaluacion_id = e.id
                  ORDER BY p.evaluacion_id, p.orden ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener pregunta por ID
    public function getById($id)
    {
        $query = "SELECT 
                    p.id,
                    p.evaluacion_id,
                    e.nombre as evaluacion_nombre,
                    p.texto_pregunta,
                    p.puntaje,
                    p.orden
                  FROM " . $this->table_name . " p
                  LEFT JOIN Evaluaciones e ON p.evaluacion_id = e.id
                  WHERE p.id = :id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Obtener preguntas por evaluación
    public function getByEvaluacion($evaluacion_id)
    {
        $query = "SELECT 
                    p.id,
                    p.evaluacion_id,
                    e.nombre as evaluacion_nombre,
                    p.texto_pregunta,
                    p.puntaje,
                    p.orden
                  FROM " . $this->table_name . " p
                  LEFT JOIN Evaluaciones e ON p.evaluacion_id = e.id
                  WHERE p.evaluacion_id = :evaluacion_id
                  ORDER BY p.orden ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":evaluacion_id", $evaluacion_id);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener preguntas con sus alternativas
    public function getWithAlternativas($evaluacion_id)
    {
        $query = "SELECT 
                    p.id,
                    p.evaluacion_id,
                    p.texto_pregunta,
                    p.puntaje,
                    p.orden,
                    a.id as alternativa_id,
                    a.texto_alternativa,
                    a.es_correcta
                  FROM " . $this->table_name . " p
                  LEFT JOIN Alternativas a ON p.id = a.pregunta_id
                  WHERE p.evaluacion_id = :evaluacion_id
                  ORDER BY p.orden ASC, a.id ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":evaluacion_id", $evaluacion_id);
        $stmt->execute();

        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Agrupar alternativas por pregunta
        $preguntas = [];
        foreach ($results as $row) {
            $pregunta_id = $row['id'];

            if (!isset($preguntas[$pregunta_id])) {
                $preguntas[$pregunta_id] = [
                    'id' => $row['id'],
                    'evaluacion_id' => $row['evaluacion_id'],
                    'texto_pregunta' => $row['texto_pregunta'],
                    'puntaje' => $row['puntaje'],
                    'orden' => $row['orden'],
                    'alternativas' => []
                ];
            }

            if ($row['alternativa_id']) {
                $preguntas[$pregunta_id]['alternativas'][] = [
                    'id' => $row['alternativa_id'],
                    'texto_alternativa' => $row['texto_alternativa'],
                    'es_correcta' => $row['es_correcta']
                ];
            }
        }

        return array_values($preguntas);
    }

    // Crear múltiples preguntas para una evaluación
    public function createMultiple($preguntas)
    {
        try {
            $this->conn->beginTransaction();

            $query = "INSERT INTO " . $this->table_name . " 
                      (evaluacion_id, texto_pregunta, puntaje, orden) 
                      VALUES 
                      (:evaluacion_id, :texto_pregunta, :puntaje, :orden)";

            $stmt = $this->conn->prepare($query);

            $inserted_ids = [];

            foreach ($preguntas as $pregunta) {
                $stmt->bindParam(":evaluacion_id", $pregunta['evaluacion_id']);
                $stmt->bindParam(":texto_pregunta", $pregunta['texto_pregunta']);
                $stmt->bindParam(":puntaje", $pregunta['puntaje']);
                $stmt->bindParam(":orden", $pregunta['orden']);

                if ($stmt->execute()) {
                    $inserted_ids[] = $this->conn->lastInsertId();
                } else {
                    throw new Exception("Error al insertar pregunta");
                }
            }

            $this->conn->commit();
            return $inserted_ids;
        } catch (Exception $e) {
            $this->conn->rollback();
            return false;
        }
    }

    // Actualizar pregunta
    public function update()
    {
        $query = "UPDATE " . $this->table_name . " 
                  SET evaluacion_id = :evaluacion_id,
                      texto_pregunta = :texto_pregunta,
                      puntaje = :puntaje,
                      orden = :orden
                  WHERE id = :id";

        $stmt = $this->conn->prepare($query);

        // Limpiar datos
        $this->id = htmlspecialchars(strip_tags($this->id));
        $this->evaluacion_id = htmlspecialchars(strip_tags($this->evaluacion_id));
        $this->texto_pregunta = htmlspecialchars(strip_tags($this->texto_pregunta));
        $this->puntaje = htmlspecialchars(strip_tags($this->puntaje));
        $this->orden = htmlspecialchars(strip_tags($this->orden));

        // Vincular parámetros
        $stmt->bindParam(":id", $this->id);
        $stmt->bindParam(":evaluacion_id", $this->evaluacion_id);
        $stmt->bindParam(":texto_pregunta", $this->texto_pregunta);
        $stmt->bindParam(":puntaje", $this->puntaje);
        $stmt->bindParam(":orden", $this->orden);

        return $stmt->execute();
    }

    // Eliminar pregunta
    public function delete()
    {
        // Primero eliminar las alternativas asociadas
        $query_alt = "DELETE FROM Alternativas WHERE pregunta_id = :pregunta_id";
        $stmt_alt = $this->conn->prepare($query_alt);
        $stmt_alt->bindParam(":pregunta_id", $this->id);
        $stmt_alt->execute();

        // Luego eliminar la pregunta
        $query = "DELETE FROM " . $this->table_name . " WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        
        $this->id = htmlspecialchars(strip_tags($this->id));
        $stmt->bindParam(":id", $this->id);
        
        return $stmt->execute();
    }

    // Eliminar todas las preguntas de una evaluación
    public function deleteByEvaluacion($evaluacion_id)
    {
        try {
            $this->conn->beginTransaction();

            // Primero obtener todas las preguntas de la evaluación
            $query_preguntas = "SELECT id FROM " . $this->table_name . " WHERE evaluacion_id = :evaluacion_id";
            $stmt_preguntas = $this->conn->prepare($query_preguntas);
            $stmt_preguntas->bindParam(":evaluacion_id", $evaluacion_id);
            $stmt_preguntas->execute();
            
            $preguntas = $stmt_preguntas->fetchAll(PDO::FETCH_ASSOC);

            // Eliminar alternativas de todas las preguntas
            foreach ($preguntas as $pregunta) {
                $query_alt = "DELETE FROM Alternativas WHERE pregunta_id = :pregunta_id";
                $stmt_alt = $this->conn->prepare($query_alt);
                $stmt_alt->bindParam(":pregunta_id", $pregunta['id']);
                $stmt_alt->execute();
            }

            // Eliminar las preguntas
            $query = "DELETE FROM " . $this->table_name . " WHERE evaluacion_id = :evaluacion_id";
            $stmt = $this->conn->prepare($query);
            $stmt->bindParam(":evaluacion_id", $evaluacion_id);
            $result = $stmt->execute();

            $this->conn->commit();
            return $result;
        } catch (Exception $e) {
            $this->conn->rollback();
            return false;
        }
    }

    // Reordenar preguntas
    public function reorderPreguntas($evaluacion_id, $orden_preguntas)
    {
        try {
            $this->conn->beginTransaction();

            $query = "UPDATE " . $this->table_name . " 
                      SET orden = :orden 
                      WHERE id = :id AND evaluacion_id = :evaluacion_id";

            $stmt = $this->conn->prepare($query);

            foreach ($orden_preguntas as $orden => $pregunta_id) {
                $nuevo_orden = $orden + 1; // Orden empieza en 1
                $stmt->bindParam(":orden", $nuevo_orden);
                $stmt->bindParam(":id", $pregunta_id);
                $stmt->bindParam(":evaluacion_id", $evaluacion_id);
                
                if (!$stmt->execute()) {
                    throw new Exception("Error al reordenar pregunta");
                }
            }

            $this->conn->commit();
            return true;
        } catch (Exception $e) {
            $this->conn->rollback();
            return false;
        }
    }

    // Obtener siguiente número de orden
    public function getNextOrden($evaluacion_id)
    {
        $query = "SELECT COALESCE(MAX(orden), 0) + 1 as next_orden 
                  FROM " . $this->table_name . " 
                  WHERE evaluacion_id = :evaluacion_id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":evaluacion_id", $evaluacion_id);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['next_orden'];
    }

    // Contar preguntas por evaluación
    public function countByEvaluacion($evaluacion_id)
    {
        $query = "SELECT COUNT(*) as total 
                  FROM " . $this->table_name . " 
                  WHERE evaluacion_id = :evaluacion_id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":evaluacion_id", $evaluacion_id);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['total'];
    }

    // Calcular puntaje total de una evaluación
    public function calculateTotalPuntaje($evaluacion_id)
    {
        $query = "SELECT SUM(puntaje) as total_puntaje 
                  FROM " . $this->table_name . " 
                  WHERE evaluacion_id = :evaluacion_id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":evaluacion_id", $evaluacion_id);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['total_puntaje'] ?? 0;
    }

    // Validar que una pregunta tenga alternativas
    public function hasAlternativas($pregunta_id)
    {
        $query = "SELECT COUNT(*) as total 
                  FROM Alternativas 
                  WHERE pregunta_id = :pregunta_id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":pregunta_id", $pregunta_id);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['total'] > 0;
    }
}
?>