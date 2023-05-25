use Sales;
-- select * from Product;
CREATE TABLE Product (
                          product_id INT PRIMARY KEY AUTO_INCREMENT,
                          product_name VARCHAR(255) NOT NULL ,
                          wholesale_price INT NOT NULL , -- опт
                          retail_price INT NOT NULL -- розница
);

CREATE TABLE Customer (
                           customer_id INT PRIMARY KEY AUTO_INCREMENT,
                           customer_name VARCHAR(255) NOT NULL,
                           address VARCHAR(255),
                           phone VARCHAR(20)
);

CREATE TABLE Deal (
                       deal_id INT PRIMARY KEY AUTO_INCREMENT,
                       customer_id INT,
                       product_id INT,
                       quantity INT NOT NULL CHECK (quantity > 0),
                       purchase_date DATE NOT NULL,
                       FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
                       FOREIGN KEY (product_id) REFERENCES Product(product_id)
);