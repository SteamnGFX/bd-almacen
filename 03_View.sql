USE almacen;

-- Vista que obtiene todos los datos de los Empleados:
DROP VIEW IF EXISTS v_empleados;
CREATE VIEW v_empleados AS
    SELECT  
            E.idEmpleado,
            U.idUsuario,
            U.nombre AS nombreUsuario,
			U.contrasenia,
			U.rol,
            U.lastToken,
            E.nombre,
            E.apellidoPaterno,
            E.apellidoMaterno,
            E.genero,
			E.telefonoFijo,
            E.telefonoMovil,
            E.rfc,
            E.correo,
            E.numeroUnico,
            E.estatus
	FROM    empleado E
            INNER JOIN usuario U ON U.idUsuario = E.idUsuario;

-- Vista que obtiene todos los datos de los Armazones:
DROP VIEW IF EXISTS v_producto;
CREATE VIEW v_producto AS
    SELECT  nombre,
            marca,
            descripcion,
            existencias,
            proveedor,            
			estatus
    FROM    producto;