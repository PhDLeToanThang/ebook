# Mobile Read Ebook — Ứng dụng Đọc sách Di động

## Bảng phân loại Ứng dụng Đọc sách Mobile (theo Periodic Table)

| Nhóm | Ứng dụng | Nền tảng | OPDS Auth | Khuyến nghị |
|---|---|---|---|---|
| **OPDS + Auth (Nhóm 1)** | **FBReader** | Android/iOS/Win/Mac/Linux | ✅ Basic Auth | ⭐ Chính |
| | CoolReader | Android | ✅ Basic Auth | ⭐ Thay thế |
| | Moon+ Reader | Android | ✅ Basic Auth | Có quảng cáo |
| | EBookDroid | Android | ✅ Basic Auth | PDF/DJVU |
| **Không OPDS Auth (Nhóm 2)** | PocketBook | Android/iOS | ❌ | Tránh dùng |
| | ReadEra | Android | ❌ | Tránh dùng |
| | Freda | Windows | ❌ Lỗi auth | Tránh dùng |

---

## Hướng dẫn Kết nối OPDS qua FBReader

### Bước 1: Cài đặt FBReader

| Nền tảng | Link |
|---|---|
| Android | [Google Play](https://play.google.com/store/apps/details?id=org.geometerplus.zlibrary.ui.android) |
| iOS/iPad | [App Store](https://apps.apple.com/app/fbreader/id1067172178) |
| Windows | [Microsoft Store](https://www.microsoft.com/store/apps/9PMZ94127M4G) |
| MacOS | [App Store](https://apps.apple.com/app/fbreader/id1067172178) |
| Linux | [fbreader.org](https://fbreader.org/linux/packages) |

### Bước 2: Thêm Kho sách OPDS

1. Mở FBReader → **Kho sách trên mạng** (Network Library)
2. Chọn **Thêm thư mục** (Add Catalog)
3. Nhập URL: `https://ebook.cloud:8443/opds`
4. Nhập **Tên đăng nhập** và **Mật khẩu** (do Thủ thư cấp)
5. Đặt tên cho kho sách (vd: "Thư viện ebook.cloud")
6. Lưu lại

### Bước 3: Duyệt và Đọc sách

- Duyệt theo **Danh mục** / **Tác giả** / **Mới nhất**
- Tìm kiếm sách theo từ khóa
- Nhấn vào sách → **Tải về** → Đọc
- FBReader tự động đồng bộ tiến độ đọc, bookmark

---

## Mô hình Khai thác Ứng dụng Mobile cho Người dùng

```
┌────────────────────────────────────────────────────────────────────┐
│                    Người dùng Đọc sách                             │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  FBReader (App chính - đa nền tảng)                         │   │
│  │  • Kết nối OPDS có xác thực                                 │   │
│  │  • Đọc online/offline                                       │   │
│  │  • Đồng bộ bookmark, ghi chú                                │   │
│  │  • Hỗ trợ EPUB, MOBI, PDF, DJVU                             │   │
│  └──────────────────────────┬──────────────────────────────────┘   │
│                             │                                      │
│                             ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  https://ebook.cloud:8443/opds                              │   │
│  │  calibre-server (OPDS 1.2)                                  │   │
│  │  HTTP Basic Auth → Danh mục sách → Tải file                 │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```
