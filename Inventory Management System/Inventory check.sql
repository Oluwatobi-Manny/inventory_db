USE Inventory
GO

EXEC InsertSupplier 'Supplier C', 'NYC', '+9345759110', 'Jackson Fellows', 'supplierc@example.com'
EXEC InsertProduct 'Caps', 3, 3, 1000, 2.50
EXEC InsertCategories 'Gadgets'
EXEC InsertCustomer 'Jeremiah', 'Okorie', 'jerrynysc@example.com', '+2348111111111', '2007-01-01', 'M', 'ilawe NCCF Home',
					'NYC', 'NYC', '92478', 'U.S.A', 1
EXEC InsertCustomer 'Jeremiah', 'Okorie', 'john.doe@example.com', '+2348111111111', '2007-01-01', 'M', 'ilawe NCCF Home',
					'NYC', 'NYC', '92478', 'U.S.A', 1
EXEC UpdateStock 1, 12, 'OUT'
EXEC UpdateStock 1, 12, 'IN'
EXEC CheckStock 
EXEC CheckStockNameId @ProductID = '2';
EXEC CheckStockNameId @ProductName = 'Laptop';
EXEC UpdateCustomer 5, 'Jerry', 'Bob', 'jerrybob@example.om', '321-657-2345', '2007-01-01', 'M', '3 Alfred Str.', 'Gotham',
					'NJ', '92345', 'USA', 'Manager'
EXEC DeleteCustomer 5, 'Manager', 'User stopped using store'
EXEC DeleteCustomer 6, 'Manager', 'User stopped using store'
EXEC DeleteProduct 2, 'Manager', 'Testing'
EXEC UpdateSupplierInfo 2, 'NJ', '233-333-3333', 'Jeremy Lynch', 'supplierb@example.com','Manager'
EXEC LowStockAlert 51
EXEC GeneralMonthlySalesReport
EXEC InsertOrder 1, '2024-06-10'
EXEC UpdateStock 1,10,'IN', 1
EXEC UpdateStock 3, 100,'OUT', 5
EXEC GeneralMonthlySalesSold
EXEC GeneralMonthlyGoodsBought


SELECT * FROM Suppliers
SELECT * FROM Products
SELECT * FROM Categories
SELECT * FROM Customers
SELECT * FROM Transactions
SELECT * FROM CustomerChangeLog
SELECT * FROM CustomerDeletionLog
SELECT * FROM ProductDeletionLog
SELECT * FROM SupplierUpdateLog
SELECT * FROM Orders
SELECT * FROM OrderDetails
SELECT * FROM Transactions_IN
SELECT * FROM Transactions_OUT

-- Insert sample data row by row
UPDATE Orders
SET expected_delivery_date = '2024-10-10', delivery_date = '2024-10-12'
WHERE order_id = 1;

UPDATE Orders
SET expected_delivery_date = '2024-11-01', delivery_date = '2024-11-03'
WHERE order_id = 2;

UPDATE Orders
SET expected_delivery_date = '2024-12-15', delivery_date = '2024-12-17'
WHERE order_id = 3;

UPDATE Orders
SET expected_delivery_date = '2024-04-15', delivery_date = '2024-04-13'
WHERE order_id = 4;

UPDATE Orders
SET expected_delivery_date = '2024-05-06', delivery_date = '2024-05-06'
WHERE order_id = 5;

EXEC CheckSupplierPerformance
EXEC MonthCheckSupplierPerformance @Year = 2024, @Month = 2;