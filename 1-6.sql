-- Create tables section -------------------------------------------------

USE [master];
GO

IF EXISTS (SELECT 1 FROM sys.sysdatabases WHERE [name] = 'TransportSystem')
	BEGIN
		ALTER DATABASE [TransportSystem] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE [TransportSystem];
	END

CREATE DATABASE [TransportSystem];
GO

USE [TransportSystem];
GO

-- Table Stations

CREATE TABLE [Stations]
(
 [Id] INT NOT NULL PRIMARY KEY,
 [Name] Nvarchar(50) NOT NULL
 ) AS NODE
go

-- Table Stations

CREATE TABLE [Cities]
(
 [Id] INT NOT NULL PRIMARY KEY,
 [Name] Nvarchar(50) NOT NULL,
 [Region] Nvarchar(50) NOT NULL
 ) AS NODE
go

-- Table Routes

CREATE TABLE [Routes]
(
 [Id] INT NOT NULL PRIMARY KEY,
 [Number] Nvarchar(50) NOT NULL,
) AS NODE
go

-- Table Transports

CREATE TABLE [Transports]
(
 [Id] INT NOT NULL PRIMARY KEY,
 [Number] Nvarchar(50) NOT NULL,
 [TypeOfTransport] Nvarchar(50) NOT NULL,
) AS NODE
go

CREATE TABLE [StationIn] AS EDGE; --в каком городе находится станция
CREATE TABLE [TransportIn] AS EDGE; --какой транспорт по какому маршруту ездит
CREATE TABLE [StationFrom] AS EDGE; --из какой станции начинается маршрут
CREATE TABLE [StationTo] AS EDGE; --в какой станции завершается маршрут
CREATE TABLE [Roads] AS EDGE; --дороги между городами 

ALTER TABLE [StationIn] ADD CONSTRAINT [EC_StationIn] CONNECTION ([Stations] TO [Cities]);
ALTER TABLE [TransportIn] ADD CONSTRAINT [EC_TransportIn] CONNECTION ([Transports] TO [Routes]);
ALTER TABLE [StationFrom] ADD CONSTRAINT [EC_StationFrom] CONNECTION ([Routes] TO [Stations]);
ALTER TABLE [StationTo] ADD CONSTRAINT [EC_StationTo] CONNECTION ([Routes] TO [Stations]);
ALTER TABLE [Roads] ADD CONSTRAINT [EC_Roads] CONNECTION ([Cities] TO [Cities]);

--INSERT Stations

INSERT INTO [Stations]([Id], [Name])
VALUES (1, 'Autostation 1 of Minsk'),
	   (2, 'Autostation 2 of Minsk'),
	   (3, 'Railway station of Minsk'),
	   (4, 'Railway station of Grodno'),
	   (5, 'Autostation of Grodno'),
	   (6, 'Railway station of Brest'),
	   (7, 'Autostation of Brest'),
	   (8, 'Railway station of Vitebsk'),
	   (9, 'Autostation of Vitebsk'),
	   (10, 'Autostation of Gomel');

--INSERT Cities

INSERT INTO [Cities]([Id], [Name], [Region])
VALUES (1, 'Minsk', 'Minsk'),
	   (2, 'Grodno', 'Grodno'),
	   (3, 'Brest', 'Brest'),
	   (4, 'Vitebsk', 'Vitebsk'),
	   (5, 'Gomel', 'Gomel'),
	   (6, 'Mogilev', 'Mogilev'),
	   (7, 'Lida', 'Lida'),
	   (8, 'Polotsk', 'Polotsk'),
	   (9, 'Smorgon', 'Smorgon'),
	   (10, 'Baranovichi', 'Baranovichi');

--INSERT Routes

INSERT INTO [Routes]([Id], [Number])
VALUES (1, '0023'),
	   (2, '0078'),
	   (3, '0165'),
	   (4, '0003'),
	   (5, '0111'),
	   (6, '0037'),
	   (7, '0089'),
	   (8, '0031'),
	   (9, '0019'),
	   (10, '0106');

--INSERT Transports

INSERT INTO [Transports]([Id], [Number], [TypeOfTransport])
VALUES (1, '2303RK', 'Car'),
	   (2, '4817TZ', 'Car'),
	   (3, '3952LM', 'Car'),
	   (4, '7630BD', 'Car'),
	   (5, '1284QS', 'Bus'),
	   (6, '9075XE', 'Bus'),
	   (7, '3142NG', 'Bus'),
	   (8, '6729HV', 'Train'),
	   (9, '5430AZ', 'Train'),
	   (10, '8091CY', 'Train');

--INSERT StationIn

INSERT INTO [StationIn] ($from_id, $to_id)
VALUES ((SELECT $node_id FROM [Stations] WHERE [Id] = 1), (SELECT $node_id FROM [Cities] WHERE [Id] = 1)),
	   ((SELECT $node_id FROM [Stations] WHERE [Id] = 2), (SELECT $node_id FROM [Cities] WHERE [Id] = 1)),
	   ((SELECT $node_id FROM [Stations] WHERE [Id] = 3), (SELECT $node_id FROM [Cities] WHERE [Id] = 1)),
	   ((SELECT $node_id FROM [Stations] WHERE [Id] = 4), (SELECT $node_id FROM [Cities] WHERE [Id] = 2)),
	   ((SELECT $node_id FROM [Stations] WHERE [Id] = 5), (SELECT $node_id FROM [Cities] WHERE [Id] = 2)),
	   ((SELECT $node_id FROM [Stations] WHERE [Id] = 6), (SELECT $node_id FROM [Cities] WHERE [Id] = 3)),
	   ((SELECT $node_id FROM [Stations] WHERE [Id] = 7), (SELECT $node_id FROM [Cities] WHERE [Id] = 3)),
	   ((SELECT $node_id FROM [Stations] WHERE [Id] = 8), (SELECT $node_id FROM [Cities] WHERE [Id] = 4)),
	   ((SELECT $node_id FROM [Stations] WHERE [Id] = 9), (SELECT $node_id FROM [Cities] WHERE [Id] = 4)),
	   ((SELECT $node_id FROM [Stations] WHERE [Id] = 10), (SELECT $node_id FROM [Cities] WHERE [Id] = 5));

--INSERT TransportIn

INSERT INTO [TransportIn] ($from_id, $to_id)
VALUES ((SELECT $node_id FROM [Transports] WHERE [Id] = 1), (SELECT $node_id FROM [Routes] WHERE [Id] = 1)),
	   ((SELECT $node_id FROM [Transports] WHERE [Id] = 2), (SELECT $node_id FROM [Routes] WHERE [Id] = 2)),
	   ((SELECT $node_id FROM [Transports] WHERE [Id] = 3), (SELECT $node_id FROM [Routes] WHERE [Id] = 3)),
	   ((SELECT $node_id FROM [Transports] WHERE [Id] = 4), (SELECT $node_id FROM [Routes] WHERE [Id] = 4)),
	   ((SELECT $node_id FROM [Transports] WHERE [Id] = 5), (SELECT $node_id FROM [Routes] WHERE [Id] = 7)),
	   ((SELECT $node_id FROM [Transports] WHERE [Id] = 6), (SELECT $node_id FROM [Routes] WHERE [Id] = 8)),
	   ((SELECT $node_id FROM [Transports] WHERE [Id] = 7), (SELECT $node_id FROM [Routes] WHERE [Id] = 9)),
	   ((SELECT $node_id FROM [Transports] WHERE [Id] = 8), (SELECT $node_id FROM [Routes] WHERE [Id] = 5)),
	   ((SELECT $node_id FROM [Transports] WHERE [Id] = 9), (SELECT $node_id FROM [Routes] WHERE [Id] = 5)),
	   ((SELECT $node_id FROM [Transports] WHERE [Id] = 10), (SELECT $node_id FROM [Routes] WHERE [Id] = 6));

--INSERT StationFrom

INSERT INTO [StationFrom] ($from_id, $to_id)
VALUES ((SELECT $node_id FROM [Routes] WHERE [Id] = 1), (SELECT $node_id FROM [Stations] WHERE [Id] = 1)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 2), (SELECT $node_id FROM [Stations] WHERE [Id] = 1)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 3), (SELECT $node_id FROM [Stations] WHERE [Id] = 2)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 4), (SELECT $node_id FROM [Stations] WHERE [Id] = 2)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 5), (SELECT $node_id FROM [Stations] WHERE [Id] = 3)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 6), (SELECT $node_id FROM [Stations] WHERE [Id] = 3)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 7), (SELECT $node_id FROM [Stations] WHERE [Id] = 5)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 8), (SELECT $node_id FROM [Stations] WHERE [Id] = 7)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 9), (SELECT $node_id FROM [Stations] WHERE [Id] = 9)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 10), (SELECT $node_id FROM [Stations] WHERE [Id] = 10));

--INSERT StationTo

INSERT INTO [StationTo] ($from_id, $to_id)
VALUES ((SELECT $node_id FROM [Routes] WHERE [Id] = 1), (SELECT $node_id FROM [Stations] WHERE [Id] = 5)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 2), (SELECT $node_id FROM [Stations] WHERE [Id] = 7)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 3), (SELECT $node_id FROM [Stations] WHERE [Id] = 9)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 4), (SELECT $node_id FROM [Stations] WHERE [Id] = 10)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 5), (SELECT $node_id FROM [Stations] WHERE [Id] = 4)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 6), (SELECT $node_id FROM [Stations] WHERE [Id] = 6)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 7), (SELECT $node_id FROM [Stations] WHERE [Id] = 1)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 8), (SELECT $node_id FROM [Stations] WHERE [Id] = 1)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 9), (SELECT $node_id FROM [Stations] WHERE [Id] = 2)),
	   ((SELECT $node_id FROM [Routes] WHERE [Id] = 10), (SELECT $node_id FROM [Stations] WHERE [Id] = 2));


--INSERT Roads

INSERT INTO [Roads] ($from_id, $to_id)
VALUES ((SELECT $node_id FROM [Cities] WHERE [Id] = 1), (SELECT $node_id FROM [Cities] WHERE [Id] = 2)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 1), (SELECT $node_id FROM [Cities] WHERE [Id] = 3)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 1), (SELECT $node_id FROM [Cities] WHERE [Id] = 4)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 1), (SELECT $node_id FROM [Cities] WHERE [Id] = 5)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 2), (SELECT $node_id FROM [Cities] WHERE [Id] = 5)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 2), (SELECT $node_id FROM [Cities] WHERE [Id] = 6)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 2), (SELECT $node_id FROM [Cities] WHERE [Id] = 7)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 3), (SELECT $node_id FROM [Cities] WHERE [Id] = 6)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 5), (SELECT $node_id FROM [Cities] WHERE [Id] = 9)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 4), (SELECT $node_id FROM [Cities] WHERE [Id] = 8)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 6), (SELECT $node_id FROM [Cities] WHERE [Id] = 10)),
	   ((SELECT $node_id FROM [Cities] WHERE [Id] = 10), (SELECT $node_id FROM [Cities] WHERE [Id] = 8));

--Найти маршруты по которым ездят поезда

SELECT DISTINCT r.Number
FROM [Transports] AS t,
	 [TransportIn] AS ti,
	 [Routes] AS r
WHERE MATCH(t-(ti)->r)
  AND t.TypeOfTransport = 'Train'

--Найти транспорт который ездит в Минска

SELECT t.Number
FROM [Transports] AS t,
	 [TransportIn] AS ti,
	 [Routes] AS r,
	 [StationTo] AS st,
	 [Stations] AS s,
	 [StationIn] AS si,
	 [Cities] AS c
WHERE MATCH(t-(ti)->r-(st)->s-(si)->c)
  AND c.Name = 'Minsk'

--Найти маршруты между Минском и Гродно

SELECT *
FROM [Routes] AS r,
	 [StationTo] AS st,
	 [StationFrom] AS sf,
	 [Stations] AS s1,
	 [Stations] AS s2,
	 [StationIn] AS si1,
	 [StationIn] AS si2,
	 [Cities] AS c1,
	 [Cities] AS c2
WHERE MATCH(c1<-(si1)-s1<-(sf)-r-(st)->s2-(si2)->c2)
  AND (c1.Name = 'Minsk' AND c2.Name = 'Gomel'
   OR c1.Name = 'Gomel' AND c2.Name = 'Minsk')

--Найти автобус, которая ездит между Минском и Брестом

SELECT t.Number
FROM [Transports] AS t,
	 [TransportIn] AS ti1,
	 [TransportIn] AS ti2,
	 [Routes] AS r1,
	 [Routes] AS r2,
	 [StationTo] AS st,
	 [StationFrom] AS sf,
	 [Stations] AS s1,
	 [Stations] AS s2,
	 [StationIn] AS si1,
	 [StationIn] AS si2,
	 [Cities] AS c1,
	 [Cities] AS c2
WHERE MATCH(c1<-(si1)-s1<-(sf)-r1<-(ti1)-t-(ti2)->r2-(st)->s2-(si2)->c2)
  AND (c1.Name = 'Minsk' AND c2.Name = 'Brest'
   OR c1.Name = 'Brest' AND c2.Name = 'Minsk')
  AND t.TypeOfTransport = 'Bus'

--Найти маршрут в Гомель

SELECT r.Number
FROM [Routes] AS r,
	 [StationTo] AS st,
	 [Stations] AS s,
	 [StationIn] AS si,
	 [Cities] AS c
WHERE MATCH(r-(st)->s-(si)->c)
  AND c.Name = 'Gomel'

--Максимально возможная сеть дорог для 'Minsk'

SELECT c1.Name,
	   STRING_AGG(c2.Name, '->') WITHIN GROUP (GRAPH PATH)
FROM [Cities] AS c1,
	 [Roads] FOR PATH AS r,
	 [Cities] FOR PATH AS c2
WHERE MATCH(SHORTEST_PATH(c1(-(r)->c2)+))
  AND c1.Name = 'Minsk'

--Откуда можно доехать из 'Baranovichi' проехав только два города

SELECT c1.Name,
	   STRING_AGG(c2.Name, '->') WITHIN GROUP (GRAPH PATH)
FROM [Cities] AS c1,
	 [Roads] FOR PATH AS r,
	 [Cities] FOR PATH AS c2
WHERE MATCH(SHORTEST_PATH(c1(<-(r)-c2){1,2}))
  AND c1.Name = 'Baranovichi'


--PowerBi
SELECT c1.Id AS IdFirst,
	   c1.Name AS First,
	   CONCAT(N'city', c1.Id) AS [First image name],
	   c2.Id AS IdSecond,
	   c2.Name AS Second,
	   CONCAT(N'city', c2.Id) AS [Second image name]
FROM [Cities] AS c1,
	 [Roads] AS r,
	 [Cities] AS c2
WHERE MATCH(c1-(r)->c2)

SELECT t.Id AS IdFirst,
	   t.Number AS First,
	   CONCAT(t.TypeOfTransport, t.Id) AS [First image name],
	   r.Id AS IdSecond,
	   r.Number AS Second,
	   CONCAT(N'Routes', r.Id) AS [Second image name]
FROM [Transports] AS t,
	 [TransportIn] AS ti,
	 [Routes] AS r
WHERE MATCH(t-(ti)->r)

SELECT s.Id AS IdFirst,
	   s.Name AS First,
	   CONCAT(N'station', s.Id) AS [First image name],
	   c.Id AS IdSecond,
	   c.Name AS Second,
	   CONCAT(N'city', c.Id) AS [Second image name]
FROM [Cities] AS c,
	 [StationIn] AS si,
	 [Stations] AS s
WHERE MATCH(s-(si)->c)

SELECT r.Id AS IdFirst,
	   r.Number AS First,
	   CONCAT(N'Routes', r.Id) AS [First image name],
	   s1.Id AS IdSecond,
	   s1.Name AS Second,
	   CONCAT(N'station', s1.Id) AS [Second image name],
	   s2.Id AS IdThrid,
	   s2.Name AS Thrid,
	   CONCAT(N'station', s2.Id) AS [Thrid image name]
FROM [Routes] AS r,
	 [StationTo] AS st,
	 [StationFrom] AS sf,
	 [Stations] AS s1,
	 [Stations] AS s2
WHERE MATCH(s1<-(sf)-r-(st)->s2)

SELECT @@SERVERNAME