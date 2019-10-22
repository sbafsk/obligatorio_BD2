-- Consultas Obligatorio BD2

USE OBLIGATORIO1BD2
GO


-- Consulta A :
-- a. Devolver id y nombre de los artistas nacionales con m�s de 3 �lbumes, que tengan
-- menos de 100 temas y hayan recibido m�s de 1000 reproducciones.
SELECT  Ar.artistaId, Ar.artistaNombre, COUNT(DISTINCT Al.albumId) AS CantAlb, COUNT(C.cancionId) as CantCan
FROM artista Ar, album Al, cancion C
WHERE	Ar.artistaId = Al.artistaId AND
		Al.albumId = C.albumId AND
		Ar.esNacional =  0  AND
		Ar.artistaCantReproducciones > 1000
GROUP BY Ar.artistaId, Ar.artistaNombre
HAVING	COUNT(DISTINCT Al.albumId) > 0 AND
		COUNT(C.cancionId) < 100 


-- Consulta B
-- b. Proporcionar un listado de los 10 artistas nacionales (id y nombre) con m�s
-- reproducciones en lo que va del a�o. Devolver el listado en orden de cantidad de
-- reproducciones descendente.

SELECT TOP 10 artistaId as ID, artistaNombre as Nombre 
FROM artista 
WHERE esNacional=1 ORDER BY artistaCantReproducciones DESC;



-- Consulta C
-- c. Mostrar para cada playlist su nombre, el nombre de usuario y la cantidad de canciones
-- que la componen. En caso de ser una playlist curada, en el lugar correspondiente a
-- nombre de usuario debe aparecer �playlist Curada�.

SELECT p.playListId as 'ID playlist', u.usuarioNombre as 'Usuario', COUNT(pc.cancionId) as 'Cantidad de canciones'
FROM playList as p, usuario as u, playListCancion as pc
WHERE p.playListId = pc.playListId AND u.usuarioId = p.usuarioId
GROUP BY pc.playListId, p.playListId, u.usuarioNombre;



-- Consulta D
-- d. Mostrar id y nombre de los usuarios que se registraron en la aplicaci�n este a�o, tienen
-- m�s de 4 playlists con 10 temas, no tienen playlists con menos de 3 temas y han
-- reproducido alg�n tema en los �ltimos 10 d�as.




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
