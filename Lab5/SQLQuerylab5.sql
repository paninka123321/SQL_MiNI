-- zadanie 1
Select ProductID, ShipCountry, Sum(Quantity) as TotalQuantity from [Order Details] Od 
join (Select OrderId, ShipCountry, O.EmployeeID from Employees E 
      left join Orders O on E.EmployeeID = O.EmployeeID where E.EmployeeID = 2) A 
      on Od.OrderID = A.OrderID group by ProductID, ShipCountry

-- Zadanie 2
Select FirstName as EmployeeName, LastName as EmployeeSurname, Sum(Quantity) as TotalQuantity from Products P 
join (Select ProductID, Quantity, B.* from [Order Details] Od 
      join (Select FirstName, LastName, OrderID, OrderDate from Orders O 
            join Employees E on O.EmployeeID = E.EmployeeID where YEAR(OrderDate) = 1998) B 
      on Od.OrderID = B.OrderID) C 
      on P.ProductID = C.ProductID where ProductName = 'Chocolade' group by FirstName, LastName Having SUM(Quantity)>= 100

--Zadanie 3
Select C.CustomerId, OrderId from Customers C left join Orders O on C.CustomerID = O.CustomerID where Country = 'Italy'
Select ProductID, D.OrderID, CustomerID, Avg(Od.Quantity) as MeanQuantity from [Order Details] Od 
join (Select C.CustomerId, OrderId from Customers C left join Orders O on C.CustomerID = O.CustomerID where Country = 'Italy') D on Od.OrderID = D.OrderID 
group by CustomerID, D.OrderID, ProductID having Avg(Od.Quantity) >= 20 order by Count(D.OrderID) desc

--Zadanie 4
Select ProductName, ContactName as CustomerName, OrderDate, Quantity from Products P 
join (Select ProductId, Quantity, F.* from [Order Details] Od 
      join (Select C.CustomerID, ContactName, City, OrderId, OrderDate from Customers C 
            left join Orders O on C.CustomerID = O.CustomerID where City = 'Berlin') F 
      on Od.OrderID = F.OrderID) G 
      on P.ProductID = G.ProductID order by CustomerName, ProductName, OrderDate

--Zadanie 5
Select ProductName from Products P 
join (Select ProductId from Orders O 
      join [Order Details] Od on O.OrderID = Od.OrderID where O.ShipCountry = 'France' and Year(O.OrderDate) = 1998) H on P.ProductID = H.ProductID

--Zadanie 6 (chyba juz)
Select ProductName, CustomerID from Products P 
join (Select ProductID, CustomerID, COUNT(I.OrderID) as orders_count from [Order Details] Od 
      join (Select C.CustomerId, OrderId from Customers C join Orders O on C.CustomerID = O.CustomerID) I on Od.OrderID = I.OrderID 
      group by CustomerID, ProductID having Count(I.OrderID) >=2) J on P.ProductID = J.ProductID where ProductName not like 'Ravioli'

--Zadanie 7
Select CompanyName, Od.OrderId, Count(ProductID) as ProductCount from [Order Details] Od join 
(Select C.CustomerID, OrderId, CompanyName from Customers C 
 join Orders O on C.CustomerID = O.CustomerID where Country = 'France') J 
 on Od.OrderID = J.OrderID group by CompanyName, Od.OrderID having Count(ProductID) >= 4

--Zadanie 8
-- tak nie mo¿na bo zwraca nulle i jest problem, pytanie jak zast¹piæ null 0 wtedy by da³o radê, ale pewnie i tak wolniejsze
--Select * from (Select CompanyName, ShipCountry, Count(ShipCountry) as country_count_france from Customers C join Orders O on C.CustomerID = O.CustomerID where ShipCountry = 'France' group by CompanyName, ShipCountry having Count(ShipCountry) >=5) A
--left join
--(Select CompanyName, ShipCountry, Count(ShipCountry) as country_count_belgium from Customers C join Orders O on C.CustomerID = O.CustomerID where ShipCountry = 'Belgium' group by CompanyName, ShipCountry) B on A.CompanyName = B.CompanyName where country_count_belgium <=2 or country_count_belgium = NULL
-- tak te¿ nie mo¿na, bo ten sam problem
--Select * from (Select CompanyName, ShipCountry, Count(ShipCountry) as country_count_france from Customers C join Orders O on C.CustomerID = O.CustomerID where ShipCountry = 'France' group by CompanyName, ShipCountry having Count(ShipCountry) >=5) A
--left join
--(Select CompanyName, ShipCountry, Count(ShipCountry) as country_count_belgium from Customers C join Orders O on C.CustomerID = O.CustomerID where ShipCountry = 'Belgium' group by CompanyName, ShipCountry) B on A.CompanyName = B.CompanyName where country_count_belgium <=2 
Select CompanyName from Customers C 
join Orders O on O.CustomerID = C.CustomerID 
where O.ShipCountry = 'France' and not exists (Select CompanyName, Cc.CustomerID, ShipCountry from Customers Cc 
                                               join Orders Oo on Oo.CustomerID = Cc.CustomerID where ShipCountry = 'Belgium' and Cc.CustomerId = C.CustomerID 
                                               group by CompanyName, Cc.CustomerID, ShipCountry having count(ShipCountry) >2)

--Zadanie 9
Select P.ProductName, C.CompanyName, A.MaxQuantity from [Order Details] Od 
join (Select ProductID, max(Quantity) MaxQuantity  from [Order Details] Od group by ProductID) A on Od.ProductID = A.ProductID
join Products P on P.ProductID = Od.ProductID join orders O on O.orderid = Od.OrderID join Customers C on C.CustomerID = O.CustomerID 
where Od.Quantity = A.MaxQuantity order by P.ProductName

--Zadanie 10
--funkcja over() do liczenia funkcji zagregowanych dla grup
Select EmployeeId from (Select EmployeeId, OrderCount, [OrderAverage] = Avg(OrderCount) over() 
                        from (Select EmployeeId, COUNT(OrderId) as OrderCount from Orders group by EmployeeID) A) B where OrderCount > 1.2 * OrderAverage

--Zadanie 11
Select top 5 ProductCount, OrderId from (Select O.OrderId, Count(distinct ProductID) as ProductCount from Orders O 
                                         join [Order Details] Od on Od.OrderID = O.OrderID group by O.OrderID) A order by ProductCount desc

--Zadanie 12
Select * from 
(Select ProductId, Sum(Case when (YEAR(OrderDate) = 1997) then Quantity else 0 end) as TotalQuantity1997, 
 Sum(Case when (Year(OrderDate) = 1996) then Quantity else 0 end) as TotalQuantity1996 from Orders O join [Order Details] Od on O.OrderID = Od.OrderID 
 where YEAR(OrderDate) = 1997 or YEAR(OrderDate) = 1996 group by ProductID) A where TotalQuantity1997 > TotalQuantity1996

--Zadanie 13
-- coœ tu Ÿle zrobi³am :(
-- Select * from (Select ProductId, Count(Case when (YEAR(OrderDate) = 1997) then ProductId else 0 end) as Number1997, Count(Case when (Year(OrderDate) = 1996) then ProductId else 0 end) as Number1996 from Orders O join [Order Details] Od on O.OrderID = Od.OrderID where YEAR(OrderDate) = 1997 or YEAR(OrderDate) = 1996 group by ProductID) A where Number1997 > Number1996

--Zadanie 14

select 
 year(OrderDate) as OrderYear, datepart(month, OrderDate) as OrderMonth,
 O.OrderId, O.CustomerID, Cust.CompanyName, Cust.Country as CustomerCountry, Cust.City AS CustomerCity, 
 O.ShipCountry, O.ShipCity, OD.ProductID, P.ProductName, Cat.CategoryName,  OD.UnitPrice,
 OD.Quantity, OD.UnitPrice * OD.Quantity as ProductValue 
from Orders O 
JOIN [Customers] Cust    ON O.CustomerID = Cust.CustomerID
JOIN [Order Details] OD ON OD.OrderID = O.OrderID
JOIN [Products] P ON P.ProductID = OD.ProductID
JOIN [Categories] Cat ON Cat.CategoryID = P.CategoryID


--Zadanie 15
SELECT OrderId,ProductName,CategoryName, ProductValue,
SUM(ProductValue) OVER (PARTITION BY ProductName) as ProdTotalSale,
SUM(ProductValue) OVER (PARTITION BY CategoryName) as CategoryTotalSale   
FROM OrdersTotal order by ProductName

--Zadanie 16
SELECT distinct	ProductName,CategoryName, 
SUM(ProductValue) OVER (PARTITION BY ProductName) as ProdTotalSale,
SUM(ProductValue) OVER (PARTITION BY CategoryName) as CategoryTotalSale,
SUM(ProductValue) OVER () as TotalSale   
FROM OrdersTotal order by ProductName

--Zadanie 17
select OrderId, ProductId, ProductValue, 
SUM(ProductValue) OVER (ORDER BY OrderId, ProductId ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as ProdTotalSale
from OrdersTotal order by OrderId

-- Zadanie 18
select OrderId, ProductId, ProductValue, 
SUM(ProductValue) OVER (ORDER BY OrderId, ProductId ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as ProdTotalSale
from OrdersTotal order by OrderId, ProductId

--Zadanie 19
select   ProductName, OrderYear, OrderMonth, 
SUM(OrderTotal) OVER (PARTITION BY ProductName,OrderYear,OrderMonth) AS ProductMonthSale,
SUM(OrderTotal) OVER (PARTITION BY ProductName,OrderYear ORDER BY OrderMonth) as ProdUntilMonthSale,
count(*) OVER (PARTITION BY ProductName,OrderYear ORDER BY OrderMonth) as MonthCount
from (select sum(ProductValue) as OrderTotal, ProductName, OrderYear, OrderMonth from OrdersTotal
group by ProductName, OrderYear, OrderMonth) as OrdersGrouped
order by ProductName,OrderYear,OrderMonth


