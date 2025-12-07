# ER Notes: Entities & Relationships

**Entities (core)**
- User (user_id PK): customer or admin; attributes: name, email, role, created_at
- Vendor (vendor_id PK): name, owner_user_id (FK to User), status
- Product (product_id PK): vendor_id FK, name, description, sku, price, active
- Category (category_id PK): name, description
- ProductCategory (product_id, category_id) associative
- Inventory (inventory_id PK): product_id FK, quantity_on_hand, reorder_level
- Cart (cart_id PK): user_id FK, created_at, updated_at
- CartItem (cart_item_id PK): cart_id FK, product_id FK, qty, added_at
- Order (order_id PK): user_id FK, total_amount, status, created_at
- OrderItem (order_item_id PK): order_id FK, product_id FK, vendor_id, qty, price_at_purchase
- Payment (payment_id PK): order_id FK, amount, status, provider_txn, created_at
- Shipment (shipment_id PK): order_id FK, shipped_at, delivered_at, status, tracking_no
- Review (review_id PK): user_id FK, product_id FK, rating, comment, created_at

**Relationships**
- User 1–M Order (user places many orders)
- Vendor 1–M Product (vendor lists many products)
- Product M–M Category via ProductCategory
- Order 1–M OrderItem; OrderItem links to Product (and stores vendor_id snapshot)
- Cart 1–M CartItem; CartItem references Product
- Product 1–1 Inventory (or 1–M if multiple warehouses)

**Strong vs Weak**
- Strong: User, Vendor, Product, Order, Category
- Weak/Dependent: CartItem, OrderItem, ProductCategory (associative)

**Participation & Cardinalities**
- Product must belong to exactly one Vendor (total participation)
- Order must be placed by one User (total participation)
- CartItem partially participates (cart can be empty)
