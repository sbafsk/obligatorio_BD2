-- CREACION DE LA BASE DE DATOS Y SU CORRESPONDIENTES TABLAS
--
-- Nota: Las restricciones que NO son "not null" o "IDENTITY" 
-- estan declaradas en el archivo Restricciones.sql
--

--DROP DATABASE OBLIGATORIO1BD2

--CREATE DATABASE OBLIGATORIO1BD2
GO
USE OBLIGATORIO1BD2
GO

-- tabla artista
CREATE TABLE artista(artistaId int not null,
                     artistaNombre varchar(30) not null,
					 artistaFoto varchar(50), 
					 esNacional numeric(1) not null,
					 artistaCantReproducciones numeric(10) not null) 
GO

-- tabla album
CREATE TABLE album(albumId character(5) not null, 
                   albumNombre varchar(30) not null,
				   artistaId int not null,
				   albumCantReproducciones numeric(10) not null)
GO

-- tabla cancion
CREATE TABLE cancion(cancionId int identity(1,1) not null,
                     cancionNombre varchar(30) not null,
					 albumId character(5) not null,
					 cancionCantReproducciones numeric(10) not null)
GO

-- tabla plan ("plan" es una palabra reservada en SQL, se agrena un digito numerico)
CREATE TABLE plan1(planId int identity(1,1) not null, 
                   planNombre varchar(30) not null, 
				   planCosto decimal not null, 
				   esPlanVigente numeric(1) not null, 
				   esRecurrente numeric(1) not null)
GO

-- tabla usuario
CREATE TABLE usuario(usuarioId character(20) not null, 
                     usuarioNombre varchar(30) not null, 
					 usuarioMail varchar(60) not null, 
					 fechaCreacion date not null, 
					 planId int not null, 
					 fechaPlanActivoDesde datetime not null)
GO

-- tabla compra
CREATE TABLE compra(compraId int identity(1,1) not null, 
                    usuarioId character(20) not null, 
					planId int, 
					fechaGenerada date, 
					fechaPaga date)
GO

-- tabla playList
CREATE TABLE playList(playListId int IDENTITY(1,1) not null, 
                      playListNombre varchar(30) not null, 
					  usuarioId character(20), 
					  playListFechaCreacion date not null, 
					  esPlayListCurada numeric(1) not null)
GO

-- tabla playListCancion
CREATE TABLE playListCancion(playListId int not null,
                             cancionId int not null)
GO

-- tabla historialCancion
-- Nota: La fecha debe guardar hasta los segundos.
CREATE TABLE historialCancion(historialCancionId int IDENTITY(1,1) not null, 
                              historialCancionFecha datetime not null, 
							  usuarioId character(20) not null, 
							  cancionId int not null)
GO