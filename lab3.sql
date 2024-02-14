-- 1 Найти и вывести на экран название продуктов и название категорий товаров, к
-- которым относится этот продукт, с учетом того, что в выборку попадут только
-- товары с цветом Red и ценой не менее 100.
select p.Name, c.Name
from Production.Product p
join Production.ProductSubcategory s
on p.ProductSubcategoryID = s.ProductSubcategoryID
join Production.ProductCategory c
on s.ProductCategoryID = c.ProductCategoryID
where Color like 'Red' and ListPrice >= 100;


-- 2 Вывести на экран названия подкатегорий с совпадающими именами.
select c.Name
from Production.ProductSubcategory c
group by c.Name
having count(*) > 1;


-- 3 Вывести на экран название категорий и количество товаров в данной
-- категории.
select c.Name, count(distinct ProductID) Count
from Production.Product
join Production.ProductSubcategory
on Product.ProductSubcategoryID = ProductSubcategory.ProductSubcategoryID
join Production.ProductCategory c
on ProductSubcategory.ProductCategoryID = c.ProductCategoryID
group by c.Name;


-- 4 Вывести на экран название подкатегории, а также количество товаров в данной
-- подкатегории с учетом ситуации, что могут существовать подкатегории с
-- одинаковыми именами.
select s.Name, count(distinct ProductID) Count
from Production.Product
join Production.ProductSubcategory s
on Product.ProductSubcategoryID = s.ProductSubcategoryID
group by s.Name;


-- 5 Вывести на экран название первых трех подкатегорий с наибольшим
-- количеством товаров.
select top 3 s.name
from Production.ProductSubcategory s
join Production.Product P
on s.ProductSubcategoryID = P.ProductSubcategoryID
group by s.name
order by count(distinct productID) desc;


-- 6 Вывести на экран название подкатегории и максимальную цену продукта с
-- цветом Red в этой подкатегории.
select sc.Name, max(ListPrice)
from Production.ProductSubcategory sc
join Production.Product P
on sc.ProductSubcategoryID = P.ProductSubcategoryID
where Color like 'Red'
group by sc.Name;


-- 7 Вывести на экран название поставщика и количество товаров, которые он
-- поставляет.
select v.Name, count(distinct p.productId)
from Production.Product p
join Purchasing.ProductVendor
on p.ProductID = ProductVendor.ProductID
join Purchasing.Vendor v
on ProductVendor.BusinessEntityID = v.BusinessEntityID
group by v.Name;


-- 8 Вывести на экран название товаров, которые поставляются более чем одним
-- поставщиком.
select p.Name
from Production.Product p
join Purchasing.ProductVendor v
on p.ProductID = v.ProductID
group by p.Name
having count(distinct BusinessEntityID) > 1;


-- 9 Вывести на экран название самого продаваемого товара.
select top 1 p.Name
from Production.Product p
join Sales.SalesOrderDetail s
on p.ProductID = s.ProductID
group by p.Name
order by count(distinct s.ProductID) desc;



-- 10 Вывести на экран название категории, товары из которой продаются наиболее
-- активно.
select top 1 c.Name
from Production.Product
join Production.ProductSubcategory
on Product.ProductSubcategoryID = ProductSubcategory.ProductSubcategoryID
join Production.ProductCategory c
on ProductSubcategory.ProductCategoryID = c.ProductCategoryID
group by c.Name
order by count(distinct ProductID) desc;


-- 11 Вывести на экран названия категорий, количество подкатегорий и количество
-- товаров в них.
select c.name, count(distinct s.name), count(distinct p.ProductID)
from Production.Product p
join Production.ProductSubcategory s
on p.ProductSubcategoryID = s.ProductSubcategoryID
join Production.ProductCategory c
on s.ProductCategoryID = c.ProductCategoryID
group by c.name;


-- 12 Вывести на экран номер кредитного рейтинга и количество товаров,
-- поставляемых компаниями, имеющими этот кредитный рейтинг.
select CreditRating, count(distinct pv.ProductID)
from Purchasing.ProductVendor pv
join Purchasing.Vendor V on V.BusinessEntityID = pv.BusinessEntityID
group by CreditRating;
