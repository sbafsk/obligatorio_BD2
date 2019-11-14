-- ##
--
-- Disparadores
-- 
-- ##

USE OBLIGATORIO1BD2
GO

-- ##
-- A. Cada vez que se ingrese un registro en historialCanci�n, 
-- se actualicen la cantidad de reproducciones de la canci�n, 
-- el �lbum y el artista.
-- ##

CREATE TRIGGER actualizarCantidadReproduccionCancionAlbumArtista
	ON cancion 
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE cancion
	SET cancionCantReproducciones = cancionCantReproducciones + 1
END
GO


-- ##
-- B. Cuando se ingrese una playList, 
-- validar que no tenga usuario en caso de que sea
-- curada y que lo tenga en caso contrario.
-- ##



-- ##
-- C. Controlar que las playLists no tengan m�s de 100 canciones.
-- ##



-- ##
-- D. No permitir asignar planes no vigentes a los usuarios.
-- ##



-- ##
-- E. Implementar un disparador que al eliminar un artista, 
-- elimine todo lo relacionado al mismo.
-- (�lbum, canci�n, sacarlo de playlist y de historial).
-- ##


