# eBook Platform — Kiến trúc Hệ thống Quản lý & Kinh doanh Sách Số

Hệ thống **ebook.cloud.edu.vn** là nền tảng quản lý thư viện điện tử, chuyển đổi số nội dung và kinh doanh sách số theo mô hình **DRM-free**, dựa trên công nghệ mã nguồn mở.

---

## Bảng phân loại Công nghệ Nền tảng Sách Số (Periodic Table of Ebook Technology)

*Tham khảo phương pháp phân loại của DevSecOps Periodic Table (digital.ai)*

| Nhóm | Công nghệ | Vai trò |
|---|---|---|
| **Catalog & Delivery** | OPDS (Atom feed) | Giao thức chuẩn phân phối metadata ebook |
| **Library Management** | Calibre + calibre-web | Quản lý thư viện tập trung, chuyển đổi định dạng |
| **Ecommerce** | NopCommerce (.NET Core) | Shop bán sách số, quản lý đơn hàng, khách hàng |
| **Mobile Reading** | FBReader / CoolReader / Moon+ Reader | Ứng dụng đọc sách trên Android/iOS/Windows/Mac/Linux |
| **Serialization** | EPUB / AZW3 / MOBI / PDF | Định dạng xuất bản sách số |
| **Metadata** | ISBN / DOI / DC (Dublin Core) | Định danh và mô tả sách |
| **Storage** | Local FS / S3 / MinIO | Lưu trữ file gốc và file chuyển đổi |
| **Security** | HTTPS / Basic Auth / Token | Xác thực người dùng cho OPDS |
| **Content Conversion** | Calibre ebook-convert, Pandoc | Chuyển đổi giữa các định dạng ebook |
| **OCR & Document AI** | Surya / VNCV / Docling | Nhận dạng văn bản từ scan/ảnh → số hóa |
| **RAG & Knowledge** | WeKnora / RAGFlow / nom-vn | Hỏi đáp thông minh từ tài liệu đã số hóa |
| **BI & Analytics** | YAI-Excel / KNIME / Power BI | Tính KPI, dashboard, báo cáo từ dữ liệu |
| **CI/CD** | GitHub Actions / Docker Compose | Triển khai tự động các dịch vụ |
| **Observability** | Langfuse / Prometheus | Giám sát hệ thống AI pipeline |

---

## Chiến lược DRM-free & Loại bỏ Phụ thuộc HW

> **Amazon khai tử Kindle for PC vào 30/06/2026** — xác nhận xu hướng các nền tảng đóng (walled garden) ngày càng thắt chặt bảo vệ DRM.

### Nguyên tắc Kiến trúc

1. **DRM-free là chuẩn mặc định** — Tất cả ebook trên hệ thống được loại bỏ DRM bằng Calibre + DeDRM plugin
2. **OPDS làm giao thức chuẩn** — Thay vì phụ thuộc app đọc riêng (Kindle app), dùng OPDS feed chuẩn để bất kỳ app nào (FBReader, Moon+ Reader, CoolReader) cũng đọc được
3. **Không khóa cứng vào HW nào** — Người dùng đọc trên bất kỳ thiết bị nào: Android, iOS, Windows, Mac, Linux, E-ink (Kobo, PocketBook)
4. **Calibre làm trung tâm** — Quản lý metadata, chuyển đổi định dạng, đồng bộ thư viện qua calibre-web

---

## Kiến trúc Tổng quan 4 Tầng

```
┌────────────────────────────────────────────────────────────────────────────┐
│  TẦNG 4: KINH DOANH & QUẢN TRỊ                                             │
│  ┌─────────────────┐ ┌──────────────────┐ ┌──────────────────┐             │
│  │  NopCommerce    │ │  Báo cáo KPI     │ │  Quản lý Xuất    │             │
│  │  Shop Ebook     │ │  Doanh thu/Tồn   │ │  bản & Bản quyền │             │
│  │  (Web UI)       │ │  kho/Chi phí     │ │  (Luật sư)       │             │
│  └────────┬────────┘ └────────┬─────────┘ └────────┬─────────┘             │
└───────────┼───────────────────┼────────────────────┼───────────────────────┘
            │                   │                    │
┌───────────┼───────────────────┼────────────────────┼──────────────────────┐
│  TẦNG 3: THƯ VIỆN SỐ (Librarian)                                          │
│                                                                           │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │                    calibre-web / calibre-server                     │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │  │
│  │  │ Metadata │ │ Convert  │ │ OPDS     │ │ DeDRM    │ │ Content  │   │  │
│  │  │ Manager  │ │ Pipeline │ │ Catalog  │ │ Plugin   │ │ Server   │   │  │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘   │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │  OPDS Feed: https://ebook.cloud.edu.vn:8083/opds                    │  │
│  │  Web Reader: https://ebook.cloud.edu.vn:8083                        │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
└───────────┼───────────────────┬────────────────────┬──────────────────────┘
            │                   │                    │
┌───────────┼───────────────────┼────────────────────┼──────────────────────┐
│  TẦNG 2: TỔ CHỨC & PHÒNG BAN (Giảng viên/Nhóm tác giả)                    │
│                                                                           │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │  Biên tập & Hiệu đính: Git + Calibre Editor + Docling               │  │
│  │  → Đầu sách .epub/.pdf/.docx đã được phê duyệt                      │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
└───────────┼───────────────────┬────────────────────┬──────────────────────┘
            │                   │                    │
┌───────────┼───────────────────┼────────────────────┼──────────────────────┐
│  TẦNG 1: CÁ NHÂN (Tác giả/Giảng viên)                                     │
│                                                                           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐                      │
│  │ Viết     │ │ OCR      │ │ Chuyển   │ │ Soạn     │                      │
│  │ tài liệu │ │ Scan →   │ │ đổi      │ │ thảo     │                      │
│  │ (Word)   │ │ Surya    │ │ Calibre  │ │ Git      │                      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘                      │
└───────────────────────────────────────────────────────────────────────────┘
```

---

## Luồng Đọc sách qua OPDS + FBReader

```
người dùng mở FBReader
        │
        ▼
Thêm "Kho sách trên mạng" (Network Library)
        │
        ▼
Nhập URL: https://ebook.cloud.edu.vn:8083/opds
        │
        ▼
Nhập tên đăng nhập + mật khẩu (HTTP Basic Auth)
        │
        ▼
FBReader tải catalog OPDS (XML/Atom)
        │
        ▼
Duyệt sách theo Danh mục/Tác giả/Tìm kiếm
        │
        ▼
Chọn sách → Tải xuống → Đọc online/offline
        │
        ▼
FBReader lưu tiến độ đọc, bookmark, ghi chú
```

**OPDS Catalog** do calibre-server cung cấp tự động từ thư viện Calibre.

---

## Luồng Xử lý AI: OCR → Số hóa → RAG → BI Dashboard

*Tham khảo WeKnora + giải pháp thay thế từ GIAI_PHAP_THAY_THE.md*

```
Giấy in / Sách scan / Ảnh chụp
        │
        ▼
┌─────────────────────────────────────────────┐
│ BƯỚC 1: OCR & DOCUMENT PARSING              │
│                                             │
│  Surya (layout + OCR + table) — 91 ngôn ngữ │
│  VNCV (tiếng Việt OCR, ONNX, siêu nhẹ)      │
│  Docling (PDF/Word/PPT → Markdown/JSON)     │
│                                             │
│  Output: JSON/Markdown/CSV có cấu trúc      │
└─────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────┐
│ BƯỚC 2: RAG & KNOWLEDGE PLATFORM            │
│                                             │
│  WeKnora hoặc RAGFlow / nom-vn              │
│  → Index vào Vector DB (pgvector/Milvus)    │
│  → Hỏi đáp bằng tiếng Việt/Anh              │
│  → Wiki Mode tự động (WeKnora)              │
│                                             │
│  Output: Hệ thống Q&A thông minh            │
└─────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────┐
│ BƯỚC 3: DATA MODELING & ANALYTICS           │
│                                             │
│  txt2sql / sql / Query / DAX                │
│  AND-OR-Filter Data → Dataset               │
│  KNIME Workflow: Data Modeling              │
│  → Xuất Dashboard BI (Power BI / KNIME)     │
│                                             │
│  Output: KPI Dashboard, Báo cáo Quản trị    │
└─────────────────────────────────────────────┘
```

---

## Các Thành phần Triển khai

### 1. Calibre + calibre-web — Trung tâm Thư viện Số

| Tính năng | Mô tả |
|---|---|
| **Docker triển khai** | `docker run -d -p 8083:8083 linuxserver/calibre-web` |
| **OPDS Catalog** | `https://ebook.cloud.edu.vn:8083/opds` |
| **Xác thực** | HTTP Basic Auth / LDAP / OAuth |
| **Chuyển đổi định dạng** | Calibre ebook-convert (EPUB ↔ AZW3 ↔ PDF ↔ MOBI) |
| **Loại bỏ DRM** | Plugin DeDRM (dành cho sách người dùng đã mua) |
| **Metadata** | Tự động tải bìa, mô tả từ Google Books/Amazon |

### 2. NopCommerce — Shop Bán Sách Số

| Tính năng | Mô tả |
|---|---|
| **Nền tảng** | .NET Core 6+, Linux Ubuntu 20.04 |
| **Cơ sở dữ liệu** | MySQL / MariaDB |
| **Triển khai** | Docker hoặc bash script `shop.sh` |
| **Tích hợp** | Liên kết đến file .epub/.pdf trên calibre-web |
| **Xác thực** | Admin: quản lý sách, đơn hàng, khách hàng |

### 3. FBReader — Ứng dụng Đọc sách Đa nền tảng

| Nền tảng | Link cài đặt |
|---|---|
| **Android** | Google Play: `org.geometerplus.zlibrary.ui.android` |
| **iOS/iPad** | App Store: `FBReader` |
| **Windows** | Microsoft Store / fbreader.org |
| **MacOS** | App Store / fbreader.org |
| **Linux** | fbreader.org |

### 4. Ứng dụng OPDS Mobile thay thế

| App | Nền tảng | OPDS Auth | Ghi chú |
|---|---|---|---|
| **FBReader** | Android/iOS/Win/Mac/Linux | ✅ Basic Auth | Khuyên dùng chính |
| **CoolReader** | Android | ✅ Basic Auth | Dễ dùng, nhẹ |
| **Moon+ Reader** | Android | ✅ Basic Auth | Nhiều tính năng, có QC |
| **EBookDroid** | Android | ✅ Basic Auth | Hỗ trợ PDF/DJVU |
| **PocketBook** | Android/iOS | ❌ | Không OPDS auth |
| **ReadEra** | Android | ❌ | Không OPDS auth |

---

## Lộ trình Phát triển

### Giai đoạn 1: Thư viện Số cơ bản
- [x] Triển khai calibre-web với OPDS
- [x] Cấu hình xác thực người dùng
- [ ] Tải lên 100+ đầu sách DRM-free
- [ ] Kiểm thử đọc qua FBReader

### Giai đoạn 2: Shop Ebook
- [x] Triển khai NopCommerce (shop.sh)
- [ ] Tích hợp OPDS feed vào sản phẩm
- [ ] Thiết lập thanh toán
- [ ] Đồng bộ kho sách giữa shop và thư viện

### Giai đoạn 3: AI & OCR Pipeline
- [ ] Cài đặt Surya / VNCV OCR
- [ ] Triển khai WeKnora hoặc RAGFlow
- [ ] Số hóa tài liệu giấy → ebook
- [ ] Thiết lập RAG Q&A cho thư viện

### Giai đoạn 4: BI & Analytics
- [ ] Kết nối KNIME với dữ liệu doanh thu
- [ ] Xây dựng Data Model (txt2sql)
- [ ] Dashboard KPI cho Quản trị viên
- [ ] Báo cáo Xuất bản & Doanh thu tự động

---

## Tham khảo

- [Calibre - Quản lý Ebook](https://calibre-ebook.com/)
- [calibre-web Docker](https://hub.docker.com/r/linuxserver/calibre-web)
- [NopCommerce](https://www.nopcommerce.com/)
- [FBReader](https://fbreader.org/)
- [OPDS Specification](https://opds.io/)
- [WeKnora - Tencent Knowledge Platform](https://github.com/Tencent/WeKnora)
- [Surya OCR](https://github.com/datalab-to/surya)
- [Docling - IBM Document Conversion](https://github.com/docling-project/docling)
- [nom-vn - Vietnamese AI Toolkit](https://github.com/nrl-ai/nom-vn)
- [Periodic Table of DevSecOps - Digital.ai](https://digital.ai/learn/devsecops-periodic-table/)
- [Kindle Saigon - Calibre Guide](https://www.kindlesaigon.vn/blogs/tin-tuc/huong-dan-can-ban-calibre-phan-mem-quan-li-ebook)
