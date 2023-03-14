DROP DATABASE IF EXISTS almacen;
CREATE DATABASE almacen;
USE almacen;

-- ------------- TABLA USUARIO -------------- --
CREATE TABLE usuario (
	idUsuario           INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre              VARCHAR(129) UNIQUE NOT NULL,
    contrasenia         VARCHAR(129) NOT NULL,
    rol                 VARCHAR(25) NOT NULL DEFAULT 'Empleado', -- Rol: Administrador; Empleado;
    lastToken           VARCHAR(65) NOT NULL DEFAULT '', -- Esto es para la seguridad de los servicios
    dateLastToken       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP -- STR_TO_DATE('01/01/1901 00:00:00', '%d/%m/%Y %H:%i:%S')
);

-- ------------- TABLA PERSONA -------------- --
CREATE TABLE persona (
	idPersona 			INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre 				VARCHAR(50) NOT NULL,
	apellidoPaterno 	VARCHAR(40) NOT NULL,
	apellidoMaterno 	VARCHAR(40) NOT NULL DEFAULT '',
    genero              VARCHAR(2) NOT NULL DEFAULT 'O', -- Genero: M; F; O;
	fechaNacimiento 	DATE NOT NULL,
	calle 				VARCHAR(129) NOT NULL DEFAULT '',
	numero 				VARCHAR(20)  NOT NULL DEFAULT '',
	colonia 			VARCHAR(40) NOT NULL DEFAULT '',
	cp 					VARCHAR(25) NOT NULL DEFAULT '', -- Aunque el CP es un numero, se maneja como cadena por la internacionalización
	ciudad 				VARCHAR(40) NOT NULL DEFAULT '',
	estado 				VARCHAR(40) NOT NULL DEFAULT '',
	telcasa             VARCHAR(20) NOT NULL DEFAULT '',
	telmovil            VARCHAR(20) NOT NULL DEFAULT '',
    email               VARCHAR(129) NOT NULL DEFAULT '',
    rfc 				VARCHAR(15) NOT NULL DEFAULT ''
);

-- ------------- TABLA EMPLEADO -------------- --
CREATE TABLE empleado (
    idEmpleado			INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    idPersona			INT NOT NULL,
    idUsuario           INT NOT NULL,
    numeroUnico         VARCHAR(65) NOT NULL DEFAULT '',
    estatus             INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_empleado_persona FOREIGN KEY (idPersona) 
                REFERENCES persona(idPersona),
    CONSTRAINT fk_empleado_usuario FOREIGN KEY (idUsuario) 
                REFERENCES usuario(idUsuario)
);

-- ------------- TABLA PRODUCTO -------------- --
CREATE TABLE producto(
    idProducto          INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre              VARCHAR(255) NOT NULL,
    marca               VARCHAR(129) NOT NULL,
    descripcion        	VARCHAR(129) NOT NULL,
    existencias         INT NOT NULL DEFAULT 1,
	proveedor        	VARCHAR(129) NOT NULL,
    estatus             INT NOT NULL DEFAULT 1 -- 1: Activo; 0: Inactivo o Eliminado
);

-- ------------- TABLA ESTANTE -------------- --
CREATE TABLE estante(
    idEstante          INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre              VARCHAR(255) NOT NULL,
    cantidad            INT NOT NULL DEFAULT 1,
    idProducto        INT NOT NULL,
    
CONSTRAINT fk_estante_producto FOREIGN KEY (idProducto) 
                REFERENCES producto(idProducto)
);

-- ------------- TABLA ALMACEN -------------- --
CREATE TABLE almacen(
    idAlmacen          INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    idEstante          INT NOT NULL,
    
CONSTRAINT fk_almacen_estante FOREIGN KEY (idEstante) 
                REFERENCES estante(idEstante)
);

-- ------------- TABLA SALIDA -------------- --
CREATE TABLE salida(
    idSalida          	INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    salidaIndividual  	INT NOT NULL DEFAULT 1,
    salidaTotal  		INT NOT NULL,
    fechaSalida			DATE NOT NULL,
    idProducto			INT NOT NULL,
    
CONSTRAINT fk_salida_producto FOREIGN KEY (idProducto) 
                REFERENCES producto(idProducto)
);

-- ------------- TABLA REPORTE -------------- --
CREATE TABLE reporte(
    idReporte          INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    idSalida          INT NOT NULL,
    
CONSTRAINT fk_reporte_salidas FOREIGN KEY (idSalida) 
                REFERENCES salida(idSalida)
);

-- ------------- TABLA ENTRADA -------------- --
CREATE TABLE entrada(
    idEntrada          	INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    entradaIndividual  	INT NOT NULL DEFAULT 1,
    entradaTotal  		INT NOT NULL,
    fechaEntrada			DATE NOT NULL,
    idProducto			INT NOT NULL,
    
CONSTRAINT fk_entrada_idEntrada FOREIGN KEY (idProducto) 
                REFERENCES producto(idProducto)
);