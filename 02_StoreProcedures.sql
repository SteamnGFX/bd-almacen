USE almacen;
 
-- Stored Procedure para insertar nuevos Empleados.
DROP PROCEDURE IF EXISTS insertarEmpleado;
DELIMITER $$

CREATE PROCEDURE insertarEmpleado(	/* Datos Personales */
                                    IN	var_nombre          VARCHAR(64),    --  1
                                    IN	var_apellidoPaterno VARCHAR(64),    --  2
                                    IN	var_apellidoMaterno VARCHAR(64),    --  3
                                    IN  var_genero          VARCHAR(2),     --  4
                                    IN	var_telefonoFijo    VARCHAR(20),    --  5
                                    IN	var_telefonoMovil   VARCHAR(20),    --  6
                                    IN	var_correo          VARCHAR(129),   --  7
                                    in  var_rfc				VARCHAR(15),	--  8
                                    
                                    /* Datos de Usuario */
                                    IN	var_nombreUsuario   VARCHAR(129),   -- 9
                                    IN	var_contrasenia     VARCHAR(129),   -- 10
                                    IN	var_rol             VARCHAR(25),    -- 11                                    
                                    
                                    /* Valores de Retorno */
                                    OUT	var_idUsuario       INT,            -- 12
                                    OUT	var_idEmpleado      INT,            -- 13
                                    OUT	var_numeroUnico     VARCHAR(65),    -- 14
                                    OUT var_lastToken       VARCHAR(65)     -- 15
				)                                    
    BEGIN        
        -- Insertamos los datos de seguridad del Empleado:
        INSERT INTO usuario ( nombre, contrasenia, rol) 
                    VALUES( var_nombreUsuario, var_contrasenia, var_rol);
        -- Obtenemos el ID de Usuario que se generó:
        SET var_idUsuario = LAST_INSERT_ID();

        --  Generamos el numero unico de empleado.        
        SET var_numeroUnico = '';
        --  Agregamos la primera letra del apellidoPaterno:
        IF  LENGTH(var_apellidoPaterno) >= 1 THEN
            SET var_numeroUnico = SUBSTRING(var_apellidoPaterno, 1, 1);
        ELSE
            SET var_numeroUnico = 'X';
        END IF;
        --  Agregamos la segunda letra del apellidoPaterno:
        IF  LENGTH(var_apellidoPaterno) >= 2 THEN
            SET var_numeroUnico = CONCAT(var_numeroUnico, SUBSTRING(var_apellidoPaterno, 2, 1));
        ELSE
            SET var_numeroUnico = CONCAT(var_numeroUnico, 'X');
        END IF;        
        --  Agregamos el timestamp:
        SET var_numeroUnico = CONCAT(var_numeroUnico, CAST(UNIX_TIMESTAMP() AS CHAR));
        -- Codificamos el numero unico generado:
        SET var_numeroUnico = MD5(var_numeroUnico);

        -- Finalmente, insertamos en la tabla Empleado:
        INSERT INTO empleado (idUsuario, nombre, apellidoPaterno, apellidoMaterno, genero, rfc, correo, numeroUnico, estatus, telefonoFijo, telefonoMovil)
                    VALUES(var_idUsuario, var_nombre, var_apellidoPaterno, var_apellidoMaterno, var_genero, var_rfc,
                    var_correo, var_numeroUnico, 1, var_telefonoFijo, var_telefonoMovil);
        -- Obtenemos el ID del Empleado que se genero:
        SET var_idEmpleado = LAST_INSERT_ID();
    END
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS insertarProducto;
DELIMITER $$
CREATE PROCEDURE insertarProducto(	/* Datos del Producto */
                                    IN	var_nombre          VARCHAR(255),   --  1
                                    IN	var_marca          	VARCHAR(129),   --  2
									IN  var_descripcion     VARCHAR(129),   --  4
                                    IN  var_existencias     INT,            --  6
                                    IN 	var_proveedor       VARCHAR(129),	--  7
                                    
                                    /* Valores de Retorno */
                                    OUT	var_idProducto      INT             --  8
				)                                    
    BEGIN        
        -- Comenzamos insertando los datos del Producto:
        INSERT INTO producto (nombre, marca, descripcion, existencias, proveedor, estatus)
                    VALUES   (var_nombre, var_marca, var_descripcion, var_existencias, var_proveedor, 1);
        -- Obtenemos el ID de Producto que se generó:
        SET var_idProducto = LAST_INSERT_ID();
END
$$

DELIMITER ;

