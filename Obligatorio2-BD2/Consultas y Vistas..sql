-- ##
-- 
-- Consultas y Vistas.
-- 
-- ##

USE OBLIGATORIO1BD2
GO

-- ##
-- Consultas:
-- ##


-- ##
-- A. Mostrar los usuarios que han escuchado todas las playlists curadas 
-- (basta con haber escuchado con un tema de la playlist para considerar escuchó la playlist).
-- ##



-- ##
-- B. Mostrar para cada artista, la cantidad de álbumes que tiene con más de 10 temas. 
-- En caso de que haya artistas sin álbumes, también deben mostrarse.
-- ##



-- ##
-- C. Devolver id y nombre del/los usuario/s que escuchó/escucharon más temas nacionales
-- en lo que va del año.
-- ##



-- ##
-- D. Devolver el id y nombre de los usuarios, que tengan más de 3 playlists, 
-- que hayan escuchado más de 10 temas por mes en los últimos 3 meses 
-- y que no hayan escuchado más de 20 artistas distintos en el mes actual.
-- ##



-- ##
-- E. Devolver el nombre de los usuarios 
-- que hayan escuchado temas de todos los álbumes de ‘Jaime Roos’.
-- ##

-- ##
-- F. Eliminar los artistas que no tengan temas en playlists 
-- y que no tengan reproducciones en lo que va del año.
-- ##



-- ##
-- Vistas
-- ##

-- ##
-- A. Crear una vista 'usuariosPorPlan' que muestre por pan, 
-- la cantidad de usuarios que tiene, 
-- considerando solamente los planes con más de 10 usuarios.
-- ##

CREATE VIEW usuariosPorPlan
AS (
	SELECT DISTINCT p.planNombre, count(u.planId) as 'Cantidad' 
	FROM usuario u, plan1 p 
	WHERE u.planid = p.planid 
	GROUP BY p.planNombre
	HAVING count(u.planId) > 10
);


-- ##
-- B. Crear una vista, ‘promedioReproduccionesUsuariosMesAnio’ que muestra para cada mes, 
-- año el promedio de reproducciones (reproducciones totales / usuarios distintos). 
-- Mostrar en el resultado solo los meses/años con más de 100 reproducciones.
-- ##


