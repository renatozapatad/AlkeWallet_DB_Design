--Creamos la base de datos

CREATE DATABASE AlkeWallet;
--Nos metemos dentro de la base de datos para crear tablas
USE AlkeWallet;

CREATE TABLE Moneda (
    currency_id INT AUTO_INCREMENT PRIMARY KEY,
    currency_name VARCHAR(50) NOT NULL,
    currency_symbol VARCHAR(5) NOT NULL
);

CREATE TABLE Usuario (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    saldo DECIMAL(15,2) DEFAULT 0.00,
    currency_id INT,
    FOREIGN KEY (currency_id) REFERENCES Moneda(currency_id)
);

CREATE TABLE Transaccion (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_user_id INT NOT NULL,
    receiver_user_id INT NOT NULL,
    importe DECIMAL(15,2) NOT NULL CHECK (importe > 0),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_user_id) REFERENCES Usuario(user_id),
    FOREIGN KEY (receiver_user_id) REFERENCES Usuario(user_id)
);


-- Insertar datos
INSERT INTO Moneda (currency_name, currency_symbol) VALUES 
('Peso Chileno', 'CLP'), ('Dólar', 'USD');

INSERT INTO Usuario (nombre, correo_electronico, contrasena, saldo, currency_id) VALUES 
('Juan Perez', 'juan@mail.com', '1234', 50000.00, 1),
('Maria Silva', 'maria@mail.com', '5678', 15000.00, 1);

-- Transacción ACID
START TRANSACTION;
    UPDATE Usuario SET saldo = saldo - 10000.00 WHERE user_id = 1;
    UPDATE Usuario SET saldo = saldo + 10000.00 WHERE user_id = 2;
    INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe) VALUES (1, 2, 10000.00);
COMMIT;


--Consultas
-- 1. Nombre de la moneda elegida por un usuario
SELECT u.nombre, m.currency_name FROM Usuario u INNER JOIN Moneda m ON u.currency_id = m.currency_id WHERE u.user_id = 1;

-- 2. Todas las transacciones registradas
SELECT * FROM Transaccion;

-- 3. Transacciones realizadas por un usuario
SELECT * FROM Transaccion WHERE sender_user_id = 1 OR receiver_user_id = 1;

-- 4. Modificar el correo electrónico
UPDATE Usuario SET correo_electronico = 'juan_nuevo@mail.com' WHERE user_id = 1;

-- 5. Eliminar una transacción
DELETE FROM Transaccion WHERE transaction_id = 1;
