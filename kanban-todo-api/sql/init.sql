-- =============================================
-- INVENTORY MANAGEMENT SYSTEM - INITIALIZATION
-- Database: PostgreSQL
-- Author: Open Source Contributor
-- =============================================

-- 1. CLEANUP (Xóa bảng cũ nếu tồn tại để tránh lỗi khi chạy lại)
DROP TABLE IF EXISTS stock_movements CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS warehouses CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;

-- =============================================
-- 2. CREATE TABLES (Tạo bảng)
-- =============================================

-- Bảng Nhà cung cấp
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Kho hàng (Hỗ trợ đa chi nhánh)
CREATE TABLE warehouses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Sản phẩm
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL, -- Mã SKU (Mã vạch) là duy nhất
    name VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    price DECIMAL(15, 2) NOT NULL,
    cost_price DECIMAL(15, 2), -- Giá vốn
    min_stock_level INT DEFAULT 10, -- Ngưỡng cảnh báo hết hàng
    supplier_id INT REFERENCES suppliers(id) ON DELETE SET NULL,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Tồn kho (Snapshot hiện tại)
-- Lưu trữ số lượng hiện có của từng sản phẩm tại từng kho
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id) ON DELETE CASCADE,
    warehouse_id INT REFERENCES warehouses(id) ON DELETE CASCADE,
    quantity INT DEFAULT 0 CHECK (quantity >= 0), -- Không cho phép tồn kho âm
    last_updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(product_id, warehouse_id) -- Một sản phẩm ở một kho chỉ có 1 dòng ghi nhận
);

-- Bảng Lịch sử giao dịch (Audit Log)
-- Ghi lại mọi hành động Nhập/Xuất/Chuyển kho
CREATE TABLE stock_movements (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id) ON DELETE CASCADE,
    warehouse_id INT REFERENCES warehouses(id) ON DELETE CASCADE,
    quantity_change INT NOT NULL, -- Số dương (+): Nhập, Số âm (-): Xuất
    reason VARCHAR(50), -- VD: "Purchase", "Sale", "Damage", "Transfer"
    reference_id VARCHAR(50), -- Mã đơn hàng hoặc mã phiếu nhập
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50) -- Người thực hiện (User ID hoặc Email)
);

-- =============================================
-- 3. INDEXES (Tối ưu tốc độ)
-- =============================================

-- Tăng tốc độ quét mã vạch (Barcode Scanning)
CREATE INDEX idx_products_sku ON products(sku);
-- Tăng tốc độ tìm kiếm sản phẩm theo tên
CREATE INDEX idx_products_name ON products(name);
-- Tăng tốc độ lọc lịch sử giao dịch theo kho và thời gian
CREATE INDEX idx_movements_warehouse_date ON stock_movements(warehouse_id, created_at);

-- =============================================
-- 4. AUTOMATION (Trigger tự động cập nhật kho)
-- =============================================

-- Hàm xử lý: Khi có giao dịch mới -> Tự động cập nhật bảng inventory
CREATE OR REPLACE FUNCTION update_inventory_after_movement()
RETURNS TRIGGER AS $$
BEGIN
    -- Upsert: Nếu chưa có dòng inventory thì tạo mới, nếu có rồi thì cập nhật cộng dồn
    INSERT INTO inventory (product_id, warehouse_id, quantity, last_updated)
    VALUES (NEW.product_id, NEW.warehouse_id, NEW.quantity_change, NOW())
    ON CONFLICT (product_id, warehouse_id) 
    DO UPDATE SET 
        quantity = inventory.quantity + NEW.quantity_change,
        last_updated = NOW();
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Gắn hàm trên vào bảng stock_movements
CREATE TRIGGER trigger_auto_update_inventory
AFTER INSERT ON stock_movements
FOR EACH ROW
EXECUTE FUNCTION update_inventory_after_movement();

-- =============================================
-- 5. SEED DATA (Dữ liệu mẫu cho Demo)
-- =============================================

-- Tạo nhà cung cấp mẫu
INSERT INTO suppliers (name, email, phone) VALUES 
('Apple Distribution', 'contact@apple-dist.com', '0901234567'),
('Samsung Electronics', 'b2b@samsung.com', '0909888777');

-- Tạo kho hàng mẫu
INSERT INTO warehouses (name, location) VALUES 
('Kho Chính (HCM)', 'Quận 7, TP.HCM'),
('Kho Hà Nội', 'Cầu Giấy, Hà Nội');

-- Tạo sản phẩm mẫu (iPhone, Samsung)
INSERT INTO products (sku, name, price, min_stock_level, supplier_id) VALUES 
('8931234567890', 'iPhone 15 Pro Max 256GB', 29990000, 5, 1),
('8939876543210', 'Samsung Galaxy S24 Ultra', 26990000, 5, 2),
('KB-LOGI-MX', 'Bàn phím Logitech MX Keys', 2500000, 10, NULL);

-- Giả lập nhập kho đầu kỳ (Sẽ tự động kích hoạt Trigger để cập nhật inventory)
INSERT INTO stock_movements (product_id, warehouse_id, quantity_change, reason, reference_id, created_by) VALUES 
(1, 1, 50, 'Initial Stock', 'INIT-001', 'admin'), -- Nhập 50 iPhone vào kho HCM
(1, 2, 20, 'Initial Stock', 'INIT-002', 'admin'), -- Nhập 20 iPhone vào kho HN
(2, 1, 30, 'Initial Stock', 'INIT-001', 'admin'); -- Nhập 30 Samsung vào kho HCM

-- =============================================
-- END OF FILE
-- =============================================
```

### Cách sử dụng file `init.sql` này

Bạn có 2 cách phổ biến để chạy file này:

#### Cách 1: Dùng Docker (Khuyên dùng cho Open Source)
Nếu bạn dùng Docker Compose, bạn chỉ cần đặt file `init.sql` này vào cùng thư mục với `docker-compose.yml`.

Trong file `docker-compose.yml`, bạn thêm dòng cấu hình `volumes` như sau:

```yaml
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: adminpassword
      POSTGRES_DB: inventory_db
    volumes:
      # Dòng này sẽ copy file init.sql vào thư mục đặc biệt của Docker
      # Postgres sẽ tự động chạy file này ngay lần đầu tiên khởi động container
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
```

#### Cách 2: Chạy thủ công (Nếu cài Postgres trực tiếp trên máy)
Nếu bạn đã cài PostgreSQL trên máy tính, bạn mở Terminal/Command Prompt lên và chạy lệnh sau:

```bash
psql -U postgres -d inventory_db -f init.sql