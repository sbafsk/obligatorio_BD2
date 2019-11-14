-- ###
--
-- Procedimientos y funciones
--
-- ##

USE OBLIGATORIO1BD2
GO

-- ##
-- A. Crear un procedimiento almacenado 'reproduccionesPorUsuarioPorAnio' 
-- que reciba como parámetros un año y un id de usuario, 
-- y devuelva por parámetro: 
-- la cantidad de artistas distintos escuchados por el usuario en el año, 
-- la cantidad de álbumes distintos escuchados por el usuario en el año y 
-- la cantidad de temas distintos escuchados por el usuario en el año.
-- ##

CREATE PROCEDURE reproduccionesPorUsuarioPorAnio
	@anio datetime,
	@idUsuario character(20),
	@cantArtisAnio numeric(10) output,
	@cantAlbumAnio numeric(10) output,
	@cantTemasAnio numeric(10) output
AS
BEGIN
	SELECT	@cantArtisAnio = COUNT(DISTINCT Ar.artistaId),
			@cantAlbumAnio = COUNT(DISTINCT Al.albumId),
			@cantTemasAnio = COUNT(DISTINCT CA.cancionId)
	FROM	artista Ar, album Al, cancion Ca, historialCancion Hc
	WHERE	Ar.artistaId = Al.artistaId AND
			Al.albumId = CA.albumId AND
			Ca.cancionId = Hc.cancionId AND
			@anio = YEAR(Hc.historialCancionFecha) AND
			@idUsuario = Hc.usuarioId 			
END
GO

-- ##
-- B. Crear un procedimiento almacenado 'albumMasEscuchadoArtista', 
-- que dado el código de un artista, devuelva por parámetro, 
-- el álbum con más reproducciones del artista, 
-- y la cantidad de reproducciones de dicho álbum.
-- ##

CREATE PROCEDURE albumMasEscuchadoArtista
	@idArtista int,
	@albumMasReproducciones varchar(30) output,
	@cantReproducciones numeric(10) output
AS
BEGIN
	SELECT	@albumMasReproducciones = MAX(Al.albumNombre),
			@cantReproducciones = COUNT(DISTINCT Al.albumId)
	FROM	album Al, cancion Ca, historialCancion Hc
	WHERE	@idArtista = Al.artistaId AND
			Al.albumId = CA.albumId AND
			Ca.cancionId = Hc.cancionId 
	ORDER BY  COUNT(DISTINCT Al.albumId) DESC
END
GO

-- ##
-- C. Implementar una función 'reproduccionesPorArtistaPorAnio', 
-- que reciba como parámetros el id de un artista y un año, 
-- devolviendo la cantidad de reproducciones del artista en el año.
-- ##

CREATE FUNCTION reproduccionesPorArtistaPorAnio(
	@idArtista int,
	@anio datetime
	) 
	RETURNS numeric(10)
BEGIN
	DECLARE @cantReproducciones numeric(10);

	SELECT	@cantReproducciones = COUNT (*)
	FROM	album Al, cancion Ca, historialCancion Hc
	WHERE	@idArtista = Al.artistaId AND
			Al.albumId = CA.albumId AND
			Ca.cancionId = Hc.cancionId AND
			@anio = YEAR(Hc.historialCancionFecha)
			
	RETURN @cantReproducciones
END
GO

-- ##
-- D. Implementar un procedimiento almacenado 'resumenArtistaPorAnio', 
-- que dados elcódigo de un artista y un año, 
-- devuelva por parámetro: la cantidad de reproducciones totales que tuvo el artista en el año, 
-- la cantidad de playLists distintas creadas en el año proporcionado 
-- en que aparece alguno de sus temas, 
-- la cantidad de usuarios distintos que escucharon alguno de sus temas en el año.
-- ##

CREATE PROCEDURE resumenArtistaPorAnio
	@idArtista int,
	@anio datetime
AS
BEGIN
	SELECT *
	FROM

END
GO


-- ##
-- E. Crear una función, ‘artistaNacionalMasEscuchadoRangoFechas’ 
-- que reciba por parámetros un rango de fechas y 
-- devuelva el artista nacional más escuchado en dicho período.
-- ##

CREATE FUNCTION artistaNacionalMasEscuchadoRangoFechas(
	@fechaDesde date,
	@fechaHasta date
	) returns varchar(30)
AS
BEGIN
	DECLARE @artNacMasEscuchad varchar(30);
	
	SELECT @artNacMasEscuchad = Ar.artistaNombre
	FROM artista Ar, album Al, cancion Ca, historialCancion Hc
	WHERE	Ar.artistaId = Al.artistaId AND
			Al.albumId = CA.albumId AND
			Ca.cancionId = Hc.cancionId AND
			@fechaDesde >= Hc.historialCancionFecha AND
			@fechaHasta <= Hc.historialCancionFecha
	ORDER BY  COUNT(Hc.cancionId) DESC

	RETURN @artNacMasEscuchad 
END



-- ##
-- F. Implementar un procedimiento almacenado, ‘infoAlbum’, 
-- que reciba por parámetro el id de un álbum y devuelva, 
-- también por parámetros: la cantidad de temas del álbum, 
-- la fecha en que se reprodujo por primera vez alguno de los temas del álbum 
-- y la cantidad de reproducciones del álbum.
-- ##



-- ##
-- G. Crear una función 'temasPorArtista' que reciba como parámetro un id de artista y
-- devuelva la cantidad de temas de dicho artista.
-- ## 

CREATE FUNCTION temasPorArtista(
	@idArtista int)
	RETURNS NUMERIC(10)
AS
BEGIN
	DECLARE @cantidadTemas NUMERIC(10)
	SELECT 


