

-- создаем таблицу Reactor_Details - Ключевая информация об энергоблоке

CREATE TABLE Reactor_Details (
Reactor_Details_ID serial PRIMARY KEY,
Reactor_Name VARCHAR (50) UNIQUE NOT NULL,
Reactor_Type VARCHAR(50) NOT NULL,
Reactor_Model VARCHAR(50) NOT NULL,
Reactor_Status VARCHAR(50) NOT NULL,
Reactor_Owner VARCHAR(50) NOT NULL,
Reactor_Operator VARCHAR(50) NOT NULL
);

-- проверяем
select * from Reactor_Details; 


-- заполняем таблицу данными (по строкам, потому что я еще не знаю как спарсить все данные)

INSERT INTO Reactor_Details VALUES 
(1, 'ATUCHA-1', 'PHWR', 'PHWR KWU', 'Operational', 'NUCLEOELECTRICA ARGENTINA S.A.', 'NUCLEOELECTRICA ARGENTINA S.A.'), 
(2, 'ATUCHA-2', 'PHWR', 'PHWR KWU', 'Operational', 'NUCLEOELECTRICA ARGENTINA S.A.', 'NUCLEOELECTRICA ARGENTINA S.A.');


select * from Reactor_Details; -- проверяем


-- создаем таблицу Location - Местоположение энергоблока

CREATE TABLE Location (
Location_ID	serial PRIMARY KEY,
Location VARCHAR(50) NOT NULL,
Country VARCHAR(50) NOT NULL
);

-- проверяем
select * from Location;

-- заполняем таблицу данными

INSERT INTO Location VALUES 
(1, 'LIMA', 'Argentina'),
(2, 'LIMA', 'Argentina');

-- проверяем
select * from Location;

-- создаем таблицу Reactor_Dates - Даты жизненного цикла (день, месяц, год)
CREATE TABLE Reactor_Dates (
Reactor_Dates_ID serial PRIMARY KEY,
Construction_Start_Date DATE NOT NULL, 
Construction_Suspension_Date DATE,
Construction_Restart_Date DATE,
Commercial_Operation_Date DATE,
First_Criticality_Date DATE,
First_Grid_Connection DATE,
Permanent_Shutdown_Date DATE
);

-- проверяем
select * from Reactor_Dates;

-- заполняем таблицу данными
INSERT INTO Reactor_Dates VALUES 
(1, '1968-06-01', NULL, NULL, '1974-06-24', '1974-01-13', '1974-03-19', NULL),
(2, '1981-07-14', NULL, NULL, '2016-05-26', '2014-06-03', '2014-06-26', NULL);

-- проверяем
select * from Reactor_Dates;


-- создаем таблицу Reactor_Capacity - Мощность реактора

CREATE TABLE Reactor_Capacity (
Reactor_Capacity_ID serial PRIMARY KEY,
Reference_Unit_Power NUMERIC,
Design_Net_Capacity NUMERIC,
Gross_Capacity NUMERIC,
Thermal_Capacity NUMERIC
);

-- проверяем
select * from Reactor_Capacity;

-- заполняем таблицу данными
INSERT INTO Reactor_Capacity VALUES 
(1, 340, 319, 362, 1179),
(2, 693, 692, 745, 2160);

-- проверяем
select * from Reactor_Capacity;

-- создаем таблицу Translation - Таблица с русским переводов информации об энергоблоки, 
-- необходима для вывода данных в визуализациях

CREATE TABLE Translation_rus (
Translation_ID serial PRIMARY KEY,
Reactor_Name_Rus VARCHAR (100),
Reactor_Status_Rus VARCHAR (100),
Country_Rus VARCHAR (100),
Reactor_Location_Rus VARCHAR (100),
Owner_Rus VARCHAR (100),
Operator_Rus VARCHAR(100)
);

-- проверяем
select * from Translation_rus;

-- заполняем таблицу данными
INSERT INTO Translation_rus VALUES 
(1, 'Атуча-1', 'Действующие', 'Аргентина', 'Лима', 'Nucleoelectrica Argentina SA (NASA)'),
(2, 'Атуча-2', 'Действующие', 'Аргентина', 'Лима', 'Nucleoelectrica Argentina SA (NASA)');

-- проверяем
select * from Translation_rus;

-- создаем БАЗОВУЮ таблицу Reactors
CREATE TABLE Reactors(
Reactors_ID	serial PRIMARY KEY,
Reactor_Details_ID INTEGER references Reactor_Details (Reactor_Details_ID),
Translation_ID INTEGER references Translation_rus (Translation_ID), 
Reactor_Capacity_ID INTEGER references Reactor_Capacity (Reactor_Capacity_ID),
Reactor_Dates_ID INTEGER references Reactor_Dates (Reactor_Dates_ID), 
Location_ID INTEGER references Location (Location_ID)
);

-- проверяем
select * from Reactors;

-- заполняем таблицу данными
INSERT INTO Reactors VALUES (1,1, 1, 1, 1, 1), (2,2,2,2,2,2);

-- проверяем
select * from Reactors;



-------------------------------------------------------------------------------------
-- ЗАПРОСЫ К ТАБЛИЦАМ

-- 1. посчитать количество действующих реакторов в Аргентине

 SELECT COUNT(reactor_name)
FROM 
Location
LEFT JOIN 
Reactor_Details
    ON Reactor_Details_ID=Location_ID
WHERE 
Reactor_Status = 'Operational' and
Country = 'Argentina'
;

-- 2. посчитать количество остановленных реакторов в Аргентине

 SELECT COUNT(reactor_name)
FROM 
Location
LEFT JOIN 
Reactor_Details
    ON Reactor_Details_ID=Location_ID
WHERE 
Reactor_Status = 'Permanent Shutdown' and
Country = 'Argentina'
;

 -- 3. выбрать все реакторы мощностью больше 200 Мвт и отсортировать по названию в обратном порядке

SELECT reactor_name, Reference_Unit_Power
    FROM Reactor_Capacity
	JOIN Reactor_Details
	ON Reactor_Details_ID=Reactor_Capacity_ID
    WHERE Reference_Unit_Power > 200
	ORDER BY  reactor_name DESC
;

-- 4. вывести названия всех аргентинских энергоблоков , тип реактора, статус, 
--- город, мощность блока и дату запуска в эксплуатацию (Reference_Unit_Power )

 SELECT reactor_name, reactor_type, reactor_status, Location, Reference_Unit_Power, Commercial_Operation_Date, Country FROM
	(SELECT Reactor_Details_ID, reactor_name, reactor_type, reactor_status, Location, Reference_Unit_Power, Country 
	FROM
		(SELECT reactor_name, reactor_type, reactor_status, Location, Country, Reactor_Details_ID
		FROM Reactor_Details
		JOIN Location
		ON Reactor_Details_ID=Location_ID) as tmp
			JOIN Reactor_Capacity
			ON Reactor_Capacity.Reactor_Capacity_ID=tmp.Reactor_Details_ID) as tmp2
				JOIN Reactor_Dates
				on Reactor_Dates.Reactor_Dates_ID=tmp2.Reactor_Details_ID
	 WHERE Country = 'Argentina'
 ;
 
-- 5. посчитать сколько реакторов в Аргентине (всех типов)

SELECT COUNT (reactor_name) FROM		
	(SELECT reactor_name, country
		FROM Reactor_Details
		JOIN Location
		ON Reactor_Details_ID=Location_ID) as tmp
 	 WHERE tmp.Country = 'Argentina'
 ;
 
 -- 6. найти все реакторы мощностью 693 Мвт и отсортировать по названию энергоблока
SELECT Reference_Unit_Power, reactor_name
		FROM Reactor_Details
		JOIN Reactor_Capacity
		ON Reactor_Details_ID=Reactor_Capacity_ID
 	 WHERE Reference_Unit_Power = 693
	 ORDER BY reactor_name
 ;
 
  -- 7. посчитать среднюю мощность всех аргентинских реакторов
  SELECT  AVG (Reference_Unit_Power) as Reference_Unit_Power_AVR
		FROM Location
		JOIN Reactor_Capacity
		ON Location_ID=Reactor_Capacity_ID
 	 WHERE Country = 'Argentina'
 ;

  -- 7. посчитать среднюю мощность всех реакторов PHWR
  SELECT AVG (Reference_Unit_Power) as Reference_Unit_Power_AVR
		FROM Reactor_Capacity
		JOIN Reactor_Details
		ON Reactor_Details_ID=Reactor_Capacity_ID
 	 WHERE Reactor_Type = 'PHWR'
 ;
 
 
 -- 8 сравнить в одной таблице мощность каждого реактора со средней мощностью всех реакторов
SELECT Reference_Unit_Power, AVG (Reference_Unit_Power) OVER ()
  FROM Reactor_Capacity;


-- 9 сравнить в одной таблице сумму мощности каждого реакторов со средней мощностью реакторов 
-- (странная метрика №1)
SELECT sum(Reference_Unit_Power) OVER w, avg(Reference_Unit_Power) OVER w
  FROM Reactor_Capacity
  WINDOW w AS ();
  
  
 -- 10 разделить мощность каждого энергоблока на сумму мощностей этого энергоблока 
 --(странная метрика №2)
SELECT Reactor_Capacity_ID, Reference_Unit_Power / SUM(Reference_Unit_Power ) 
OVER (PARTITION BY Reactor_Capacity_ID) as strange_Power_metric
FROM Reactor_Capacity
ORDER BY Reactor_Capacity_ID;
