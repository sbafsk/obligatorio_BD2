CREATE DATABASE OBLIGATORIO1BD2
GO
USE OBLIGATORIO1BD2
GO
CREATE TABLE artista(artistaId int not null,
                     artistaNombre varchar(30) not null,
					 artistaFoto varchar(50), 
					 esNacional numeric(1), 
					 artistaCantReproducciones numeric(10))
GO
CREATE TABLE album(albumId character(5) not null, 
                   albumNombre varchar(30) not null,
				   artistaId int not null,
				   albumCantReproducciones numeric(10))
GO
CREATE TABLE cancion(cancionId int identity(1,1) not null,
                     cancionNombre varchar(30) not null,
					 albumId character(5) not null,
					 cancionCantReproducciones numeric(10))
GO
CREATE TABLE plan1(planId int identity(1,2) not null, 
                   planNombre varchar(30) not null, 
				   planCosto decimal, 
				   esPlanVigente numeric(1) not null, 
				   esRecurrente numeric(1) not null)
GO
CREATE TABLE usuario(usuarioId character(20) not null, 
                     usuarioNombre varchar(30) not null, 
					 usuarioMail varchar(60), 
					 fechaCreacion date, 
					 planId int, 
					 fechaPlanActivoDesde datetime)
GO
CREATE TABLE compra(compraId int identity(1,1) not null, 
                    usuarioId character(20) not null, 
					planId int, 
					fechaGenerada date, 
					fechaPaga date)
GO
CREATE TABLE playList(playListId int identity(1,1) not null, 
                      playListNombre varchar(30) not null, 
					  usuarioId character(20) not null, 
					  playListFechaCreacion date, 
					  esPlayListCurada numeric(1))
GO
CREATE TABLE playListCancion(playListId int not null,
                             cancionId int not null)
GO
CREATE TABLE historialCancion(historialCancionId int identity(1,1) not null, 
                              historialCancionFecha datetime not null, 
							  usuarioId character(20) not null, 
							  cancionId int not null)
GO