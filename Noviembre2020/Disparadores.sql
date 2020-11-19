-- ##
--
-- Disparadores
-- 
-- ##

USE OBLIGATORIOBD2
GO

/*
 a. Mediante un disparador, controle que solo se puedan insertar de a un equipo por vez
    y cuando esto ocurra controle que se cumplan las restricciones que debe cumplir esta
	tabla y que no pudieron ser implementadas en el créate de la misma
	(este disparador debe tener en cuenta inserciones SIMPLES)

*/

CREATE TRIGGER controlInserIntoEquipos
	ON EQUIPOS 
	INSTEAD OF INSERT
AS
BEGIN	

	SET NOCOUNT ON;	
	
	DECLARE @eqpNom varchar(50), @eqpTipo varchar(10)

	IF(1 = (SELECT COUNT(I.EqpIP) FROM inserted I))
		BEGIN
			SELECT @eqpNom = I.EqpNom, @eqpTipo = I.EqpTipo
			FROM inserted I

			IF(@eqpTipo = 'Terminal')
				BEGIN 
					SET @eqpNom = CONCAT('WKS',@eqpNom)
				END
			IF(@eqpTipo = 'Servidor')
				BEGIN 
					SET @eqpNom = CONCAT('SRV',@eqpNom)
				END
			IF(@eqpTipo = 'Tablet')
				BEGIN 
					SET @eqpNom = CONCAT('TBL',@eqpNom)
				END
			ELSE
				BEGIN 
					SET @eqpNom = CONCAT('IMP',@eqpNom)
				END
				
			INSERT INTO EQUIPOS 
			SELECT I.EqpIp, @eqpNom, I.EqpSO, I.EqpTipo, I.ZonaId 
			FROM inserted I
		END
	ELSE
		BEGIN
			Print 'Solo se puede insertar de a un equipo.'
		END

END
GO
SELECT * FROM EQUIPOS ORDER BY EqpNom

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