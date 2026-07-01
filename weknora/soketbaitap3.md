# Bài tập 3: Tổng kết quá trình OCR & Xuất dữ liệu Metric Excel

## 1. Chất lượng quét files OCR gốc

| Yêu cầu | Mô tả |
|---|---|
| **Độ phân giải** | >= 300 dpi (file thử nghiệm chỉ ~150 dpi gây khó khăn) |
| **Chất lượng màu** | Trắng/đen rõ ràng, hạn chế chấm nhiễu (bụi) lẫn vào vùng chữ |
| **Khẩu độ / Hình học** | Rộng x Dài x độ vuông góc đảm bảo lề quét không bị xoay nghiêng |
| **Tools chuyển đổi** | Cần tools chuyên dụng: OfficeCLI, MS Office (cách truyền thống) |

## 2. Các khó khăn gặp phải

1. **File thử nghiệm chất lượng thấp** (~150 dpi) — thách thức cho mọi tools truyền thống.
2. **File bị xoay nghiêng**, tỉ lệ Rộng x Dài x góc không đảm bảo — OCR nhận dạng sai hàng loạt.
3. **Màu sắc nhiễu**: đen trắng lộn xộn, bụi lẫn vào vùng chữ cần nhận dạng → tạo ra ký tự lạ, sai số liệu.

## 3. Giải pháp của Local Private AI

### 3.1. Đa dạng cách tiếp cận

Mỗi người thực hành cùng một câu lệnh (prompt) nhưng ra nhiều cách chọn Python và thư viện khác nhau:

> EasyOCR, Surya OCR, PaddleOCR, Tesseract OCR, LMTS, PyTorch, Python OCR, PDF2img...

Điều này không khác gì cách Mr. Edison thí nghiệm cùng lúc 1001 phép thử để tìm ra chất lượng ổn nhất.

### 3.2. Giải pháp rút gọn thời gian

Muốn AI bớt đi nhiều phép thử cùng lúc (gây chậm xử lý và mất thời gian), **cần đưa thêm tài liệu tham khảo**:

- Bài viết, ebook, handbook
- Nội quy tiêu chuẩn quy trình
- Chia sẻ kinh nghiệm về cách dùng thư viện Python OCR mạnh nhất, hiệu quả nhất

→ Để AI xác định dùng luôn thư viện tối ưu mà không cần thử sai nhiều lần.

## 4. Hạn chế đã ghi nhận

### 4.1. Về mô tả nội dung đầu vào

> **Việc đưa file OCR vào nhận dạng gặp vướng mắc về miêu tả các nội dung tóm tắt trước khi yêu cầu AI thực hiện nhận dạng chính là trở ngại chính.**

Hệ quả:
- Mất thời gian cho AI xử lý
- Chất lượng nội dung nhận dạng bị ảnh hưởng
- Kết quả đầu ra thiếu chính xác

### 4.2. Về xuất dữ liệu vào Excel

> **Việc yêu cầu AI thực hiện xuất, cập nhật vào file Excel mới cũng vướng mắc về miêu tả các nội dung tóm tắt, cụ thể, chi tiết trước khi yêu cầu AI thực hiện.**

Hệ quả:
- Mất thời gian xử lý
- Chất lượng số liệu bị ảnh hưởng
- Công thức, hàm, biểu đồ, bảng số liệu đưa vào Excel bị sai lệch

## 5. Kết luận

| Yếu tố | Hiện trạng | Giải pháp đề xuất |
|---|---|---|
| Chất lượng scan | 150 dpi, nhiễu, xoay | Scan >= 300 dpi, căn chỉnh lề |
| Thư viện OCR | Thử sai nhiều loại | Cung cấp tài liệu hướng dẫn để AI chọn đúng |
| Prompt mô tả | Thiếu chi tiết, cụ thể | Tóm tắt rõ cấu trúc, loại dữ liệu, kỳ vọng trước khi yêu cầu |
| Xuất Excel | Thiếu đặc tả KPI, sheet, cột | Định nghĩa trước schema: tên sheet, cột, KPI, đơn vị |

**Bài học:** Chất lượng đầu ra tỉ lệ thuận với chất lượng mô tả đầu vào + chất lượng file gốc + thư viện OCR phù hợp.

---

## 6. Câu hỏi & Trả lời về Cấu hình máy Laptop

**Câu hỏi:**  
Với laptop 8GB RAM, CPU 4 core có Hyper-Threading (8 luận lý), ổ cứng 1TB NVMe, Windows 11 Pro, chạy AionUI + opencode, cần xử lý 500 file PDF (~100 trang/file, chất lượng 300 dpi, 1 ngày). Hỏi khả năng, thời gian, tốc độ?

### 6.1. Phân tích khối lượng

| Chỉ tiêu | Giá trị |
|---|---|
| Số file | 500 PDF |
| Số trang/file | ~100 |
| **Tổng số trang** | **50,000 trang** |
| Dung lượng ảnh @300 dpi | ~8.5 MB/trang → ~425 GB tổng (xử lý tuần tự, không lưu đồng thời) |

### 6.2. Dự tính thời gian xử lý

| Công đoạn | Tool | Tốc độ 1 luồng | 4-5 workers |
|---|---|---|---|
| Render PDF → ảnh | PyMuPDF | ~0.3s/trang | ~0.07s/trang |
| OCR | Tesseract OEM1 `vie` | ~4s/trang | ~1s/trang |
| Excel generation | openpyxl / officecli | ~2-5s/file | ~2-5s/file |
| **Tổng 500 file** | | **~57 giờ (2.4 ngày)** | **~14-18 giờ** |

### 6.3. Nút thắt cổ chai

| Yếu tố | Ảnh hưởng | Giải pháp |
|---|---|---|
| **RAM 8GB** | Chạy tối đa 4-5 worker. OS + Python chiếm ~3GB, còn ~5GB cho workers (mỗi worker ~1GB). | Giới hạn worker = 4. Tránh swap. |
| **CPU 4C/8T** | Tesseract LSTM dùng CPU tuyến tính. Nhiệt tăng cao nếu chạy 100% >30 phút. | Đặt laptop trên giá thoáng nhiệt. Dùng chế độ hiệu năng cao. |
| **NVMe 1TB** | ✅ Đủ nhanh, không phải bottleneck. |
| **Win 11 Pro** | Chiếm nhiều RAM hơn Linux (~2.5-3GB). | Có thể cân nhắc WSL2 để giảm ~1GB. |

### 6.4. Đề xuất tối ưu cho cấu hình 8GB

| Giải pháp | Tốc độ dự kiến | Ghi chú |
|---|---|---|
| **Tesseract OEM1 + 4 workers** | ~1 trang/s (~14h) | ✅ Ổn định, kiểm chứng |
| **Giảm DPI xuống 200** | ~0.5s/trang | ✅ Giảm ~40% thời gian, RAM giảm 50% |
| **Chỉ OCR trang có text** | Tiết kiệm 20-30% | Bỏ qua chart/ảnh toàn trang |
| **Batch 50 PDF/lần** | ~8-10 tiếng | Chạy qua đêm |
| **PaddleOCR (MKLDNN)** | ~1.5-2 trang/s | ⚠️ RAM cao hơn, dễ swap |
| **Dùng officecli thay openpyxl** | Tiết kiệm ~2 phút/file | Có sẵn trong opencode |

### 6.5. Kết luận về khả năng

- **500 file/ngày (giờ hành chính):** ❌ **Không khả thi** — cần 14-18 giờ.
- **500 file/ngày (chạy 24/7):** ✅ **Khả thi** — nếu chạy qua đêm + song song 4 workers.
- **100-150 file/ngày (giờ hành chính 8 tiếng):** ✅ **Khả thi** — ~4-6 phút/file.

### 6.6. Khuyến nghị nâng cấp

| Nâng cấp | Cải thiện | Chi phí ước tính |
|---|---|---|
| **RAM 16→32GB** | Thêm worker, giảm 30% thời gian | ~500K-1.5M VND |
| **GPU NVIDIA (CUDA)** | PaddleOCR/EasyOCR nhanh gấp 5-10x (~0.2s/trang → 5,000 trang/h) | Phụ thuộc dòng GPU |
| **WSL2 Ubuntu** | Tiết kiệm ~1GB RAM, tăng worker | Miễn phí |

---

*Tài liệu tổng kết Bài tập 3 — Dự án LPAI-OCR-Excel*
