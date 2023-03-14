USE almacen;

-- Vista que obtiene todos los datos de los Empleados:
DROP VIEW IF EXISTS v_empleados;
CREATE VIEW v_empleados AS
    SELECT  P.idPersona,
            P.nombre,
            P.apellidoPaterno,
            P.apellidoMaterno,
            P.genero,
            DATE_FORMAT(P.fechaNacimiento, '%d/%m/%Y') AS fechaNacimiento,
            P.calle,
            P.numero,
            P.colonia,
            P.cp,
            P.ciudad,
            P.estado, 
            P.telcasa,
            P.telmovil,
            P.email,
            P.rfc,
            E.idEmpleado,
            E.numeroUnico,
            E.estatus,
            U.idUsuario,
			U.nombre AS nombreUsuario,
			U.contrasenia,
			U.rol,
            U.lastToken,
            DATE_FORMAT(U.dateLastToken, '%d/%m/%Y %H:%i:%S') AS dateLastToken
    FROM    persona P
            INNER JOIN empleado E ON E.idPersona = P.idPersona
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