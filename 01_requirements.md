# Requirements & Case Brief

**Narrative (half-page)**
The marketplace connects multiple independent vendors with customers through a unified shopping experience. Vendors can register, upload product listings (with categories and inventory levels), and manage orders. Customers browse products, add items to carts, checkout (with payment authorization), and track shipments. Admins moderate vendors, products, and reviews to enforce policies. Key operations include product search and discovery, cart lifecycle (add/update/abandon), placing and paying orders (atomic reservation of stock), shipment tracking, and review moderation. The system must support vendor dashboards that show sales, low-stock alerts, and fulfillment metrics.

**Primary users**
- Customer: browse, purchase, review
- Vendor: manage products, inventory, view orders
- Admin: moderate content, manage users

**Business rules (12)**
1. Inventory cannot go negative; stock must be reserved at order placement.
2. A product may belong to multiple categories (M–M).
3. A user may only leave a review for products they purchased and for which the order is delivered.
4. Vendors can create and manage only their own products; admins can manage all.
5. An order belongs to one buyer but can contain items from multiple vendors.
6. Payment must be authorized (or transactions rolled back) before confirming order.
7. Cart items older than 7 days without checkout are considered abandoned.
8. Low-stock alert triggers when `quantity_on_hand <= reorder_level`.
9. SKU codes are unique per vendor; global product IDs are unique across system.
10. Refunds cannot exceed the original paid amount and update inventory accordingly.
11. Deleting a vendor with active products/orders is restricted (soft-delete recommended).
12. Sensitive customer data (payment tokens) stored encrypted or tokenized.
