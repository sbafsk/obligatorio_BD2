-- Consultas Obligatorio BD2

USE OBLIGATORIO1BD2
GO


-- Consulta A :
-- a. Devolver id y nombre de los artistas nacionales con más de 3 álbumes, que tengan
-- menos de 100 temas y hayan recibido más de 1000 reproducciones.
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
-- b. Proporcionar un listado de los 10 artistas nacionales (id y nombre) con más
-- reproducciones en lo que va del año. Devolver el listado en orden de cantidad de
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
-- nombre de usuario debe aparecer “playlist Curada”.

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
-- d. Mostrar id y nombre de los usuarios que se registraron en la aplicación este año, tienen
-- más de 4 playlists con 10 temas, no tienen playlists con menos de 3 temas y han
-- reproducido algún tema en los últimos 10 días.
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
-- e. Mostrar el/los temas más escuchados en el último mes.

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
