CREATE DATABASE Instacart;

USE Instacart;

CREATE TABLE Departments
(
  department_id INT NOT NULL,
  department VARCHAR(50) NOT NULL,
  PRIMARY KEY (department_id)
);

CREATE TABLE Aisles
(
  aisle_id INT NOT NULL,
  aisle VARCHAR(80) NOT NULL,
  department_id INT NOT NULL,
  PRIMARY KEY (aisle_id),
  FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Products
(
  product_id INT NOT NULL,
  product_name VARCHAR(1000) NOT NULL,
  aisle_id INT NOT NULL,
  PRIMARY KEY (product_id),
  FOREIGN KEY (aisle_id) REFERENCES Aisles(aisle_id)
);

CREATE TABLE Orders
(
  order_id INT NOT NULL,
  user_id INT NOT NULL,
  order_number INT NOT NULL,
  order_dow INT NOT NULL,
  order_hour_of_day INT NOT NULL,
  days_since_prior_order INT NOT NULL,
  PRIMARY KEY (order_id)
);

CREATE TABLE Order_products
(
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  add_to_cart_order INT NOT NULL,
  reordered INT NOT NULL,
  PRIMARY KEY (product_id, order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  UNIQUE (product_id, order_id)
);

SET FOREIGN_KEY_CHECKS=0;

LOAD DATA LOCAL INFILE '/Users/bryton/Desktop/Courses/Database for Data Science/Data/Instacart/departments.csv'
INTO TABLE Departments
COLUMNS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/bryton/Desktop/Courses/Database for Data Science/Data/Instacart_normalize/aisles.csv'
INTO TABLE Aisles
COLUMNS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE '/Users/bryton/Desktop/Courses/Database for Data Science/Data/Instacart/products.csv'
INTO TABLE Products
COLUMNS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/bryton/Desktop/Courses/Database for Data Science/Data/Instacart/orders.csv'
INTO TABLE Orders
COLUMNS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/bryton/Desktop/Courses/Database for Data Science/Data/Instacart/order_products.csv'
INTO TABLE Order_products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


LOAD DATA FROM s3 's3://s3instacart/departments.csv'
INTO TABLE Departments
COLUMNS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA FROM s3 's3://s3instacart/aisles.csv'
INTO TABLE Aisles
COLUMNS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


LOAD DATA FROM s3 's3://s3instacart/products.csv'
INTO TABLE Products
COLUMNS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA FROM s3 's3://s3instacart/orders.csv'
INTO TABLE Orders
COLUMNS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

LOAD DATA FROM s3 's3://s3instacart/order_products.csv'
INTO TABLE Order_products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
