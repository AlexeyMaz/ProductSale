use Sales;

INSERT INTO Product (product_name, wholesale_price, retail_price)
VALUES
    ('Product A', 10, 15),
    ('Product B', 8, 12),
    ('Product C', 5, 9);

INSERT INTO Customer (customer_name, address, phone)
VALUES
    ('John Doe', '123 Main St', '79189443512'),
    ('Jane Smith', '456 Elm St', '79000451312'),
    ('Mike Johnson', '789 Oak St', '74955023188');

INSERT INTO Deal (customer_id, product_id, quantity, purchase_date)
VALUES
    (1, 1, 2, '2023-05-15'),
    (2, 2, 1, '2023-05-16'),
    (2, 1, 3, '2023-05-17');
