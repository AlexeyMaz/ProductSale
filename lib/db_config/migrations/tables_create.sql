use Sales;

CREATE TABLE Product (
                          product_id INT PRIMARY KEY AUTO_INCREMENT,
                          name VARCHAR(255),
                          wholesale_price DECIMAL(10,2), -- опт
                          retail_price DECIMAL(10,2) -- розница
);

CREATE TABLE Customer (
                           customer_id INT PRIMARY KEY AUTO_INCREMENT,
                           name VARCHAR(255),
                           address VARCHAR(255),
                           phone VARCHAR(20)
);

CREATE TABLE Deal (
                       deal_id INT PRIMARY KEY AUTO_INCREMENT,
                       customer_id INT,
                       product_id INT,
                       quantity INT,
                       purchase_date DATE,
                       FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
                       FOREIGN KEY (product_id) REFERENCES Product(product_id)
);