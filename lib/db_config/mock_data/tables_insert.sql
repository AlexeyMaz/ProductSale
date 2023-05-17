use Sales;

INSERT INTO Product (product_name, wholesale_price, retail_price)
VALUES
    ('Product A', 10.50, 15.99),
    ('Product B', 8.75, 12.99),
    ('Product C', 5.99, 9.99);

INSERT INTO Customer (customer_name, address, phone)
VALUES
    ('John Doe', '123 Main St', '555-1234'),
    ('Jane Smith', '456 Elm St', '555-5678'),
    ('Mike Johnson', '789 Oak St', '555-9012');

INSERT INTO Deal (customer_id, product_id, quantity, purchase_date)
VALUES
    (1, 1, 2, '2023-05-15'),
    (2, 3, 1, '2023-05-16'),
    (3, 2, 3, '2023-05-17');
