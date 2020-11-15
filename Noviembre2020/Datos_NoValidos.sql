--
-- CARGA DE DATOS CON ERRORES
--

USE OBLIGATORIO1BD2
GO


--ALBUM

-- Insertar un album sin la existencia del artista
INSERT INTO album (albumId, albumNombre, artistaId, albumCantReproducciones) 
VALUES ('qwe','Nombre del album',1245,4);

-- Insertar un album excediendo el largo del id de album
INSERT INTO album (albumId, albumNombre, artistaId, albumCantReproducciones) 
VALUES ('qwewdasceqwe','Nombre del album',1,4);

-- Insertar un album sin un ID
INSERT INTO album (albumNombre, artistaId, albumCantReproducciones) 
VALUES ('Nombre del album',1,4);

-- Insertar un album excediendo el largo del campo albumCantReproducciones
INSERT INTO album (albumId, albumNombre, artistaId, albumCantReproducciones) 
VALUES ('qwewd','Nombre del album',1,40000000000);

-- Insertar un album duplicado
INSERT INTO album (albumId, albumNombre, artistaId, albumCantReproducciones) 
VALUES ('1', 'Doctor in the house', 1, 36561283);






--ARTISTA

-- Insertar un artista duplicado
INSERT INTO artista (artistaId, artistaNombre, artistaFoto, esNacional, artistaCantReproducciones) 
VALUES (9, 'Nichole Evans', '9HtG2cmF2oFQ2SV7e3Ol', 1, 50177325);

-- Insertar un artista sin ID
INSERT INTO artista (artistaNombre, artistaFoto, esNacional, artistaCantReproducciones) 
VALUES ('Nichole Evans', '9HtG2cmF2oFQ2SV7e3Ol', 1, 50177325);

-- Insertar un artista con una opción inválida en el campo 'esNacional'
INSERT INTO artista (artistaId, artistaNombre, artistaFoto, esNacional, artistaCantReproducciones) 
VALUES (101021, 'Nichole Evans', '9HtG2cmF2oFQ2SV7e3Ol', 3, 50177325);

-- Insertar un artista sin nombre
INSERT INTO artista (artistaId, artistaFoto, esNacional, artistaCantReproducciones) 
VALUES (1424, '9HtG2cmF2oFQ2SV7e3Ol', 1, 50177325);

-- Insertar un artista sin el campo 'esNacional'
INSERT INTO artista (artistaId, artistaNombre, artistaFoto, artistaCantReproducciones) 
VALUES (46123, 'Nichole Evans', '9HtG2cmF2oFQ2SV7e3Ol', 50177325);






--CANCION

-- Insertar canción con un ID (El campo es identity)
INSERT INTO cancion (cancionId, cancionNombre, albumId, cancionCantReproducciones) 
VALUES (142, 'Like a Rancid Stick', '21', 83550416);

-- Insertar canción sin un nombre
INSERT INTO cancion (albumId, cancionCantReproducciones) 
VALUES ( '21', 83550416);

-- Insertar canción con un número excedido en el campo cancionCantReproducciones
INSERT INTO cancion (cancionNombre, albumId, cancionCantReproducciones) 
VALUES ('Like a Rancid Stick', '21', 8355041600000000);

-- Insertar canción sin albumID
INSERT INTO cancion (cancionNombre, cancionCantReproducciones) 
VALUES ('Like a Rancid Stick', 83550416);

-- Insertar canción con albumID inexistente
INSERT INTO cancion (cancionNombre, albumId, cancionCantReproducciones) 
VALUES ('Like a Rancid Stick', 'asd10', 83550416);





--COMPRA

-- Insertar una compra con plan inexistente
INSERT INTO compra (usuarioId, planId, fechaGenerada, fechaPaga) 
VALUES ('tiffanymyers', '50', '20090531', '20150722');

-- Insertar una compra sin ID de usuario
INSERT INTO compra (planId, fechaGenerada, fechaPaga) 
VALUES ('2', '20090531', '20150722');

-- Insertar una compra con un ID (El campo es identity)
INSERT INTO compra (compraId, usuarioId, planId, fechaGenerada, fechaPaga) 
VALUES (3, 'tiffanymyers', '2', '20090531', '20150722');






--HISTORIAL CANCION

-- Insertar un dato con un ID (El campo es identity)
INSERT INTO historialCancion(historialCancionId, historialCancionFecha,usuarioId,cancionId) 
VALUES (5, '20030322 04:05:12','korbenrhodes','7');

-- Insertar un dato con usuario inexistente
INSERT INTO historialCancion(historialCancionFecha,usuarioId,cancionId) 
VALUES ('20030322 05:05:12','154dasdasvw','7');

-- Insertar dato con fecha duplicada
INSERT INTO historialCancion(historialCancionFecha,usuarioId,cancionId) 
VALUES ('20030322 04:05:12','korbenrhodes','7');

-- Insertar dato sin fecha
INSERT INTO historialCancion(usuarioId,cancionId) 
VALUES ('korbenrhodes','7');

-- Insertar dato sin usuario
INSERT INTO historialCancion(historialCancionFecha, cancionId) 
VALUES ('20030322 04:05:12','7');

-- Insertar dato sin id de canción
INSERT INTO historialCancion(historialCancionFecha,usuarioId) 
VALUES ('20030322 04:05:12','korbenrhodes');






--PLAYLIST

-- Insertar ID de playlist cuando el campo es IDENTITY
INSERT INTO playList (playListId, playListNombre, usuarioId, playListFechaCreacion,esPlayListCurada) 
VALUES (1510, 'NombrePrueba', 800, '20051012', 1);

-- Insertar una playlist cuando no existe el usuario
INSERT INTO playList (playListNombre, usuarioId, playListFechaCreacion,esPlayListCurada) 
VALUES ('NombrePrueba', 800, '20051012', 1);

-- Insertar una playlist cuando el campo "esPlayListCurada" no esta en las opciones (0 o 1)
INSERT INTO playList (playListNombre, usuarioId, playListFechaCreacion,esPlayListCurada) 
VALUES ('NombrePrueba', 'alasdairsteele', '20051012', 3);

-- Insertar una playlist sin el campo "esPlayListCurada"
INSERT INTO playList (playListNombre, usuarioId, playListFechaCreacion) 
VALUES ('NombrePrueba', 'alasdairsteele', '20051012');

-- Insertar una playlist sin un nombre
INSERT INTO playList(usuarioId,playListFechaCreacion,esPlayListCurada) 
VALUES ('shanipowell','20000113',0);

-- Insertar una playlist duplicada
INSERT INTO playList(playListNombre,usuarioId,playListFechaCreacion,esPlayListCurada) 
VALUES ('Acoustic Blues','shanipowell','20000113',0);






--PLAYLIST CANCION

-- Insertar un dato duplicado
INSERT INTO playListCancion(playListId,cancionId) 
VALUES (12,71);

-- Insertar un dato sin playListId
INSERT INTO playListCancion(cancionId) 
VALUES (71);

-- Insertar un dato sin cancionId
INSERT INTO playListCancion(playListId) 
VALUES (12);

-- Insertar un dato con cancionId inexistente
INSERT INTO playListCancion(playListId,cancionId) 
VALUES (12,710);

-- Insertar un dato con playListId inexistente
INSERT INTO playListCancion(playListId,cancionId) 
VALUES (1200,71);






--USUARIO

-- Insertar un usuario duplicado
INSERT INTO usuario (usuarioId, usuarioNombre, usuarioMail, fechaCreacion, planId, fechaPlanActivoDesde) 
VALUES ('tiffanymyers', 'Tiffany Myers', 'tiffanymyers@gmail.com', '20091008', '1','20150126');

-- Insertar un usuario sin nombre
INSERT INTO usuario (usuarioId, usuarioMail, fechaCreacion, planId, fechaPlanActivoDesde) 
VALUES ('tiffanymyers', 'tiffanymyers@gmail.com', '20091008', '1','20150126');

-- Insertar un usuario sin 'fechaCreacion'
INSERT INTO usuario (usuarioId, usuarioNombre, usuarioMail, planId, fechaPlanActivoDesde) 
VALUES ('tiffanymyers', 'Tiffany Myers', 'tiffanymyers@gmail.com', '1','20150126');

-- Insertar un usuario con mail duplicado
INSERT INTO usuario (usuarioId, usuarioNombre, usuarioMail, fechaCreacion, planId, fechaPlanActivoDesde) 
VALUES ('tiffanymyers2', 'Tiffany Myers2', 'tiffanymyers@gmail.com', '20091008', '1','20150126');

-- Insertar un usuario con plan inexistente
INSERT INTO usuario (usuarioId, usuarioNombre, usuarioMail, fechaCreacion, planId, fechaPlanActivoDesde) 
VALUES ('tiffanymyers1', 'Tiffany Myer2', 'tiffanymyer2s@gmail.com', '20091008', '18','20150126');

