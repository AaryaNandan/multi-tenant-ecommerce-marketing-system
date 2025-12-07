-- CRUD examples for main tables (condensed)

-- Create (INSERT)
-- Users: see seed file

-- Read
SELECT * FROM Products WHERE active=1 LIMIT 20;

-- Update
UPDATE Inventory SET quantity_on_hand = quantity_on_hand - 1 WHERE product_id = 3;

-- Delete (soft delete recommended)
UPDATE Vendors SET status='deleted' WHERE vendor_id = 3;

-- 12 required queries (Q1..Q12)

-- Q1 Top sellers per category (by units sold) — uses OrderItems join to ProductCategory
SELECT c.category_id, c.name AS category,
       oi.product_id, p.name AS product,
       SUM(oi.quantity) AS units_sold,
       RANK() OVER (PARTITION BY c.category_id ORDER BY SUM(oi.quantity) DESC) AS rnk
FROM OrderItems oi
JOIN Products p ON p.product_id = oi.product_id
JOIN ProductCategory pc ON pc.product_id = p.product_id
JOIN Categories c ON c.category_id = pc.category_id
GROUP BY c.category_id, oi.product_id
HAVING units_sold > 0
ORDER BY c.category_id, units_sold DESC;

-- Q2 Low-stock alerts
SELECT p.product_id, p.name, i.quantity_on_hand, i.reorder_level
FROM Inventory i JOIN Products p ON p.product_id = i.product_id
WHERE i.quantity_on_hand <= i.reorder_level;

-- Q3 Conversion rate (carts -> orders) by week
SELECT YEAR(o.created_at) AS yr, WEEK(o.created_at) AS wk,
       COUNT(DISTINCT c.cart_id) AS carts_created,
       COUNT(DISTINCT o.order_id) AS orders_placed,
       ROUND(100.0 * COUNT(DISTINCT o.order_id) / NULLIF(COUNT(DISTINCT c.cart_id),0),2) AS conversion_pct
FROM Carts c
LEFT JOIN Orders o ON o.user_id = c.user_id AND o.created_at BETWEEN c.created_at AND DATE_ADD(c.created_at, INTERVAL 7 DAY)
GROUP BY yr, wk
ORDER BY yr DESC, wk DESC;

-- Q4 Customers also bought (co-occurrence)
SELECT t.product_id, t.also_product_id, COUNT(*) AS freq
FROM (
  SELECT oi1.order_id, oi1.product_id, oi2.product_id AS also_product_id
  FROM OrderItems oi1
  JOIN OrderItems oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id <> oi2.product_id
) t
GROUP BY t.product_id, t.also_product_id
ORDER BY t.product_id, freq DESC;

-- Q5 Average rating & count per product
SELECT p.product_id, p.name, COUNT(r.review_id) AS review_count, ROUND(AVG(r.rating),2) AS avg_rating
FROM Products p LEFT JOIN Reviews r ON r.product_id = p.product_id
GROUP BY p.product_id;

-- Q6 Order value distribution by vendor
SELECT oi.vendor_id, v.name AS vendor, COUNT(DISTINCT oi.order_id) AS orders_count, SUM(oi.quantity * oi.unit_price) AS revenue
FROM OrderItems oi JOIN Vendors v ON v.vendor_id = oi.vendor_id
GROUP BY oi.vendor_id;

-- Q7 Refund rate per product
SELECT oi.product_id, p.name,
       SUM(CASE WHEN pay.status='refunded' THEN oi.quantity ELSE 0 END) AS refunded_units,
       SUM(oi.quantity) AS total_units,
       ROUND(100.0 * SUM(CASE WHEN pay.status='refunded' THEN oi.quantity ELSE 0 END) / NULLIF(SUM(oi.quantity),0),2) AS refund_pct
FROM OrderItems oi
LEFT JOIN Orders o ON o.order_id = oi.order_id
LEFT JOIN Payments pay ON pay.order_id = oi.order_id
LEFT JOIN Products p ON p.product_id = oi.product_id
GROUP BY oi.product_id;

-- Q8 Abandoned carts older than 7 days
SELECT c.cart_id, c.user_id, c.created_at, TIMESTAMPDIFF(DAY, c.updated_at, NOW()) AS days_since_update
FROM Carts c
LEFT JOIN Orders o ON o.user_id = c.user_id AND o.created_at > c.created_at
WHERE o.order_id IS NULL AND c.updated_at < DATE_SUB(NOW(), INTERVAL 7 DAY);

-- Q9 Orders pending shipment > 48h
SELECT o.order_id, o.created_at, TIMESTAMPDIFF(HOUR, o.created_at, NOW()) AS hours_pending
FROM Orders o
LEFT JOIN Shipments s ON s.order_id = o.order_id
WHERE o.status IN ('paid','processing') AND (s.shipped_at IS NULL OR s.status!='shipped') AND TIMESTAMPDIFF(HOUR, o.created_at, NOW()) > 48;

-- Q10 View: vw_vendor_dashboard(vendor_id)
CREATE OR REPLACE VIEW vw_vendor_dashboard AS
SELECT v.vendor_id, v.name AS vendor_name,
       COALESCE(SUM(oi.quantity * oi.unit_price),0) AS total_revenue,
       COALESCE(SUM(CASE WHEN s.status='delivered' THEN 1 ELSE 0 END),0) AS shipments_delivered,
       COALESCE(SUM(CASE WHEN i.quantity_on_hand <= i.reorder_level THEN 1 ELSE 0 END),0) AS low_stock_count
FROM Vendors v
LEFT JOIN OrderItems oi ON oi.vendor_id = v.vendor_id
LEFT JOIN Orders o ON o.order_id = oi.order_id
LEFT JOIN Shipments s ON s.order_id = o.order_id
LEFT JOIN Products p ON p.vendor_id = v.vendor_id
LEFT JOIN Inventory i ON i.product_id = p.product_id
GROUP BY v.vendor_id;

-- Q11 Top sellers per vendor (by revenue)
SELECT v.vendor_id, v.name, SUM(oi.quantity * oi.unit_price) AS revenue
FROM OrderItems oi JOIN Vendors v ON v.vendor_id = oi.vendor_id
GROUP BY v.vendor_id ORDER BY revenue DESC LIMIT 20;

-- Q12 Search: full-text (example using MATCH in MySQL)
SELECT product_id, name, description
FROM Products
WHERE MATCH(name, description) AGAINST('"ceramic mug"' IN BOOLEAN MODE)
LIMIT 20;
