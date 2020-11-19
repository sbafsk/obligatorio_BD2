--
-- CARGA DE DATOS CON ERRORES
--

USE OBLIGATORIOBD2
GO


--ZONAS
-- insertar una zona sin nombre
INSERT INTO ZONAS (ZonaDescrip) VALUES ('nulla suspendisse potenti cras in purus eu magna vulputate luctus');

-- insertar una zona con ID
INSERT INTO ZONAS (ZonaId, ZonaNom, ZonaDescrip) VALUES (1,'South','nulla suspendisse potenti cras in purus eu magna vulputate luctus');


--USUARIOS

--Insertar UsuPsw sin digito--
INSERT INTO USUARIOS (Usuario, UsuPsw, UsuNomApp, UsuMail) Values
 ('srodkjh0', 'VojsAdjd', 'srodri', 'srodri0@amazonaws.com'),
 ('jffikss1', 'fsdgytcSC', 'jfernan', 'jfernan@sfgate.com');



--EQUIPOS

--Insertar Equipos fuera del rango de ip--
INSERT INTO EQUIPOS(EqpIP, EqpNom, EqpTipo, EqpSO, ZonaId) VALUES
('315.266.268.40.15', 'iames0', 'Terminal', 'MS-Windows', 6),
('320-475.387.99', 'bbanasiak1', 'Servidor', 'CentOS', 10)



--PERMISOSCNX

--Insertar Permisos con Habilitado sin (SI-NO)
INSERT INTO PERMISOSCNX (Usuario, ZonaID, Habilitado) VALUES
('aalonzo', 22, 'Checked'),
('tgonzales2', 20, 'Error')



--Tareas

--Insercción de tareas con id--
INSERT INTO TAREAS (TarId,TarEstado, TarHrsAcum, TarFchIni, TarFchFin, TarFchFPrev, TarDescrip) VALUES
(1,'EN DESARROLLO', 10, '2019-12-06 00:16:23', '2020-11-12 20:57:06', '2020-07-26 09:10:22', 'Donec quis orci eget orci vehicula condimentum.'),
(2,'CANCELADA', 7, '2020-06-25 11:27:36', null, '2021-01-29 19:06:41', 'Pellentesque at nulla.')

--Insercción de tareas con fecha de inicio mayor a la fecha de finalizacion prevista--
INSERT INTO TAREAS (TarEstado, TarHrsAcum, TarFchIni, TarFchFin, TarFchFPrev, TarDescrip) VALUES
('EN DESARROLLO', 10, '2020-12-06 00:16:23', '2020-11-12 20:57:06', '2020-07-26 09:10:22', 'Donec quis orci eget orci vehicula condimentum.'),
('CANCELADA', 7, '2021-06-25 11:27:36', null, '2021-01-29 19:06:41', 'Pellentesque at nulla.')

--Insercción de tareas con horas acumuladas menores a 1--
INSERT INTO TAREAS (TarId,TarEstado, TarHrsAcum, TarFchIni, TarFchFin, TarFchFPrev, TarDescrip) VALUES
(1,'EN DESARROLLO', 0, '2019-12-06 00:16:23', '2020-11-12 20:57:06', '2020-07-26 09:10:22', 'Donec quis orci eget orci vehicula condimentum.'),
(2,'CANCELADA', 0, '2020-06-25 11:27:36', null, '2021-01-29 19:06:41', 'Pellentesque at nulla.')



--CtrlConexiones

--Insercción de conexiones sin fechas--
INSERT INTO CTRLCONEXIONES (Usuario, EqpIP, CnxFchHr, CnxPermitida, TarID) VALUES
('spietro2', '108.1135.242.80 ', 'NO', 10)

--Insercción de conexiones con id pasado por parametro--
INSERT INTO CTRLCONEXIONES (CnxId,Usuario, EqpIP, CnxFchHr, CnxPermitida, TarID) VALUES
(1,'ngodney12', '92.202.30.20', '2020-02-05 10:32:52', 'NO', 95),
(10,'rkaren13', '194.156.241.82 ', '2020-02-05 10:32:52', 'SI', 15)


