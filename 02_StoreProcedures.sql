USE almacen;
 
-- Stored Procedure para insertar nuevos Empleados.
DROP PROCEDURE IF EXISTS insertarEmpleado;
DELIMITER $$

CREATE PROCEDURE insertarEmpleado(	/* Datos Personales */
                                    IN	var_nombre          VARCHAR(64),    --  1
                                    IN	var_apellidoPaterno VARCHAR(64),    --  2
                                    IN	var_apellidoMaterno VARCHAR(64),    --  3
                                    IN  var_genero          VARCHAR(2),     --  4
                                    IN  var_fechaNacimiento VARCHAR(11),    --  5
                                    IN	var_calle           VARCHAR(129),   --  6
                                    IN  var_numero          VARCHAR(20),    --  7
                                    IN  var_colonia         VARCHAR(40),    --  8
                                    IN  var_cp              VARCHAR(25),    --  9
                                    IN  var_ciudad          VARCHAR(40),    -- 10
                                    IN  var_estado          VARCHAR(40),    -- 11
                                    IN	var_telcasa         VARCHAR(20),    -- 12
                                    IN	var_telmovil        VARCHAR(20),    -- 13
                                    IN	var_email           VARCHAR(129),   -- 14
                                    in  var_rfc				VARCHAR(15),	-- 15
                                    
                                    /* Datos de Usuario */
                                    IN	var_nombreUsuario   VARCHAR(129),   -- 16
                                    IN	var_contrasenia     VARCHAR(129),   -- 17
                                    IN	var_rol             VARCHAR(25),    -- 18                                    
                                    
                                    /* Valores de Retorno */
                                    OUT	var_idPersona       INT,            -- 18
                                    OUT	var_idUsuario       INT,            -- 19
                                    OUT	var_idEmpleado      INT,            -- 20
                                    OUT	var_numeroUnico     VARCHAR(65),    -- 21
                                    OUT var_lastToken       VARCHAR(65)     -- 22
				)                                    
    BEGIN        
        -- Comenzamos insertando los datos de la Persona:
        INSERT INTO persona (nombre, apellidoPaterno, apellidoMaterno, genero,
                             fechaNacimiento, calle, numero, colonia, cp, ciudad,
                             estado, telcasa, telmovil, email, rfc)
                    VALUES( var_nombre, var_apellidoPaterno, var_apellidoMaterno, 
                            var_genero, STR_TO_DATE(var_fechaNacimiento, '%d/%m/%Y'), 
                            var_calle, var_numero, var_colonia, var_cp, var_ciudad,
                            var_estado, var_telcasa, var_telmovil, var_email, var_rfc);
        -- Obtenemos el ID de Persona que se generó:
        SET var_idPersona = LAST_INSERT_ID();

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
        INSERT INTO empleado (idPersona, idUsuario, numeroUnico)
                    VALUES(var_idPersona, var_idUsuario, var_numeroUnico);
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

