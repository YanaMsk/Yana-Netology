

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
