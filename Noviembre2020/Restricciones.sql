-- CREACION DE LA BASE DE DATOS CON RESTRICCIONES
--

DROP DATABASE OBLIGATORIOBD2

CREATE DATABASE OBLIGATORIOBD2
GO

USE OBLIGATORIOBD2
GO

/*
TAREAS (TarId, TarEstado, TarHrsAcum, TarFchIni, TarFchFin, TarFchFPrev,
TarDescrip)
En esta tabla se registran las Tareas que realiza el área de Tecnología. Las tareas se identifican por
un autonumerico, y tienen un Estado que puede tomar valores: EN ESPERA, EN DESARROLLO,
RESUELTO, CANCELADA. También se guarda la cantidad de horas de trabajo acumuladas en
atención a cada tarea, así como la fecha de inicio, la fecha de finalización y la fecha de finalización
prevista.
Finalmente, todas las tareas tienen una descripción.
Excepto el campo fecha de finalización todos los demás son obligatorios.
Debe controlarse que la fecha de inicio no sea mayor a la fecha prevista de finalización
Se considera que la cantidad de horas de trabajo acumuladas debe ser mayor a 1 hr, debido que la
sola gestión inicial lleva por lo menos ese tiempo.

*/

Create Table TAREAS (
	TarId int identity(1,1)	not null, 
	TarEstado varchar(15) NOT NULL, 
	TarHrsAcum int NOT NULL, 
	TarFchIni date NOT NULL, 
	TarFchFin date, 
	TarFchFPrev date NOT NULL, 
	TarDescrip varchar(200) NOT NULL,
	PRIMARY KEY (TarId),
	CHECK (TarEstado = 'EN ESPERA' OR TarEstado = 'EN DESARROLLO' OR TarEstado = 'RESUELTO' OR TarEstado = 'CANCELADA'),
	CHECK (TarHrsAcum > 1),
	CHECK (TarFchIni < TarFchFPrev)
	 )
GO

/*
ZONAS (ZonaId, ZonaNom, ZonaDescrip)
Registra las Zonas que conforman la Red de la Empresa. Las zonas se identifican por un Numero. El
nombre de las zonas es un dato obligatorio y no existen dos zonas con igual nombre.
Al momento de ingresar los datos suponer que hay una zona por cada área de la Empresa, y una
zona llamada DMZ donde están los equipos que conforman la Red Perimetral.
*/
Create Table ZONAS (
	ZonaId int not null, 
	ZonaNom varchar(50) NOT NULL UNIQUE,
	ZonaDescrip varchar(100),
	PRIMARY KEY (ZonaId)
	)
GO

/*
USUARIOS (Usuario, UsuPsw, UsuNomApp, UsuMail)
Registra los Usuarios de Red de la Empresa los cuales se identifican mediante el campo usuario que
es de hasta 50 caracteres. También se registra la clave usuPsw, dato obligatorio, el cual debe tener
un máximo de 100 caracteres, y deben contener por lo menos un digito.
Finalmente se guardan, si se conocen, los datos de nombre y apellido UsuNomApp, así como el mail
UsuMail.

*/
Create Table USUARIOS (
	Usuario varchar(50) not null, 
	UsuPsw varchar(100) NOT NULL, /*Era varchar(200)*/
	UsuNomApp varchar(200),
	UsuMail varchar(200),
	CHECK (UsuPsw LIKE '%[0-9]%'),
	PRIMARY KEY (Usuario)
	) 
GO

/*
EQUIPOS (EqpIP, EqpNom, EqpTipo, EqpSO, ZonaId)
Registra el equipamiento informático de la empresa, los cuales se identifican por su IP (EqpIP), la
cual está formado por 4 secuencias de 3 dígitos, cada secuencia puede tomar valores entre 0 y 255, y
están separadas por un punto, ejemplo 192.168.045.123
De los equipos se registra su nombre EqpNom que no puede repetirse, el tipo de equipo EqpTipo que
puede tomar los valores: Terminal, Servidor, Tablet o Impresora, y la zona donde se encuentra
ZonaID.
Los nombres de los equipos deben tener por prefijo:
WKS si son Terminales de Trabajo
SRV si son Servidores
IMP si son Impresoras
TBL si son Tablets
Todos los datos de esta tabla son requeridos excepto el Sistema Operativo 
*/
Create Table EQUIPOS (
	EqpIP char(15) not null,  
	EqpNom varchar(50) NOT NULL UNIQUE, 
	EqpTipo varchar(10) NOT NULL, 
	EqpSO  varchar(10), 
	ZonaId int NOT NULL,
	PRIMARY KEY (EqpIP),
	FOREIGN KEY (ZonaId) REFERENCES ZONAS(ZonaId),
	CHECK (EqpIP LIKE '([0-9]{0,3}\.){3}[0-9]{0,3}'),
	--CHECK (EqpIP LIKE '[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}'), ([0-9]{0,3}\.){3}[0-9]{0,3}
	CHECK (EqpTipo = 'Terminal' OR EqpTipo = 'Servidor' OR EqpTipo = 'Tablet' OR EqpTipo = 'Impresora')
	)
GO

/*
PERMISOSCNX (Usuario, ZonaId, Habilitado)
En esta tabla se indica las zonas a las que puede acceder cada usuario. El campo Habilitado puede
tomar valores SI o NO según dicho permiso este habilitado o no, por defecto las conexiones no están
habilitadas
*/
Create Table PERMISOSCNX (
	Usuario varchar(50) NOT NULL, 
	ZonaId int NOT NULL, 
	Habilitado char(2) NOT NULL,
	PRIMARY KEY (Usuario, ZonaId),
	FOREIGN KEY (Usuario) REFERENCES USUARIOS(Usuario),
	FOREIGN KEY (ZonaId) REFERENCES ZONAS(ZonaId),
	CHECK (Habilitado = 'SI' OR Habilitado = 'NO')
	)
GO

/*
CTRLCONEXIONES (CnxId, Usuario, EqpIP, CnxFchHr, CnxPermitida, TarID)
En esta tabla se registran todos los intentos de conexión de los usuarios en los equipos. Cada intento
de conexión se identifica por un auto numérico, y se guarda la fecha hora en que ocurrió CnxFchHr,
dato obligatorio.
Si el usuario está intentando conectarse a una zona para la cual tiene permiso entonces se permite la
conexión, si una conexión fue permitida o no se registra en el campo CnxPermitida
En el campo TarID indica la tarea que analizara el caso, en caso de ser necesario.
*/

Create Table CTRLCONEXIONES (
	CnxId int identity(1,1) not null, 
	Usuario varchar(50), 
	EqpIP char(15), 
	CnxFchHr datetime NOT NULL, 
	CnxPermitida char(2), 
	TarID int,
	FOREIGN KEY (Usuario) REFERENCES USUARIOS(Usuario),
	FOREIGN KEY (TarId) REFERENCES TAREAS(TarId),
	FOREIGN KEY (EqpIP) REFERENCES EQUIPOS(EqpIP),
	PRIMARY KEY (CnxId))
GO
/*
ESCANEOS (ScnHerr, ScnVulnNom, ScnDescrip)
En esta tabla se registran las herramientas usadas para realizar escaneos de vulnerabilidades y las
vulnerabilidades que éstas son capaces de detectar. scnHerr es el nombre de la herramienta y
ScnVulnNom es el nombre de vulnerabilidad que es capaz de detectar. También se guarda una
descripción. Ejemplo (“McAfee”, “Virus”, “Escaneo para detección de virus”), (“Crowdstrike”,
“malware”, “Escaneo para detección de malware”), etc.

*/

Create Table ESCANEOS (
	ScnHerr varchar(100) NOT NULL, 
	ScnVulnNom varchar(100) NOT NULL, 
	ScnDescrip varchar(200),
	PRIMARY KEY (ScnHerr, ScnVulnNom)
	)
GO

/*
CTRLVULNERABILIDADES (ScnHerr, ScnVulnNom, ZonaId, VulnFchScanO,
VulnFchScanU, VulnCriticidad, TarID)
En esta tabla se registran las vulnerabilidades detectadas por los escaneos. Estas vulnerabilidades se
identifican con la herramienta y el nombre de la vulnerabilidad, la zona en la que se detecto la
vulnerabilidad y la fecha en que se detecto.
Una vulnerabilidad se mantiene abierta mientras siga siendo detectada registrándose en el campo
VulnFchHScanU la fecha de ultimo escaneo que la detecto, y si hay una tarea que este analizando
esta situación esta es indicada en el campo TarID
Una vez que una vulnerabilidad es resuelta, es decir la tarea que la estaba analizando la resolvió, si
vuelve a aparecer se trata como una nueva vulnerabilidad, es decir un nuevo registro en esta tabla
Finalmente se registra la criticidad de cada vulnerabilidad detectada, la que puede tomar los valores:
BAJA, MEDIA, ALTA
*/
create table CTRLVULNERABILIDADES (
	ScnHerr varchar(100) NOT NULL, 
	ScnVulnNom varchar(100) NOT NULL, 
	ZonaId int NOT NULL, 
	VulnFchScanO date NOT NULL, 
	VulnFchScanU date, 
	VulnCriticidad varchar(5),
	TarID int,
	PRIMARY KEY (ScnHerr, ScnVulnNom, ZonaId, VulnFchScanO),
	FOREIGN KEY (ScnHerr, ScnVulnNom) REFERENCES ESCANEOS,
	FOREIGN KEY (TarId) REFERENCES TAREAS,
	FOREIGN KEY (ZonaId) REFERENCES ZONAS,
	CHECK (VulnCriticidad = 'BAJA' OR VulnCriticidad = 'MEDIA' OR VulnCriticidad = 'ALTA') 
	)
GO

/*
RACI (RaciTarId, RaciUsuario, RaciRol)
En esta tabla se guardan los usuarios vinculados a cada tarea y el rol que tienen en dicha tarea. Los
Roles posibles son: Responsable de Ejecución (R), Administrador (A), Consultor (C) aporta
información requerida para realizar la tarea, y finalmente Informativo persona que debe estar
informada del cambio (I)

*/
Create Table RACI (
	RaciTarId int NOT NULL, 
	RaciUsuario varchar(50) NOT NULL, 
	RaciRol char(1) NOT NULL,
	PRIMARY KEY (RaciTarId, RaciUsuario, RaciRol),
	CHECK (RaciRol = 'R' OR RaciRol = 'A' OR RaciRol = 'C' OR RaciRol = 'I')
	)


-- Indices necesarios
USE OBLIGATORIOBD2
GO
--
-- Indices por ser clave foranea.
--
-- Tabla EQUIPOS columna ZonaId
CREATE INDEX ind_eqZonaId ON EQUIPOS(ZonaId) 

-- Tabla PERMISOSCNX columna ZonaId
CREATE INDEX ind_permZonaId ON PERMISOSCNX(ZonaId)

-- Tabla CTRLCONEXIONES columnas Usuario y TarId
CREATE INDEX ind_ctrlconUsuario ON CTRLCONEXIONES(Usuario) 

CREATE INDEX ind_ctrlconTarId ON CTRLCONEXIONES(TarId) 

-- Tabla CTRLVULNERABILIDADES columnas ScnHerr con ScnVulnNom, TarId y ZonaId
CREATE INDEX ind_ctrlvulScnHerrScnVulnNom ON CTRLVULNERABILIDADES(ScnHerr, ScnVulnNom) 

CREATE INDEX ind_ctrlvulTarId ON CTRLVULNERABILIDADES(TarId) 

CREATE INDEX ind_ctrlvulZonaId ON CTRLVULNERABILIDADES(ZonaId) 

--
-- Indices comunmente utilizados en consultas.
--
-- Tabla CTRLVULNERABILIDADES columna VulnCriticidad
CREATE INDEX ind_ctrlvulVulnCriticidad ON CTRLVULNERABILIDADES(VulnCriticidad) 

-- Tabla ZONAS columna ZonaNom
CREATE INDEX ind_zonZonaNom ON ZONAS(ZonaNom) 

-- Tabla CTRLCONEXIONES columna CnxPermitida
CREATE INDEX ind_ctrlconCnxPermitida ON CTRLCONEXIONES(CnxPermitida) 

-- Tabla TAREAS columna TarEstado
CREATE INDEX ind_tarTarEstado ON TAREAS(TarEstado) 

-- Tabla TAREAS columna TarHrsAcum
CREATE INDEX ind_tarTarHrsAcum ON TAREAS(TarHrsAcum) 

-- Tabla CTRLCONEXIONES columna CnxFchHr
CREATE INDEX ind_ctrlconCnxFchHr ON CTRLCONEXIONES(CnxFchHr) 
