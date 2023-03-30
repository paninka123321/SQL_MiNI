-- Zadanie 1
select * from Orders

-- Zadanie 2
select * from Orders where ShipCountry = 'Germany' or ShipCountry = 'Mexico' or ShipCountry = 'Brazil'
--lub
select * from Orders where ShipCountry in ('Germany', 'Mexico', 'Brazil')

--Zadanie 3
select distinct ShipCity from Orders where ShipCountry = 'Germany'

--Zadanie 4
--Select * from Orders where OrderDate like '1996-07%'
Select * from Orders where MONTH(OrderDate) = '7' and Year(OrderDate) = '1996'
select * from orders where month(orderDate)=7 and year(orderdate)=1996

--Zadanie 5
select upper(substring(companyName,1,10)) as company_code from Customers

--Zadanie 6 
Select o.* from Orders o join Customers c on o.CustomerID = c.CustomerID
where Country = 'France'

--Zadanie 7 
Select distinct o.ShipCountry from Orders o join Customers c on o.CustomerID = o.CustomerID where Country = 'Germany'
Select distinct ShipCountry from Orders o join Customers c on o.CustomerID = o.CustomerID where Country = 'Germany'

--Zadanie 8
Select o. * from Orders o join Customers c on o.CustomerID = c.CustomerID where Country != ShipCountry
Select o. * from Orders o join Customers c on o.CustomerID = c.CustomerID where c.Country != o.ShipCountry

--Zadanie 9 
Select * from Customers C where not exists (select * from Orders O where O.CustomerID = C.CustomerID)
Select CustomerID from Customers C where not exists (select * from Orders O where O.CustomerID = C.CustomerID)
Select distinct CustomerID from Customers C where not exists (select * from Orders O where O.CustomerID = C.CustomerID)
Select * from Customers C where CustomerID not in (select CustomerId from Orders O where O.CustomerID = C.CustomerID)
Select * from Customers C where CustomerID not in (select C.CustomerId from Customers C join Orders O on O.CustomerID = C.CustomerID)

--Zadanie 10
/*
pytanie dlaczego to nie dobrze?
Select * from Customers C where exists (Select * from Orders O where exists (select * from [Order Details] Od where not exists (select * from Products P where Od.ProductID = P.ProductID and ProductName = 'Chocolade'))) or not exists (
select * from Orders O where C.CustomerID = O.CustomerID)
*/
Select * from customers c where not exists (select * from orders o where o.customerid=c.customerid
and exists (select * from [order details] od join products p on p.productid=od.productid where od.orderid=o.orderid and p.productname='Chocolade'))

-- Zadanie 11
Select * from Customers C where C.CustomerID in (Select CustomerID from Orders O join (select Od.* from [Order Details] Od join Products P on Od.ProductID = P.ProductID where ProductName = 'Scottish Longbreads') A on O.OrderID = A.OrderID)

select * from customers c where exists (select * from orders o join [order details] od on od.orderid=o.orderid
join products p on p.productid=od.productid where p.productname='Scottish Longbreads' and o.customerid=c.customerid)

-- Zadanie 12
Select O.* from Orders O join (Select distinct OrderID from [Order Details] Od join Products P on Od.ProductID = P.ProductID where ProductName = 'Scottish Longbreads' and ProductName != 'Chocolade') B on O.OrderID = B.OrderID
Select * from Orders where OrderId in (Select distinct OrderID from [Order Details] Od join Products P on Od.ProductID = P.ProductID where ProductName = 'Scottish Longbreads' and ProductName != 'Chocolade')
select * from orders o where 
exists (select * from [order details] od join products p on p.productid=od.productid where productname='Scottish Longbreads' and od.orderid=o.orderid)
and not exists (select * from [order details] od join products p on p.productid=od.productid where productname='Chocolade' and od.orderid=o.orderid)

-- Zadanie 13
Select distinct FirstName, LastName from Employees E join (select * from Orders where CustomerID = 'ALFKI') C on E.EmployeeID = C.EmployeeID
select firstname, lastname from employees e where exists (select * from orders o
where customerid='ALFKI' and e.employeeid=o.employeeid)

-- Zadanie 14
Select FirstName, LastName, OrderDate, status from Employees E join (Select  O.OrderDate, F.ProductID, O.OrderID, status, O.EmployeeID from Orders O join (Select Od.ProductID, Od.OrderID, status from [Order Details] Od join (Select *, (case when ProductName = 'Chocolade' then 1 else 0 end) as status from Products) D on Od.ProductID = D.ProductID) F on O.OrderID = F.OrderID) G on E.EmployeeID = G.EmployeeID
Select * from [Order Details] Od join (Select OrderID, FirstName, LastName, OrderDate, CustomerID, E.EmployeeID from Employees E join Orders O on  E.EmployeeID = O.EmployeeID) D on Od.OrderID = D.OrderID

-- Zadanie 15 
Select ProductName, B.*, MONTH(OrderDate) as Month, Year(OrderDate) as Year from Products P join (Select A.*, ProductId from [Order Details] Od join (Select OrderDate, ShipCountry, Country, O.CustomerID, OrderID from Orders O join Customers C on O.CustomerID = C.CustomerID) A on A.OrderID = Od.OrderID) B on B.ProductID = P.ProductID where Country = 'Germany' and SUBSTRING(ProductName, 1, 1) like '[c-s]' order by OrderDate desc

SELECT P.ProductName, O.ShipCountry, O.OrderId, YEAR(orderdate) as rok,
MONTH(orderdate) as miesiac, orderDate from Customers c join orders o on o.customerid=c.customerid
join [order details] od on od.orderid=o.orderid 
join products p on od.productid=p.productid
where c.country='Germany' and p.productname like '[c-s]%' order by orderdate desc
