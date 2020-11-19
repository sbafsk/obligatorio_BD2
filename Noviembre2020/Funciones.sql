-- ###
--
-- Funciones
--
-- ##

USE OBLIGATORIOBD2
GO


/*
b. Crear una función que dada una zona y una cantidad de días X, devuelva la
cantidad de vulnerabilidades encontradas en dicha zona en los últimos X días
indicados por los parámetros
*/

CREATE FUNCTION CantVulnZonaUltimosDias(@ZonaId int, @xDias int) RETURNS int
AS
BEGIN

	DECLARE @cantVul int
	
	SELECT @cantVul = COUNT(CV.ScnVulnNom)
	FROM CTRLVULNERABILIDADES CV
	WHERE @ZonaId = CV.ZonaId AND
		  CV.VulnFchScanO > DATEADD(day,-@xDias, '2020-09-30') -- lo ultimos registros son del 2020-09-28

	return @cantVul
END
GO

SELECT dbo.CantVulnZonaUltimosDias(20, 90)

select * from CTRLVULNERABILIDADES WHERE ZonaId = 20 ORDER BY VulnFchScanO 



/*
c. Crear una función que dada una herramienta de escaneo devuelva el nombre de la
zona con más vulnerabilidades criticas, altas, encontradas por escaneos realizados
por dicha herramienta. Si hay más de una zona en dichas condiciones devolver la
que tenga la vulnerabilidad más reciente
*/

CREATE FUNCTION ZonaMasCritPorHerr(@scnHerr varchar(100)) RETURNS varchar(50)
AS
BEGIN

	DECLARE @zonaNom varchar(50)
	
	SELECT TOP(1) @zonaNom = Z.ZonaNom
	FROM CTRLVULNERABILIDADES CV, ZONAS Z
	WHERE	@scnHerr = CV.ScnHerr AND
			CV.VulnCriticidad = 'ALTA' AND
			Z.ZonaId = CV.ZonaId
	GROUP BY  Z.ZonaNom
	ORDER BY COUNT(CV.ZonaId) DESC

	return @zonaNom
END
GO

/* TEST */
SELECT dbo.ZonaMasCritPorHerr('Ad-aware')

SELECT  TOP(1) Z.ZonaNom
FROM CTRLVULNERABILIDADES CV, ZONAS Z

WHERE	'Ad-aware' = CV.ScnHerr AND 
		Z.ZonaId = CV.ZonaId
GROUP BY  Z.ZonaNom
ORDER BY COUNT(CV.ZonaId) DESC, CV.VulnFchScanO DESC

select * from CTRLVULNERABILIDADES WHERE ZonaId = 20 ORDER BY VulnFchScanO 
select * from ZONAS




