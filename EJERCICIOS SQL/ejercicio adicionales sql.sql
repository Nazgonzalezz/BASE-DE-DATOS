-- ELIMINO LA BASE DE DATOS SI EXISTE
DROP DATABASE IF EXISTS dbsql1;
GO

-- CREO LA BASE DE DATOS
create database dbsql1
go

-- USO LA BASE DE DATOS
use dbsql1
go

-- ELIMINO LAS TABLAS SI EXISTEN 
DROP TABLE IF EXISTS tabla4;
GO
DROP TABLE IF EXISTS tabla3;
GO
DROP TABLE IF EXISTS tabla2;
GO
DROP TABLE IF EXISTS tabla1;
GO

-- CREO LAS  TABLAS 
create table tabla1 (c1 int not null primary key, c2 varchar(20) null)
GO
create table tabla2 (c1 int not null primary key, c2 varchar(50) null)
GO
create table tabla3 (c3 int not null primary key, c1 int null foreign key
references tabla1(c1))
GO
create table tabla4 (c4 smallint not null primary key, c5 varchar(5) not null)
GO

-- INSERTO DATOS EN LAS TABLAS
insert into tabla1 values(1,'a')
insert into tabla1 values(2,'b')
insert into tabla1 values(3,'c')
insert into tabla1 values(4,'c')
insert into tabla2 values (2,'b')
insert into tabla4 values (1,'1')
insert into tabla4 values (2,'2')


--==========================================================================================================
-- 1) Ejecuta la siguiente sentencia:
--==========================================================================================================
select count(1) 
   from tabla1
GO
-- ¿Qué realizó el count(1)? 
-- conto la cantidad de filas que tenia la tabla.El 1 es simplemente un valor constante y no afecta el resultado; 
-- se podría usar cualquier otro número o expresión constante.

-- ¿Existe alguna diferencia con count(*)? 
-- nop
select count(*) 
   from tabla1
GO

-- ¿Existe alguna diferencia con haber usado count(c1)? ¿Sería correcto utilizar count(distinct c1)?
-- Si. count(c1) cuenta el número de filas donde la columna c1 no es NULL. Si c1 contiene valores NULL,
-- esas filas no se contarán. En cambio, count(1) y count(*) cuentan todas las filas, independientemente
-- de si contienen valores NULL.

select count(c1) 
   from tabla1
GO

-- count(distinct c1) cuenta el número de valores distintos en la columna c1. Es útil cuando quieres saber 
-- cuántos valores únicos hay en una columna específica. Este uso es correcto si tu objetivo es contar 
-- valores únicos en c1.
select count(distinct c1) 
   from tabla1
GO

--=========================================================================================================
-- 2) Ejecuta la siguiente sentencia:
--=========================================================================================================
(SELECT DISTINCT 'Juan' AS Nombre, 'Perez' as Apellido)
UNION ALL
(SELECT DISTINCT 'Juan' AS Nombre, 'Perez' as Apellido) 
GO

-- ¿Cuántas filas devolvió? ¿Cómo debería realizar para filtrar duplicados? 
-- la consulta devolvio dos filas 
-- UNION ALL no elimina duplicados; simplemente combina los resultados de ambas consultas, 
-- incluyendo todas las filas.
-- para que no aparezcan duplicados deberia usarse: 
(SELECT DISTINCT 'Juan' AS Nombre, 'Perez' AS Apellido)
UNION
(SELECT DISTINCT 'Juan' AS Nombre, 'Perez' AS Apellido);
GO

--¿Qué sucede cuando las columnas no tienen alias?
SELECT 'Juan', 'Perez';
GO

--==========================================================================================================
-- 3) Ejecuta la siguiente sentencia:
--==========================================================================================================
insert into tabla3 values(1,null);
go

--¿Se pudo ejecutar? ¿Qué conclusión podemos tomar de los nulos en las constraints?
--si 
--Constraints de Clave Foránea: Si una columna que es clave foránea permite NULL, entonces se pueden insertar
--valores NULL en esa columna sin que se verifique la existencia del valor en la tabla referenciada.

--==========================================================================================================
-- 4) Ejecuta la siguiente sentencia:
--==========================================================================================================
select * from tabla1,tabla2
go
--¿Qué operación realizó entre tabla1 y tabla2? ¿Cómo se llaman las columnas del listado?
--==========================================================================================================
--5) Ejecuta la siguiente sentencia:
--==========================================================================================================
select * 
from tabla1,tabla4 
where tabla1.c1 = tabla4.c4
go

--¿Se pudo ejecutar la sentencia? ¿Qué tipo de conversión se ha realizado?
-- se pudo ejecutar correctamente la consulta, aunque los datos no esten definidos del mismo tipo 
-- se conviertieron los datos automaticamente


--==========================================================================================================
-- 6) Ejecuta la siguiente sentencia:
--==========================================================================================================
select * 
from tabla1,tabla4
where tabla1.c1=tabla4.c5
go
--¿Se pudo ejecutar la sentencia? ¿Qué tipo de conversión se ha realizado?

--==========================================================================================================
--8) Ejecuta la siguiente sentencia:
--==========================================================================================================
create trigger tg1 on tabla1,tabla2 
after insert
as 
	insert into tabla1 
	select c1*10, 'tg-' + c2 
	from inserted
end
go

--¿Se pudo crear? ¿Por qué? ¿Qué debería realizar para corregirlo?
--no. Sintaxis Incorrecta para Múltiples Tablas: En SQL Server, los triggers no pueden ser definidos para 
--múltiples tablas a la vez. Un trigger solo puede estar asociado a una tabla.

--Referencia a la Tabla inserted: La tabla inserted es una tabla lógica que contiene las filas insertadas 
--en la tabla que dispara el trigger. Esta tabla solo está disponible en el contexto de un trigger y no 
--puede ser referenciada fuera de él.

CREATE TRIGGER tgg1 ON tabla1
AFTER INSERT
AS
BEGIN
    INSERT INTO tabla1 (c1, c2)
    SELECT c1 * 10, 'tg-' + c2
    FROM inserted;
END
go

CREATE TRIGGER tg2 ON tabla2
AFTER INSERT
AS
BEGIN
    INSERT INTO tabla1 (c1, c2)
    SELECT c1 * 10, 'tg-' + c2
    FROM inserted;
END;
go

--==========================================================================================================
-- 9) Ejecuta la siguiente sentencia:
--==========================================================================================================
create trigger tg3 on tabla1 
after select
as 
	insert into tabla1 
	select c1*10, 'tg-' + c2 
	from inserted
end
go
--¿Se pudo crear? ¿Por qué? 
-- los trigger solo se disparan con el insert, delete o el uptade, no con el select


--==========================================================================================================
--10) Triggers recursivos: Realizar la siguiente creación de triggers sobre las tablas tabla1 y
--tabla2. Observar que el trigger de la tabla1 llama implícitamente al trigger de la tabla2.
--==========================================================================================================

create or alter trigger tg1_tabla1 on tabla1 
instead of insert
as
begin
	declare @val1 int, @val2 varchar(20)
	select @val1=c1, @val2=c2 from inserted
	insert into tabla2 values (@val1, @val2)
end
go

create or alter trigger tg1_tabla2 on tabla2 
instead of insert
as
begin
	declare @val1 int, @val2 varchar(20)
	select @val1=c1, @val2=c2 from inserted
	insert into tabla2 values (@val1, @val2 + 'xxxxx')
end
	select * from tabla1
	select * from tabla2
	insert into tabla1 values (4,'d')
go
--¿Qué sucedió al ejecutarse un trigger que posee una tabla con otro trigger?
--¿Podemos decir que un trigger puede llamar a otro trigger implícitamente?
--Sí, un trigger puede llamar a otro trigger implícitamente.


--==========================================================================================================
--11) Triggers cíclicos: Realizar la siguiente creación de triggers sobre las tablas tabla1 y tabla2.
--En este caso, se observa que existe un ciclo entre las llamadas a triggers, ya que tg1 llama a
--tabla2 y tg2 llama a tabla1.
--==========================================================================================================

create or alter trigger tg1_tabla1 on tabla1 instead of insert
as
begin
declare @val1 int, @val2 varchar(20)
select @val1=c1, @val2=c2 from inserted
insert into tabla2 values (@val1, @val2)
end
go

create or alter trigger tg1_tabla2 on tabla2 instead of insert
as
begin
declare @val1 int, @val2 varchar(20)
select @val1=c1, @val2=c2 from inserted
insert into tabla1 values (@val1, @val2 + 'x')
end
go

select * from tabla1
go
select * from tabla2
go
insert into tabla1 values (4,'d')
go
--¿Qué sucedió al ejecutarse un trigger que posee una tabla con otro trigger en forma cíclica?
--¿Podemos decir que es posible realizar ciclos a través de los triggers o provoca algún error?
--Cuando se crean triggers cíclicos, como en tu ejemplo, se puede provocar un ciclo infinito de llamadas 
--entre los triggers, lo que generalmente resulta en un error o en la interrupción de la ejecución debido 
--a la detección de recursión excesiva por parte del sistema de base de datos.

--==========================================================================================================
--12) Ejecuta la siguiente sentencia:
--==========================================================================================================

create view vista1
as
select c1 from tabla1 order by 1

--¿Se pudo crear? ¿Por qué? ¿Qué debería realizar para corregirlo? Realiza las correcciones
--necesarias
--las vistas en SQL Server no pueden contener cláusulas ORDER BY a menos que también incluyan una cláusula TOP

create view vista1
as
	select top 100 c1 
	from tabla1 
	order by 1

--o tambien:

CREATE VIEW vista1
AS
	sELECT TOP 100 PERCENT c1
	FROM tabla1
	ORDER BY c1;
--TOP 100 PERCENT selecciona todas las filas: especifico el el porcentaje de filas que voy a traer es el 100%


--==========================================================================================================
--13) Ejecuta la siguiente sentencia:
--==========================================================================================================

create view vista2
as
	insert into tabla2 values (2,'b')
--¿Se puede crear una vista con una sentencia de Insert? ¿Qué sentencias pueden existir en una vista?
-- no se puedee

--==========================================================================================================
--14) Ejecuta la siguiente sentencia:
--==========================================================================================================

create view vista222 
as 
	select count(*) 
	from tabla2
go
--¿Se pudo crear? ¿Por qué? ¿Qué debería realizar para corregirlo? Realiza las acciones 
--nop
create view vista222 
as 
	select count(*) as columna
	from tabla2
go
--ahora si 
--==========================================================================================================
--15) Ejecuta la siguiente sentencia:
--==========================================================================================================

create view vista3
as
	select * 
	from tabla1,tabla2
	where tabla1.c1 = tabla2.c1
go

--¿Se pudo crear? ¿Por qué? ¿Qué debería realizar para corregirlo?--nop, no se puede repetir nombre de columnas 

create view vista3
as
	select  tabla1.c1 as c11, tabla1.c2 as c12, tabla2.c1 as c21,tabla2.c2 as c22
	from tabla1,tabla2
	where tabla1.c1 = tabla2.c1
go


--==========================================================================================================
--16)Ejecuta la siguiente sentencia:
--==========================================================================================================
create view vista4
as
	select * 
	from tabla1
go

--Verificamos qué datos tien
--Intentamos actualizar la vista:

update vista4 set c1=c1*10 where c1=1
go
--¿Se pudo realizar?
--Cambiamos la vista:
alter view vista4
as
select top 10 * from tabla1 order by c1

--Intentamos actualizar la vista:
update vista4 set c1=c1*10 where c1=1

-- ¿Se pudo realizar?
--Cambiamos la vista:
alter view vista4
as
	select tabla1.*,tabla2.c1 as t2c1, tabla2.c2 t2c2 
	from tabla1,tabla2
	where tabla1.c1=tabla2.c1

--Intentamos actualizar la vista:
update vista4 set c1=c1*10 where c1=2

--¿Se pudo realizar? ¿Cuándo una vista es actualizable?
--Una vista es actualizable cuando cumple con los siguientes criterios:
	--Está basada en una sola tabla.
	--No contiene funciones de agregación (COUNT, SUM, etc.), GROUP BY, DISTINCT, o TOP.
	--No contiene subconsultas complejas.
	--No contiene uniones (JOIN) complejas.
	--Incluye la clave primaria de la tabla subyacente.

--==========================================================================================================
--17)Ejecuta la siguiente sentencia:
--==========================================================================================================
create function function1()
returns int
as
begin
	update tabla1 set c1=c1*10
	return (select count(*) from tabla1)
end
go

--¿Se pudo crear? ¿Qué tipo de sentencias permiten las funciones?
--las funciones en SQL Server tienen restricciones sobre el tipo de sentencias que pueden contener. En particular,
--las funciones no pueden contener sentencias que modifiquen el estado de la base de datos, como UPDATE, INSERT, 
--DELETE, o MERGE.







