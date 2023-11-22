/* ***** Esquema ******/

DROP SCHEMA IF EXISTS flower_shop;
CREATE SCHEMA flower_shop;
USE flower_shop;

/* ***** Esquema ***** */

/* ***** Tablas ****** */

/* Tabla 'users' */
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
/* Tabla 'users' */

/* Tabla 'products' */
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
/* Tabla 'products' */

/* Tabla 'shopping_cart' */
DROP TABLE IF EXISTS flower_shop.shopping_cart;
ALTER TABLE flower_shop.shopping_cart AUTO_INCREMENT = 1;
CREATE TABLE flower_shop.shopping_cart
(
    id smallint unsigned NOT NULL AUTO_INCREMENT,
    user_id smallint unsigned NOT NULL,
    product_id smallint unsigned NOT NULL,
    quantity smallint unsigned NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
)   ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/* Tabla 'shopping_cart' */

/* ***** Tablas ******/

/* ***** Procedimientos Almacenados - 'users' ******/

/* Procedimiento Almacenado 'add_user' */
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
/* Procedimiento Almacenado 'add_user' */

/* Procedimiento Almacenado 'edit_user' */
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
/* Procedimiento Almacenado 'edit_user' */

/* Procedimiento Almacenado 'delete_user' */
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
/* Procedimiento Almacenado 'delete_user' */

/* Procedimiento Almacenado 'verify_identity' */
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
/* Procedimiento Almacenado 'verify_identity' */

/* Procedimiento Almacenado 'get_users' */
DROP PROCEDURE IF EXISTS sp_get_users;
DELIMITER //
CREATE PROCEDURE sp_get_users()
BEGIN
    -- Obtener todos los usuarios.
    SELECT * FROM users;
END //
DELIMITER ;
/* Procedimiento Almacenado 'get_users' */

/* Procedimiento Almacenado 'get_users_by_id' */
DROP PROCEDURE IF EXISTS sp_get_users_by_id;
DELIMITER //
CREATE PROCEDURE sp_get_users_by_id
(
    IN p_id SMALLINT UNSIGNED
)
BEGIN
    -- Obtener un usuario por su id.
    SELECT * FROM users WHERE id = p_id;
END //
DELIMITER ;
/* Procedimiento Almacenado 'get_users_by_id' */

/* ***** Procedimientos Almacenados - 'users' ******/

/* ***** Procedimientos Almacenados - 'products' ******/

/* Procedimiento Almacenado 'add_product' */
DROP PROCEDURE IF EXISTS sp_add_product;
DELIMITER //
CREATE PROCEDURE sp_add_product
(
    IN p_name VARCHAR(255),
    IN p_description VARCHAR(255),
    IN p_price DECIMAL(10,2),
    IN p_url_image VARCHAR(255)
)
BEGIN
    DECLARE product_count INT;

    -- Verificar si el producto ya existe.
    SELECT COUNT(*) INTO product_count FROM products WHERE name = p_name COLLATE utf8mb4_unicode_ci;
    
    -- Manejar la excepción de producto duplicado.
    IF product_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Producto ya existe.';
    END IF;

    -- Verificar campos nulos.
    IF p_name IS NULL OR p_description IS NULL OR p_price IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Campos obligatorios no pueden ser nulos.';
    END IF;

    -- Insertar el nuevo producto.
    INSERT INTO products (name, description, price, url_image)
    VALUES (p_name, p_description, p_price, p_url_image);
END //
DELIMITER ;

/* ***** Procedimientos Almacenados - 'shopping_cart' ******/

/* Procedimiento Almacenado 'get_shopping_cart' */
DROP PROCEDURE IF EXISTS sp_get_shopping_cart;
DELIMITER //
CREATE PROCEDURE sp_get_shopping_cart
(
    IN p_user_id SMALLINT UNSIGNED
)
BEGIN
    -- Obtener todos los productos del carrito de compras de un usuario.
    SELECT * FROM shopping_cart WHERE user_id = p_user_id;
END //
DELIMITER ;
/* Procedimiento Almacenado 'get_shopping_cart' */

/* Procedimiento Almacenado 'add_to_shopping_cart' */
DROP PROCEDURE IF EXISTS sp_add_to_shopping_cart;
DELIMITER //
CREATE PROCEDURE sp_add_to_shopping_cart
(
    IN p_user_id SMALLINT UNSIGNED,
    IN p_product_id SMALLINT UNSIGNED,
    IN p_quantity SMALLINT UNSIGNED
)
BEGIN
    DECLARE product_count INT;
    DECLARE product_quantity INT;
    DECLARE new_quantity INT;
    SET product_count = 0;
    SET product_quantity = 0;
    SET new_quantity = 0;

    -- Verificar si el producto ya existe en el carrito de compras.
    SELECT COUNT(*) INTO product_count FROM shopping_cart WHERE user_id = p_user_id AND product_id = p_product_id;
    
    -- Obtener la cantidad del producto en el carrito de compras.
    SELECT quantity INTO product_quantity FROM shopping_cart WHERE user_id = p_user_id AND product_id = p_product_id;

    -- Manejar la excepción de producto duplicado.
    IF product_count > 0 THEN
        SET new_quantity = product_quantity + p_quantity;
        UPDATE shopping_cart SET quantity = new_quantity WHERE user_id = p_user_id AND product_id = p_product_id;
    ELSE
        INSERT INTO shopping_cart (user_id, product_id, quantity) VALUES (p_user_id, p_product_id, p_quantity);
    END IF;
END //
DELIMITER ;
/* Procedimiento Almacenado 'add_to_shopping_cart' */

/* Procedimiento Almacenado 'remove_from_shopping_cart' */
DROP PROCEDURE IF EXISTS sp_remove_from_shopping_cart;
DELIMITER //
CREATE PROCEDURE sp_remove_from_shopping_cart
(
    IN p_user_id SMALLINT UNSIGNED,
    IN p_product_id SMALLINT UNSIGNED
)
BEGIN
    -- Eliminar un producto del carrito de compras.
    DELETE FROM shopping_cart WHERE user_id = p_user_id AND product_id = p_product_id;
END //
DELIMITER ;
/* Procedimiento Almacenado 'remove_from_shopping_cart' */

/* Procedimiento Almacenado 'clear_shopping_cart' */
DROP PROCEDURE IF EXISTS sp_clear_shopping_cart;
DELIMITER //
CREATE PROCEDURE sp_clear_shopping_cart
(
    IN p_user_id SMALLINT UNSIGNED
)
BEGIN
    -- Eliminar todos los productos del carrito de compras de un usuario.
    DELETE FROM shopping_cart WHERE user_id = p_user_id;
END //
DELIMITER ;
/* Procedimiento Almacenado 'clear_shopping_cart' */

/* Procedimiento Almacenado 'get_essential_data' */
DROP PROCEDURE IF EXISTS sp_get_essential_data;
DELIMITER //
CREATE PROCEDURE sp_get_essential_data()
BEGIN
    SELECT shopping_cart.id, products.name, shopping_cart.quantity, products.price, (shopping_cart.quantity * products.price) AS total_price
    FROM shopping_cart
    INNER JOIN products ON shopping_cart.product_id = products.id;
END //
DELIMITER ;
/* Procedimiento Almacenado 'get_essential_data' */

/* ***** Procedimientos Almacenados - 'shopping_cart' ******/

/* Usuarios 'Administrador' */
CALL sp_add_user("administrador-1", "admin-1", "John", "Doe", "johndoe@mail.com", "Calle 1 # 2-3", "1234567890", 1);
CALL sp_add_user("administrador-2", "admin-2", "Anna", "Collins", "annacollins@mail.com", "Calle 2 # 2-3", "1234567890", 1);

/* Productos - 10 - 'Flores' */
CALL sp_add_product("Rosa", "Rosa roja", 10000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
CALL sp_add_product("Girasol", "Girasol amarillo", 15000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
CALL sp_add_product("Orquídea", "Orquídea morada", 20000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
CALL sp_add_product("Tulipán", "Tulipán rojo", 25000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
CALL sp_add_product("Margarita", "Margarita blanca", 30000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
CALL sp_add_product("Lirio", "Lirio amarillo", 35000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
CALL sp_add_product("Clavel", "Clavel rosado", 40000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
CALL sp_add_product("Crisantemo", "Crisantemo blanco", 45000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
CALL sp_add_product("Hortensia", "Hortensia azul", 50000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
CALL sp_add_product("Lavanda", "Lavanda morada", 55000, "https://i.pinimg.com/originals/0e/0d/9a/0e0d9a5e2b5b6b6b5b6b5b6b5b6b5b6b.jpg");
/* Productos - 10 - 'Flores' */