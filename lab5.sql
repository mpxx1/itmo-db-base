-- 1 Найти среднее количество покупок на чек для каждого покупателя

select CustomerID, avg(prodCount) avg_cnt from (
    select CustomerID, count(ProductID) prodCount
    from sales.SalesOrderDetail sod
    join Sales.SalesOrderHeader SOH
        on SOH.SalesOrderID = sod.SalesOrderID
    group by CustomerID
) tab1
group by CustomerID;



-- 2 Найти для каждого продукта и каждого покупателя соотношение
-- количества
-- фактов покупки данного товара данным покупателем к общему количеству
-- фактов покупки товаров данным покупателем


select table1.CustomerID, table1.ProductID, table1.cnt, table2.cnt, cast(table1.cnt as float) / cast(table2.cnt as float) from (
    select CustomerID, ProductID, count(sod.SalesOrderID) as cnt
    from Sales.SalesOrderDetail sod
    join Sales.SalesOrderHeader SOH
        on SOH.SalesOrderID = sod.SalesOrderID
    group by CustomerID, ProductID
              ) table1,
             (
                 select CustomerID, count(ProductID) cnt
                 from Sales.SalesOrderDetail sod
                 join Sales.SalesOrderHeader soh
                 on sod.SalesOrderID = soh.SalesOrderID
                 group by CustomerID
             ) table2
where table1.CustomerID = table2.CustomerID
order by CustomerID;



-- 3 Вывести на экран следящую информацию: Название продукта, Общее
-- количество фактов покупки этого продукта, Общее количество покупателей
-- этого продукта


select tab1.ProductID, tab1.cnt, tab2.cnt from (
    select ProductID, count(*) cnt
    from Sales.SalesOrderDetail sod
    group by ProductID
              ) tab1,
    (
        select ProductID, count(distinct CustomerID) cnt
        from Sales.SalesOrderDetail sod
        join Sales.SalesOrderHeader soh
        on sod.SalesOrderID = soh.SalesOrderID
        group by ProductID
    ) tab2
where tab1.ProductID = tab2.ProductID;



-- 4 Вывести для каждого покупателя информацию о максимальной и минимальной
-- стоимости одной покупки, чеке, в виде таблицы: номер покупателя,
-- максимальная сумма, минимальная сумма.



select * from (
    select CustomerID, soh.SalesOrderID, max(ListPrice) max, min(ListPrice) min
    from Sales.SalesOrderHeader soh
    join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    join Production.Product p
    on sod.ProductID = p.ProductID
    group by CustomerID, soh.SalesOrderID
              ) tab1;


-- 5 Найти номера покупателей, у которых не было нет ни одной пары чеков с
-- одинаковым количеством наименований товаров.


select CustomerID from
(
    select CustomerID, soh.SalesOrderID, count(distinct ProductID) cnt
    from sales.SalesOrderHeader soh
    join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    group by CustomerID, soh.SalesOrderID
) tab1
group by CustomerID
having sum(cnt) = sum(distinct cnt);


-- 6 Найти номера покупателей, у которых все купленные ими товары были
-- куплены как минимум дважды, т.е. на два разных чека.


select CustomerID from
(
    select CustomerID, count(ProductID) cnt
    from Sales.SalesOrderHeader soh
    join Sales.SalesOrderDetail SOD
        on soh.SalesOrderID = SOD.SalesOrderID
    group by CustomerID, ProductID
) tab1
group by CustomerID
having max(cnt) = 2 and min(cnt) = 2;










-- найте для каждого покупателя кол-во чеков, где присутствуют товары минимум из 2х подкатегорий товаров


select CustomerID, count(SalesOrderID) cnt from (
    select CustomerID, SOD.SalesOrderID
    from Sales.SalesOrderHeader soh
    join Sales.SalesOrderDetail SOD
        on soh.SalesOrderID = SOD.SalesOrderID
    join Production.Product p
        on SOD.ProductID = p.ProductID
    group by CustomerID, SOD.SalesOrderID
    having count(ProductSubcategoryID) >= 2
) tab1
group by CustomerID;
