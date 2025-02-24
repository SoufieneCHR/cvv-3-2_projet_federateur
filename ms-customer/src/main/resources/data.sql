CREATE TABLE IF NOT EXISTS customer(
    customer_id int AUTO_INCREMENT PRIMARY KEY,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    email varchar(100) NOT NULL,
    mobile_number varchar(20) NOT NULL
);

INSERT INTO customer (first_name, last_name, email, mobile_number) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321');