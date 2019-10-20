USE OBLIGATORIO1BD2
GO

-- Consulta A

-- Consulta B
SELECT TOP 10 artistaId as ID, artistaNombre as Nombre 
FROM artista 
WHERE esNacional=1 ORDER BY artistaCantReproducciones DESC;

-- Consulta C

SELECT p.playListId as 'ID playlist', u.usuarioNombre as 'Usuario', COUNT(pc.cancionId) as 'Cantidad de canciones'
FROM playList as p, usuario as u, playListCancion as pc
WHERE p.playListId = pc.playListId AND u.usuarioId = p.usuarioId
GROUP BY pc.playListId, p.playListId, u.usuarioNombre;

-- Consulta D

-- Consulta E
SELECT * FROM cancion
WHERE cancionCantReproducciones = (
	SELECT MAX(cancionCantReproducciones) 
	FROM cancion
);


-- Consulta F

