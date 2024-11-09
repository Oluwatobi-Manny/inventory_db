*This SQL project aims to develop a robust and efficient Inventory Management System (IMS) to track and manage a company's inventory.*

# Use Case: Inventory Management System

**Objective:** To manage and track the inventory of products in a warehouse using an SQL database.

**Key Features:**

1. **Product Information:**
   * **Product ID:** Unique identifier for each product.
   * **Product Name:** Descriptive name of the product.
   * **Category:** Categorization of products for better organization.
   * **Supplier:** Information about the product supplier.
   * **Cost Price:** Purchase cost of the product.
   * **Selling Price:** Retail price of the product.

2. **Inventory Levels:**
   * **Quantity on Hand:** Current stock level of the product.
   * **Reorder Level:** Minimum stock level to trigger a purchase order.
   * **Reorder Quantity:** Quantity to order when stock reaches the reorder level.

3. **Purchase Orders:**
   * **Purchase Order Number:** Unique identifier for each purchase order.
   * **Supplier:** Supplier information.
   * **Order Date:** Date the order was placed.
   * **Expected Delivery Date:** Estimated delivery date.
   * **Order Details:** List of products ordered, quantities, and prices.

4. **Sales Orders:**
   * **Sales Order Number:** Unique identifier for each sales order.
   * **Customer Information:** Customer details.
   * **Order Date:** Date the order was placed.
   * **Order Details:** List of products sold, quantities, and prices.

5. **Reports and Analytics:**
   * **Inventory Reports:** Generate reports on low-stock items and product performance.
   * **Sales Reports:** Analyze sales trends, top-selling products, and customer purchasing behavior.
   * **Purchase Reports:** Track purchasing trends, supplier performance, and cost analysis.

**Schema:**
```sql
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
```

**Operations:**

1. **Add a new product:**
```sql
-- Insert products
INSERT INTO Products (product_name, category_id, supplier_id, quantity_in_stock, price_per_unit) 
VALUES 
('Laptop', 1, 1, 50, 1000.00),
('Chair', 2, 2, 200, 50.00),
('T-Shirt', 3, 1, 500, 10.00);
```

2. **Update inventory for a product:**
```sql
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
```

3. **Check stock levels for a product:**
```sql
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
```

4. **Get products below a certain stock level:**
```sql
CREATE PROCEDURE LowStockAlert
    @threshold INT
AS
BEGIN
    SELECT product_name, quantity_in_stock
    FROM Products
    WHERE quantity_in_stock < @threshold;
END;
```

5. **Generate monthly reports:**
```sql
CREATE PROCEDURE GeneralMonthlySalesReport
AS
BEGIN
    SELECT product_name, SUM(quantity) AS total_sold
    FROM Transactions
    JOIN Products ON Transactions.product_id = Products.product_id
    WHERE transaction_type = 'OUT' AND MONTH(Transactions.created_at) = MONTH(GETDATE())
    GROUP BY product_name;
END;
```

This basic inventory management system allows you to add new products, update inventory levels, check stock levels, find products that are low in stock, and update product details.

Feel free to expand on this system to include more features such as tracking sales, generating reports, and managing multiple warehouses. Let me know if you need any more help!


**SQL Implementation:**

* **Database Design:** Create a relational database with tables for products, categories, suppliers, purchase orders, sales orders, and inventory levels.
* **Data Entry:** Populate the database with accurate and up-to-date product information, inventory levels, and transaction details.
* **SQL Queries:** Use SQL queries to retrieve, update, and analyze inventory data. For example:
  ```sql
  -- Retrieve low-stock items
  SELECT product_name, quantity_on_hand
  FROM products
  WHERE quantity_on_hand < reorder_level;

  -- Calculate total sales revenue
  SELECT SUM(quantity * selling_price) AS total_revenue
  FROM sales_orders
  JOIN order_details ON sales_orders.order_id = order_details.order_id;
  ```
* **User Interface:** Develop a user-friendly interface (e.g., web-based or command-line) to interact with the system.

**Benefits:**

* **Improved Inventory Accuracy:** Real-time tracking of stock levels reduces stockouts and overstock.
* **Efficient Order Processing:** Automated order fulfillment and purchase order generation save time and effort.
* **Data-Driven Decisions:** Data-driven insights help optimize inventory levels and purchasing strategies.
* **Cost Reduction:** Minimized inventory holding costs and reduced losses.
* **Enhanced Customer Satisfaction:** Timely order fulfillment and product availability improve customer satisfaction.

By implementing this Inventory Management System, "The Gadget Shop" can streamline its operations, reduce costs, and improve overall business performance.
