/* 

Store Inventory Control Management Database Using SQL

Database Design

Tables:
1. Products
   - `product_id` (Primary Key)
   - `product_name`
   - `category_id` (Foreign Key)
   - `supplier_id` (Foreign Key)
   - `quantity_in_stock`
   - `price_per_unit`

2. Categories
   - `category_id` (Primary Key)
   - `category_name`

3. Suppliers
   - `supplier_id` (Primary Key)
   - `supplier_name`
   - `contact_info`

4. Customers
   - `customer_id` (Primary Key)
   - `customer_name`
   - `contact_info`

5. Orders
   - `order_id` (Primary Key)
   - `customer_id` (Foreign Key)
   - `order_date`

6. OrderDetails
   - `order_detail_id` (Primary Key)
   - `order_id` (Foreign Key)
   - `product_id` (Foreign Key)
   - `quantity`
   - `price`

7. Transactions
   - `transaction_id` (Primary Key)
   - `product_id` (Foreign Key)
   - `transaction_type` (e.g., 'IN' for incoming stock, 'OUT' for outgoing stock)
   - `quantity`
   - `transaction_date`
*/

-- Create dB
CREATE DATABASE Inventory;

--- Create Tables

USE Inventory

GO

CREATE TABLE Categories (
    category_id INT IDENTITY (1,1) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
	created_at DATETIME DEFAULT GETDATE() NOT NULL
);

CREATE TABLE Suppliers (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    unique_supplier_id AS ('sup_' + CAST(supplier_id AS VARCHAR(10))) PERSISTED,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_address VARCHAR(255),
    supplier_phone VARCHAR(20),
    contact_person VARCHAR(100),
    email VARCHAR(100),
    created_at DATETIME DEFAULT GETDATE() NOT NULL
);


CREATE TABLE Products (
    product_id INT IDENTITY (1,1) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    supplier_id INT,
    quantity_in_stock INT,
    price_per_unit DECIMAL(10, 2),
	created_at DATETIME DEFAULT GETDATE() NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone_number NVARCHAR(15),
    date_of_birth DATE,
    gender CHAR(1),
    address NVARCHAR(255),
    city NVARCHAR(100),
    state NVARCHAR(100),
    postal_code NVARCHAR(20),
    country NVARCHAR(100),
    registration_date DATETIME DEFAULT GETDATE(),
    last_purchase_date DATETIME
);

CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Altering Orders

EXEC sp_rename 'Orders.customer_id', 'supplier_id', 'COLUMN';

ALTER TABLE Orders
ADD expected_delivery_date DATE,
    delivery_date DATE;

ALTER TABLE Orders
ADD CONSTRAINT FK_Order_Supplier
FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id);

CREATE TABLE OrderDetails (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Transactions (
    transaction_id INT IDENTITY (1,1) PRIMARY KEY,
    product_id INT,
	customer_id INT,
    transaction_type CHAR(3) NOT NULL CHECK (transaction_type IN ('IN', 'OUT')),
    quantity INT NOT NULL,
	created_at DATETIME DEFAULT GETDATE() NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
	FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

ALTER TABLE Transactions
ADD price DECIMAL(10, 2);


--- Inserting data into tables

-- Insert categories
INSERT INTO Categories (category_name) VALUES ('Electronics'), ('Furniture'), ('Clothing');

-- Insert suppliers
INSERT INTO Suppliers (supplier_name, supplier_address, supplier_phone, contact_person, email)
VALUES 
('Supplier A', '123 Main St, City A', '123-456-7890', 'John Doe', 'john.doe@example.com'),
('Supplier B', '456 Elm St, City B', '234-567-8901', 'Jane Smith', 'jane.smith@example.com'),
('Supplier C', '789 Oak St, City C', '345-678-9012', 'Alice Johnson', 'alice.johnson@example.com');


-- Insert products
INSERT INTO Products (product_name, category_id, supplier_id, quantity_in_stock, price_per_unit) 
VALUES 
('Laptop', 1, 1, 50, 1000.00),
('Chair', 2, 2, 200, 50.00),
('T-Shirt', 3, 1, 500, 10.00);

-- Insert customers
INSERT INTO Customers (first_name, last_name, email, phone_number, date_of_birth, gender, address, city, state, postal_code, country, registration_date, last_purchase_date)
VALUES 
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '1985-05-15', 'M', '123 Elm Street', 'Springfield', 'IL', '62704', 'USA', '2023-01-15', '2023-09-20'),
('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', '1990-08-25', 'F', '456 Oak Avenue', 'Metropolis', 'NY', '10001', 'USA', '2023-02-20', '2023-09-25'),
('Alice', 'Johnson', 'alice.johnson@example.com', '555-123-4567', '1978-12-05', 'F', '789 Pine Road', 'Gotham', 'NJ', '07001', 'USA', '2023-03-10', '2023-09-30'),
('Bob', 'Brown', 'bob.brown@example.com', '444-987-6543', '1982-03-22', 'M', '321 Maple Lane', 'Star City', 'CA', '90001', 'USA', '2023-04-05', '2023-10-01');

-- Insert transactions
INSERT INTO Transactions (product_id, customer_id, transaction_type, quantity) 
VALUES 
(1, 4, 'IN', 50),
(2, 2, 'OUT', 20),
(3, 2, 'IN', 100);

-- Insert Orders table
INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2024-01-15'),
(2, '2024-02-20'),
(3, '2024-03-25'),
(1, '2024-04-10'),
(2, '2024-05-05');

-- Insert Order details table
INSERT INTO OrderDetails (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 19.99),
(2, 2, 1, 49.99),
(3, 3, 3, 29.99),
(1, 1, 1, 9.99),
(2, 2, 4, 39.99);

-- Query to check tables

--- Categories
SELECT *
FROM Categories;

--- Customers
SELECT *
FROM Customers;

--- Products
SELECT *
FROM Products;

--- Suppliers
SELECT *
FROM Suppliers;

--- Transactions
SELECT *
FROM Transactions;

--- Orders
SELECT *
FROM Orders;

-- OrderDetails
SELECT *
FROM OrderDetails

-- Procedure to insert products

USE Inventory

GO
CREATE PROCEDURE InsertProduct
    @product_name VARCHAR(100),
    @category_id INT,
    @supplier_id INT,
    @quantity_in_stock INT,
    @price_per_unit DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Products (product_name, category_id, supplier_id, quantity_in_stock, price_per_unit)
    VALUES (@product_name, @category_id, @supplier_id, @quantity_in_stock, @price_per_unit);
END;

-- Procedure to insert Categories

GO

CREATE PROCEDURE InsertCategories
    @category_name VARCHAR(100)
AS
BEGIN
    INSERT INTO Categories (category_name)
    VALUES (@category_name);
END;

-- Procedure to insert Suppliers
GO

CREATE PROCEDURE InsertSupplier
    @SupplierName NVARCHAR(100),
	@SupplierAddress NVARCHAR (255),
	@SupplierPhone NVARCHAR (15),
    @ContactPerson NVARCHAR(100),
    @Email NVARCHAR(50)
AS
BEGIN
INSERT INTO Suppliers (supplier_name, supplier_address, supplier_phone, contact_person, email)
    VALUES (@SupplierName, @SupplierAddress, @SupplierPhone, @ContactPerson, @Email);
END;


--Procedure to insert Customer
GO 

CREATE PROCEDURE InsertCustomer
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100),
    @phone_number NVARCHAR(15),
    @date_of_birth DATE,
    @gender CHAR(1),
    @address NVARCHAR(255),
    @city NVARCHAR(100),
    @state NVARCHAR(100),
    @postal_code NVARCHAR(20),
    @country NVARCHAR(100),
    @new_customer_id INT OUTPUT
AS
BEGIN
    -- Check for duplicate email
    IF EXISTS (SELECT 1 FROM Customers WHERE email = @Email)
    BEGIN
        RAISERROR('Email already exists.', 16, 1);
        RETURN;
    END

    -- Insert new customer
    INSERT INTO Customers (first_name, last_name, email, phone_number, date_of_birth, gender, address, city, state, postal_code, country)
    VALUES (@first_name, @last_name, @email, @phone_number, @date_of_birth, @gender, @address, @city, @state, @postal_code, @country);

    -- Get the new CustomerID
    SET @new_customer_id = SCOPE_IDENTITY();
END;

-- Procedure to update stock and store outgoing from buyers and incoming from suppliers
--- Create tables for transactions in and out

CREATE TABLE Transactions_IN (
    transaction_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    supplier_id NVARCHAR(100),
    price DECIMAL(10, 2),
    transaction_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE Transactions_OUT (
    transaction_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    customer_id NVARCHAR(100),
    price DECIMAL(10, 2),
    transaction_date DATETIME DEFAULT GETDATE()
);

--- Insert Trigger
GO

CREATE TRIGGER trg_AfterInsertTransaction
ON Transactions
AFTER INSERT
AS
BEGIN
    INSERT INTO Transactions_IN (transaction_id, product_id, quantity, supplier_id, price, transaction_date)
    SELECT transaction_id, product_id, quantity, customer_id, price, created_at
    FROM inserted
    WHERE transaction_type = 'IN';

    INSERT INTO Transactions_OUT (transaction_id, product_id, quantity, customer_id, price, transaction_date)
    SELECT transaction_id, product_id, quantity, customer_id, price, created_at
    FROM inserted
    WHERE transaction_type = 'OUT';
END;


--- Create stored procedure
GO

CREATE PROCEDURE UpdateStock
    @product_id INT,
    @quantity INT,
    @transaction_type CHAR(3),
    @customer_id INT
AS
BEGIN
    DECLARE @price DECIMAL(10, 2);

    -- Get the price of the product from the Products table
    SELECT @price = price_per_unit FROM Products WHERE product_id = @product_id;

    -- Validate customer_id based on transaction type
    IF @transaction_type = 'IN'
    BEGIN
        -- Check if customer_id is a valid supplier
        IF EXISTS (SELECT 1 FROM Suppliers WHERE supplier_id = @customer_id)
        BEGIN
            UPDATE Products
            SET quantity_in_stock = quantity_in_stock + @quantity
            WHERE product_id = @product_id;

            SET @price = @price * @quantity; 
        END
        ELSE
        BEGIN
            PRINT 'Invalid supplier ID for IN transaction.';
            RETURN;
        END
    END
    ELSE IF @transaction_type = 'OUT'
    BEGIN
        -- Ensure customer_id is an integer (this is implicit as customer_id is declared as INT)
        UPDATE Products
        SET quantity_in_stock = quantity_in_stock - @quantity
        WHERE product_id = @product_id;

        SET @price = @price * @quantity;  
    END

    -- Insert the transaction record
    INSERT INTO Transactions (product_id, transaction_type, quantity, customer_id, price)
    VALUES (@product_id, @transaction_type, @quantity, @customer_id, @price);
END;


-- To check general stock levels
GO

CREATE PROCEDURE CheckStock
AS
BEGIN
    SELECT product_name, quantity_in_stock
    FROM Products;
END;


-- To check specific stock level
GO

CREATE PROCEDURE CheckStockNameId
    @ProductName NVARCHAR(50) = NULL,
    @ProductID INT = NULL
AS
BEGIN
    IF @ProductName IS NOT NULL
    BEGIN
        SELECT product_name, quantity_in_stock
        FROM Products
        WHERE product_name = @ProductName;
    END
    ELSE IF @ProductID IS NOT NULL
    BEGIN
        SELECT product_name, quantity_in_stock
        FROM Products
        WHERE product_id = @ProductID;
    END
    ELSE
    BEGIN
        SELECT product_name, quantity_in_stock
        FROM Products;
    END
END;

-- To update customer details

CREATE TABLE CustomerChangeLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    ChangeDate DATETIME DEFAULT GETDATE(),
    ChangedBy NVARCHAR(100),
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX)
);

GO

CREATE PROCEDURE UpdateCustomer
    @customer_id INT,
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100),
    @phone_number NVARCHAR(15),
    @date_of_birth DATE,
    @gender CHAR(1),
    @address NVARCHAR(255),
    @city NVARCHAR(100),
    @state NVARCHAR(100),
    @postal_code NVARCHAR(20),
    @country NVARCHAR(100),
    @changedBy NVARCHAR(100)
AS
BEGIN
    DECLARE @OldValues NVARCHAR(MAX), @NewValues NVARCHAR(MAX);

    -- Capture old values
    SELECT @OldValues = CONCAT('FirstName: ', first_name, ', LastName: ', last_name, ', Email: ', email, ', PhoneNumber: ', phone_number, ', DateOfBirth: ', date_of_birth, ', Gender: ', Gender, ', Address: ', address, ', City: ', city, ', State: ', state, ', PostalCode: ', postal_code, ', Country: ', country)
    FROM Customers
    WHERE customer_id = @customer_id;

    -- Update customer details
    UPDATE Customers
    SET first_name = @first_name,
        last_name = @last_name,
        email = @email,
        phone_number = @phone_number,
        date_of_birth = @date_of_birth,
        gender = @gender,
        address = @address,
        city = @city,
        state = @state,
        postal_code = @postal_code,
        country = @country
    WHERE customer_ID = @customer_ID;

    -- Capture new values
    SELECT @NewValues = CONCAT('FirstName: ', @first_name, ', LastName: ', @last_name, ', Email: ', @email, ', PhoneNumber: ', @phone_number, ', DateOfBirth: ', @date_of_birth, ', Gender: ', @gender, ', Address: ', @address, ', City: ', @city, ', State: ', @state, ', PostalCode: ', @postal_code, ', Country: ', @country);

    -- Log the changes
    INSERT INTO CustomerChangeLog (CustomerID, ChangedBy, OldValue, NewValue)
    VALUES (@customer_id, @ChangedBy, @OldValues, @NewValues);
END;

-- To delete Customer details

CREATE TABLE CustomerDeletionLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    DeletionDate DATETIME DEFAULT GETDATE(),
    DeletedBy NVARCHAR(100),
    Reason NVARCHAR(255)
);

GO

CREATE PROCEDURE DeleteCustomer
    @customer_id INT,
    @deleted_by NVARCHAR(100),
    @reason NVARCHAR(255)
AS
BEGIN
    -- Check if the customer exists
    IF EXISTS (SELECT 1 FROM Customers WHERE customer_id = @customer_id)
    BEGIN
        -- Log the deletion
        INSERT INTO CustomerDeletionLog (CustomerID, DeletedBy, Reason)
        VALUES (@customer_id, @deleted_by, @reason);

        -- Delete the customer
        DELETE FROM Customers WHERE customer_ID = @customer_id;
        PRINT 'Customer deleted successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Customer not found or is still active.';
    END
END;

-- To delete categories details

CREATE TABLE CategoryDeletionLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    CategoryID INT,
    DeletionDate DATETIME DEFAULT GETDATE(),
    DeletedBy NVARCHAR(100),
    Reason NVARCHAR(255)
);

GO

CREATE PROCEDURE DeleteCategory
    @category_id INT,
    @deleted_by NVARCHAR(100),
    @reason NVARCHAR(255)
AS
BEGIN
    -- Check if the category exists
    IF EXISTS (SELECT 1 FROM Categories WHERE category_id = @category_id)
    BEGIN
        -- Log the deletion
        INSERT INTO CategoryDeletionLog (CategoryID, DeletedBy, Reason)
        VALUES (@category_id, @deleted_by, @reason);

        -- Delete the category
        DELETE FROM Categories WHERE category_id = @category_id;
        PRINT 'Category deleted successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Category not found.';
    END
END;

-- To delete Product

-- Create the ProductDeletionLog table
CREATE TABLE ProductDeletionLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT,
    DeletionDate DATETIME DEFAULT GETDATE(),
    DeletedBy NVARCHAR(100),
    Reason NVARCHAR(255)
);

GO

-- Create the DeleteProduct stored procedure
CREATE PROCEDURE DeleteProduct
    @product_id INT,
    @deleted_by NVARCHAR(100),
    @reason NVARCHAR(255)
AS
BEGIN
    -- Check if the product exists and is no longer in stock
    IF EXISTS (SELECT 1 FROM Products WHERE product_id = @product_id AND quantity_in_stock = 0)
    BEGIN
        -- Check for existing transactions
        IF NOT EXISTS (SELECT 1 FROM Transactions WHERE product_id = @product_id)
        BEGIN
            -- Log the deletion
            INSERT INTO ProductDeletionLog (ProductID, DeletionDate, DeletedBy, Reason)
            VALUES (@product_id, GETDATE(), @deleted_by, @reason);

            -- Delete the product
            DELETE FROM Products 
            WHERE product_id = @product_id;

            PRINT 'Product deleted successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Product has existing transactions and cannot be deleted.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Product not found or still in stock.';
    END
END;

-- To update supplier info
CREATE TABLE SupplierUpdateLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    SupplierID INT,
    UpdateDate DATETIME DEFAULT GETDATE(),
    UpdatedBy NVARCHAR(100),
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX)
);

GO

CREATE PROCEDURE UpdateSupplierInfo
    @supplier_id INT,
    @supplier_address NVARCHAR(100),
    @supplier_phone NVARCHAR(15),
    @contact_person NVARCHAR(100),
    @email NVARCHAR(100),
    @Updated_by NVARCHAR(100)
AS
BEGIN
    DECLARE @OldValues NVARCHAR(MAX), @NewValues NVARCHAR(MAX);

    -- Check if the supplier exists
    IF EXISTS (SELECT 1 FROM Suppliers WHERE supplier_id=@supplier_id)
    BEGIN
        -- Capture old values
        SELECT @OldValues = CONCAT('SupplierAddress: ', supplier_address,', SupplierPhone: ', supplier_phone, ', ContactPerson: ', contact_person, ', Email: ',email)
        FROM Suppliers
        WHERE supplier_id = @supplier_id;

        -- Update supplier details
        UPDATE Suppliers
        SET supplier_address = @supplier_address,
            supplier_phone = @supplier_phone,
            contact_person = @contact_person,
            email = @email
        WHERE supplier_id = @supplier_id;

        -- Capture new values
        SELECT @NewValues = CONCAT('SupplierAddress: ', @supplier_address,', SupplierPhone: ', @supplier_phone, ', ContactPerson: ', @contact_person, ', Email: ', @email);

        -- Log the update
        INSERT INTO SupplierUpdateLog (SupplierID, UpdatedBy, OldValue, NewValue)
        VALUES (@supplier_id, @updated_by, @OldValues, @NewValues);

        -- Update related products
        UPDATE Products
        SET supplier_id = @supplier_ID
        WHERE supplier_id = @supplier_ID;

        PRINT 'Supplier and related products updated successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Supplier not found.';
    END
END;

-- Low Stock update
GO

CREATE PROCEDURE LowStockAlert
    @threshold INT
AS
BEGIN
    SELECT product_name, quantity_in_stock
    FROM Products
    WHERE quantity_in_stock < @threshold;
END;

-- General Monthly report
GO

CREATE PROCEDURE GeneralMonthlySalesReport
AS
BEGIN
    SELECT product_name, SUM(quantity) AS total_sold
    FROM Transactions
    JOIN Products ON Transactions.product_id = Products.product_id
    WHERE transaction_type = 'OUT' AND MONTH(Transactions.created_at) = MONTH(GETDATE())
    GROUP BY product_name;
END;

-- Monthly Goods Sold
GO

CREATE PROCEDURE GeneralMonthlySalesSold
AS
BEGIN
    SELECT product_name, SUM(price) AS total_price
    FROM Transactions
    JOIN Products ON Transactions.product_id = Products.product_id
    WHERE transaction_type = 'OUT' AND MONTH(Transactions.created_at) = MONTH(GETDATE())
    GROUP BY product_name;
END;

-- Monthly Goods Bought
GO

CREATE PROCEDURE GeneralMonthlyGoodsBought
AS
BEGIN
    SELECT product_name, SUM(price) AS total_price
    FROM Transactions
    JOIN Products ON Transactions.product_id = Products.product_id
    WHERE transaction_type = 'IN' AND MONTH(Transactions.created_at) = MONTH(GETDATE())
    GROUP BY product_name;
END;

-- Insert New Order
GO

CREATE PROCEDURE InsertOrder
    @customer_id INT,
    @order_date DATE
AS
BEGIN
    INSERT INTO Orders (customer_id, order_date)
    VALUES (@customer_id, @order_date);
END;

--Insert Order Details
GO

CREATE PROCEDURE InsertOrderDetails
    @order_id INT,
    @product_id INT,
    @quantity INT,
    @price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO OrderDetails (order_id, product_id, quantity, price)
    VALUES (@order_id, @product_id, @quantity, @price);
END;

-- Attempt to delete product by cashier
GO

CREATE PROCEDURE AttemptDeleteProduct
    @product_id INT
AS
BEGIN
    PRINT 'You are not fit to delete.';
END;

-- General Check Supplier Performance 
GO

CREATE PROCEDURE CheckSupplierPerformance
AS
BEGIN
    -- Calculate average delivery time and number of late deliveries for each supplier
    SELECT 
        supplier_id,
        AVG(DATEDIFF(day, order_date, delivery_date)) AS Avg_Delivery_Time,
        SUM(CASE WHEN delivery_date > expected_delivery_date THEN 1 ELSE 0 END) AS Late_Deliveries
    FROM 
        Orders
    GROUP BY 
        supplier_id;
END;

-- Monthly Supplier Performance
GO

CREATE PROCEDURE MonthCheckSupplierPerformance
    @Year INT,
    @Month INT
AS
BEGIN
    -- Calculate average delivery time and number of late deliveries for each supplier for a specific month and year
    SELECT 
        supplier_id,
        AVG(DATEDIFF(day, order_date, delivery_date)) AS Avg_Delivery_Time,
        SUM(CASE WHEN delivery_date > expected_delivery_date THEN 1 ELSE 0 END) AS Late_Deliveries
    FROM 
        Orders
    WHERE 
        YEAR(order_date) = @Year AND MONTH(order_date) = @Month
    GROUP BY 
        supplier_id;
END;


/*
Manager: Full access to all tables and stored procedures.
*/

GO

-- Create a user without a login
CREATE USER Manager WITHOUT LOGIN;
GO

-- Add the user to the db_owner role
ALTER ROLE db_owner ADD MEMBER Manager;

GO

-- Cashier: Access to view products, orders, and order details.

USE Inventory;

GO

CREATE USER Cashier WITHOUT LOGIN;
GRANT SELECT ON Products TO Cashier;
GRANT SELECT ON Orders TO Cashier;
GRANT SELECT ON OrderDetails TO Cashier;
GRANT EXECUTE ON CheckStock TO Cashier;
GRANT EXECUTE ON InsertCustomer TO Cashier;
GRANT EXECUTE ON UpdateCustomer TO Cashier;
GRANT EXECUTE ON AttemptDeleteProduct TO Cashier;


-- Last Purchase date Trigger
GO

CREATE TRIGGER trg_UpdateLastPurchaseDate
ON Transactions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Customers
    SET last_purchase_date = (SELECT MAX(created_at) 
                              FROM Transactions 
                              WHERE customer_id = inserted.customer_id)
    FROM inserted
    WHERE Customers.customer_id = inserted.customer_id;
END;