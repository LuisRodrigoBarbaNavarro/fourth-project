/* Crear Esquema */
DROP SCHEMA IF EXISTS flower_shop;
CREATE SCHEMA flower_shop;

/* Usar Esquema */
USE flower_shop;

/* Crear Tabla 'users' */
DROP TABLE IF EXISTS flower_shop.users;
ALTER TABLE flower_shop.users AUTO_INCREMENT = 1;
CREATE TABLE flower_shop.users
(
    id smallint unsigned NOT NULL AUTO_INCREMENT,
    username varchar(20) NOT NULL,
    password char(102) NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(50) NOT NULL,
    physical_address varchar(255) NOT NULL,
    phone varchar(20),
    user_type tinyint NOT NULL,
    PRIMARY KEY (id)
)   ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* Crear Tabla 'products' */
DROP TABLE IF EXISTS flower_shop.products;
ALTER TABLE flower_shop.products AUTO_INCREMENT = 1;
CREATE TABLE flower_shop.products
(
    id smallint unsigned NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    description varchar(255) NOT NULL,
    price decimal(10,2) NOT NULL,
    url_image varchar(255),
    PRIMARY KEY (id)
)   ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* Crear Tabla 'user_cart' */
DROP TABLE IF EXISTS flower_shop.user_cart;
ALTER TABLE flower_shop.user_cart AUTO_INCREMENT = 1;
CREATE TABLE flower_shop.user_cart
(
    id smallint unsigned NOT NULL AUTO_INCREMENT,
    user_id smallint unsigned NOT NULL,
    product_id smallint unsigned NOT NULL,
    quantity smallint unsigned NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES flower_shop.users(id),
    FOREIGN KEY (product_id) REFERENCES flower_shop.products(id)
)   ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* Crear Procedimiento Almacenado 'add_user' */
DROP PROCEDURE IF EXISTS sp_add_user;
DELIMITER //
CREATE PROCEDURE sp_add_user
(
    IN p_username VARCHAR(20),
    IN p_password VARCHAR(102),
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(50),
    IN p_physical_address VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_user_type TINYINT
)
BEGIN
	DECLARE user_count INT;
    DECLARE hashed_password VARCHAR(255);
    SET hashed_password = SHA2(p_password, 256);

    -- Verificar si el usuario ya existe.
    SELECT COUNT(*) INTO user_count FROM flower_shop.users WHERE username = p_username COLLATE utf8mb4_unicode_ci;
    
    -- Manejar la excepción de usuario duplicado.
    IF user_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Usuario ya existe.';
    END IF;

    -- Verificar campos nulos.
    IF p_username IS NULL OR p_password IS NULL OR p_user_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Campos obligatorios no pueden ser nulos.';
    END IF;

    -- Insertar el nuevo usuario.
    INSERT INTO users (username, password, first_name, last_name, email, physical_address, phone, user_type)
    VALUES (p_username, hashed_password, p_first_name, p_last_name, p_email, p_physical_address, p_phone, p_user_type);
END //
DELIMITER ;

/* Crear Procedimiento Almacenado 'edit_user' */
DROP PROCEDURE IF EXISTS sp_edit_user;
DELIMITER //
CREATE PROCEDURE sp_edit_user
(
    IN p_id SMALLINT UNSIGNED,
    IN p_username VARCHAR(20),
    IN p_password VARCHAR(102),
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(50),
    IN p_physical_address VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_user_type TINYINT
)
BEGIN
    DECLARE user_count INT;
    DECLARE hashed_password VARCHAR(255);
    SET hashed_password = SHA2(p_password, 256);

    -- Verificar si el usuario ya existe.
    SELECT COUNT(*) INTO user_count FROM flower_shop.users WHERE username = p_username COLLATE utf8mb4_unicode_ci;
    
    -- Manejar la excepción de usuario duplicado.
    IF user_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Usuario ya existe.';
    END IF;

    -- Verificar campos nulos.
    IF p_username IS NULL OR p_password IS NULL OR p_user_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Campos obligatorios no pueden ser nulos.';
    END IF;

    -- Actualizar el usuario.
    UPDATE users
    SET username = p_username, password = hashed_password, first_name = p_first_name, last_name = p_last_name, email = p_email, physical_address = p_physical_address, phone = p_phone, user_type = p_user_type
    WHERE id = p_id;
END //
DELIMITER ;

/* Crear Procedimiento Almacenado 'delete_user' */
DROP PROCEDURE IF EXISTS sp_delete_user;
DELIMITER //
CREATE PROCEDURE sp_delete_user
(
    IN p_id SMALLINT UNSIGNED
)
BEGIN
    -- Eliminar el usuario.
    DELETE FROM users WHERE id = p_id;
END //
DELIMITER ;

/* Crear Procedimiento Almacenado 'verify_identity' */
DROP PROCEDURE IF EXISTS sp_verify_identity;
DELIMITER //
CREATE PROCEDURE sp_verify_identity
(
    IN p_username VARCHAR(20), 
    IN p_plain_text_password VARCHAR(20)
)
BEGIN
	DECLARE stored_password VARCHAR(255);
	SELECT password INTO stored_password
    FROM flower_shop.users
	WHERE username = p_username COLLATE utf8mb4_unicode_ci;
	IF stored_password IS NOT NULL AND stored_password = SHA2(p_plain_text_password, 256) THEN
		SELECT id, username, stored_password, first_name, last_name, email, physical_address, phone, user_type
        FROM flower_shop.users
		WHERE username = p_username COLLATE utf8mb4_unicode_ci;
	ELSE
		SELECT NULL;
	END IF;
END //
DELIMITER ;

/* Crear Usuarios 'Administrador' */
CALL sp_add_user("administrador-1", "admin-1", "John", "Doe", "johndoe@mail.com", "Calle 1 # 2-3", "1234567890", 1);
CALL sp_add_user("administrador-2", "admin-2", "Anna", "Collins", "annacollins@mail.com", "Calle 2 # 2-3", "1234567890", 1);

/* Verificar Usuarios 'Administrador' */
CALL sp_verify_identity("administrador-1", "admin-1");
CALL sp_verify_identity("administrador-2", "admin-2");

select * from products;