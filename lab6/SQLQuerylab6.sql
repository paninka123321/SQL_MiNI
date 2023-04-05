--Task 1
Begin transaction;
	Select * from Orders where EmployeeID = '1';
	Update Orders set EmployeeID = '4' where EmployeeID = '1';
	Select * from Orders where EmployeeID = '1';
Rollback;
Select * from Orders where EmployeeID = 1;

-- vs Commit
Begin transaction;
	Select * from Orders where EmployeeID = '1';
	Update Orders set EmployeeID = '4' where EmployeeID = '1';
	Select * from Orders where EmployeeID = '1';
Commit;
Select * from Orders where EmployeeID = 1;

--Rollback makes changes but then give up it (so it's something like a test)

--Task 2
Begin transaction;
	Select P.ProductId, ProductName, A.* from Products P left join
	(Select Od.* from Orders O left join [Order Details] Od on O.OrderID = Od.OrderID where OrderDate > '1997-07-15') A
	on P.ProductID = A.ProductID where ProductName = 'Ikura';
	Update [Order Details] set Quantity = Round(Quantity *0.8, 0) where ProductId in (Select ProductID from Products where ProductName ='Ikura')
	and OrderID in (Select OrderID from Orders where OrderDate > '1997-07-15')
	Select P.ProductId, ProductName, A.* from Products P left join
	(Select Od.* from Orders O left join [Order Details] Od on O.OrderID = Od.OrderID where OrderDate > '1997-07-15') A
	on P.ProductID = A.ProductID where ProductName = 'Ikura';
Rollback;

--Task 3
Begin transaction;
	Select distinct top 1 Od.OrderID, CustomerID, OrderDate, Quantity, P.ProductID from Orders O join [Order Details] Od on O.OrderID = Od.OrderID
	join Products P on Od.ProductID = P.ProductID
	where CustomerID = 'Alfki' and ProductName != 'Chocolade'  order by OrderDate desc
	
	Insert into [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount) 
	Values ((Select A.OrderID from (Select distinct top 1 Od.OrderID, OrderDate from Orders O join [Order Details] Od on O.OrderID = Od.OrderID
	join Products P on Od.ProductID = P.ProductID
	where CustomerID = 'Alfki' and ProductName != 'Chocolade'  order by OrderDate desc) A), 
	(Select ProductId from Products where ProductName = 'Chocolade'),
	10,
	9,
	0.1)

	Select distinct  Od.OrderID, CustomerID, OrderDate, Quantity, P.ProductID from Orders O join [Order Details] Od on O.OrderID = Od.OrderID
	join Products P on Od.ProductID = P.ProductID
	where CustomerID = 'Alfki'

Rollback
	--or
Begin transaction;
	declare @t1 int = (Select OrderID from (Select distinct top 1 Od.OrderID, CustomerID, OrderDate, Quantity, P.ProductID from Orders O join [Order Details] Od on O.OrderID = Od.OrderID
	join Products P on Od.ProductID = P.ProductID
	where CustomerID = 'Alfki' and ProductName != 'Chocolade'  order by OrderDate desc)B);

	declare @t2 int = (Select ProductId P from Products P where P.ProductName = 'Chocolade');

	Insert into [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount) 
	Values (@t1, @t2,
	10,
	9,
	0.1);

	Select distinct  Od.OrderID, CustomerID, OrderDate, Quantity, P.ProductID from Orders O join [Order Details] Od on O.OrderID = Od.OrderID
	join Products P on Od.ProductID = P.ProductID
	where CustomerID = 'Alfki'
Rollback

--Task 5
-- Usuñ dane wszystkich kontrahentów, którzy nie z³o¿yli ¿adnych zamówieñ
-- deklaracja nowej zmiennej 
Begin transaction;
Delete from Customers where Customers.CustomerID in 
(Select CustomerID from Customers C where CustomerID not in 
(Select distinct O.CustomerID from Orders O));
Rollback;

--or:
Begin transaction;
	Delete from Customers where NOT EXISTS 
	(Select Cc.* From ORDERS O join Customers Cc on O.CustomerId=Cc.CustomerId where Customers.CustomerID = Cc.CustomerID);
Rollback;

-- or:
Begin transaction;
	Delete from Customers where NOT EXISTS 
	(Select OrderID From ORDERS O where Customers.CustomerID = O.CustomerID);
Rollback;

--or:
Begin transaction;
Declare @currentId nchar(5);
DECLARE customercursor CURSOR LOCAL FOR SELECT CustomerId FROM Customers
WHERE Customers.CustomerID not in (Select distinct O.CustomerID from Orders O);

OPEN customercursor;
FETCH NEXT FROM customercursor INTO @currentId

WHILE @@FETCH_STATUS=0
BEGIN
Delete from Customers where Customers.CustomerID = @currentId
FETCH NEXT FROM customercursor INTO @currentId
END

CLOSE customercursor
Deallocate customercursor;
Rollback;

-- Task 6
Select Sum(Quantity) as Chocolade_Total_Quantity from [Order Details] Od where exists (Select ProductName from Products P where 
	P.ProductID = Od.ProductID and ProductName = 'Chocolade') and
	exists (Select OrderDate from Orders O where O.OrderID = Od.OrderID and Year(O.OrderDate) = '1997');

Begin transaction;
-- new id creats by default Declare @newID  int = (Select top(1) ProductId from Products P order by ProductId desc) + 1;
Insert into Products (ProductName) values ('Programming in Java')

Update [Order Details] set Quantity = Quantity + 1 where  exists (select OrderDate from Orders O where YEAR(O.OrderDate) = '1997' and O.OrderID = [Order Details].OrderID)
	and exists (Select ProductName from Products P where 
		P.ProductID = [Order Details].ProductID and ProductName = 'Chocolade');
Commit;
Select Sum(Quantity) as Chocolade_Total_Quantity from [Order Details] Od where exists (Select ProductName from Products P where 
	P.ProductID = Od.ProductID and ProductName = 'Chocolade') and
	exists (Select OrderDate from Orders O where O.OrderID = Od.OrderID and Year(O.OrderDate) = '1997');

--Task 7
Select Sum(Quantity) as Chocolade_Total_Quantity from [Order Details] Od where exists (Select ProductName from Products P where 
		P.ProductID = Od.ProductID and ProductName = 'Chocolade') and
		exists (Select OrderDate from Orders O where O.OrderID = Od.OrderID and Year(O.OrderDate) = '1997');

Begin transaction;
	Update [Order Details] set Quantity = Quantity*2 where  exists (select OrderDate from Orders O where YEAR(O.OrderDate) = '1997' and O.OrderID = [Order Details].OrderID)
		and exists (Select ProductName from Products P where 
		P.ProductID = [Order Details].ProductID and ProductName = 'Chocolade');
	
	Select Sum(Quantity) as Chocolade_Total_Quantity from [Order Details] Od where exists (Select ProductName from Products P where 
		P.ProductID = Od.ProductID and ProductName = 'Chocolade') and
		exists (Select OrderDate from Orders O where O.OrderID = Od.OrderID and Year(O.OrderDate) = '1997');
Rollback;

Select Sum(Quantity) as Chocolade_Total_Quantity from [Order Details] Od where exists (Select ProductName from Products P where 
		P.ProductID = Od.ProductID and ProductName = 'Chocolade') and
		exists (Select OrderDate from Orders O where O.OrderID = Od.OrderID and Year(O.OrderDate) = '1997');
--Rollback gives me the resignation of changes

--Task 8

Begin transaction;
-- Quantity of chocolade orders from 1997
	Select Sum(Quantity) as Chocolade_Total_Quantity from [Order Details] Od where exists (Select ProductName from Products P where 
		P.ProductID = Od.ProductID and ProductName = 'Chocolade') and
		exists (Select OrderDate from Orders O where O.OrderID = Od.OrderID and Year(O.OrderDate) = '1997');

-- 2 times increase the number of Chocolade in orders from 1997
	Update [Order Details] set Quantity = Quantity*2 where  exists (select OrderDate from Orders O where YEAR(O.OrderDate) = '1997' and O.OrderID = [Order Details].OrderID)
		and exists (Select ProductName from Products P where 
		P.ProductID = [Order Details].ProductID and ProductName = 'Chocolade');

-- Check the quantity of chocolade orders from 1997	after changes	
	Select Sum(Quantity) as Chocolade_Total_Quantity_after_changes from [Order Details] Od where exists (Select ProductName from Products P where 
		P.ProductID = Od.ProductID and ProductName = 'Chocolade') and
		exists (Select OrderDate from Orders O where O.OrderID = Od.OrderID and Year(O.OrderDate) = '1997');

	Select COUNT(OrderID) as Number_od_orders from Orders

-- Delete from orders products without chocolade
	Declare @chocolade_id int;
	set @chocolade_id = (Select distinct ProductId from Products where ProductName = 'Chocolade');
	
	Delete from [Order Details] where ProductID != @chocolade_id;
	Delete from Orders where not exists (Select ProductId from [Order Details] Od
		where Orders.OrderID = Od.OrderID and Od.ProductID = @chocolade_id);

	Select COUNT(OrderID) as Number_of_orders_after_changes from Orders
Rollback;


-- Check the quantity of Ikura	
	Select Sum(Quantity) as Ikura_Total_Quantity from [Order Details] Od where exists (Select ProductName from Products P where 
		P.ProductID = Od.ProductID and ProductName = 'Ikura')

-- Add Ikura to orders withou Ikura
Begin transaction;
	Declare @ikura_id int;
	set @ikura_id = (Select ProductId from Products where ProductName = 'Ikura');
	Declare @order_id int;
	Declare ikura_cursor Cursor Local For Select OrderID from (Select distinct OrderID from [Order Details] Od where Od.ProductID != @ikura_id) A;
	
	OPEN ikura_cursor;
	FETCH NEXT FROM ikura_cursor INTO @order_id;

	WHILE @@FETCH_STATUS=0
	BEGIN
	Insert into [Order Details] (OrderID, ProductID, Quantity) values (@order_id, @ikura_id, 1);
	FETCH NEXT FROM ikura_cursor INTO @order_id
	End

	CLOSE ikura_cursor
	Deallocate ikura_cursor;

Commit;

-- Check the quantity of Ikura	
	Select Sum(Quantity) as Ikura_Total_Quantity from [Order Details] Od where exists (Select ProductName from Products P where 
		P.ProductID = Od.ProductID and ProductName = 'Ikura')

-- Increase 2 times quantity of Ikura in orders from 1997
Begin transaction;
		Update [Order Details] set Quantity = Quantity*2 where  exists (select OrderDate from Orders O where YEAR(O.OrderDate) = '1997' and O.OrderID = [Order Details].OrderID)
		and exists (Select ProductName from Products P where 
		P.ProductID = [Order Details].ProductID and ProductName = 'Ikura');
Commit;

-- Check the quantity of Ikura	
	Select Sum(Quantity) as Ikura_Total_Quantity from [Order Details] Od where exists (Select ProductName from Products P where 
		P.ProductID = Od.ProductID and ProductName = 'Ikura')

