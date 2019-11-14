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
-- (basta con haber escuchado con un tema de la playlist para considerar escuchó la playlist).
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


-- ##
-- B. Mostrar para cada artista, la cantidad de álbumes que tiene con más de 10 temas. 
-- En caso de que haya artistas sin álbumes, también deben mostrarse.
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


-- ##
-- C. Devolver id y nombre del/los usuario/s que escuchó/escucharon más temas nacionales
-- en lo que va del año.
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



-- ##
-- D. Devolver el id y nombre de los usuarios, que tengan más de 3 playlists, 
-- que hayan escuchado más de 10 temas por mes en los últimos 3 meses 
-- y que no hayan escuchado más de 20 artistas distintos en el mes actual.
-- ##



-- ##
-- E. Devolver el nombre de los usuarios 
-- que hayan escuchado temas de todos los álbumes de ‘Jaime Roos’.
-- ##

-- ##
-- F. Eliminar los artistas que no tengan temas en playlists 
-- y que no tengan reproducciones en lo que va del año.
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




-- ##
-- Vistas
-- ##

-- ##
-- A. Crear una vista 'usuariosPorPlan' que muestre por pan, 
-- la cantidad de usuarios que tiene, 
-- considerando solamente los planes con más de 10 usuarios.
-- ##

CREATE VIEW usuariosPorPlan
AS (
	SELECT DISTINCT p.planNombre, count(u.planId) as 'Cantidad' 
	FROM usuario u, plan1 p 
	WHERE u.planid = p.planid 
	GROUP BY p.planNombre
	HAVING count(u.planId) > 10
);


-- ##
-- B. Crear una vista, ‘promedioReproduccionesUsuariosMesAnio’ que muestra para cada mes, 
-- año el promedio de reproducciones (reproducciones totales / usuarios distintos). 
-- Mostrar en el resultado solo los meses/años con más de 100 reproducciones.
-- ##


