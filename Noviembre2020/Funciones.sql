-- ###
--
-- Procedimientos y funciones
--
-- ##

USE OBLIGATORIO1BD2
GO

-- ##
-- A. Crear un procedimiento almacenado 'reproduccionesPorUsuarioPorAnio' 
-- que reciba como par�metros un a�o y un id de usuario, 
-- y devuelva por par�metro: 
-- la cantidad de artistas distintos escuchados por el usuario en el a�o, 
-- la cantidad de �lbumes distintos escuchados por el usuario en el a�o y 
-- la cantidad de temas distintos escuchados por el usuario en el a�o.
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
-- que dado el c�digo de un artista, devuelva por par�metro, 
-- el �lbum con m�s reproducciones del artista, 
-- y la cantidad de reproducciones de dicho �lbum.
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
-- C. Implementar una funci�n 'reproduccionesPorArtistaPorAnio', 
-- que reciba como par�metros el id de un artista y un a�o, 
-- devolviendo la cantidad de reproducciones del artista en el a�o.
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
-- que dados elc�digo de un artista y un a�o, 
-- devuelva por par�metro: la cantidad de reproducciones totales que tuvo el artista en el a�o, 
-- la cantidad de playLists distintas creadas en el a�o proporcionado 
-- en que aparece alguno de sus temas, 
-- la cantidad de usuarios distintos que escucharon alguno de sus temas en el a�o.
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
-- E. Crear una funci�n, �artistaNacionalMasEscuchadoRangoFechas� 
-- que reciba por par�metros un rango de fechas y 
-- devuelva el artista nacional m�s escuchado en dicho per�odo.
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
-- F. Implementar un procedimiento almacenado, �infoAlbum�, 
-- que reciba por par�metro el id de un �lbum y devuelva, 
-- tambi�n por par�metros: la cantidad de temas del �lbum, 
-- la fecha en que se reprodujo por primera vez alguno de los temas del �lbum 
-- y la cantidad de reproducciones del �lbum.
-- ##



-- ##
-- G. Crear una funci�n 'temasPorArtista' que reciba como par�metro un id de artista y
-- devuelva la cantidad de temas de dicho artista.
-- ## 

CREATE FUNCTION temasPorArtista(
	@idArtista int)
	RETURNS NUMERIC(10)
AS
BEGIN
	DECLARE @cantidadTemas NUMERIC(10)
	SELECT 


