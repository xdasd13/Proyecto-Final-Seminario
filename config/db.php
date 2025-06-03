<?php
// Configuración de la base de datos
class DatabaseConfig {
    private $host = 'localhost';
    private $dbName = 'my_database';
    private $username = 'root';
    private $password = '';
    private $conn;

    // Hacemos la conexión a la base de datos
    public function getConnection(){
        $this->conn = null;
        // Verificamos si la conexión ya está establecida
        try {
            $this->conn = new PDO(
                "mysql:host={$this->host};
                dbname={$this->dbName}", 
                $this->username, 
                $this->password
            );
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->exec("set names utf8mb4");
        } catch(PDOException $exception){
            echo "Error de conexión: " . $exception->getMessage();
        }

        return $this->conn;
    }
}















?>