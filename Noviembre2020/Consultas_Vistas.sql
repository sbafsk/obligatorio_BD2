--Consultas:

/* a) Mostrar los datos de las ultimas Vulnerabilidades de criticidad ALTA que no hayan sido
resueltas aún. En el resultado debe aparecer también el nombre de la zona en la cual
se detectó la Vulnerabilidad */


/* b) Mostrar los datos de los usuarios que pueden acceder a todas las zonas. */


/*c) Mostrar los datos de las zonas mas seguras de la red, siendo estas aquellas que no
han tenido vulnerabilidades ALTA los últimos tres meses, y que tienen menos de 3
usuarios con conexiones no permitidas en el último mes*/


/*d) Se quiere los usuarios que hace mas de 180 dias que no se conectan. En el resultado
debe aparecer la cantidad de días que hace que no se conectan y el nombre del
equipo al que se conectó por última vez*/


/*e) Para cada usuario que es responsable de mas de 3 tareas no resueltas, mostrar el
usuario y el promedio de horas que están insumiendo estas tareas*/


/*f) Para cada Zona de la Red indicar la cantidad de conexiones no permitidas a equipos
de la zona, y la cantidad de vulnerabilidades encontradas en la zona en los últimos 30
días. Usar la función 6b) en la solución implementada*/

-- ##
-- 
-- Consultas y Vistas.
-- 
-- ##

USE OBLIGATORIO1BD2
GO

-- Consulta A :
-- a. Devolver id y nombre de los artistas nacionales con m�s de 3 �lbumes, que tengan
-- menos de 100 temas y hayan recibido m�s de 1000 reproducciones.
SELECT  Ar.artistaId, Ar.artistaNombre, COUNT(DISTINCT Al.albumId) AS cantAlbum, COUNT(C.cancionId) as cantTemas
FROM artista Ar, album Al, cancion C
WHERE	Ar.artistaId = Al.artistaId AND
		Al.albumId = C.albumId AND
		Ar.esNacional =  0  AND
		Ar.artistaCantReproducciones > 1000
GROUP BY Ar.artistaId, Ar.artistaNombre
HAVING	COUNT(DISTINCT Al.albumId) > 3 AND
		COUNT(C.cancionId) < 100 


-- Consulta B
-- b. Proporcionar un listado de los 10 artistas nacionales (id y nombre) con m�s
-- reproducciones en lo que va del a�o. Devolver el listado en orden de cantidad de
-- reproducciones descendente.

SELECT TOP(10) A.artistaId as ID, A.artistaNombre as Nombre, COUNT(H.historialCancionId) AS CantidadRep
FROM artista A, album AL, cancion C, historialCancion H
WHERE	A.artistaId = AL.artistaId AND
		AL.albumId = C.albumId AND
		C.albumId = H.cancionId AND
		esNacional = 1 AND
		YEAR(H.historialCancionFecha) > YEAR(GETDATE())
GROUP BY A.artistaId, A.artistaNombre
ORDER BY  COUNT(H.historialCancionId) DESC;

-- Consulta C
-- c. Mostrar para cada playlist su nombre, el nombre de usuario y la cantidad de canciones
-- que la componen. En caso de ser una playlist curada, en el lugar correspondiente a
-- nombre de usuario debe aparecer �playlist Curada�.

SELECT 
	p.playListId as 'ID playlist', 
	CASE p.esPlayListCurada 
		WHEN 1 
		THEN 'Playlist Curada' 
		ELSE u.usuarioNombre 
		END AS 'Usuario', 
	COUNT(pc.cancionId) as 'Cantidad de canciones'
FROM playList as p, usuario as u, playListCancion as pc
WHERE p.playListId = pc.playListId AND u.usuarioId = p.usuarioId
GROUP BY pc.playListId, p.playListId, u.usuarioNombre, p.esPlayListCurada



-- Consulta D
-- d. Mostrar id y nombre de los usuarios que se registraron en la aplicaci�n este a�o, tienen
-- m�s de 4 playlists con 10 temas, no tienen playlists con menos de 3 temas y han
-- reproducido alg�n tema en los �ltimos 10 d�as.
SELECT U.usuarioId, U.usuarioNombre
FROM usuario U, playList P, playListCancion PC
WHERE	U.usuarioId = P.usuarioId AND
		P.playListId = PC.playListId AND
		YEAR(U.fechaCreacion) = YEAR(GETDATE())
		AND
		U.usuarioId IN (SELECT H.usuarioId 
						FROM historialCancion H 
						WHERE H.historialCancionFecha >= DATEADD(day,-10, GETDATE())
						) AND
		U.usuarioId NOT IN (SELECT P.usuarioId
							FROM playList P, playListCancion PC
							WHERE P.playListId = PC.playListId
							GROUP BY P.usuarioId
							HAVING COUNT (PC.cancionId) <= 3
							)
GROUP BY U.usuarioId, U.usuarioNombre
HAVING	COUNT(P.playListId) > 4 AND
		COUNT(PC.cancionId) >= 10 
		
--select * from usuario

-- Consulta E
-- e. Mostrar el/los temas m�s escuchados en el �ltimo mes.

SELECT * FROM cancion
WHERE cancionCantReproducciones = (
	SELECT MAX(cancionCantReproducciones) 
	FROM cancion
);


-- Consulta F
-- f. Devolver mediante una consulta la cantidad de reproducciones totales del mes actual,
-- la cantidad de temas distintos que se reprodujeron en el mes actual y el promedio de
-- reproducciones por usuario en el mes corriente.
SELECT COUNT(H.historialCancionId) AS TotalRepMes, COUNT(DISTINCT H.cancionId) AS CancionesDif, AVG(C.cancionCantReproducciones) AS PromedioRep
FROM historialCancion H, cancion C
WHERE	H.cancionId = C.cancionId AND
		MONTH(H.historialCancionFecha) = MONTH(GETDATE()) AND
		YEAR(H.historialCancionFecha) = YEAR(GETDATE())


--SELECT *
-- FROM historialCancion
-- WHERE	MONTH(historialCancionFecha) = MONTH(GETDATE()) AND
--			YEAR(historialCancionFecha) = YEAR(GETDATE())
-- ORDER BY historialCancionFecha


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


