# Relational Schema Draft (tables, columns, PK/FK)

Users(user_id PK, name, email UNIQUE, password_hash, role ENUM('customer','vendor_owner','admin'), created_at)
Vendors(vendor_id PK, user_id FK -> Users(user_id), name, description, status ENUM('active','suspended','deleted'), created_at)
Products(product_id PK, vendor_id FK -> Vendors(vendor_id), name, description, sku, price DECIMAL(10,2), active BOOL, created_at)
Categories(category_id PK, name, description)
ProductCategory(product_id FK, category_id FK, PRIMARY KEY(product_id, category_id))
Inventory(inventory_id PK, product_id FK -> Products(product_id) UNIQUE, quantity_on_hand INT, reorder_level INT, reserved INT DEFAULT 0)
Carts(cart_id PK, user_id FK -> Users(user_id), created_at, updated_at)
CartItems(cart_item_id PK, cart_id FK -> Carts(cart_id), product_id FK -> Products(product_id), quantity INT, added_at)
Orders(order_id PK, user_id FK -> Users(user_id), total_amount DECIMAL(12,2), status ENUM('pending','paid','processing','shipped','delivered','cancelled','refunded'), created_at)
OrderItems(order_item_id PK, order_id FK -> Orders(order_id), product_id FK -> Products(product_id), vendor_id FK -> Vendors(vendor_id), quantity INT, unit_price DECIMAL(10,2))
Payments(payment_id PK, order_id FK -> Orders(order_id), amount DECIMAL(12,2), method VARCHAR(50), provider_txn VARCHAR(255), status ENUM('authorized','captured','failed','refunded'), created_at)
Shipments(shipment_id PK, order_id FK -> Orders(order_id), carrier VARCHAR(100), tracking_no VARCHAR(255), shipped_at DATETIME, delivered_at DATETIME, status ENUM('pending','shipped','in_transit','delivered','returned')) 
Reviews(review_id PK, user_id FK -> Users(user_id), product_id FK -> Products(product_id), rating INT CHECK (rating BETWEEN 1 AND 5), comment TEXT, created_at)

Notes:
- `Inventory.reserved` stores units reserved by pending orders to avoid oversell; reserved + quantity_on_hand must not go negative.
- OrderItem stores `vendor_id` and `unit_price` snapshot to keep historical accuracy.
