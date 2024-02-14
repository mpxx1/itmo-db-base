/* lab2 */

/* 1 Найти и вывести на экран количество товаров каждого цвета,
   исключив из поиска товары, цена которых меньше 30.
*/
select Color, count(Color) as Count
from Production.Product
where ListPrice < 30 and Color is not null
group by Color;

/* 2 Найти и вывести на экран список, состоящий из цветов товаров, таких,
   что минимальная цена товара данного цвета более 100.
*/
select Color
from Production.Product
where Color is not null
group by Color
having min(ListPrice) > 100;

/* 3 Найти и вывести на экран номера подкатегорий товаров и количество товаров в каждой категории.
*/
select ProductSubcategoryID, count(ProductSubcategoryID) as Count
from Production.Product
where ProductSubcategoryID is not null
group by ProductSubcategoryID;

/* 4 Найти и вывести на экран номера товаров и количество фактов продаж данного
   товара (используется таблица SalesORDERDetail).
*/
select ProductID, count(*) as Count
from Sales.SalesOrderDetail
group by ProductID;


/* 5 Найти и вывести на экран номера товаров, которые были куплены более пяти раз. */
select ProductID
from Sales.SalesOrderDetail
group by ProductID
having count(*) > 5;

/* 6 Найти и вывести на экран номера покупателей, CustomerID,
   у которых существует более одного чека, SalesORDERID, с одинаковой датой */
select CustomerID
from Sales.SalesOrderHeader
group by CustomerID, OrderDate
having count(*) > 1;


/* 7  Найти и вывести на экран все номера чеков, на которые приходится более трех продуктов. */
select SalesOrderID
from Sales.SalesOrderDetail
group by SalesOrderID
having count(distinct ProductID) > 3;

/* 8 Найти и вывести на экран все номера продуктов, которые были куплены более трех раз.
 */
select ProductID
from Sales.SalesOrderDetail
group by ProductID
having count(*) > 3;


/* 9 Найти и вывести на экран все номера продуктов, которые были куплены или
три или пять раз. */
select ProductID
from Sales.SalesOrderDetail
group by ProductID
having count(*) = 3
    or count(*) = 5;

/* 10 Найти и вывести на экран все номера подкатегорий, в которым относится
более десяти товаров. */
select ProductSubcategoryID
from Production.Product
group by ProductSubcategoryID
having count(*) > 10;

/* 11 Найти и вывести на экран номера товаров, которые всегда покупались в одном экземпляре за одну покупку.
 */
select ProductID
from sales.salesOrderDetail
group by ProductID
having count(*) = sum(OrderQty);

/* 12 Найти и вывести на экран номер чека, SalesORDERID,
   на который приходится с наибольшим разнообразием товаров купленных на этот чек. */
select top 1 SalesOrderID
from sales.SalesOrderDetail
group by SalesOrderID
order by count(distinct ProductID) desc;

/* 13 Найти и вывести на экран номер чека, SalesORDERID с наибольшей суммой покупки,
   исходя из того, что цена товара – это UnitPrice, а количество конкретного товара в чеке – это ORDERQty.
   */
select top 1 SalesOrderID
from sales.SalesOrderDetail
group by SalesOrderID
order by sum(UnitPrice * OrderQty) desc;

/* 14 Определить количество товаров в каждой подкатегории, исключая товары,
   для которых подкатегория не определена, и товары, у которых не определен цвет. */
select ProductSubcategoryID, count(*) as Count
from Production.Product
where ProductSubcategoryID is not null and
      Color is not null
group by ProductSubcategoryID;

/* 15 Получить список цветов товаров в порядке убывания количества товаров данного цвета */
select Color
from production.Product
group by Color
order by count(*) desc;

/* 16 Вывести на экран ProductID тех товаров, что всегда покупались в количестве более 1 единицы
   на один чек, при этом таких покупок было более двух. */
select ProductID
from sales.SalesOrderDetail
group by ProductID
having min(OrderQty) > 1 and count(SalesOrderID) > 2;
