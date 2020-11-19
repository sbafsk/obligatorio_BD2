-- ###
--
-- DISPARADORES
--
-- ##

/*a. Mediante un disparador, controle que solo se puedan insertar de a un equipo por vez
Y cuando esto ocurra controle que se cumplan las restricciones que debe cumplir esta
tabla y que no pudieron ser implementadas en el créate de la misma
(este disparador debe tener en cuenta inserciones SIMPLES)*/


/*b. Crear un disparador que cada vez que se ingrese un registro a la tabla de Control de
Conexiones determine los valores que corresponden para los campos fecha-hora y
conexión permitida. Usar el procedimiento o función implementado en el punto 6a)
(este disparador debe tener en cuenta inserciones MULTIPLES)*/


/*c. Crear un disparador que cada vez que se ingresen controles de vulnerabilidades,
resultados de escaneos, haga lo siguiente
• Si esa vulnerabilidad esta abierta, actualice la fecha de ultima vez que fue
encontrada la vulnerabilidad con la fecha del dia.
• Si esa vulnerabilidad no esta abierta agregue el registro (inicialmente sin tarea
asociada)
Se considera que una vulnerabilidad esta abierta si dicha herramienta ya la detecto en
la misma zona, y no tiene tarea asociada o tiene una tarea que no esta RESUELTA
(este disparador debe tener en cuenta modificaciones SIMPLES)*/


/*d. Crear un disparador que controle que solo se puedan eliminar control de conexiones
que no tengan tareas asociadas y que sean de una antigüedad mayor a 1 año.
(este disparador debe tener en cuenta eliminaciones MULTIPLES)*/


/*e. Crear un disparador que controle que si una tarea es marcada como CANCELADA
deje en null los controles de conexiones o vulnerabilidades que tenga asociados.
(este disparador debe tener en cuenta modificaciones MULTIPLES)
*/



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
	ON historialCancion 
	AFTER INSERT
AS
BEGIN	

	SET NOCOUNT ON;	

	DECLARE @idCancion int;
	DECLARE @idAlbum character(5);
	DECLARE @idArtista int;		
	
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
	
	SET NOCOUNT ON;	

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
-- C. Controlar que las playLists no tengan m�s de 100 canciones.
-- ##

CREATE TRIGGER validarPlaylistCantCanciones
	ON playListCancion
	INSTEAD OF INSERT
AS
BEGIN
	
	SET NOCOUNT ON;	

	DECLARE @totalCanciones INT;	

	SELECT @totalCanciones = COUNT(cancionId)
	FROM playListCancion
	WHERE playListId IN (	SELECT playListId
							FROM inserted
							)

	IF(@totalCanciones >= 100)
		BEGIN
			PRINT('Una playlist no puede tener mas de 100 canciones')
			ROLLBACK
		END
	ELSE
		BEGIN
		INSERT INTO playListCancion SELECT * FROM inserted
		END

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

	SET NOCOUNT ON;	
	
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
-- (�lbum, canci�n, sacarlo de playlist y de historial).
-- ##

CREATE TRIGGER elminarInfoArtista
	ON artista
	AFTER DELETE
AS
BEGIN

	SET NOCOUNT ON;	

	DECLARE @iDArtista int;
	
	SELECT @iDArtista = artistaId
	FROM deleted	

	DELETE album
	WHERE artistaId = @iDArtista

	DELETE cancion
	WHERE albumId IN (	SELECT albumId
						FROM album 
						WHERE artistaId = @iDArtista
						)

	DELETE playListCancion
	WHERE cancionId IN (SELECT cancionId
						FROM cancion C, album A
						WHERE	A.artistaId = @iDArtista AND
								A.albumId = C.albumId
						)

	DELETE historialCancion
	WHERE cancionId IN (SELECT cancionId
						FROM cancion C, album A
						WHERE	A.artistaId = @iDArtista AND
								A.albumId = C.albumId
						)
END
