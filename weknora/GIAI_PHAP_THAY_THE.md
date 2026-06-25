# Giải Pháp Mã Nguồn Mở Thay Thế & Bổ Sung cho WeKnora

> **Bài toán:** OCR từ ảnh/bản in giấy → số liệu CSV/MD/DOCX/Excel/PDF/PPTX → AI/ML học & Q&A → Xử lý Excel tự động điền ô, tính 300+ KPI, vẽ biểu đồ.

**Kết luận ngắn:** Không có **một** GitHub project nào làm được tất cả. Giải pháp là **kết hợp nhiều project** thành pipeline.

---

## Mục Lục

1. [Phân Loại Giải Pháp](#1-phân-loại-giải-pháp)
2. [OCR & Document Processing (Scan → Số liệu)](#2-ocr--document-processing-scan--số-liệu)
3. [RAG & Knowledge Platform (Học & Q&A)](#3-rag--knowledge-platform-học--qa)
4. [Excel Automation & BI (KPI, Chart, Formula)](#4-excel-automation--bi-kpi-chart-formula)
5. [Vietnamese-specific Tools](#5-vietnamese-specific-tools)
6. [Pipeline Đề Xuất](#6-pipeline-đề-xuất)
7. [So Sánh Chi Tiết](#7-so-sánh-chi-tiết)
8. [Lộ Trình Triển Khai](#8-lộ-trình-triển-khai)

---

## 1. Phân Loại Giải Pháp

| Nhóm | Mô tả | GitHub Projects |
|---|---|---|
| **OCR Engine** | Nhận dạng chữ từ ảnh/scan, đa ngôn ngữ (VI/EN) | Surya, VNCV, PaddleOCR, Tesseract, VietOCR |
| **Document Parsing** | Parse PDF/Word/Excel/PPT → Markdown/JSON/CSV | Docling, MinerU, OpenDataLoader, GDocZ |
| **RAG Platform** | Lưu trữ, truy xuất, hỏi đáp với LLM | RAGFlow, WeKnora, OpenAgent, KnoArbor, Nexora |
| **Excel Automation** | Điền ô, tính KPI, vẽ chart, text-to-SQL | YAI-Excel, KELA-Agents, WrenAI |
| **Vietnamese AI** | Công cụ AI chuyên cho tiếng Việt | nom-vn, VNCV, DocReader, SmartInvoice |

---

## 2. OCR & Document Processing (Scan → Số liệu)

### 2.1. Surya — OCR đa ngôn ngữ mạnh nhất

| Mục | Chi tiết |
|---|---|
| **Link** | [datalab-to/surya](https://github.com/datalab-to/surya) |
| **Stars** | ⭐ 20.8k |
| **License** | Apache 2.0 |
| **Ngôn ngữ** | Python |
| **OCR accuracy** | 83.3% olmOCR-bench (top under 3B params) |
| **Đa ngôn ngữ** | 91 ngôn ngữ, Vietnamese 73.2%, English 92.3% |
| **Tính năng** | Layout analysis, table recognition, reading order, 5 pages/s trên RTX 5090 |
| **Số param** | 650M — một VLM duy nhất cho layout + OCR + table |

**Cài đặt:**
```bash
pip install surya-ocr
surya_ocr DATA.pdf    # CLI
```

**Ưu điểm:** Model duy nhất cho layout + OCR + table, accuracy cao, speed nhanh, hỗ trợ tiếng Việt.
**Nhược điểm:** Không xuất Excel trực tiếp, cần thêm bước xử lý.

---

### 2.2. VNCV — OCR tối ưu cho tiếng Việt

| Mục | Chi tiết |
|---|---|
| **Link** | [Devhub-Solutions/VNCV](https://github.com/Devhub-Solutions/VNCV) |
| **Stars** | Mới |
| **License** | Open Source |
| **Engine** | VietOCR ONNX (không cần PyTorch, nhẹ ~MB) |
| **Ngôn ngữ** | Tiếng Việt (`vi`) + Tiếng Anh (`en`) |
| **Tốc độ** | x2-x5 so với PyTorch trên CPU |

```bash
pip install vncv
```

```python
from vncv.ocr import extract_text
results = extract_text("hoadon.jpg", lang="vi")
# Trả về JSON: text, bounding box, confidence
```

**Ưu điểm:** Siêu nhẹ, tự động tải model, tối ưu cho tiếng Việt, chạy CPU.
**Nhược điểm:** Chỉ OCR text, không làm layout analysis hay table extraction.

---

### 2.3. GDocZ — Multi-engine OCR Platform

| Mục | Chi tiết |
|---|---|
| **Link** | [gramosoftai/gdoczai](https://github.com/gramosoftai/gdoczai) |
| **Stars** | 7 |
| **License** | Open Source |
| **OCR Engines** | OlmOCR, Qwen2.5-7B VL, Gemini 2.0/2.5, Chandra |
| **Tính năng** | Schema-based extraction, intelligent routing, intelligent chunking |
| **Output** | Clean JSON, hỗ trợ PostgreSQL, email connector, SFTP |

```bash
pip install gdocz
```

**Ưu điểm:** Tự động routing document đến OCR engine phù hợp, schema-based extraction.
**Nhược điểm:** Còn mới, ít sao.

---

### 2.4. DocSnap — OCR + Table Extract + Excel Export

| Mục | Chi tiết |
|---|---|
| **Link** | [bumpstar28/DocSnap](https://github.com/bumpstar28/DocSnap) |
| **License** | Open Source |
| **Engine** | Google Gemini AI |
| **Tính năng** | Table extraction, translate 14 languages, Excel export (.xlsx), inline editing |
| **UI** | Web UI đầy đủ |

**Ưu điểm:** Có UI, xuất Excel ngay, inline editing.
**Nhược điểm:** Phụ thuộc Gemini API key.

---

### 2.5. OpenDataLoader-PDF — Parser cho AI-ready data

| Mục | Chi tiết |
|---|---|
| **Link** | [katoy/opendataloader-pdf](https://github.com/katoy/opendataloader-pdf) |
| **License** | Apache 2.0 |
| **OCR** | 80+ languages, hybrid mode |
| **Output** | Markdown, JSON (bounding boxes), HTML |
| **Integration** | LangChain, Python/Node.js/Java SDKs |

```bash
pip install opendataloader-pdf
opendataloader-pdf --hybrid docling-fast file.pdf
```

**Ưu điểm:** JSON có bounding box cho citation, tích hợp LangChain.
**Nhược điểm:** Chỉ PDF, không xử lý Word/Excel/PPT.

---

### 2.6. Scan-to-Excel — Full-stack OCR App

| Mục | Chi tiết |
|---|---|
| **Link** | [SID-2006/Scan-to-Excel](https://github.com/SID-2006/Scan-to-Excel) |
| **Stars** | 1 (mới) |
| **Stack** | React + Flask + PaddleOCR |
| **Tính năng** | Upload image/PDF → OCR → table reconstruction → editable preview → Excel export |
| **Xử lý** | OpenCV table detection, PaddleOCR |

**Ưu điểm:** Có UI browser, inline editing trước export.
**Nhược điểm:** Mới, ít tính năng nâng cao.

---

### 2.7. Docling (IBM) — Document Conversion Library

| Mục | Chi tiết |
|---|---|
| **Link** | [docling-project/docling](https://github.com/docling-project/docling) |
| **Stars** | 25k+ |
| **License** | MIT |
| **Input** | PDF, DOCX, PPTX, XLSX, Images, HTML |
| **Output** | Markdown, JSON, DocTags, RAG Chunks |
| **OCR** | EasyOCR, Tesseract, RapidOCR — 27+ languages (có VI) |

```bash
pip install docling
docling myfile.pdf --to md    # CLI
```

> **Khuyến nghị:** Dùng Duckling ([gleydson115-code/duckling](https://github.com/gleydson115-code/duckling)) — GUI cho Docling.

---

## 3. RAG & Knowledge Platform (Học & Q&A)

### 3.1. RAGFlow — RAG Engine mạnh nhất hiện nay

| Mục | Chi tiết |
|---|---|
| **Link** | [infiniflow/ragflow](https://github.com/infiniflow/ragflow) |
| **Stars** | ⭐ 26k+ |
| **License** | Apache 2.0 |
| **Ngôn ngữ** | Python |
| **Tính năng** | Deep document understanding, Agent workflow, MCP, code executor, multi-modal |
| **Parsing** | MinerU, Docling — PDF, Word, Excel, PPT, images, scan |
| **UI** | Web UI đầy đủ |
| **Triển khai** | Docker Compose |

```bash
git clone https://github.com/infiniflow/ragflow.git
cd ragflow
docker compose up -d
```

**Ưu điểm:** Cộng đồng lớn nhất, deep document understanding, agentic workflow, hỗ trợ tiếng Việt qua LLM backend.
**Nhược điểm:** Không có Wiki Mode hay Excel automation native.

---

### 3.2. OpenAgent — Personal AI Assistant + Office Automation

| Mục | Chi tiết |
|---|---|
| **Link** | [the-open-agent/openagent](https://github.com/the-open-agent/openagent) |
| **Stars** | ~4k |
| **License** | MIT |
| **Tính năng** | Browser-use, MCP tools, **Office Automation (Word/Excel/PPT)**, RAG, Semantic Search |
| **UI** | Web UI + Admin panel (usage analytics, activity monitoring) |
| **LLMs** | OpenAI, Azure, Gemini, Qwen, HuggingFace, local |

**Điểm đặc biệt:** Có **Office Automation** — đọc/ghi Word, Excel, PowerPoint file trực tiếp từ agent loop!

```bash
git clone https://github.com/the-open-agent/openagent.git
docker compose up -d
```

**Ưu điểm:** Office Automation tích hợp sẵn trong agent, MCP tools, browser automation.
**Nhược điểm:** Cộng đồng nhỏ hơn RAGFlow.

---

### 3.3. Nexora — Multi-tenant AI Agent Orchestration

| Mục | Chi tiết |
|---|---|
| **Link** | [ParendumOU/Nexora](https://github.com/ParendumOU/Nexora) |
| **Stars** | ~500+ |
| **License** | MIT |
| **Tính năng** | ~90 built-in tools, ~46 LLM providers, multi-agent orchestration, RAG, semantic memory |
| **UI** | React-Flow graph builder |

**Ưu điểm:** Rất nhiều tools (Slack, Jira, K8s, Playwright), multi-agent.
**Nhược điểm:** Không có Office Automation native.

---

### 3.4. KnoArbor — AI-native Wiki Engine

| Mục | Chi tiết |
|---|---|
| **Link** | [pxcg/knoarbor](https://github.com/pxcg/knoarbor) |
| **License** | Open Source |
| **Tính năng** | Local-first Markdown wiki, ingest pipeline, lint pipeline, query pipeline |
| **Output** | Obsidian-compatible vault |

**Ưu điểm:** Local-first, output là Markdown file mở được trong Obsidian.
**Nhược điểm:** Single-user, không Excel.

---

## 4. Excel Automation & BI (KPI, Chart, Formula)

### 4.1. YAI-Excel — Universal AI Excel Dashboard Generator ★

| Mục | Chi tiết |
|---|---|
| **Link** | [gaganchauhan1997/YAI-Excel](https://github.com/gaganchauhan1997/YAI-Excel) |
| **Stars** | ~500+ |
| **License** | MIT |
| **Input** | Image, Video, PDF, Excel, CSV, Prompt |
| **Output** | Enterprise-grade .xlsx workbook |
| **AI Pool** | Gemini → Groq → OpenAI → Anthropic (rotating free tier) |
| **Tính năng** | KPI cards, charts, pivot tables, conditional formatting, slicers, formulas, interactivity |

**Pipeline 18 bước:**
```
Input → Vision AI Audit → Master Audit JSON → Excel Builder (openpyxl)
  ChartEngine · KPIEngine · TableEngine · PivotEngine · FormatEngine · FormulaWriter
```

```bash
git clone https://github.com/gaganchauhan1997/YAI-Excel.git
docker compose up -d
```

**Ưu điểm:** Tự động sinh KPI, chart, pivot, formula từ bất kỳ input nào (kể cả ảnh chụp dashboard).
**Nhược điểm:** UI tiếng Anh, phụ thuộc API AI.

---

### 4.2. KELA-Agents — AI Excel Assistant (Natural Language → SQL)

| Mục | Chi tiết |
|---|---|
| **Link** | [Pinkuburu/KELA-Agents](https://github.com/Pinkuburu/KELA-Agents) |
| **License** | Open Source (developing) |
| **Tính năng** | Natural language → SQL query, 8 chart types (ECharts), multi-table join |
| **Performance** | 50+ columns, 100k+ rows |
| **Data Safety** | Local processing, SQLite backend |

**Ưu điểm:** Query Excel bằng tiếng Anh tự nhiên, xử lý lớn, local.
**Nhược điểm:** Đang phát triển, chưa public source ổn định, tập trung query không phải write.

---

### 4.3. WrenAI — Generative BI (Text-to-SQL → Dashboard)

| Mục | Chi tiết |
|---|---|
| **Link** | [Canner/WrenAI](https://github.com/Canner/WrenAI) |
| **Stars** | ~5k+ |
| **License** | Apache 2.0 |
| **Tính năng** | Text-to-SQL, 20+ data sources, governed execution, MDL modeling, context enrichment |
| **Agent SDK** | LangChain, Pydantic AI integration |

**Ưu điểm:** Enterprise-grade BI, data governance, audit logs, kết nối 20+ nguồn dữ liệu.
**Nhược điểm:** Tập trung query/report, không parse document hay Excel cell manipulation.

---

## 5. Vietnamese-specific Tools

### 5.1. nom-vn — Vietnamese AI Toolkit ★

| Mục | Chi tiết |
|---|---|
| **Link** | [nrl-ai/nom-vn](https://github.com/nrl-ai/nom-vn) |
| **Stars** | ~50+ (mới) |
| **License** | Open Source |
| **Tính năng** | RAG pipeline, diacritic restore, segmentation, OCR (Tesseract + vie traineddata), normalization |
| **Embeddings** | VietnameseEmbedder, BKaiEmbedder, AITeamVNEmbedder |
| **UI** | Built-in web app (Streamlit-like) |
| **Triển khai** | Local-first, pip install |

```bash
pip install "nom-vn[chat,embeddings,nlp,doc]"
nom-chat    # Start web UI
```

**Modules:**
| Module | Chức năng |
|---|---|
| `nom.text` | NFC normalize, diacritic restore, word tokenization |
| `nom.chunking` | VN-aware document chunking |
| `nom.embeddings` | Embedder Protocol (BKaiEmbedder khuyến nghị) |
| `nom.retrieve` | BM25 + Dense + hybrid RRF fusion |
| `nom.doc` | PDF/DOCX/XLSX/PPTX/HTML/image → text |
| `nom.llm` | Ollama, OpenAI, Anthropic |
| `nom.rag` | One-line RAG + cross-encoder reranker |
| `nom.chat` | FastAPI + React/ShadCN UI |

**OCR Benchmark (CER trên tiếng Việt):**
- **Tesseract + vie traineddata:** 0.00% (clean), 0.70% (noisy), 30.34% (hard scan) — **tốt nhất**
- EasyOCR: 1.42/4.87/87.09%
- VietOCR: 1.41/3.37/29.00%
- PaddleOCR: 24.70/31.33/86.13%

**Ưu điểm:** Toàn diện nhất cho tiếng Việt, local-first, một thư viện làm được RAG đầy đủ.
**Nhược điểm:** Mới, cộng đồng nhỏ.

---

### 5.2. DocReader — Bilingual RAG (VI-EN)

| Mục | Chi tiết |
|---|---|
| **Link** | [Big-Data-Club/DocReader](https://github.com/Big-Data-Club/DocReader) |
| **License** | Open Source |
| **Tính năng** | GraphRAG, multi-query, HyDE, step-back, bilingual search, KG with entity aliases |
| **Stack** | MinIO + ChromaDB + Kuzu (graph), sentence-transformers, Groq LLM |
| **UI** | Streamlit |

**Ưu điểm:** GraphRAG, bilingual (VI-EN), citation, entity threading.
**Nhược điểm:** Phụ thuộc Groq API, không Excel automation.

---

### 5.3. SmartInvoice Shield — Vietnamese Invoice OCR

| Mục | Chi tiết |
|---|---|
| **Link** | [tuankiet18-dev/SMARTINVOICE-SHIELD](https://github.com/tuankiet18-dev/SMARTINVOICE-SHIELD) |
| **Stack** | .NET + React + Python (Flask) |
| **OCR** | Gemini Vision + PaddleOCR + VietOCR (triple-engine) |
| **Tính năng** | Tax risk assessment, confidence scoring, batch upload, dashboard analytics, Excel export |

**Ưu điểm:** Triple-engine OCR, tax compliance, có dashboard.
**Nhược điểm:** Chỉ cho hóa đơn Việt Nam.

---

## 6. Pipeline Đề Xuất

Dưới đây là pipeline **tối ưu nhất** để giải quyết bài toán đầy đủ:

```
┌──────────────────────────────────────────────────────────────────────────┐
│  BƯỚC 1: OCR & DOCUMENT PARSING                                          │
│  (Scan ảnh/giấy → Dữ liệu có cấu trúc)                                   │
│                                                                          │
│  Công cụ:                                                                │
│  ├─ Surya (layout + OCR + table) — cho ảnh/scan chất lượng cao           │
│  ├─ VNCV (tiếng Việt OCR) — cho văn bản tiếng Việt                       │
│  ├─ Docling/MinerU — cho PDF, Word, PPT → Markdown/JSON                  │
│  └─ YAI-Excel (vision → audit JSON) — cho ảnh chụp bảng tính/biểu đồ     │
│                                                                          │
│  Output: JSON/Markdown/CSV có cấu trúc                                   │
└──────────────────────────────────────────────────────────────────────────┘
                                  ↓
┌──────────────────────────────────────────────────────────────────────────┐
│  BƯỚC 2: RAG & KNOWLEDGE BASE (AI/ML Học & Q&A)                          │
│                                                                          │
│  Công cụ (chọn 1):                                                       │
│  ├─ nom-vn (tối ưu cho tiếng Việt, local-first, pip install)             │
│  ├─ RAGFlow (mạnh nhất, nhiều tính năng, Web UI)                         │
│  ├─ OpenAgent (có Office Automation tích hợp)                            │
│  └─ WeKnora (nếu cần Wiki Mode)                                          │
│                                                                          │
│  Output: Hệ thống hỏi đáp, truy xuất tri thức từ document                │
└──────────────────────────────────────────────────────────────────────────┘
                                  ↓
┌──────────────────────────────────────────────────────────────────────────┐
│  BƯỚC 3: EXCEL AUTOMATION & BI                                           │
│  (Điền ô, tính KPI, vẽ chart)                                            │
│                                                                          │
│  Công cụ:                                                                │
│  ├─ YAI-Excel — vision → audit JSON → .xlsx (tự động sinh KPI, chart,    │
│  │             pivot, formula, conditional format)                       │
│  ├─ OpenAgent — Office tool cho agent đọc/ghi Excel                      │
│  └─ Python script — openpyxl/xlsxwriter cho custom KPI engine            │
│                                                                          │
│  Output: File Excel hoàn chỉnh với KPI, chart, formula                   │
└──────────────────────────────────────────────────────────────────────────┘
```

### 6.1. Pipeline Chi Tiết cho Case Study: Báo Cáo KPI Tài Chính

1. **Scan báo cáo giấy** → **Surya** (layout + OCR) → Markdown/JSON
2. **Upload lên RAG** → **RAGFlow** hoặc **nom-vn** → Index vào Vector DB
3. **Hỏi đáp** bằng tiếng Việt: *"Lợi nhuận quý này là bao nhiêu?"*
4. **Export số liệu** → **YAI-Excel** → Audit JSON → Sinh file Excel với:
   - Chart cột so sánh các quý
   - KPI cards (Doanh thu, Lợi nhuận, Chi phí)
   - Conditional formatting (xanh > target, đỏ < target)
   - Formulas (SUM, AVERAGE, GROWTH%)
   - Pivot table theo department
5. **Custom KPI** → Python script với openpyxl:
   - Tính 300+ chỉ số KPI từ raw data
   - Map KPI vào các ô Excel template
   - Refresh chart data source
   - Ghi thêm OKRI, RISK, COMPLIANCE indicators

### 6.2. Code Mẫu cho Excel Custom KPI Engine

```python
import openpyxl
from openpyxl.chart import BarChart, Reference
from openpyxl.styles import PatternFill, Font
from openpyxl.utils.dataframe import dataframe_to_rows
import pandas as pd
import numpy as np

class KPIEngine:
    def __init__(self, template_path):
        self.wb = openpyxl.load_workbook(template_path)
        self.ws = self.wb.active
    
    def calculate_kpi(self, data_df):
        """Tính 300+ KPI indicators"""
        kpi = {}
        # Tài chính cơ bản
        kpi['revenue'] = data_df['DoanhThu'].sum()
        kpi['cost'] = data_df['ChiPhi'].sum()
        kpi['profit'] = kpi['revenue'] - kpi['cost']
        kpi['profit_margin'] = (kpi['profit'] / kpi['revenue']) * 100
        
        # Tăng trưởng
        kpi['revenue_growth'] = data_df['DoanhThu'].pct_change().mean() * 100
        kpi['cagr'] = ((kpi['revenue'] / data_df['DoanhThu'].iloc[0]) ** (1/len(data_df)) - 1) * 100
        
        # OKRI
        kpi['okr_achievement'] = (kpi['revenue'] / data_df['Target'].sum()) * 100
        kpi['kri_score'] = self._calculate_kri(data_df)
        
        # Risk indicators
        kpi['volatility'] = data_df['DoanhThu'].std() / data_df['DoanhThu'].mean()
        kpi['var_95'] = np.percentile(data_df['DoanhThu'].pct_change().dropna(), 5)
        
        # Compliance
        kpi['compliance_rate'] = (data_df['Compliance'].sum() / len(data_df)) * 100
        
        return kpi
    
    def write_to_cells(self, kpi_dict, mapping):
        """Điền KPI vào các ô theo mapping"""
        for kpi_name, cell_ref in mapping.items():
            self.ws[cell_ref] = kpi_dict.get(kpi_name, 0)
    
    def refresh_charts(self, data_df):
        """Cập nhật biểu đồ với dữ liệu mới"""
        for chart in self.ws._charts:
            if isinstance(chart, BarChart):
                # Map lại data source
                pass
    
    def add_compliance_sheet(self, compliance_data):
        """Thêm sheet tuân thủ"""
        ws2 = self.wb.create_sheet("Compliance")
        for r in dataframe_to_rows(compliance_data, index=False, header=True):
            ws2.append(r)
    
    def save(self, output_path):
        self.wb.save(output_path)


# Sử dụng
engine = KPIEngine("template_kpi.xlsx")
data = pd.read_csv("raw_data.csv")
kpi = engine.calculate_kpi(data)
engine.write_to_cells(kpi, {
    'revenue': 'B2',
    'profit_margin': 'B3',
    'revenue_growth': 'B4',
})
engine.save("baocao_quy_1_2026.xlsx")
```

---

## 7. So Sánh Chi Tiết

### 7.1. OCR Engines

| Tiêu chí | Surya | VNCV | PaddleOCR | Tesseract | GDocZ |
|---|---|---|---|---|---|
| **Sao** | 20.8k | Mới | 45k+ | 65k+ | 7 |
| **Tiếng Việt** | 73.2% | ✅ Tối ưu | ✅ | ✅ (vie.traineddata) | ✅ (Gemini) |
| **Tiếng Anh** | 92.3% | ✅ | ✅ | ✅ | ✅ |
| **Layout Analysis** | ✅ | ❌ | ❌ | ❌ | ✅ |
| **Table Recognition** | ✅ | ❌ | ❌ | ❌ | ✅ |
| **Speed** | ⚡⚡⚡ (5 pages/s GPU) | ⚡⚡⚡ (ONNX) | ⚡⚡ | ⚡ | ⚡ |
| **Cài đặt** | pip | pip | pip | Khó | pip |
| **Không GPU** | ⚠️ Chậm | ✅ Tốt | ⚠️ | ✅ | ⚠️ |

### 7.2. RAG Platforms

| Tiêu chí | RAGFlow | OpenAgent | Nexora | KnoArbor | WeKnora | nom-vn |
|---|---|---|---|---|---|---|
| **Sao** | 26k+ | ~4k | ~500+ | Mới | 17.1k | ~50+ |
| **Tiếng Việt** | ✅ (LLM) | ✅ (LLM) | ✅ (LLM) | ✅ (LLM) | ⚠️ (chính Hoa) | ✅ Native |
| **RAG** | ✅✅ | ✅ | ✅ | ✅ | ✅✅ | ✅ |
| **Agent** | ✅✅ (MCP) | ✅✅ (MCP) | ✅✅ (90 tools) | ❌ | ✅✅ (MCP) | ❌ |
| **Wiki Mode** | ❌ | ❌ | ❌ | ✅ | ✅✅ | ❌ |
| **Office Auto** | ❌ | ✅ (native) | ❌ | ❌ | ❌ | ❌ |
| **Multi-tenant** | ⚠️ | ✅ | ✅✅ | ❌ | ✅✅ | ❌ |
| **Triển khai** | Docker | Docker | Docker | pip | Docker | pip |
| **UI** | ✅✅ | ✅ | ✅✅ | ✅ | ✅✅ | ✅ |

### 7.3. Excel Automation

| Tiêu chí | YAI-Excel | KELA-Agents | WrenAI | OpenAgent (Office) |
|---|---|---|---|---|
| **Sao** | ~500+ | Đang dev | ~5k+ | ~4k |
| **Input → Excel** | ✅ Vision/AI | ❌ (chỉ query) | ❌ (chỉ BI) | ⚠️ (code gen) |
| **KPI tự động** | ✅✅ | ✅ (query) | ✅ (BI) | ❌ |
| **Chart** | ✅✅ (auto) | ✅ (8 types) | ✅ (dashboard) | ❌ |
| **Formula** | ✅✅ (auto) | ✅ (SQL) | ❌ | ❌ |
| **Conditional Format** | ✅✅ | ❌ | ❌ | ❌ |
| **Pivot Table** | ✅✅ | ❌ | ❌ | ❌ |
| **300+ KPI** | ⚠️ (AI gen) | ❌ | ❌ | ❌ |
| **Custom Functions** | ⚠️ | ❌ | ❌ | ❌ |

---

## 8. Lộ Trình Triển Khai Khuyến Nghị

### Giai đoạn 1: OCR & Số hóa tài liệu (Tuần 1-2)

```bash
# Cài đặt Surya - OCR chính
pip install surya-ocr

# Cài đặt VNCV - OCR tiếng Việt
pip install vncv

# Cài đặt Docling - parse PDF/Office
pip install docling

# Script tự động: scan → OCR → JSON → CSV/XLSX
python pipeline_ocr.py input/ output/
```

**Kết quả:** Scan ảnh/giấy → số liệu CSV, Excel, Markdown.

### Giai đoạn 2: RAG & Q&A (Tuần 3-4)

**Option A (khuyến nghị cho tiếng Việt):**
```bash
pip install "nom-vn[chat,embeddings,nlp,doc]"
nom-chat --port 8080
# Web UI tại http://localhost:8080
```

**Option B (mạnh nhất, nhiều tính năng):**
```bash
git clone https://github.com/infiniflow/ragflow.git
docker compose up -d
# Web UI tại http://localhost
```

**Kết quả:** Hệ thống hỏi đáp bằng tiếng Việt/Anh từ tài liệu đã scan.

### Giai đoạn 3: Excel Automation & KPI (Tuần 5-6)

```bash
# YAI-Excel - sinh Excel từ vision/PDF
git clone https://github.com/gaganchauhan1997/YAI-Excel.git
docker compose up -d

# Python KPI Engine custom
python kpi_engine.py --input data/ --output reports/ --kpi 300
```

### Giai đoạn 4: Tích hợp & Tự động hóa (Tuần 7-8)

```
[Scan] → Surya OCR → [JSON] → nom-vn RAG → [Query] → YAI-Excel → [.xlsx]
                                                ↓
                                        KPI Engine → [KPI.xlsx + Charts]
                                                ↓
                                        Compliance Engine → [OKRI, RISK, Compliance.xlsx]
```

---

## Tổng Kết

**Không có một project nào làm được tất cả.** Giải pháp là stack kết hợp:

| Vị trí | Project | Lý do chọn |
|---|---|---|
| **OCR chính** | **Surya** | 20.8k sao, 91 ngôn ngữ, layout + table, speed cao |
| **OCR tiếng Việt** | **VNCV** | Nhẹ, nhanh, tối ưu cho tiếng Việt, ONNX |
| **RAG Platform** | **RAGFlow** (ưu tiên) hoặc **nom-vn** (local) | RAGFlow: mạnh nhất; nom-vn: native tiếng Việt |
| **Excel KPI** | **YAI-Excel** + **Custom Python** | YAI-Excel: auto chart/KPI; Custom: 300+ KRI/OKRI/Compliance |
| **Office Agent** | **OpenAgent** | Khi cần agent tự động thao tác Excel/Word/PPT |

**Pipeline hoàn chỉnh khuyến nghị:**
```
Giấy/Ảnh → Surya/VNCV (OCR) → JSON → RAGFlow (Index + Q&A) 
  → YAI-Excel (Auto KPI + Chart) → KPI Engine (300+ chỉ số)
  → Compliance Engine (OKRI/RISK) → .xlsx hoàn chỉnh
```

> **Lưu ý:** Tiếng Việt trong OCR vẫn là thách thức. Surya đạt 73.2%, Tesseract + vie traineddata đạt 0-30% CER tùy độ sạch. Nên scan ở 300 DPI+, ảnh rõ, ít nhiễu để đạt kết quả tốt nhất.
