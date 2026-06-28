# AI Pipeline — OCR → Số hóa → RAG → BI Dashboard

Hệ thống chuyển đổi tài liệu giấy/scan thành dữ liệu có cấu trúc, phục vụ hỏi đáp thông minh và phân tích kinh doanh.

## Bảng phân loại Công nghệ AI (Periodic Table)

| Nhóm | Công nghệ | Vai trò |
|---|---|---|
| **OCR Engine** | [Surya](https://github.com/datalab-to/surya) (20.8k⭐) | Layout + OCR + Table, 91 ngôn ngữ |
| **OCR Vietnamese** | [VNCV](https://github.com/Devhub-Solutions/VNCV) | ONNX nhẹ, tối ưu tiếng Việt |
| **Document Parsing** | [Docling](https://github.com/docling-project/docling) (25k⭐) | PDF/Word/PPT → Markdown/JSON |
| **RAG Platform** | [WeKnora](https://github.com/Tencent/WeKnora) (17k⭐) | RAG + Agent + Wiki Mode |
| **RAG Alternative** | [RAGFlow](https://github.com/infiniflow/ragflow) (26k⭐) | RAG mạnh nhất cộng đồng |
| **Vietnamese AI** | [nom-vn](https://github.com/nrl-ai/nom-vn) | RAG native cho tiếng Việt |
| **Excel BI Automation** | [YAI-Excel](https://github.com/gaganchauhan1997/YAI-Excel) | Vision → Audit JSON → .xlsx |
| **KNIME** | [KNIME Analytics Platform](https://www.knime.com/) | Data Modeling, Workflow ETL |
| **Chart & Dashboard** | Power BI / KNIME | BI Dashboard, KPI |

---

## Pipeline Đầy đủ

```
Scan ảnh / Giấy in
    │
    ▼
┌──────────────────────────────────────────────────────────────────┐
│ B1: OCR & PARSING                                                │
│                                                                  │
│  ├─ Surya (layout analysis, OCR 91 languages, table extraction)  │
│  ├─ VNCV (tối ưu tiếng Việt, chạy CPU, ONNX)                     │
│  └─ Docling (PDF/DOCX/XLSX/PPTX → Markdown/JSON)                 │
│                                                                  │
│  Output: JSON / Markdown / CSV có cấu trúc                       │
└──────────────────────────────────────────────────────────────────┘
    │
    ▼
┌──────────────────────────────────────────────────────────────────┐
│ B2: RAG & KNOWLEDGE PLATFORM                                     │
│                                                                  │
│  ├─ WEKNORA (chính) — RAG + Agent ReAct + Wiki Mode              │
│  │   • Upload JSON/MD → Vector DB (pgvector)                     │
│  │   • Hỏi đáp RAG (tiếng Việt/Anh)                              │
│  │   • Wiki tự động từ tài liệu thô                              │
│  │   • MCP tools, Web Search                                     │
│  │                                                               │
│  └─ nom-vn (local, tối ưu tiếng Việt, pip install)               │
│                                                                  │
│  Output: Hệ thống Q&A + Wiki tự động                             │
└──────────────────────────────────────────────────────────────────┘
    │
    ▼
┌──────────────────────────────────────────────────────────────────┐
│ B3: DATA MODELING & ANALYTICS                                    │
│                                                                  │
│  ├─ txt2sql: Chuyển đổi văn bản thành câu lệnh SQL               │
│  ├─ AND-OR-Filter Data: Thiết lập bộ lọc dữ liệu                 │
│  ├─ KNIME Workflow: ETL → Data Model → Feature Engineering       │
│  ├─ YAI-Excel: Tự động sinh .xlsx với KPI, Chart, Pivot          │
│  └─ Power BI Dashboard: Xuất báo cáo quản trị                    │
│                                                                  │
│  Output: Dataset, KPI, Dashboard BI                              │
└──────────────────────────────────────────────────────────────────┘
```

---

## Case Study: Báo cáo KPI Tài chính từ Scan Giấy

1. **Scan báo cáo in** → **Surya** (layout + OCR) → JSON
2. **Upload JSON lên RAG** → **WeKnora** → Index Vector DB
3. **Hỏi đáp**: *"Lợi nhuận quý này là bao nhiêu?"*
4. **Export số liệu** → **YAI-Excel** → File .xlsx với:
   - Chart cột so sánh các quý
   - KPI cards (Doanh thu, Lợi nhuận, Chi phí)
   - Conditional formatting
   - Pivot table theo phòng ban
5. **KNIME Workflow** → Data Model → Training → Export

---

## Tham khảo

- [GIAI_PHAP_THAY_THE.md](./GIAI_PHAP_THAY_THE.md) — Phân tích chi tiết các giải pháp thay thế
- [WeKnora GitHub](https://github.com/Tencent/WeKnora)
- [Surya OCR](https://github.com/datalab-to/surya)
- [RAGFlow](https://github.com/infiniflow/ragflow)
- [nom-vn](https://github.com/nrl-ai/nom-vn)
- [YAI-Excel](https://github.com/gaganchauhan1997/YAI-Excel)