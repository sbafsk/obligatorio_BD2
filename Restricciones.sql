-- RESTRICCIONES ESTRUCTURALES Y NO ESTRUCTURALES
--
-- Nota: Las restricciones "not null" e "INDENTITY" 
-- estan declaradas junto con la creacion de las tablas.
--

USE OBLIGATORIO1BD2
GO
--
-- tabla artista
--
-- Primary Key
ALTER TABLE artista
ADD CONSTRAINT PK_artista 
	PRIMARY KEY (artistaId)

-- #El campo “esNacional” puede tomar los valores:
-- - “1” cuando se trata de unartista local. 
-- - “0” en caso contrario.
ALTER TABLE artista 
ADD CONSTRAINT check_esNacional 
	CHECK (esNacional = 0 OR esNacional = 1)

-- #La cantidad de reproducciones del artista, refiere a la suma de 
--  todas las reproducciones de todos los temas que el artista tiene en la plataforma.

-- Se debe realizar un calculo con valores de otra tabla para asignarle valor a este campo.
-- artistaCantReproducciones =
/*SELECT SUM(C.cancionCantReproducciones) as TotalReproduccionesArtista
FROM artista Ar, album Al, cancion C
WHERE	Ar.artistaId = Al.artistaId AND
		AL.albumId = C.cancionId
*/

--
-- tabla album
--
-- #Primary Key y Foreign Key
ALTER TABLE album
ADD CONSTRAINT PK_album 
	PRIMARY KEY (albumId),

	CONSTRAINT FK_album_artistaId 
	FOREIGN KEY (artistaId) 
	REFERENCES artista(artistaId)

-- #Cada álbum tiene un nombre y pertenece a un artista.
-- ?????

-- #La cantidad de reproducciones del álbum, refiere a la suma
--  de todas las reproducciones de los temas del álbum desde la plataforma.
-- albumCantReproducciones =
/* SELECT SUM(C.cancionCantReproducciones) as TotalReproduccionesAlbum
FROM album A, cancion C
WHERE	A.albumId = C.cancionId
*/

-- #Los nombres de los álbumes son únicos por artista.
ALTER TABLE album
ADD CONSTRAINT uniq_artistaId_albumNombre
	UNIQUE (artistaId, albumNombre)


--
-- tabla cancion 
--
-- #Primary Key y Foreign Key
ALTER TABLE cancion
ADD CONSTRAINT PK_cancion 
	PRIMARY KEY (cancionId),

	CONSTRAINT FK_cancion_albumId 
	FOREIGN KEY (albumId) 
	REFERENCES album(albumId)


--
-- tabla plan
--
-- #Primary Key
ALTER TABLE plan1
ADD CONSTRAINT PK_plan 
	PRIMARY KEY (planId)

-- #El atributo esPlanVigente tomas el valor: 
-- - “1” cuando se trata de un plan que actualmente puede ser seleccionado por un usuario.
-- - “0” si se trata de un plan obsoleto.
ALTER TABLE plan1 
ADD CONSTRAINT check_esPlanVigente 
	CHECK (esPlanVigente = 0 OR esPlanVigente = 1)

-- #El atributo esRecurrente toma el valor: 
-- - “1” cuando el plan requiere de un  pago mensual para mantenerse activo.
-- - “0” si se trata de un plan de pago puntual.
ALTER TABLE plan1 
ADD CONSTRAINT check_esRecurrente 
	CHECK (esRecurrente = 0 OR esRecurrente = 1)


--
-- tabla usuario
--
-- #Primary Key y Foreign Key
ALTER TABLE usuario
ADD CONSTRAINT PK_usuario 
	PRIMARY KEY (usuarioId),

	CONSTRAINT FK_usuario_planId 
	FOREIGN KEY (planId) 
	REFERENCES plan1(planId)

-- #Tanto el nombre como el mail son únicos en la tabla.
ALTER TABLE usuario
ADD CONSTRAINT uniq_usuarioNombre
	UNIQUE (usuarioNombre),

	CONSTRAINT uniq_usuarioMail
	UNIQUE (usuarioMail)


-- ALTER TABLE usuario
-- DROP CONSTRAINT FK_usuario_planId
	
--
-- tabla compra
--
-- #Primary Key y Foreign Keys.
ALTER TABLE compra
ADD CONSTRAINT PK_compra 
	PRIMARY KEY (compraId),

	CONSTRAINT	FK_compra_usuarioId 
	FOREIGN KEY (usuarioId) 
	REFERENCES usuario(usuarioId),

	CONSTRAINT 	FK_compra_planId 
	FOREIGN KEY (planId) 
	REFERENCES plan1(planId)

-- ALTER TABLE compra
-- DROP CONSTRAINT FK_compra_planId 

-- #La fecha de paga debe ser mayor o igual a la fecha de generada.
ALTER TABLE compra 
ADD CONSTRAINT check_esFechaPagaValida
CHECK (fechaPaga >= fechaGenerada)

--
-- tabla playList
-- 
-- #Primary Key y Foreign Key
ALTER TABLE playList
ADD CONSTRAINT PK_playList 
	PRIMARY KEY (playListId),

	CONSTRAINT	FK_playList_usuarioId 
	FOREIGN KEY (usuarioId) 
	REFERENCES usuario(usuarioId)

-- #Poseen un nombre, único en la tabla.
ALTER TABLE playList 
ADD CONSTRAINT uniq_playListNombre
	UNIQUE (playListNombre)

-- #El atributo “esPlayListCurada” toma el valor
-- - "1" listas creadas por administradores de la aplicación.
-- - "0" listas creadas por usuarios.
ALTER TABLE playList
ADD CONSTRAINT check_esPlayListCurada
	CHECK (esPlayListCurada = 1 OR esPlayListCurada = 0)

-- Como resolver lo siguiente ?
-- IF esPlayListCurada = 0 
-- usuarioId = not null;
-- ELSE IF esPlayListCurada = 1 
-- usuarioId = null;


--
-- tabla playListCancion
--
-- #Primary Keys y Foreign Key
ALTER TABLE playListCancion
ADD CONSTRAINT PK_playListId_cancionId
	PRIMARY KEY (playListId, cancionId),

	CONSTRAINT FK_playListCancion_cancionId
	FOREIGN KEY (cancionId)
	REFERENCES cancion(cancionId)

--
-- tabla historiaCancion
--
-- #Primary Key y Foreign Keys
ALTER TABLE historialCancion
ADD CONSTRAINT PK_historialCancionId
	PRIMARY KEY (historialCancionId),

	CONSTRAINT FK_historialCancion_usuarioId
	FOREIGN KEY (usuarioId)
	REFERENCES usuario(usuarioId),

	CONSTRAINT FK_historialCancion_cancionId
	FOREIGN KEY (cancionId)
	REFERENCES cancion(cancionId)

-- #Cada usuario solo puede tener una reproducción por fecha (fecha hora hasta segundos).
ALTER TABLE historialCancion
ADD CONSTRAINT uniq_historialCancionFecha
	UNIQUE (historialCancionFecha)


	

	






