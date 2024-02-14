-- 1 Найти название самого продаваемого продукта.

select p.Name
from Production.Product p
where p.ProductID = (
    select top 1 ProductID
    from sales.SalesOrderDetail sod
    join sales.SalesOrderHeader
    on sod.SalesOrderID = SalesOrderHeader.SalesOrderID
    group by ProductID
    order by count(*) desc
    );


-- 2 Найти покупателя,
-- совершившего покупку на самую большую сумм,
-- считая сумму покупки исходя из цены товара без скидки (UnitPrice).

select distinct CustomerID
from Sales.SalesOrderHeader soh
where CustomerID = (
    select top 1 CustomerID
    from Sales.SalesOrderHeader soh
    join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    group by CustomerID
    order by sum(UnitPrice) desc
    );


-- 3 Найти такие продукты, которые покупал только один покупатель.

select ProductID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
group by ProductID
having count(distinct CustomerID) = 1;



-- 4 Вывести список продуктов, цена которых выше средней цены товаров в
-- подкатегории, к которой относится товар.

select p.ProductID
from Production.Product p
join (
    select avg(ListPrice) avg, ProductSubcategoryID
    from Production.Product
    group by ProductSubcategoryID
    ) st
on p.ProductSubcategoryID = st.ProductSubcategoryID
where p.ListPrice > st.avg;


-- 5 Найти такие товары, которые были куплены более чем одним покупателем,
-- при
-- этом все покупатели этих товаров покупали товары только одного цвета и
-- товары
-- не входят в список покупок покупателей, купивших товары только двух цветов.

select distinct p.ProductID
from Production.Product p
join Sales.SalesOrderDetail sod
on p.ProductID = sod.ProductID
join Sales.SalesOrderHeader soh
on sod.SalesOrderID = soh.SalesOrderID
where p.ProductID in (
    select p.ProductID
    from Sales.SalesOrderDetail sod
    join Sales.SalesOrderHeader soh
    on sod.SalesOrderID = soh.SalesOrderID
    join Production.Product p
    on p.ProductID = sod.ProductID
    group by p.ProductID
    having count(distinct CustomerID) > 1
    )
and CustomerID in (
    select CustomerID
    from sales.SalesOrderHeader soh
    join sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    join Production.Product p
    on p.ProductID = sod.ProductID
    group by CustomerID
    having count(distinct p.Color) > 1
    )
and CustomerID not in (
    select CustomerID
    from sales.SalesOrderHeader soh
    join sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    join Production.Product p
    on p.ProductID = sod.ProductID
    group by CustomerID
    having count(distinct p.Color) = 2
    );


-- 6 Найти такие товары,
-- которые были куплены такими покупателями,
-- у которых они присутствовали в каждой их покупке.


select distinct ProductID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader soh
on soh.SalesOrderID = sod.SalesOrderID
and CustomerID in (
    select CustomerID
    from sales.SalesOrderHeader soh
    join sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    where sod.ProductID in (
        select ProductID
        from Sales.SalesOrderDetail sod
        join Sales.SalesOrderHeader soh
        on soh.SalesOrderID = sod.SalesOrderID
        group by ProductID
        having count(*) = count(distinct sod.SalesOrderID)
        )
    );


-- or just

select ProductID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader soh
on soh.SalesOrderID = sod.SalesOrderID
group by ProductID
having count(*) = count(sod.SalesOrderID);



-- 7 Найти покупателей, у которых есть товар, присутствующий в каждой
-- покупке/чеке.

select CustomerID
from Sales.SalesOrderHeader soh1
join Sales.SalesOrderDetail sod1
on soh1.SalesOrderID = sod1.SalesOrderID
where ProductID in (
    select ProductID
    from Sales.SalesOrderDetail sod
    join Sales.SalesOrderHeader soh
    on sod.SalesOrderID = soh.SalesOrderID
    group by ProductID
    having count(sod.SalesOrderID) = all(
        select count(distinct SalesOrderID)
        from Sales.SalesOrderDetail
        )
    );



-- 8 Найти такой товар или товары, которые были куплены не более чем тремя
-- различными покупателями.

select ProductID
from Sales.SalesOrderDetail
join Sales.SalesOrderHeader SOH
on SOH.SalesOrderID = SalesOrderDetail.SalesOrderID
group by ProductID
having count(distinct CustomerID) <= 3;



-- 10 Найти номера тех покупателей, у которых есть как минимум два чека, и
-- каждый из этих чеков содержит как минимум три товара, каждый из которых как
-- минимум был куплен другими покупателями три раза.

select CustomerID
from Sales.SalesOrderHeader
where SalesOrderID in (
    select SalesOrderID
    from Sales.SalesOrderDetail
    where ProductID in (
        select ProductID
        from Sales.SalesOrderDetail sod
        join Sales.SalesOrderHeader SOH
            on sod.SalesOrderID = SOH.SalesOrderID
        group by ProductID
        having count(distinct CustomerID) >= 4
        )
     group by SalesOrderID
     having count(distinct ProductID) >= 3
    )
    group by CustomerID
    having count(distinct SalesOrderID) >= 2;



-- 12 Найти товары, которые были куплены минимум три раза различными
-- покупателями.

select distinct ProductID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader SOH
on SOH.SalesOrderID = sod.SalesOrderID
where sod.ProductID in (
    select ProductID
    from Sales.SalesOrderDetail
    join Sales.SalesOrderHeader S
    on S.SalesOrderID = SalesOrderDetail.SalesOrderID
    group by ProductID
    having count(distinct S.CustomerID) >= 3
    );


-- 13 Найти такую подкатегорию или подкатегории товаров, которые содержат
-- более трех товаров, купленных более трех раз.


select distinct ProductSubcategoryID
from Production.Product
where ProductID in (
    select ProductID
    from Sales.SalesOrderDetail sod
    where SalesOrderID in (
        select SalesOrderID
        from Sales.SalesOrderDetail sod
        group by SalesOrderID
        having count(sod.ProductID) > 3
        )
    )
group by ProductSubcategoryID
having count(distinct ProductID) > 3;


-- 14 Найти те товары,
-- которые не были куплены более трех раз, и как минимум
-- дважды одним и тем же покупателем.

select distinct ProductID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader SOH
on SOH.SalesOrderID = sod.SalesOrderID
where CustomerID in (
    select CustomerID
    from Sales.SalesOrderHeader soh1
    where CustomerID in (
        select CustomerID
        from Sales.SalesOrderHeader soh2
        join Sales.SalesOrderDetail sod
        on sod.SalesOrderID = soh2.SalesOrderID
        where soh1.CustomerID = soh2.CustomerID
        group by CustomerID
        having count(sod.SalesOrderID) >= 2
        )
   )
group by ProductID
having count(*) <= 3;






















-- 1 Найти название самого продаваемого продукта.

select Name
from Production.Product
where ProductID = (
    select top 1 ProductID
    from Sales.SalesOrderDetail
    group by ProductID
    order by count(*) desc
    )



-- 2 Найти покупателя,
-- совершившего покупку на самую большую сумм, считая
-- сумму покупки исходя из цены товара без скидки (UnitPrice).

select distinct CustomerID
from Sales.SalesOrderHeader
where CustomerID = (
    select top 1 CustomerID
    from Sales.SalesOrderHeader soh
    join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    group by CustomerID
    order by sum(UnitPrice) desc
    )



-- 3 Найти такие продукты, которые покупал только один покупатель.

select ProductID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader SOH
on SOH.SalesOrderID = sod.SalesOrderID
group by ProductID
having count(distinct CustomerID) = 1


-- 4 Вывести список продуктов,
-- цена которых выше средней цены товаров в его подкатегории

select distinct ProductID
from Production.Product p
where ListPrice > (
    select sum(distinct p1.ListPrice) / count(distinct p1.ListPrice)
    from Production.Product p1
    where p.ProductSubcategoryID = p1.ProductSubcategoryID
    )



-- 5 Найти такие товары, которые были куплены более чем одним покупателем, при
-- этом все покупатели этих товаров покупали товары только одного цвета и товары
-- не входят в список покупок покупателей, купивших товары только двух цветов.

select distinct ProductID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader SOH
    on SOH.SalesOrderID = sod.SalesOrderID
where CustomerID in (
    select CustomerID
    from Sales.SalesOrderHeader soh
    join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    join Production.Product p
    on sod.ProductID = p.ProductID
    group by CustomerID
    having count(Color) = 1
    )
and ProductID not in (
    select ProductID
    from Sales.SalesOrderDetail sod
    join Sales.SalesOrderHeader SOH
    on SOH.SalesOrderID = sod.SalesOrderID
    where SOH.CustomerID in (
        select CustomerID
    from Sales.SalesOrderHeader soh
    join Sales.SalesOrderDetail sod
    on soh.SalesOrderID = sod.SalesOrderID
    join Production.Product p
    on sod.ProductID = p.ProductID
    group by CustomerID
    having count(Color) = 2
        )
    )
group by ProductID
having count(distinct CustomerID) > 1


-- 6 Найти такие товары,
-- которые были куплены такими покупателями,
-- у которых они присутствовали в каждой их покупке.

select distinct ProductID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader SOH
    on SOH.SalesOrderID = sod.SalesOrderID
where CustomerID in (
    select CustomerID
    from Sales.SalesOrderHeader soh1
    join Sales.SalesOrderDetail Sod1
        on soh1.SalesOrderID = Sod1.SalesOrderID
    where ProductID = sod.ProductID
    group by CustomerID
    having count(sod1.ProductID) = count(sod1.SalesOrderID)
    )

-- 7 Найти покупателей,
-- у которых есть товар, присутствующий в каждой покупке/чеке.

select distinct CustomerID
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod
on soh.SalesOrderID = sod.SalesOrderID
where ProductID in (
    select ProductID
    from Sales.SalesOrderDetail sod1
    where SalesOrderID in (
        select SalesOrderID
        from Sales.SalesOrderDetail sod2
        where sod1.ProductID = sod2.ProductID
        --group by SalesOrderID
        --having count(*) = count(ProductID)
        )
    )


-- 8 Найти такой товар или товары,
-- которые были куплены не более чем тремя различными покупателями.

select ProductID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader SOH
    on SOH.SalesOrderID = sod.SalesOrderID
group by ProductID
having count(distinct CustomerID) <= 3


-- 10 Найти номера тех покупателей,
-- у которых есть как минимум два чека,
-- и каждый из этих чеков содержит
-- как минимум три товара,
-- каждый из которых как минимум был куплен другими покупателями три раза.


select distinct CustomerID
from Sales.SalesOrderHeader soh
where soh.SalesOrderID in (
    select SalesOrderID
    from Sales.SalesOrderDetail sod
    where ProductID in (
        select ProductID
        from Sales.SalesOrderDetail sod1
        join Sales.SalesOrderHeader soh1
        on sod1.SalesOrderID = soh1.SalesOrderID
        group by ProductID
        having count(distinct CustomerID) >= 3
        )
    group by SalesOrderID
    having count(distinct ProductID) >= 3
    )
group by CustomerID
having count(distinct SalesOrderID) >= 2










-- название категории самого продаваемого товара (по кол-ву чеков)


select distinct pc.Name
from Production.ProductCategory pc
join Production.ProductSubcategory
on pc.ProductCategoryID = ProductSubcategory.ProductCategoryID
join Production.Product p
on ProductSubcategory.ProductSubcategoryID = p.ProductSubcategoryID
join Sales.SalesOrderDetail sod
on sod.ProductID = p.ProductID
where p.ProductID = (
    select top 1 ProductID
    from Sales.SalesOrderDetail sod
    group by ProductID
    order by count(sod.SalesOrderID) desc
    )
