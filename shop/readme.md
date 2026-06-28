# Shop Ebook — NopCommerce

## Bảng phân loại Công nghệ Shop Sách Số (Periodic Table)

| Nhóm | Công nghệ | Vai trò |
|---|---|---|
| **Ecommerce Platform** | NopCommerce (.NET Core 6+) | Website bán sách, giỏ hàng, thanh toán |
| **Database** | MySQL / MariaDB | Lưu đơn hàng, sản phẩm, khách hàng |
| **Web Server** | Nginx / Apache | Reverse proxy cho shop |
| **OS** | Ubuntu 20.04 LTS | Hệ điều hành máy chủ |
| **Payment Gateway** | Stripe / PayPal / VNPay | Thanh toán trực tuyến |
| **CDN** | Cloudflare | Tăng tốc, bảo mật |
| **Monitoring** | Prometheus + Grafana | Giám sát hiệu năng |
| **Hook-to-Read** | OPDS link từ calibre-web | Sau khi mua, gửi link tải ebook |

---

## Triển khai

```bash
# Tải script cài đặt tự động
wget https://raw.githubusercontent.com/PhDLeToanThang/ebook/main/shop/shop.sh
bash shop.sh
```

### Tham số cấu hình

| Tham số | Ví dụ | Mô tả |
|---|---|---|
| FQDN | `demo.company.vn` | Tên miền shop |
| dbname | `nopcommercedata` | Tên database |
| dbuser | `userdata` | User database |
| dbpassword | `P@3167168w0rd-1.22` | Mật khẩu database |
| phpmyadmin | `phpmyadmin` | Đường dẫn phpMyAdmin |
| nopcommerce | `nopcommercedata` | Thư mục dữ liệu |
| dbtype | `mysql` | Loại database |
| dbhost | `localhost` | Host database |

---

## Tích hợp với Hệ thống Ebook

```
 NopCommerce Shop                    calibre-web (Thư viện Số)
┌───────────────┐                     ┌────────────────────┐
│  Khách hàng   │                     │  OPDS Catalog      │
│  mua sách     │──Sau thanh toán──▶ │  → Link tải .epub  │
│  → Email link │                     │  → Xác thực user   │
│  tải ebook    │                     │  → Ghi nhận lượt   │
└───────────────┘                     └────────────────────┘
```

### Debug

> Cấu hình quản trị: disable đăng ký nhận tin tức và không gửi email Verify Newsletter trong nop-commerce [#7](https://github.com/PhDLeToanThang/ebook/issues/7)
