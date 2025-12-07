-- Sample seed data for Multi-Vendor Marketplace
-- NOTE: Adjust AUTO_INCREMENT starting values as needed when importing.

-- Users
INSERT INTO Users (name, email, password_hash, role) VALUES
('Alice Shopper','alice@example.com','hash_a','customer'),
('Bob Buyer','bob@example.com','hash_b','customer'),
('Carol VendorOwner','carol@example.com','hash_c','vendor_owner'),
('Dan VendorOwner','dan@example.com','hash_d','vendor_owner'),
('Eve Admin','eve@example.com','hash_e','admin'),
('Frank Shopper','frank@example.com','hash_f','customer');

-- Vendors (owner_user_id references Users)
INSERT INTO Vendors (user_id, name, description) VALUES
(3,'Carol Crafts','Handmade goods by Carol'),
(4,'Dan Deals','Electronics and gadgets'),
(3,'Carol Outlet','Carol\'s discounted items');

-- Categories
INSERT INTO Categories (name, description) VALUES
('Home','Home & living'),
('Electronics','Gadgets and devices'),
('Fashion','Clothing and accessories'),
('Toys','Kids and games'),
('Books','Printed books and ebooks');

-- Products (vendor_id must match above)
INSERT INTO Products (vendor_id, name, description, sku, price, active) VALUES
(1,'Handmade Mug','Ceramic mug, 350ml','MUG-001',12.50,1),
(1,'Knitted Scarf','Wool scarf, winter','SCARF-01',25.00,1),
(2,'Bluetooth Speaker','Portable speaker, 10W','SPK-10',45.00,1),
(2,'USB-C Cable','1.5m cable','CABL-1.5',7.99,1),
(2,'Wireless Mouse','Bluetooth mouse','MOUSE-01',19.99,1),
(3,'Clearance Mug','Old stock ceramic mug','MUG-CLR-1',6.00,1),
(1,'Handmade Bowl','Small ceramic bowl','BOWL-01',9.75,1),
(2,'Smart Lamp','WiFi smart lamp','LAMP-01',34.90,1),
(1,'Beaded Bracelet','Handmade bracelet','BRACE-1',8.50,1),
(2,'Kids Drone','Toy drone','DRONE-01',79.99,1),
(3,'Used Book: Algorithms','Second-hand copy','BOOK-ALG-1',12.00,1),
(2,'Phone Stand','Adjustable phone stand','STAND-1',11.50,1);

-- Inventory (one row per product)
INSERT INTO Inventory (product_id, quantity_on_hand, reorder_level, reserved) VALUES
(1,50,10,0),(2,30,5,0),(3,20,5,0),(4,100,20,0),(5,60,10,0),(6,5,5,0),(7,40,8,0),(8,15,3,0),(9,25,5,0),(10,8,3,0),(11,12,2,0),(12,200,50,0);

-- Carts
INSERT INTO Carts (user_id) VALUES (1),(2),(6);

-- CartItems
INSERT INTO CartItems (cart_id, product_id, quantity) VALUES
(1,1,2),(1,4,1),(2,3,1),(2,10,1),(3,12,2);

-- Orders (some sample orders demonstrating multi-vendor)
INSERT INTO Orders (user_id, total_amount, status) VALUES
(1,37.99,'paid'),
(2,79.99,'paid'),
(6,18.50,'processing'),
(1,6.00,'delivered'),
(2,91.49,'pending'),
(1,24.25,'paid');

-- OrderItems (snapshot vendor_id and unit_price)
INSERT INTO OrderItems (order_id, product_id, vendor_id, quantity, unit_price) VALUES
(1,1,1,2,12.50),(1,4,2,1,7.99),
(2,10,2,1,79.99),
(3,5,2,1,19.99),(3,9,1,1,8.50),
(4,6,3,1,6.00),
(5,8,2,1,34.90),(5,12,2,1,11.50),
(6,7,1,1,9.75);

-- Payments
INSERT INTO Payments (order_id, amount, method, provider_txn, status) VALUES
(1,37.99,'card','txn_1001','captured'),
(2,79.99,'card','txn_1002','captured'),
(3,18.50,'paypal','txn_1003','authorized'),
(4,6.00,'card','txn_1004','captured'),
(5,91.49,'card','txn_1005','authorized'),
(6,24.25,'card','txn_1006','captured');

-- Shipments
INSERT INTO Shipments (order_id, carrier, tracking_no, shipped_at, delivered_at, status) VALUES
(1,'FastShip','FS1001',NOW(),NULL,'shipped'),
(2,'PostX','PX2002',NOW(),NOW(),'delivered'),
(4,'PostX','PX2004',NOW(),NOW(),'delivered');

-- Reviews (only for delivered orders or sample data)
INSERT INTO Reviews (user_id, product_id, rating, comment) VALUES
(2,10,5,'Kids love it!'),
(1,1,4,'Nice mug, good quality'),
(2,3,4,'Great speaker for price'),
(1,6,3,'Clearance item okay'),
(6,12,5,'Very handy!'),
(1,7,4,'Looks great on table');
