-- ##
-- 
-- Consultas y Vistas.
-- 
-- ##

USE OBLIGATORIO1BD2
GO

-- ##
-- Consultas:
-- ##


-- ##
-- A. Mostrar los usuarios que han escuchado todas las playlists curadas 
-- (basta con haber escuchado con un tema de la playlist para considerar escuch� la playlist).
-- ##
SELECT * 
FROM usuario u
WHERE NOT EXISTS
    (SELECT * 
    FROM playlist pl
    WHERE pl.esPlaylistCurada = 1
    AND NOT EXISTS(
            SELECT * 
            FROM playListCancion plc, historialCancion hc
            WHERE plc.cancionId = hc.cancionId
            	AND u.usuarioId = hc.usuarioId
            	AND plc.playlistId = pl.playlistId
    )
);
GO

-- ##
-- B. Mostrar para cada artista, la cantidad de �lbumes que tiene con m�s de 10 temas. 
-- En caso de que haya artistas sin �lbumes, tambi�n deben mostrarse.
-- ##

SELECT a.artistaNombre,a.artistaId, count(*) as cantidadDiscosMasDe10
FROM artista a, 
(
	SELECT al.artistaId,c.albumId
	FROM cancion c, album al
	WHERE al.albumId = c.albumId
	GROUP BY c.albumId, al.artistaId
	HAVING COUNT(*) > 6
) b 
WHERE a.artistaId=b.artistaId
GROUP BY a.artistaNombre, a.artistaId

UNION

SELECT art.artistaNombre, art.artistaId, 0 from artista art WHERE
art.artistaId NOT IN (
	SELECT album.artistaId FROM album
)
GO

-- ##
-- C. Devolver id y nombre del/los usuario/s que escuch�/escucharon m�s temas nacionales
-- en lo que va del a�o.
-- ##

SELECT u.usuarioNombre, u.usuarioId
FROM artista a, historialCancion hc, cancion c, album al, usuario u
WHERE 
	a.esNacional = 1 AND
	hc.cancionId = c.cancionId AND
	c.albumId = al.albumId AND
	al.artistaId = a.artistaId AND 
	hc.usuarioId = u.usuarioId AND 
	YEAR(hc.historialCancionFecha) = YEAR(getDate())
GROUP BY u.usuarioNombre, u.usuarioId
HAVING COUNT(u.usuarioId) = (
	SELECT MAX(cantidad) 
	FROM (
		SELECT Count(u.usuarioId) as 'Cantidad', u.usuarioNombre
		FROM artista a, historialCancion hc, cancion c, album al, usuario u
		WHERE 
			a.esNacional = 1 AND
			hc.cancionId = c.cancionId AND
			c.albumId = al.albumId AND
			al.artistaId = a.artistaId AND 
			hc.usuarioId = u.usuarioId AND 
			YEAR(hc.historialCancionFecha) = YEAR(getDate())
		GROUP BY u.usuarioNombre
	) tablaAux
)

GO

-- ##
-- D. Devolver el id y nombre de los usuarios, que tengan m�s de 3 playlists, 
-- que hayan escuchado m�s de 10 temas por mes en los �ltimos 3 meses 
-- y que no hayan escuchado m�s de 20 artistas distintos en el mes actual.
-- ##
SELECT U.usuarioId, U.usuarioNombre
FROM usuario U, playList P, playListCancion PC, historialCancion HC, cancion C, album AL, artista AR
WHERE	U.usuarioId = P.usuarioId AND
		P.playListId = PC.playListId AND
		U.usuarioId = HC.usuarioId AND
		HC.cancionId = C.cancionId AND
		C.albumId = AL.albumId AND
		AL.artistaId = AR.artistaId AND
		U.usuarioId IN (SELECT H.usuarioId 
						FROM historialCancion H 
						WHERE H.historialCancionFecha >= DATEADD(MONTH,-3, GETDATE())
						GROUP BY H.usuarioId 
						HAVING	COUNT(P.playListId) > 30					
						)		
GROUP BY U.usuarioId, U.usuarioNombre
HAVING	COUNT(P.playListId) > 3 AND
		COUNT(DISTINCT AR.artistaId) < 20

GO
-- ##
-- E. Devolver el nombre de los usuarios 
-- que hayan escuchado temas de todos los �lbumes de �Jaime Roos�.
-- ##

SELECT U.usuarioNombre
FROM usuario U, historialCancion HC, cancion C, album AL
WHERE	U.usuarioId = HC.usuarioId AND
		HC.cancionId = C.cancionId AND
		C.albumId = AL.albumId AND 
		AL.albumId IN (	SELECT	AL.albumId
						FROM	album AL, artista AR
						WHERE	AL.artistaId = AR.artistaId AND
								AR.artistaNombre = 'Jaime Roos'
						)
GO

-- ##
-- F. Eliminar los artistas que no tengan temas en playlists 
-- y que no tengan reproducciones en lo que va del a�o.
-- ##

DELETE 
FROM artista
WHERE 
	artista.artistaId IN (	
		SELECT a.artistaId
		FROM artista as a, album as al, cancion as c
		WHERE 
			a.artistaId = al.artistaId AND
			al.albumId = c.albumId AND
			c.cancionId NOT IN (
				SELECT pc.cancionId 
				FROM playListCancion pc
			) AND
			c.cancionId NOT IN (
				SELECT DISTInCT hc.cancionId
				FROM historialCancion as hc
				WHERE YEAR(hc.historialCancionFecha) = YEAR(getDate())
			)
	) 


GO

-- ##
-- Vistas
-- ##

-- ##
-- A. Crear una vista 'usuariosPorPlan' que muestre por pan, 
-- la cantidad de usuarios que tiene, 
-- considerando solamente los planes con m�s de 10 usuarios.
-- ##

CREATE VIEW usuariosPorPlan
AS (
	SELECT DISTINCT p.planNombre, count(u.planId) as 'Cantidad' 
	FROM usuario u, plan1 p 
	WHERE u.planid = p.planid 
	GROUP BY p.planNombre
	HAVING count(u.planId) > 10
);
GO

-- ##
-- B. Crear una vista, �promedioReproduccionesUsuariosMesAnio� que muestra para cada mes, 
-- a�o el promedio de reproducciones (reproducciones totales / usuarios distintos). 
-- Mostrar en el resultado solo los meses/a�os con m�s de 100 reproducciones.
-- ##

CREATE VIEW promedioReproduccionesUsuariosMesAnio
AS (
	SELECT YEAR(hc.historialCancionFecha) as 'Anio', 
	MONTH(hc.historialCancionFecha) as 'Mes',
	CAST(COUNT(*) as float)/(SELECT COUNT( DISTINCT hc2.usuarioId) FROM historialCancion hc2 WHERE MONTH(hc.historialCancionFecha) = MONTH(hc2.historialCancionFecha)
		AND YEAR(hc.historialCancionFecha)=YEAR(hc2.historialCancionFecha) ) as 'Promedio'
	FROM historialCancion hc
	GROUP BY YEAR(hc.historialCancionFecha), MONTH(hc.historialCancionFecha)
);
GO


