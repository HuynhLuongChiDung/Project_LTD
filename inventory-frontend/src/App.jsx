import React, { useState } from 'react'
import './App.css'

function App() {
  const [page, setPage] = useState('dashboard')

  return (
    <div className="flex min-h-screen bg-gray-50">
      {/* SIDEBAR */}
      <div className="sidebar">
        <h2>OpenStock WMS</h2>
        <ul>
          <li className={page === 'dashboard' ? 'active' : ''} onClick={() => setPage('dashboard')}>
            Tổng quan (Dashboard)
          </li>
          <li className={page === 'products' ? 'active' : ''} onClick={() => setPage('products')}>
            Quản lý Hàng hóa
          </li>
          <li className={page === 'inbound' ? 'active' : ''} onClick={() => setPage('inbound')}>
            Nhập kho (Inbound)
          </li>
          <li className={page === 'outbound' ? 'active' : ''} onClick={() => setPage('outbound')}>
            Xuất kho (Outbound)
          </li>
        </ul>
      </div>

      {/* MAIN CONTENT */}
      <div className="main-content">
        <div className="header">
          <h1>
            {page === 'dashboard' && 'WMS Dashboard'}
            {page === 'products' && 'Quản lý Hàng hóa'}
            {page === 'inbound' && 'Quản lý Nhập Kho'}
            {page === 'outbound' && 'Quản lý Xuất Kho'}
          </h1>
          <div className="header-right">
            <input type="text" placeholder="Tìm kiếm..." />
            <span className="username">username</span>
          </div>
        </div>

        {/* DASHBOARD */}
        {page === 'dashboard' && (
          <div>
            <div className="stats-grid">
              <div className="stat-card">
                <p>Vị Trí Kho</p>
                <p className="value">--%</p>
                <p className="note">Đang tải dữ liệu từ backend...</p>
              </div>
              <div className="stat-card">
                <p>Doanh Thu</p>
                <p className="value">-- Tỷ</p>
                <p className="note">Đang tải dữ liệu...</p>
              </div>
              <div className="stat-card">
                <p>Đơn Hàng Cần Xử Lý</p>
                <p className="value">--</p>
                <p className="note">Đang tải dữ liệu...</p>
              </div>
              <div className="stat-card">
                <p>Tiếp Thị Liên Kết</p>
                <p className="value">--</p>
                <p className="note">Đang tải dữ liệu...</p>
              </div>
            </div>

            <div className="chart-table-grid">
              <div className="chart-box">
                <h3>Kho hàng xuất nhập khẩu</h3>
                <div className="placeholder-chart">Biểu đồ sẽ hiển thị khi backend có dữ liệu</div>
              </div>
              <div className="table-box">
                <h3>Top 5 Giao Dịch Gần Đây</h3>
                <div className="placeholder-table">Bảng sẽ hiển thị khi có dữ liệu</div>
              </div>
            </div>
          </div>
        )}

        {/* QUẢN LÝ HÀNG HÓA */}
        {page === 'products' && (
          <div className="table-container">
            <div className="table-header">Danh Sách Sản Phẩm Tồn kho</div>
            <div className="table-actions">
              <button className="btn btn-green">Import Excel</button>
              <button className="btn btn-purple">Xuất Excel</button>
              <button className="btn btn-blue">Thêm Sản Phẩm</button>
            </div>
            <table className="data-table">
              <thead>
                <tr>
                  <th>Mã SKU</th>
                  <th>Tên Sản phẩm</th>
                  <th>Danh mục</th>
                  <th>Số lượng tồn</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan="4" className="text-center py-20 text-gray-500">
                    Đang tải dữ liệu sản phẩm từ backend...
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        )}

        {/* NHẬP KHO */}
        {page === 'inbound' && (
          <div className="table-container">
            <div className="table-header">Danh sách Phiếu Nhập Kho</div>
            <button className="btn btn-blue big">Tạo Phiếu Nhập Mới (PO)</button>
            <table className="data-table">
              <thead>
                <tr>
                  <th>Mã Phiếu</th>
                  <th>Nhà Cung Cấp</th>
                  <th>Ngày Dự Kiến</th>
                  <th>Số Lượng SP</th>
                  <th>Tổng</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan="5" className="text-center py-20 text-gray-500">
                    Chưa có phiếu nhập – dữ liệu sẽ hiện khi backend sẵn sàng
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        )}

        {/* XUẤT KHO */}
        {page === 'outbound' && (
          <div className="table-container">
            <div className="table-header">Danh sách Đơn Hàng Xuất Kho</div>
            <button className="btn btn-blue big">Tạo Đơn Hàng Xuất Mới (SO)</button>
            <table className="data-table">
              <thead>
                <tr>
                  <th>Mã S.O.</th>
                  <th>Khách Hàng</th>
                  <th>Ngày Dự Kiến</th>
                  <th>Số Lượng SP</th>
                  <th>Tổng</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colSpan="5" className="text-center py-20 text-gray-500">
                    Chưa có đơn hàng – dữ liệu sẽ hiện khi backend có
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  )
}

export default App