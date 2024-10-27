--EJERCICIO 1
create table Almacen(Nro int primary key, Responsable varchar(50))
create table Articulo(CodArt int primary key, Descripcion varchar(50), Precio
decimal(12, 3))
create table Material(CodMat int primary key, Descripcion varchar(50))
create table Proveedor(CodProv int primary key, Nombre varchar(50), Domicilio
varchar(50), Ciudad varchar(50))
create table Tiene(Nro int, CodArt int)
create table Compuesto_Por(CodArt int, CodMat int)
create table Provisto_Por(CodMat int, CodProv int)

--Insercion de datos: 

insert into Almacen values
(1, 'Juan Perez'),
(2, 'Jose Basualdo'),
(3, 'Rogelio Rodriguez')
insert into Articulo values
(1, 'Sandwich JyQ', 5),
(2, 'Pancho', 6),
(3, 'Hamburguesa', 10),
(4, 'Hamburguesa completa', 15)
insert into Material values
(1, 'Pan'),
(2, 'Jamon'),
(3, 'Queso'),
(4, 'Salchicha'),
(5, 'Pan Pancho'),
(6, 'Paty'),
(7, 'Lechuga'),
(8, 'Tomate')
insert into Proveedor values
(1, 'Panadería Carlitos', 'Carlos Calvo 1212', 'CABA'),
(2, 'Fiambres Perez', 'San Martin 121', 'Pergamino'),
(3, 'Almacen San Pedrito', 'San Pedrito 1244', 'CABA'),
(4, 'Carnicería Boedo', 'Av. Boedo 3232', 'CABA'),
(5, 'Verdulería Platense', '5 3232', 'La Plata')
insert into Tiene values
--Juan Perez
(1, 1),
--Jose Basualdo
(2, 1),
(2, 2),
(2, 3),
(2, 4),
--Rogelio Rodriguez
(3, 3),
(3, 4)
insert into Compuesto_Por values
--Sandwich JyQ
(1, 1), (1, 2), (1, 3),
--Pancho
(2, 4), (2, 5),
--Hamburguesa
(3, 1), (3, 6),
--Hamburguesa completa
(4, 1), (4, 6), (4, 7), (4, 8)
insert into Provisto_Por values
--Pan
(1, 1), (1, 3),
--Jamon
(2, 2), (2, 3), (2, 4),
--Queso
(3, 2), (3, 3),
--Salchicha
(4, 3), (4, 4),
--Pan Pancho
(5, 1), (5, 3),
--Paty
(6, 3), (6, 4),
--Lechuga
(7, 3), (7, 5),
--Tomate
(8, 3), (8, 5)
GO

--RESOLUCION DE CONSIGNAS: 
--1. Listar los nombres de los proveedores de la ciudad de La Plata1. Listar los nombres de los proveedores de la ciudad de La Plata

SELECT Nombre 
from Proveedor
where ciudad like 'La Plata' 

--2. Listar los números de artículos cuyo precio sea inferior a $10.
select descripcion 
from Articulo
where precio < 10

--3. Listar los responsables de los almacenes.
select responsable
from Almacen

--4. Listar los códigos de los materiales que provea el proveedor 3 y no los provea el proveedor 5 
--(lo modifique para poder hacerlo con los datos que tengo )

select CodMat  
from Provisto_Por
where CodProv = 3 and CodMat not in (Select CodMat from Provisto_Por where CodProv = 5)

--otra solucion:
select CodMat  
from Provisto_Por
where CodProv = 3 EXCEPT
(Select CodMat from Provisto_Por where CodProv = 5)

--otra solucion: (tiene mejor performans)
select pp.CodMat  
from Provisto_Por pp
where pp.CodProv = 3 and  not exists 
                          (Select 1 from Provisto_Por ppp where ppp.CodProv = 5 and pp.CodMat = ppp.CodMat)


--5. Listar los números de almacenes que almacenan el artículo 1.

select nro
from Tiene
where CodArt = 1

--6. Listar los proveedores de Pergamino que se llamen Pérez

Select * 
from Proveedor
where nombre like '%Perez%' and ciudad = 'pergamino'

--7. Listar los almacenes que contienen los artículos 1 y los artículos 2 (ambos)

Select t1.nro 
from tiene t1
where t1.codArt = 1 and exists (select 1 from tiene t2 where t2.codArt = 2 and  t2.nro = t1.nro)

--otra solucion:
select tt.nro
	from tiene tt
	where tt.CodArt = 1 
INTERSECT
select ttt.nro 
	from tiene ttt
	where ttt.CodArt = 2

--otra solucion:
select t1.nro
from tiene t1,tiene t2
where t1.Nro = t2.Nro and t1.CodArt = 1 and t2.CodArt = 2
 
--otra solucion: 
SELECT Nro
FROM Tiene
WHERE CodArt = 1 AND Nro IN (SELECT Nro FROM Tiene WHERE CodArt = 2)

--8. Listar los artículos que cuesten más de $100 o que estén compuestos por el material 1.

select c.CodArt
from Compuesto_Por c
where  c.CodMat = 1 or exists (select 1 from Articulo A where a.precio > 100 and c.CodArt = a.CodArt)

--otra solucion:

SELECT A.CodArt
FROM Articulo A JOIN Compuesto_por C ON A.CodArt = C.CodArt
WHERE A.Precio>100 and C.CodMat = 1

--otra solucion:
select a.codArt
from articulo a 
where a.precio > 100 
UNION
select cp.CodArt 
from Compuesto_Por cp 
where cp.CodMat = 1

--9. Listar los materiales, código y descripción, provistos por proveedores de la ciudad de la plata.
select distinct m.descripcion, m.codMat, p.Nombre
from Material m
   inner join Provisto_Por pp on m.CodMat = pp.CodMat 
   inner join Proveedor p on p.CodProv = pp.CodProv 
where p.ciudad = 'la plata'

--10. Listar el código, descripción y precio de los artículos que se almacenan en 1.
select distinct art.CodArt, art.Descripcion, art.Precio
from Articulo art 
   inner join Tiene t on art.CodArt = t.CodArt
where t.Nro = 1

--11. Listar la descripción de los materiales que componen el artículo 2.
select m.Descripcion
from Material m
where exists (select 1 from Compuesto_Por cp where cp.CodMat = m.CodMat and cp.CodArt = 2)

--12. Listar los nombres de los proveedores que proveen los materiales al almacén que Martín Gómez tiene a su cargo.
select p.Nombre
from Proveedor p
where   p.CodProv IN (select pp.CodProv from Provisto_Por pp, Almacen a,Tiene t, Compuesto_Por cp
                     where a.Responsable = 'Juan Perez' and a.Nro = t.Nro and t.CodArt = cp.CodArt and cp.CodMat = Pp.CodMat)
					 order by p.Nombre 

--otra solucion 
select distinct p.Nombre
from Proveedor p
  inner join Provisto_Por pp  on pp.CodProv = p.CodProv
  inner join Compuesto_Por cp on cp.CodMat = pp.CodMat
  inner join Tiene t          on t.CodArt = cp.CodArt
  inner join Almacen a        on a.Nro = t.Nro
where a.Responsable = 'Juan Perez'
order by p.Nombre 

--13. Listar códigos y descripciones de los artículos compuestos por al menos un material provisto por el proveedor Perez.
--esta mal:
select distinct a.CodArt, a.Descripcion
from Articulo a
  inner join Compuesto_Por cp   on cp.CodArt = a.CodArt
  inner join Provisto_Por pp    on cp.CodMat = pp.CodMat
  inner join Proveedor p        on p.CodProv = pp.CodProv
  inner join Tiene t            on t.CodArt = cp.CodArt
  inner join Almacen alm        on alm.Nro = t.Nro
where  p.Nombre= '%Carlitos'

--14. Hallar los códigos y nombres de los proveedores que proveen al menos un material que se usa en algún artículo cuyo precio es mayor a $100.

select distinct p.codProv,p.nombre 
from proveedor p
	inner  join Provisto_Por  pp   on pp.codProv = p.codProv 
	inner  join material  m        on m.codMat = pp.codMat 
	inner  join Compuesto_Por  cp  on cp.codMat = m.codMat 
	inner  join articulo  a        on a.codArt = cp.codArt 
where a.precio > 100

--15.1 Listar los números de almacenes que tienen todos los artículos

select COUNT(*) as [cantidad total de articulos]
from articulo

select t.nro, count(t.CodArt)  as [cantidad de articulos que tiene el almacen]
from tiene t
group by t.nro 
having count (t.codart) = (select count (*) from Articulo) 

--15.2 Listar los números de almacenes que tienen todos los artículos que incluyen el material con código 1.
--cantidad de articulos: 
select count(*) as [cantidad de articulos con mat 1]
from articulo a
  join compuesto_por cp on a.codart = cp.codart
  where cp.codmat = 1



--16. Listar los proveedores de Capital Federal que sean únicos proveedores de algún material.



--17. Listar el/los artículo/s de mayor precio.

select a1.* 
from articulo a1
where a1.precio >= all (select a2.precio from articulo a2)
order by precio desc 

--18. Listar el/los artículo/s de menor precio.

select a1.* 
from articulo a1
where a1.precio <= all (select a2.precio from articulo a2)
order by precio desc 

--otra solucion:
select a.codArt 
from articulo a 
where a.codart not IN(
	select  a1.CodArt
	from articulo a1,articulo a2 
	where a1.precio > a2.precio 
	)

--19. Listar el promedio de precios de los artículos en cada almacén.
--20. Listar los almacenes que almacenan la mayor cantidad de artículos.
--21. Listar los artículos compuestos por al menos 2 materiales.
--22. Listar los artículos compuestos por exactamente 2 materiales.
--23. Listar los artículos que estén compuestos con hasta 2 materiales.
--24. Listar los artículos compuestos por todos los materiales.
--25. Listar las ciudades donde existan proveedores que provean todos los materiales.



