/* 1 Найти и вывести на экран названия продуктов, их цвет и размер. */

select Name, Color, Size
from Production.Product;

/* 2 Найти и вывести на экран названия,
     цвет и размер таких продуктов, у которых
     цена более 100 */

select Name, Color, Size
from Production.Product
where ListPrice > 100;

/* 3 Найти и вывести на экран название,
     цвет и размер таких продуктов, у которых
     цена менее 100 и цвет Black. */

select Name, Color, Size
from Production.Product
where ListPrice < 100
and Color = 'Black';

-- 4 Найти и вывести на экран название, цвет и размер таких продуктов, у которых
-- цена менее 100 и цвет Black, упорядочив вывод по возрастанию стоимости
-- продуктов.

select Name, Color, Size
from Production.Product
where ListPrice < 100
and Color = 'Black'
order by ListPrice;

-- 5 Найти и вывести на экран название и
--   размер первых трех самых дорогих
--   товаров с цветом Black.

select top 3 Name, Size
from Production.Product
where Color = 'Black'
order by ListPrice desc;

-- 6 Найти и вывести на экран название и
--   цвет таких продуктов, для которых
--   определен и цвет, и размер.

select Name, Color
from Production.Product
where Color is not null
and Size is not null;

-- 7 Найти и вывести на экран не повторяющиеся цвета продуктов,
--   у которых цена
--   находится в диапазоне от 10 до 50 включительно.

select distinct Color
from Production.Product
where ListPrice >= 10 and ListPrice <= 50;

-- 8 Найти и вывести на экран все цвета таких продуктов,
--   у которых в имени первая буква ‘L’ и третья ‘N’.

select Color
from Production.Product
where Name like 'L_N%';

-- 9 Найти и вывести на экран названия таких продуктов, которых начинаются
--   либо на букву ‘D’, либо на букву ‘M’, и при этом длина имени – более трех
--   символов.

select Name
from Production.Product
where Name like '[DM]%'
and len(Name) > 3;

-- 10 Вывести на экран названия продуктов, у которых дата начала продаж – не
--    позднее 2012 года.

select Name
from Production.Product
where datepart(year, SellStartDate) <= 2012;

-- 11 Найти и вывести на экран названия всех подкатегорий товаров.

select Name
from Production.ProductSubcategory;

-- 12 Найти и вывести на экран названия всех категорий товаров.

select Name
from Production.ProductCategory;

-- 13 Найти и вывести на экран имена всех клиентов из таблицы Person,
--    у которых обращение (Title) указано как «Mr.».

select FirstName
from Person.Person
where Title = 'Mr.';

-- 14 Найти и вывести на экран имена всех клиентов из таблицы Person,
--    для которых не определено обращение (Title).
select FirstName
from Person.Person
where Title is null;
