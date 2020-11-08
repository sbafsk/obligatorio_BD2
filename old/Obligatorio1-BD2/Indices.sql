-- Indices necesarios
USE OBLIGATORIO1BD2
GO
--
-- Indices por ser clave foranea.
--
-- Tabla album columna artistaId
CREATE INDEX ind_albArtistaId ON album(artistaId) 

-- Tabla cancion columna albumId
CREATE INDEX ind_canAlbumId ON cancion(albumID) 

-- Tabla usuario columna planId
CREATE INDEX ind_usuPlanId ON usuario(planId) 

-- Tabla compra columnas usuarioId y planId
CREATE INDEX ind_comUsuarioId ON compra(usuarioId) 

CREATE INDEX ind_comPlanId ON compra(planId) 

-- Tabla playList columna usuarioId
CREATE INDEX ind_plaUsuarioId ON playList(usuarioId) 

-- Tabla playListCancion columna cancionId
CREATE INDEX ind_plaCanCancionId ON playListCancion(cancionId) 

-- Tabla historialCancion columna usuarioId y cancionId 
CREATE INDEX ind_hisUsuarioId ON historialCancion(usuarioId) 

CREATE INDEX ind_hisCancionId ON historialCancion(cancionId) 

--
-- Indices comunmente utilizados en consultas.
--
-- Tabla artista columna artistaNombre
CREATE INDEX ind_artistaNombre ON artista(artistaNombre) 

-- Tabla album columna albumNombre
CREATE INDEX ind_albumNombre ON album(albumNombre) 

-- Tabla cancion columna cancionNombre
CREATE INDEX ind_cancionNombre ON cancion(cancionNombre) 

-- Tabla plan columna planNombre
CREATE INDEX ind_planNombre ON plan1(planNombre) 

-- Tabla usuario columna usuarioNombre
CREATE INDEX ind_usuarioNombre ON usuario(usuarioNombre) 

-- Tabla playList columna playListNombre
CREATE INDEX ind_playListNombre ON playList(playListNombre) 