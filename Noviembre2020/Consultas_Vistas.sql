
USE OBLIGATORIOBD2
GO

--CONSULTAS:


/* a) Mostrar los datos de las ultimas Vulnerabilidades de criticidad ALTA que no hayan sido
resueltas aún. En el resultado debe aparecer también el nombre de la zona en la cual
se detectó la Vulnerabilidad */

SELECT v.ScnHerr, v.ScnVulnNom, z.ZonaNom, v.VulnFchScanO, v.VulnFchScanU, v.VulnCriticidad ,v.TarID
FROM CTRLVULNERABILIDADES v
left join ZONAS z on z.ZonaId = v.zonaId
left join TAREAS t on t.TarId = v.TarID
WHERE v.VulnCriticidad = 'ALTA' 
AND t.TarEstado IN ('EN ESPERA', 'EN DESARROLLO');


/* b) Mostrar los datos de los usuarios que pueden acceder a todas las zonas. */

SELECT u.Usuario, u.UsuPsw, u.UsuNomApp, u.UsuMail
FROM USUARIOS u, PERMISOSCNX p
WHERE u.Usuario = p.Usuario AND p.Habilitado = 'SI'
GROUP BY u.Usuario, u.UsuPsw, u.UsuNomApp, u.UsuMail
HAVING COUNT(p.ZonaId) = (SELECT count(*) FROM ZONAS)


/*c) Mostrar los datos de las zonas mas seguras de la red, siendo estas aquellas que no
han tenido vulnerabilidades ALTA los últimos tres meses, y que tienen menos de 3
usuarios con conexiones no permitidas en el último mes*/

select z.ZonaId, z.ZonaNom, z.ZonaDescrip
from ZONAS z, Usuarios u
where z.ZonaId <> ALL(select distinct c.ZonaId
				from CTRLVULNERABILIDADES c 
				where (c.VulnFchScanU BETWEEN DATEADD(month, -3, GETDATE()) and GETDATE()) and c.VulnCriticidad = 'ALTA')
and z.ZonaId in (select distinct p.ZonaId from PERMISOSCNX p where p.Habilitado = 'NO' group by p.ZonaId having COUNT(*) < 3)
group by z.ZonaId, z.ZonaNom, z.ZonaDescrip


-- TEST
select p.ZonaId from PERMISOSCNX p where p.Habilitado = 'NO' group by p.ZonaId having COUNT(*) < 3

select * from PERMISOSCNX p, ZONAS z where p.ZonaId = z.ZonaId and p.Habilitado = 'NO'
select p.Usuario from PERMISOSCNX p where p.Habilitado = 'NO' group by p.Usuario having COUNT(*) < 3

select distinct c.ZonaId from CTRLVULNERABILIDADES c where (c.VulnFchScanU BETWEEN DATEADD(month, -3, GETDATE()) and GETDATE()) and c.VulnCriticidad = 'ALTA'
select c.ZonaId, c.ScnHerr, c.ScnVulnNom, c.VulnFchScanU, c.TarID, DATEADD(month, -3, GETDATE()) as tiempo  from CTRLVULNERABILIDADES c where c.VulnFchScanU BETWEEN DATEADD(month, -3, GETDATE()) and GETDATE() and c.VulnCriticidad = 'ALTA';


/*d) Se quiere los usuarios que hace mas de 180 dias que no se conectan. En el resultado
debe aparecer la cantidad de días que hace que no se conectan y el nombre del
equipo al que se conectó por última vez*/

SELECT u.Usuario, u.UsuPsw, u.UsuNomApp, u.UsuMail, DATEDIFF(day, c.CnxFchHr, GETDATE()) as Diferencia_dias, e.EqpNom
FROM CTRLCONEXIONES c, USUARIOS u, EQUIPOS e
WHERE not exists(SELECT c.CnxFchHr FROM CTRLCONEXIONES C WHERE u.Usuario = C.Usuario and c.CnxPermitida = 1 AND c.CnxFchHr > DATEADD(day, -180, GETDATE()))
	and c.EqpIP = e.EqpIP
	and c.Usuario = u.Usuario
group by u. Usuario, u.UsuPsw, u.UsuNomApp, u.UsuMail, e.EqpNom, c.CnxFchHr


/*e) Para cada usuario que es responsable de mas de 3 tareas no resueltas, mostrar el
usuario y el promedio de horas que están insumiendo estas tareas*/

SELECT u.Usuario, AVG(t.TarHrsAcum) as Promedio_Horas
FROM USUARIOS u, TAREAS t, RACI r
WHERE r.RaciUsuario = u.Usuario
	AND r.RaciTarId = t.TarId
	AND t.TarEstado not in ('CANCELADA','RESUELTO')
GROUP BY u.Usuario
HAVING Count(*) > 3

-- test
select * from tareas t where t.TarEstado not in ('CANCELADA','RESUELTO') and t.TarId in ('4','19','57','60','95', '101')
select * from raci r where r.RaciUsuario = 'clafoyr'


/*f) Para cada Zona de la Red indicar la cantidad de conexiones no permitidas a equipos
de la zona, y la cantidad de vulnerabilidades encontradas en la zona en los últimos 30
días. Usar la función 6b) en la solución implementada*/

SELECT z.ZonaId, z.ZonaNom, z.ZonaDescrip, count(distinct c.CnxId) as Cantidad_NoPermitida, dbo.CantVulnZonaUltimosDias(z.ZonaId, 30) as Cantidad_Vulnerabilidades
from Zonas z, CTRLCONEXIONES c, EQUIPOS e
where c.CnxPermitida = 0
	and e.ZonaId = z.ZonaId
	and c.EqpIP = e.EqpIP
group by z.ZonaId, z.ZonaNom, z.ZonaDescrip

--test
select * from CTRLCONEXIONES c where c.CnxPermitida = 0
select * from EQUIPOS e



--VISTAS:

USE OBLIGATORIOBD2
GO

/*a. Crear una vista que muestre para cada herramienta de escaneo mostrar la cantidad
de vulnerabilidades que ha detectado de criticidad alta, media y baja en el mes
actual. En el resultado de deben aparecer todas las herramientas de escaneo*/

CREATE VIEW Escaneos_Vulnerabilidades AS
SELECT DISTINCT
	e.ScnHerr,
	(SELECT COUNT(cv.ScnHerr) from CTRLVULNERABILIDADES cv WHERE CV.VulnCriticidad = 'ALTA' AND cv.ScnHerr = e.ScnHerr AND Month(cv.VulnFchScanU) = MONTH(GETDATE())) as ALTA,
	(SELECT COUNT(cv.ScnHerr) from CTRLVULNERABILIDADES cv WHERE CV.VulnCriticidad = 'MEDIA' AND cv.ScnHerr = e.ScnHerr AND Month(cv.VulnFchScanU) = MONTH(GETDATE())) as MEDIA,
	(SELECT COUNT(cv.ScnHerr) from CTRLVULNERABILIDADES cv WHERE CV.VulnCriticidad = 'BAJA' AND cv.ScnHerr = e.ScnHerr AND Month(cv.VulnFchScanU) = MONTH(GETDATE())) as BAJA
FROM ESCANEOS E

--SELECT cv.* from CTRLVULNERABILIDADES cv WHERE cv.VulnCriticidad = 'ALTA' AND Month(cv.VulnFchScanU) = MONTH(GETDATE())


/*b. Crear una vista que muestre los datos de los usuarios (usuario, nombre) más
críticos siendo estos los que son responsables de ejecutar más cantidad de tareas
que no están resueltas ni en espera. En el resultado también debe aparecer el
promedio de horas dedicadas a esas tareas.*/


CREATE VIEW Usuarios_Criticos AS
select u.Usuario, u.UsuNomApp, AVG(t.TarHrsAcum) as Promedio_Horas
from USUARIOS u, TAREAS t, RACI r
where r.RaciUsuario = u.Usuario and r.RaciTarId = t.TarId and t.TarEstado in ('CANCELADAS','EN DESARROLLO')
group by u.Usuario, u.UsuNomApp;

-- * test * 
select * from tareas t where t.TarEstado in ('CANCELADAS','EN DESARROLLO') and t.TarId in ('6','43')
select * from raci r where r.RaciUsuario = 'zhazeman9'

