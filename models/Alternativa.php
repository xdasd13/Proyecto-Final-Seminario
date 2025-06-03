<?php
require_once __DIR__ . '/../config/db.php';

class Alternativa
{
    private $conn;
    private $table_name = "Alternativas";

    // Propiedades de la tabla
    public $id;
    public $pregunta_id;
    public $texto_alternativa;
    public $es_correcta;

    public function __construct()
    {
        $database = new DatabaseConfig();
        $this->conn = $database->getConnection();
    }

    // Crear nueva alternativa
    public function create()
    {
        $query = "INSERT INTO " . $this->table_name . " 
                  (pregunta_id, texto_alternativa, es_correcta) 
                  VALUES 
                  (:pregunta_id, :texto_alternativa, :es_correcta)";

        $stmt = $this->conn->prepare($query);

        // Limpiar datos
        $this->pregunta_id = htmlspecialchars(strip_tags($this->pregunta_id));
        $this->texto_alternativa = htmlspecialchars(strip_tags($this->texto_alternativa));
        $this->es_correcta = htmlspecialchars(strip_tags($this->es_correcta));

        // Vincular parámetros
        $stmt->bindParam(":pregunta_id", $this->pregunta_id);
        $stmt->bindParam(":texto_alternativa", $this->texto_alternativa);
        $stmt->bindParam(":es_correcta", $this->es_correcta);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }

        return false;
    }

    // Obtener todas las alternativas
    public function getAll()
    {
        $query = "SELECT 
                    a.id,
                    a.pregunta_id,
                    p.texto_pregunta,
                    a.texto_alternativa,
                    a.es_correcta
                  FROM " . $this->table_name . " a
                  LEFT JOIN Preguntas p ON a.pregunta_id = p.id
                  ORDER BY a.pregunta_id, a.id ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener alternativa por ID
    public function getById($id)
    {
        $query = "SELECT 
                    a.id,
                    a.pregunta_id,
                    p.texto_pregunta,
                    a.texto_alternativa,
                    a.es_correcta
                  FROM " . $this->table_name . " a
                  LEFT JOIN Preguntas p ON a.pregunta_id = p.id
                  WHERE a.id = :id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Obtener alternativas por pregunta
    public function getByPregunta($pregunta_id)
    {
        $query = "SELECT 
                    a.id,
                    a.pregunta_id,
                    p.texto_pregunta,
                    a.texto_alternativa,
                    a.es_correcta
                  FROM " . $this->table_name . " a
                  LEFT JOIN Preguntas p ON a.pregunta_id = p.id
                  WHERE a.pregunta_id = :pregunta_id
                  ORDER BY a.id ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":pregunta_id", $pregunta_id);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener alternativas correctas por pregunta
    public function getCorrectasByPregunta($pregunta_id)
    {
        $query = "SELECT 
                    a.id,
                    a.pregunta_id,
                    p.texto_pregunta,
                    a.texto_alternativa,
                    a.es_correcta
                  FROM " . $this->table_name . " a
                  LEFT JOIN Preguntas p ON a.pregunta_id = p.id
                  WHERE a.pregunta_id = :pregunta_id AND a.es_correcta = 1
                  ORDER BY a.id ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":pregunta_id", $pregunta_id);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Crear múltiples alternativas para una pregunta
    public function createMultiple($alternativas)
    {
        try {
            $this->conn->beginTransaction();

            $query = "INSERT INTO " . $this->table_name . " 
                      (pregunta_id, texto_alternativa, es_correcta) 
                      VALUES 
                      (:pregunta_id, :texto_alternativa, :es_correcta)";

            $stmt = $this->conn->prepare($query);

            $inserted_ids = [];

            foreach ($alternativas as $alternativa) {
                $stmt->bindParam(":pregunta_id", $alternativa['pregunta_id']);
                $stmt->bindParam(":texto_alternativa", $alternativa['texto_alternativa']);
                $stmt->bindParam(":es_correcta", $alternativa['es_correcta']);

                if ($stmt->execute()) {
                    $inserted_ids[] = $this->conn->lastInsertId();
                } else {
                    throw new Exception("Error al insertar alternativa");
                }
            }

            $this->conn->commit();
            return $inserted_ids;
        } catch (Exception $e) {
            $this->conn->rollback();
            return false;
        }
    }

    // Validar que exista al menos una alternativa correcta
    public function validateCorrectAnswers($pregunta_id)
    {
        $query = "SELECT COUNT(*) as total_correctas 
                  FROM " . $this->table_name . " 
                  WHERE pregunta_id = :pregunta_id AND es_correcta = 1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":pregunta_id", $pregunta_id);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['total_correctas'] > 0;
    }

    // Actualizar alternativa
    public function update()
    {
        $query = "UPDATE " . $this->table_name . " 
                  SET pregunta_id = :pregunta_id,
                      texto_alternativa = :texto_alternativa,
                      es_correcta = :es_correcta
                  WHERE id = :id";

        $stmt = $this->conn->prepare($query);

        // Limpiar datos
        $this->id = htmlspecialchars(strip_tags($this->id));
        $this->pregunta_id = htmlspecialchars(strip_tags($this->pregunta_id));
        $this->texto_alternativa = htmlspecialchars(strip_tags($this->texto_alternativa));
        $this->es_correcta = htmlspecialchars(strip_tags($this->es_correcta));

        // Vincular parámetros
        $stmt->bindParam(":id", $this->id);
        $stmt->bindParam(":pregunta_id", $this->pregunta_id);
        $stmt->bindParam(":texto_alternativa", $this->texto_alternativa);
        $stmt->bindParam(":es_correcta", $this->es_correcta);

        return $stmt->execute();
    }

    // Eliminar alternativa
    public function delete()
    {
        $query = "DELETE FROM " . $this->table_name . " WHERE id = :id";
        
        $stmt = $this->conn->prepare($query);
        
        $this->id = htmlspecialchars(strip_tags($this->id));
        
        $stmt->bindParam(":id", $this->id);
        
        return $stmt->execute();
    }

    // Eliminar todas las alternativas de una pregunta
    public function deleteByPregunta($pregunta_id)
    {
        $query = "DELETE FROM " . $this->table_name . " WHERE pregunta_id = :pregunta_id";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":pregunta_id", $pregunta_id);
        
        return $stmt->execute();
    }
}
?>