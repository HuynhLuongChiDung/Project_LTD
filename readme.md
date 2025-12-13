# OpenStock – Hệ thống Quản lý Kho Hàng (WMS)

*Hệ thống quản lý kho hàng hiện đại, mã nguồn mở – Đồ án môn Phát triển Ứng dụng Mã nguồn mở – BDU 2025*

## Giới thiệu dự án

Dự án được phát triển như một phần của đồ án môn **Phát triển Ứng dụng Mã nguồn mở** – Trường Đại học Bình Dương năm 2025.

Mục tiêu:
- Xây dựng hệ thống quản lý kho hiện đại với giao diện thân thiện
- Áp dụng kiến thức FastAPI, React, database migrations và authentication
- Tạo nền tảng có thể mở rộng, dễ bảo trì và triển khai

## Tính năng chính

- **Dashboard tổng quan**: Biểu đồ nhập/xuất kho, thống kê doanh thu, đơn hàng cần xử lý, vị trí kho
- **Quản lý hàng hóa**: Danh sách sản phẩm tồn kho, lọc theo danh mục/trạng thái/nhà cung cấp, import/export Excel
- **Quản lý nhập kho (Inbound)**: Tạo phiếu nhập, theo dõi nhà cung cấp, ngày dự kiến
- **Quản lý xuất kho (Outbound)**: Tạo đơn hàng xuất, theo dõi khách hàng
- **Báo cáo & thống kê**: Biểu đồ chi tiết, top giao dịch
- **Thiết kế responsive**: Hỗ trợ cả Desktop và Mobile

## Công nghệ sử dụng

- **Backend**: FastAPI (Python)
- **Frontend**: React + Vite + Tailwind CSS (hoặc CSS tùy chỉnh)
- **Database**: SQLite (dễ chạy local) – có thể chuyển sang PostgreSQL
- **Authentication**: JWT + Role-based Authorization
- **Các thư viện chính**: SQLAlchemy, Alembic, pydantic-settings, Recharts (biểu đồ)

## Hướng dẫn cài đặt và chạy dự án

### Yêu cầu
- Python 3.10+
- Node.js 18+ (cho frontend)
### Cài đặt

1. Clone dự án
-git clone https://github.com/HuynhLuongChiDung/Project_LTD.git
-cd Project_LTD

3. Chạy Backend
-cd kanban-todo-api
-python -m venv .venv
-source .venv/bin/activate    # Windows: .venv\Scripts\activate
-pip install -r requirements.txt
-python main.py

4. Chạy Frontend
-cd ../inventory-frontend
-npm install
-npm run dev
