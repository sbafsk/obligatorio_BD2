-- ##
--
-- Disparadores
-- 
-- ##

USE OBLIGATORIO1BD2
GO

-- ##
-- A. Cada vez que se ingrese un registro en historialCanción, 
-- se actualicen la cantidad de reproducciones de la canción, 
-- el álbum y el artista.
-- ##

CREATE TRIGGER actualizarCantidadReproduccionCancionAlbumArtista
	ON historialCancion 
	AFTER INSERT
AS
BEGIN	
	DECLARE @idCancion int;
	DECLARE @idAlbum character(5);
	DECLARE @idArtista int;

	SET NOCOUNT ON;		
	
	SELECT	@idCancion = I.cancionId,
			@idAlbum = Al.albumId,
			@idArtista = Ar.artistaId
	FROM	inserted I, 
			cancion C, 
			album Al,
			artista Ar
	WHERE	Ar.artistaId = Al.artistaId AND
			Al.albumId = C.albumId AND
			C.cancionId = I.cancionId
	
	UPDATE cancion
	SET cancionCantReproducciones = cancionCantReproducciones + 1
	WHERE @idCancion = cancionId

	UPDATE album
	SET albumCantReproducciones = albumCantReproducciones + 1
	WHERE @idAlbum = albumId


	UPDATE artista
	SET artistaCantReproducciones = artistaCantReproducciones + 1
	WHERE @idArtista = artistaId

END
GO


-- ##
-- B. Cuando se ingrese una playList, 
-- validar que no tenga usuario en caso de que sea curada
-- y que lo tenga en caso contrario.
-- ##

CREATE TRIGGER validarPlaylistCurada
	ON playList
	INSTEAD OF INSERT
AS
BEGIN
	DECLARE @esCurada numeric(1);
	DECLARE @usuario character(20);

	SELECT @esCurada = I.esPlayListCurada
	FROM inserted I

	IF(@esCurada = 1 AND @usuario != NULL)
		BEGIN
			print('La playlist es Curada, no puede tener un usuario')
			ROLLBACK
		END	
	ELSE
		BEGIN
			IF(@esCurada = 0 AND @usuario = NULL)
				BEGIN
					print('La playlist NO es Curada, debe tener un usuario')
					ROLLBACK
				END
			ELSE
				BEGIN
					INSERT INTO playList SELECT * FROM inserted
				END
		END
END
GO



-- ##
-- C. Controlar que las playLists no tengan más de 100 canciones.
-- ##

CREATE TRIGGER validarPlaylistCantCanciones
	ON playList
	AFTER INSERT
AS
BEGIN

	DECLARE @totalCanciones 

END
GO

-- ##
-- D. No permitir asignar planes no vigentes a los usuarios.
-- ##

CREATE TRIGGER validarVigenciaPlan
	ON usuario
	INSTEAD OF INSERT
AS
BEGIN
	
	DECLARE @planVigente int;
	
	SELECT @planVigente = esPlanVigente
	FROM plan1
	WHERE planId IN (SELECT planId FROM inserted)

	IF(@planVigente = 0)
		BEGIN
			PRINT('No se puede asignar al usuario un plan NO vigente.')
			ROLLBACK
		END
	ELSE
		BEGIN
			INSERT INTO usuario SELECT * FROM inserted
		END
			   
END
GO




-- ##
-- E. Implementar un disparador que al eliminar un artista, 
-- elimine todo lo relacionado al mismo.
-- (álbum, canción, sacarlo de playlist y de historial).
-- ##

CREATE TRIGGER elminarInfoArtista
	ON artista
	AFTER DELETE
AS
BEGIN
	DECLARE @iDArtista int

	SELECT @iDArtista = artistaId
	FROM deleted

	DELETE album
	WHERE artistaId = @iDArtista

	DELETE cancion
	WHERE artistaId = @iDArtista

	DELETE playList
	WHERE artistaId = @iDArtista

	DELETE historialCancion
	WHERE artistaId = @iDArtista

END