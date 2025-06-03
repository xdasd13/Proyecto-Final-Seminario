<?php
require_once __DIR__ . '/../config/db.php';

class Evaluacion
{
    private $conn;
    private $table_name = "Evaluaciones";

    // Propiedades de la tabla
    public $id;
    public $nombre;
    public $area_id;
    public $admin_id;
    public $fecha_creacion;
    public $fecha_inicio;
    public $fecha_fin;
    public $duracion;
    public $puntaje;
    public $publicada;

    public function __construct()
    {
        $database = new DatabaseConfig();
        $this->conn = $database->getConnection();
    }

    // Crear nueva evaluación
    public function create()
    {
        $query = "INSERT INTO " . $this->table_name . " 
                  (nombre, area_id, admin_id, fecha_inicio, fecha_fin, duracion, puntaje, publicada) 
                  VALUES 
                  (:nombre, :area_id, :admin_id, :fecha_inicio, :fecha_fin, :duracion, :puntaje, :publicada)";

        $stmt = $this->conn->prepare($query);

        // Limpiar datos
        $this->nombre = htmlspecialchars(strip_tags($this->nombre));
        $this->area_id = htmlspecialchars(strip_tags($this->area_id));
        $this->admin_id = htmlspecialchars(strip_tags($this->admin_id));
        $this->fecha_inicio = htmlspecialchars(strip_tags($this->fecha_inicio));
        $this->fecha_fin = htmlspecialchars(strip_tags($this->fecha_fin));
        $this->duracion = htmlspecialchars(strip_tags($this->duracion));
        $this->puntaje = htmlspecialchars(strip_tags($this->puntaje));
        $this->publicada = htmlspecialchars(strip_tags($this->publicada));

        // Vincular parámetros
        $stmt->bindParam(":nombre", $this->nombre);
        $stmt->bindParam(":area_id", $this->area_id);
        $stmt->bindParam(":admin_id", $this->admin_id);
        $stmt->bindParam(":fecha_inicio", $this->fecha_inicio);
        $stmt->bindParam(":fecha_fin", $this->fecha_fin);
        $stmt->bindParam(":duracion", $this->duracion);
        $stmt->bindParam(":puntaje", $this->puntaje);
        $stmt->bindParam(":publicada", $this->publicada);

        if ($stmt->execute()) {
            return $this->conn->lastInsertId();
        }

        return false;
    }

    // Obtener todas las evaluaciones
    public function getAll()
    {
        $query = "SELECT 
                    e.id,
                    e.nombre,
                    e.area_id,
                    a.nombre as area_nombre,
                    e.admin_id,
                    ad.nombre as admin_nombre,
                    e.fecha_creacion,
                    e.fecha_inicio,
                    e.fecha_fin,
                    e.duracion,
                    e.puntaje,
                    e.publicada
                  FROM " . $this->table_name . " e
                  LEFT JOIN Areas_eva a ON e.area_id = a.id
                  LEFT JOIN Administradores ad ON e.admin_id = ad.id
                  ORDER BY e.fecha_creacion DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener evaluación por ID
    public function getById($id)
    {
        $query = "SELECT 
                    e.id,
                    e.nombre,
                    e.area_id,
                    a.nombre as area_nombre,
                    e.admin_id,
                    ad.nombre as admin_nombre,
                    e.fecha_creacion,
                    e.fecha_inicio,
                    e.fecha_fin,
                    e.duracion,
                    e.puntaje,
                    e.publicada
                  FROM " . $this->table_name . " e
                  LEFT JOIN Areas_eva a ON e.area_id = a.id
                  LEFT JOIN Administradores ad ON e.admin_id = ad.id
                  WHERE e.id = :id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Obtener evaluaciones por área
    public function getByArea($area_id)
    {
        $query = "SELECT 
                    e.id,
                    e.nombre,
                    e.area_id,
                    a.nombre as area_nombre,
                    e.admin_id,
                    ad.nombre as admin_nombre,
                    e.fecha_creacion,
                    e.fecha_inicio,
                    e.fecha_fin,
                    e.duracion,
                    e.puntaje,
                    e.publicada
                  FROM " . $this->table_name . " e
                  LEFT JOIN Areas_eva a ON e.area_id = a.id
                  LEFT JOIN Administradores ad ON e.admin_id = ad.id
                  WHERE e.area_id = :area_id
                  ORDER BY e.fecha_creacion DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":area_id", $area_id);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener evaluaciones por administrador
    public function getByAdmin($admin_id)
    {
        $query = "SELECT 
                    e.id,
                    e.nombre,
                    e.area_id,
                    a.nombre as area_nombre,
                    e.admin_id,
                    ad.nombre as admin_nombre,
                    e.fecha_creacion,
                    e.fecha_inicio,
                    e.fecha_fin,
                    e.duracion,
                    e.puntaje,
                    e.publicada
                  FROM " . $this->table_name . " e
                  LEFT JOIN Areas_eva a ON e.area_id = a.id
                  LEFT JOIN Administradores ad ON e.admin_id = ad.id
                  WHERE e.admin_id = :admin_id
                  ORDER BY e.fecha_creacion DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":admin_id", $admin_id);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener evaluaciones publicadas
    public function getPublicadas()
    {
        $query = "SELECT 
                    e.id,
                    e.nombre,
                    e.area_id,
                    a.nombre as area_nombre,
                    e.admin_id,
                    ad.nombre as admin_nombre,
                    e.fecha_creacion,
                    e.fecha_inicio,
                    e.fecha_fin,
                    e.duracion,
                    e.puntaje,
                    e.publicada
                  FROM " . $this->table_name . " e
                  LEFT JOIN Areas_eva a ON e.area_id = a.id
                  LEFT JOIN Administradores ad ON e.admin_id = ad.id
                  WHERE e.publicada = 1
                  ORDER BY e.fecha_creacion DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Obtener evaluaciones activas (dentro del rango de fechas)
    public function getActivas()
    {
        $query = "SELECT 
                    e.id,
                    e.nombre,
                    e.area_id,
                    a.nombre as area_nombre,
                    e.admin_id,
                    ad.nombre as admin_nombre,
                    e.fecha_creacion,
                    e.fecha_inicio,
                    e.fecha_fin,
                    e.duracion,
                    e.puntaje,
                    e.publicada
                  FROM " . $this->table_name . " e
                  LEFT JOIN Areas_eva a ON e.area_id = a.id
                  LEFT JOIN Administradores ad ON e.admin_id = ad.id
                  WHERE e.publicada = 1 
                  AND e.fecha_inicio <= NOW() 
                  AND e.fecha_fin >= NOW()
                  ORDER BY e.fecha_inicio ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Actualizar evaluación
    public function update()
    {
        $query = "UPDATE " . $this->table_name . " 
                  SET nombre = :nombre,
                      area_id = :area_id,
                      admin_id = :admin_id,
                      fecha_inicio = :fecha_inicio,
                      fecha_fin = :fecha_fin,
                      duracion = :duracion,
                      puntaje = :puntaje,
                      publicada = :publicada
                  WHERE id = :id";

        $stmt = $this->conn->prepare($query);

        // Limpiar datos
        $this->id = htmlspecialchars(strip_tags($this->id));
        $this->nombre = htmlspecialchars(strip_tags($this->nombre));
        $this->area_id = htmlspecialchars(strip_tags($this->area_id));
        $this->admin_id = htmlspecialchars(strip_tags($this->admin_id));
        $this->fecha_inicio = htmlspecialchars(strip_tags($this->fecha_inicio));
        $this->fecha_fin = htmlspecialchars(strip_tags($this->fecha_fin));
        $this->duracion = htmlspecialchars(strip_tags($this->duracion));
        $this->puntaje = htmlspecialchars(strip_tags($this->puntaje));
        $this->publicada = htmlspecialchars(strip_tags($this->publicada));

        // Vincular parámetros
        $stmt->bindParam(":id", $this->id);
        $stmt->bindParam(":nombre", $this->nombre);
        $stmt->bindParam(":area_id", $this->area_id);
        $stmt->bindParam(":admin_id", $this->admin_id);
        $stmt->bindParam(":fecha_inicio", $this->fecha_inicio);
        $stmt->bindParam(":fecha_fin", $this->fecha_fin);
        $stmt->bindParam(":duracion", $this->duracion);
        $stmt->bindParam(":puntaje", $this->puntaje);
        $stmt->bindParam(":publicada", $this->publicada);

        return $stmt->execute();
    }

    // Eliminar evaluación
    public function delete()
    {
        $query = "DELETE FROM " . $this->table_name . " WHERE id = :id";
        
        $stmt = $this->conn->prepare($query);
        
        $this->id = htmlspecialchars(strip_tags($this->id));
        
        $stmt->bindParam(":id", $this->id);
        
        return $stmt->execute();
    }

    // Publicar/despublicar evaluación
    public function togglePublicada($id, $estado)
    {
        $query = "UPDATE " . $this->table_name . " 
                  SET publicada = :publicada 
                  WHERE id = :id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->bindParam(":publicada", $estado);

        return $stmt->execute();
    }

    // Verificar si una evaluación está activa
    public function isActiva($id)
    {
        $query = "SELECT COUNT(*) as count 
                  FROM " . $this->table_name . " 
                  WHERE id = :id 
                  AND publicada = 1 
                  AND fecha_inicio <= NOW() 
                  AND fecha_fin >= NOW()";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['count'] > 0;
    }

    // Contar total de evaluaciones
    public function countTotal()
    {
        $query = "SELECT COUNT(*) as total FROM " . $this->table_name;
        
        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['total'];
    }

    // Contar evaluaciones por estado
    public function countByEstado($publicada)
    {
        $query = "SELECT COUNT(*) as total 
                  FROM " . $this->table_name . " 
                  WHERE publicada = :publicada";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":publicada", $publicada);
        $stmt->execute();
        
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result['total'];
    }
}
?>