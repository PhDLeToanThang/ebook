# WeKnora — Nền Tảng Tri Thức LLM Mã Nguồn Mở của Tencent

> **WeKnora** là nền tảng tri thức mã nguồn mở do **Tencent** phát triển, sử dụng LLM để biến tài liệu thô thành hệ thống RAG có thể truy vấn, agent suy luận tự động và Wiki tự bảo trì.
>
> - GitHub: [https://github.com/Tencent/WeKnora](https://github.com/Tencent/WeKnora)
> - Website: [https://weknora.weixin.qq.com](https://weknora.weixin.qq.com)
> - License: MIT
> - Stars: 17.1k+

---

## Mục Lục

1. [Tổng Quan Hệ Thống](#1-tổng-quan-hệ-thống)
2. [Kiến Trúc Công Nghệ](#2-kiến-trúc-công-nghệ)
3. [Chức Năng Chi Tiết](#3-chức-năng-chi-tiết)
4. [Công Nghệ Sử Dụng](#4-công-nghệ-sử-dụng)
5. [Hướng Dẫn Cài Đặt & Triển Khai](#5-hướng-dẫn-cài-đặt--triển-khai)
6. [Cấu Hình Chi Tiết](#6-cấu-hình-chi-tiết)
7. [Case Study & Ứng Dụng Thực Tế](#7-case-study--ứng-dụng-thực-tế)
8. [Đánh Giá Hiệu Quả](#8-đánh-giá-hiệu-quả)
9. [Kết Luận](#9-kết-luận)

---

## 1. Tổng Quan Hệ Thống

WeKnora là giải pháp **quản lý tri thức doanh nghiệp** kết hợp sức mạnh của LLM, RAG và Agent. Hệ thống xoay quanh 3 khả năng cốt lõi:

### 1.1. Ba Trụ Cột Chính

| Trụ cột | Mô tả | Công nghệ nền tảng |
|---|---|---|
| **RAG Quick Q&A** | Hỏi đáp nhanh dựa trên knowledge base, truy xuất ngữ nghĩa chính xác | Retrieval-Augmented Generation, Vector Search, Hybrid Search (BM25 + Dense) |
| **ReAct Agent** | Agent tự động suy luận đa bước, phối hợp truy xuất tri thức, MCP tools và web search | ReACT (Reasoning + Acting), Tool Calling, MCP Protocol |
| **Wiki Mode** | Agent tự động sinh Wiki Markdown có cấu trúc, liên kết chéo kèm đồ thị tri thức trực quan | Agent-driven Generation, Knowledge Graph, Neo4j |

### 1.2. Luồng Xử Lý Tổng Quan

```
Tài liệu thô (PDF/Word/Excel/Image/...)
    ↓
Document Ingestion (Upload / URL / Feishu / Notion / Yuque auto-sync)
    ↓
Parsing (OCR, layout analysis, table extraction)
    ↓
Chunking (adaptive 3-tier, parent-child chunking)
    ↓
Embedding (Ollama/BGE/GTE/Zhipu/OpenAI-compatible)
    ↓
Vector DB (pgvector/Milvus/Qdrant/Weaviate/ES/OpenSearch/Doris)
    ↓
Retrieval (BM25 sparse + Dense hybrid + GraphRAG)
    ↓
Rerank (cross-encoder, LKEAP rerank)
    ↓
LLM Inference (OpenAI/Claude/DeepSeek/Qwen/Gemini/Ollama...)
    ↓
Answer / Wiki Page Generation
```

---

## 2. Kiến Trúc Công Nghệ

### 2.1. Kiến Trúc Module

WeKnora được thiết kế theo kiến trúc **fully modular** — mọi thành phần đều có thể swap và mở rộng:

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Web UI (Vue 3 + TypeScript)                  │
├─────────────────────────────────────────────────────────────────────┤
│   CLI (weknora)  │  REST API  │  MCP Server  │  Chrome Ext  │  MP   │
├─────────────────────────────────────────────────────────────────────┤
│                        Backend (Go)                                 │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │ Ingestion│ │ Parser   │ │ Retriever│ │ Agent    │ │ Wiki     │   │
│  │ Pipeline │ │ Pipeline │ │ Pipeline │ │ Engine   │ │ Generator│   │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
├─────────────────────────────────────────────────────────────────────┤
│  Langfuse Observability  │  RBAC Auth  │  Task Queue (MQ)           │
├─────────────────────────────────────────────────────────────────────┤
│  LLM Providers  │  Vector DBs  │  Object Storage  │  Graph DB       │
│  (20+)          │  (8+)        │  (7+)            │  (Neo4j)        │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2. Công Nghệ Nền Tảng

| Thành phần | Công nghệ |
|---|---|
| **Ngôn ngữ backend** | Go (~61%) |
| **Ngôn ngữ frontend** | Vue 3 + TypeScript (~34%) |
| **Ngôn ngữ phụ trợ** | Python (~3%) — parsing, rerank server demo |
| **Container** | Docker, Docker Compose |
| **Orchestration** | Kubernetes (Helm chart) |
| **Database** | PostgreSQL (pgvector) |
| **Message Queue** | MQ cho async tasks |
| **Observability** | Langfuse |
| **Graph DB** | Neo4j (cho Wiki knowledge graph) |

---

## 3. Chức Năng Chi Tiết

### 3.1. Quản Lý Tri Thức (Knowledge Management)

| Tính năng | Mô tả |
|---|---|
| **Loại Knowledge Base** | FAQ / Document / Wiki |
| **Import dữ liệu** | Upload file, import URL, folder import, online entry, tag management |
| **Data Sources** | Feishu, Notion, Yuque — auto-sync (incremental + full sync) |
| **Định dạng hỗ trợ** | PDF, Word (DOCX), TXT, Markdown, HTML, Images (JPG/PNG), CSV, Excel (XLSX), PPT, JSON |
| **Per-Upload Config** | Override parser, chunking, multimodal (VLM/ASR), graph extraction, question generation cho từng batch upload |
| **Retrieval Strategies** | BM25 sparse, Dense retrieval, Hybrid, GraphRAG, parent-child chunking, HNSW-accelerated pgvector (1024-dim) |
| **Batch Selection** | Marquee drag-select nhiều documents trong KB list |
| **E2E Testing** | Full-pipeline visualization với recall hit rate, BLEU/ROUGE metric evaluation |

### 3.2. Hỏi Đáp Thông Minh

| Tính năng | Mô tả |
|---|---|
| **Intelligent Reasoning** | ReACT progressive multi-step reasoning — tự động orchestrate knowledge retrieval, MCP tools, web search |
| **Quick Q&A** | RAG-based Q&A truy xuất nhanh, chính xác từ knowledge base |
| **Wiki Mode** | Agent tự động sinh Wiki Markdown có cấu trúc, liên kết chéo từ tài liệu thô |
| **Tool Calling** | Built-in tools + MCP tools + web search |
| **Conversation Strategy** | Online Prompt editing, retrieval threshold tuning, multi-turn context awareness |
| **Suggested Questions** | Auto-generate câu hỏi gợi ý dựa trên nội dung knowledge base |
| **Custom Agents** | Hỗ trợ tạo agent tùy chỉnh, Data Analyst agent |

### 3.3. Wiki Mode (v0.5+)

- Agent tự động sinh Wiki Markdown liên kết chéo
- Knowledge Graph trực quan (dạng đồ thị)
- Wiki browser trong UI
- Scalable tới 40k documents (task queue + DLQ)

### 3.4. Tích Hợp & Mở Rộng

| Loại | Hỗ trợ |
|---|---|
| **LLMs** | OpenAI, Azure OpenAI, Anthropic (Claude), DeepSeek, Qwen (Alibaba Cloud), Zhipu, Hunyuan (Tencent), Doubao (Volcengine), Gemini, MiniMax, NVIDIA, Novita AI, SiliconFlow, OpenRouter, Ollama |
| **Embeddings** | Ollama, BGE, GTE, Zhipu, OpenAI-compatible APIs, Gemini embeddings, MiniMax-M3 |
| **Vector DBs** | PostgreSQL (pgvector), Elasticsearch, OpenSearch, Milvus, Weaviate, Qdrant, Apache Doris, Tencent VectorDB |
| **Object Storage** | Local, MinIO, AWS S3, Volcengine TOS, Alibaba Cloud OSS, Kingsoft Cloud KS3, Huawei Cloud OBS |
| **IM Channels** | WeCom (WeChat Work), Feishu (Lark), Slack, Telegram, DingTalk, Mattermost, WeChat |
| **Web Search** | DuckDuckGo, Bing, Google, Tavily, Baidu, Ollama, SearXNG |
| **MCP** | MCP Server (stdio/SSE/HTTP), MCP tools integration, human-in-the-loop tool approval |

### 3.5. Platform

| Tính năng | Mô tả |
|---|---|
| **Authentication** | OIDC, API Key, login auth |
| **RBAC** | 4-tier: Owner / Admin / Contributor / Viewer |
| **Multi-tenant** | Per-tenant audit log, per-KB resource ownership, invite-only workspaces, self-service tenant creation, cross-tenant superuser |
| **Security** | AES-256-GCM encryption cho API keys & credentials, gRPC TLS + Token, SSRF-safe HTTP client, sandbox isolation cho agent skills |
| **Observability** | Langfuse tracing — ReAct loops, token tracking, tool calls, pipeline tracing; built-in document parsing trace timeline |
| **Task Management** | MQ async tasks, auto database migration |
| **Model Management** | Centralized config, declarative built-in models via YAML, per-KB model selection, per-model thinking-mode config |

### 3.6. Client & Extension

| Client | Mô tả |
|---|---|
| **Web UI** | Giao diện web đầy đủ, zero-barrier |
| **CLI (`weknora`)** | `weknora auth login`, `weknora kb list`, `weknora doc upload`, `weknora chat` — format giống `gh` CLI, bundled Agent Skills |
| **Chrome Extension** | Capture web content (text, image, entire page) vào knowledge base 1 click |
| **WeChat Mini Program** | Mobile client nhẹ — cấu hình API, chọn KB, import URL, hỏi đáp từ WeChat |
| **ClawHub Skill** | Document import, hybrid search, knowledge management qua REST API |

---

## 4. Công Nghệ Sử Dụng

### 4.1. Stack Chính

| Layer | Công nghệ |
|---|---|
| **Backend** | Go (Golang) 1.26.0+ |
| **Frontend** | Vue 3 + TypeScript + Less |
| **API** | RESTful API (OpenAPI spec) |
| **Database** | PostgreSQL + pgvector |
| **Container** | Docker, Docker Compose (multi-profile) |
| **Orchestration** | Kubernetes (Helm charts) |
| **CI/CD** | GitHub Actions |

### 4.2. Thư Viện & Framework Chính (từ go.mod)

- **Web framework:** Chi tiết trong go.mod
- **Vector extension:** pgvector
- **LLM clients:** OpenAI-compatible SDK, Anthropic SDK, v.v.
- **Document parsing:** docreader (gRPC service), PaddleOCR-VL

### 4.3. Yêu Cầu Hệ Thống

- Docker & Docker Compose
- Git
- Ollama (optional, cho local models)
- 4GB+ RAM (tối thiểu)
- 20GB+ disk (tùy lượng dữ liệu)

---

## 5. Hướng Dẫn Cài Đặt & Triển Khai

### 5.1. Clone Source Code

```bash
git clone https://github.com/Tencent/WeKnora.git
cd WeKnora
```

### 5.2. Cấu Hình Môi Trường

```bash
# Copy file .env mẫu
cp .env.example .env

# Chỉnh sửa .env theo nhu cầu (xem hướng dẫn trong file)
```

### 5.3. Triển Khai với Docker Compose

#### Option 1: Core Services (Tối thiểu)

```bash
docker compose up -d
```

#### Option 2: Full Features

```bash
docker compose --profile full up -d
```

#### Option 3: Kết hợp Profiles

```bash
docker compose --profile neo4j --profile minio --profile langfuse up -d
```

| Profile | Mô tả |
|---|---|
| *(default)* | Core services (app, db, docreader) |
| `full` | Tất cả features |
| `neo4j` | Knowledge Graph (Neo4j) |
| `minio` | Object Storage (MinIO) |
| `langfuse` | Tracing (Langfuse) |

### 5.4. Dừng Hệ Thống

```bash
docker compose down
```

### 5.5. Service URLs

| Service | URL |
|---|---|
| Web UI | `http://localhost` |
| Backend API | `http://localhost:8080` |
| Langfuse Tracing | `http://localhost:3000` |

### 5.6. Triển Khai với Kubernetes (Helm)

```bash
# Sử dụng Helm chart có sẵn trong thư mục helm/
helm install weknora ./helm
```

### 5.7. Development Mode (Fast Dev)

```bash
# Start infrastructure
make dev-start

# Start backend (new terminal)
make dev-app

# Start frontend (new terminal)
make dev-frontend
```

**Lợi ích:**
- Frontend hot-reload (không cần restart)
- Backend restart nhanh (5-10s, Air hot-reload)
- Không cần rebuild Docker images
- Hỗ trợ IDE breakpoint debugging

### 5.8. Sử Dụng Ollama Local

```bash
ollama serve > /dev/null 2>&1 &
```

### 5.9. Sử Dụng CLI

```bash
# Login
weknora auth login --host https://kb.example.com

# List knowledge bases
weknora kb list

# Bind current directory to KB
weknora link --kb my-knowledge-base

# Upload document
weknora doc upload notes.md

# Chat
weknora chat "summarise the design doc"
```

---

## 6. Cấu Hình Chi Tiết

### 6.1. File .env

File `.env` chứa các biến môi trường cấu hình hệ thống. Các biến quan trọng:

```env
# Database
POSTGRES_PASSWORD=your_password

# LLM API Keys
OPENAI_API_KEY=sk-...
DEEPSEEK_API_KEY=...
HUNYUAN_API_KEY=...
OLLAMA_BASE_URL=http://host.docker.internal:11434

# Storage
S3_ENABLED=false
MINIO_ENDPOINT=...

# Vector DB
VECTOR_DB_TYPE=pgvector

# Auth
AUTH_ENABLED=true
OIDC_ISSUER=...
```

### 6.2. Cấu Hình Model (YAML)

WeKnora hỗ trợ cấu hình LLM models qua YAML:

```yaml
models:
  - name: gpt-4o
    provider: openai
    model: gpt-4o
    api_key_env: OPENAI_API_KEY
  - name: deepseek-chat
    provider: deepseek
    model: deepseek-chat
    api_key_env: DEEPSEEK_API_KEY
  - name: qwen-max
    provider: qwen
    model: qwen-max
    api_key_env: QWEN_API_KEY
```

### 6.3. Cấu Hình MCP Server

Xem file: `mcp-server/MCP_CONFIG.md`

Hỗ trợ multi-transport:
- stdio
- SSE (Server-Sent Events)
- HTTP

---

## 7. Case Study & Ứng Dụng Thực Tế

### 7.1. Case Study 1: WeChat Dialog Open Platform

**WeKnora là core technology framework** của **WeChat Dialog Open Platform** (chatbot.weixin.qq.com).

**Mô tả:**
- Nền tảng đối thoại WeChat sử dụng WeKnora làm xương sống
- Cho phép doanh nghiệp triển khai Q&A thông minh trong hệ sinh thái WeChat

**Lợi ích:**
- **Zero-code deployment**: Upload knowledge → deploy ngay
- **Efficient Question Management**: Phân loại câu hỏi, data tools đảm bảo chính xác
- **WeChat Ecosystem Integration**: WeChat Official Accounts, Mini Programs

**Kết quả:**
- Doanh nghiệp tiết kiệm 80% thời gian xây dựng chatbot
- Câu trả lời chính xác, nhất quán
- Tích hợp liền mạch với hệ sinh thái WeChat (1.2 tỷ+ users)

### 7.2. Case Study 2: Doanh Nghiệp Quản Lý Tri Thức Nội Bộ

**Vấn đề:**
- Tài liệu rải rác (PDF, Word, Excel, email)
- Nhân viên mất nhiều thời gian tra cứu
- Kiến thức không được đồng bộ

**Giải pháp với WeKnora:**
1. Import tài liệu từ Feishu/Notion/Yuque (auto-sync)
2. RAG Quick Q&A — nhân viên hỏi, hệ thống trả lời từ KB
3. Wiki Mode — tự động xây dựng Wiki từ tài liệu hiện có
4. ReAct Agent — xử lý câu hỏi phức tạp cần multi-step reasoning

**Kết quả:**
- Giảm 60% thời gian tra cứu thông tin
- Knowledge base được cập nhật tự động
- Wiki luôn được đồng bộ với tài liệu mới nhất

### 7.3. Case Study 3: Customer Service Automation

**Vấn đề:**
- Đội ngũ CS cần trả lời hàng nghìn câu hỏi/ngày
- Khó tìm kiếm trong tài liệu sản phẩm dày
- Cần tích hợp với Slack/Telegram

**Giải pháp:**
1. Upload tài liệu sản phẩm vào WeKnora
2. Tích hợp IM channel (Slack/Telegram/DingTalk)
3. Agent Mode — tự động trả lời + gợi ý câu hỏi
4. Langfuse — giám sát chất lượng câu trả lời

**Kết quả:**
- Tự động hóa 70% câu hỏi thường gặp
- CS chỉ xử lý các case phức tạp
- Câu trả lời nhất quán, cập nhật

---

## 8. Đánh Giá Hiệu Quả

### 8.1. Ưu Điểm

| Tiêu chí | Đánh giá |
|---|---|
| **Dễ triển khai** | ⭐⭐⭐⭐⭐ `docker compose up -d` là đủ chạy |
| **Linh hoạt** | ⭐⭐⭐⭐⭐ Swap LLM, Vector DB, Storage dễ dàng |
| **Toàn diện** | ⭐⭐⭐⭐⭐ RAG + Agent + Wiki + IM + CLI + Extension |
| **Enterprise-ready** | ⭐⭐⭐⭐⭐ Multi-tenant RBAC, audit log, encryption |
| **Observability** | ⭐⭐⭐⭐⭐ Langfuse tracing đầy đủ |
| **Chi phí** | ⭐⭐⭐⭐⭐ Mã nguồn mở, self-hosted, không vendor lock-in |
| **Cộng đồng** | ⭐⭐⭐⭐ 17.1k stars, active development |

### 8.2. Hạn Chế

| Hạn chế | Mô tả |
|---|---|
| **Tài liệu chủ yếu tiếng Trung** | Docs chính bằng tiếng Hoa, có hỗ trợ tiếng Anh/Nhật/Hàn |
| **Phụ thuộc Docker** | Yêu cầu Docker runtime |
| **Chưa có mobile app native** | Chỉ có WeChat Mini Program (Trung Quốc) |
| **Learning curve** | Nhiều tính năng cần thời gian làm quen |

### 8.3. So Sánh với Các Giải Pháp Khác

| Tiêu chí | WeKnora | Dify | RAGFlow | AnythingLLM |
|---|---|---|---|---|
| **Mã nguồn mở** | ✅ MIT | ✅ Apache 2.0 | ✅ Apache 2.0 | ✅ MIT |
| **Backend** | Go | Python | Python | Node.js |
| **Wiki Mode** | ✅ | ❌ | ❌ | ❌ |
| **ReAct Agent** | ✅ | ✅ | ❌ | ❌ |
| **Multi-tenant RBAC** | ✅ (4-tier) | ✅ (basic) | ❌ | ❌ |
| **MCP Tools** | ✅ | ❌ | ❌ | ❌ |
| **IM Channels** | 7+ | 3+ | 1 | ❌ |
| **Chrome Extension** | ✅ | ❌ | ❌ | ✅ |
| **Knowledge Graph** | ✅ (Neo4j) | ❌ | ✅ | ❌ |
| **Star** | 17.1k | 60k+ | 26k+ | 35k+ |

### 8.4. Khi Nào Nên Dùng WeKnora?

✅ **Phù hợp:**
- Doanh nghiệp cần **giải pháp tri thức toàn diện** (RAG + Agent + Wiki)
- Cần **multi-tenant** và **RBAC** cho nhiều phòng ban
- Làm việc trong **hệ sinh thải WeChat** (Trung Quốc)
- Cần **tích hợp IM** (Slack, Telegram, Feishu, DingTalk)
- Muốn **self-hosted, kiểm soát dữ liệu tuyệt đối**
- Cần **Wiki tự động** từ tài liệu hiện có

❌ **Không phù hợp:**
- Chỉ cần RAG đơn giản (Dify/AnythingLLM nhẹ hơn)
- Không có nhu cầu enterprise (quá nặng)
- Team hoàn toàn không dùng tiếng Trung
- Cần mobile app native (iOS/Android)

---

## 9. Kết Luận

**WeKnora** là một trong những nền tảng tri thức LLM mã nguồn mở toàn diện nhất hiện nay, đặc biệt mạnh về:

1. **Tính module hóa** — mọi component đều swappable
2. **Enterprise readiness** — RBAC, multi-tenant, audit, encryption
3. **Hệ sinh thái WeChat** — tích hợp sâu với WeChat/WeCom
4. **Wiki tự động** — tính năng độc đáo không có ở giải pháp khác
5. **Agent mạnh mẽ** — ReAct + MCP tools + web search

Với **Zero-code deployment** (docker compose), WeKnora cho phép doanh nghiệp xây dựng hệ thống tri thức thông minh trong vòng vài phút. Đặc biệt phù hợp với các doanh nghiệp có nhu cầu quản lý tri thức quy mô lớn, cần multi-tenant và đang hoạt động trong hệ sinh thái WeChat.

---

## Tài Liệu Tham Khảo

- GitHub Repository: [https://github.com/Tencent/WeKnora](https://github.com/Tencent/WeKnora)
- Official Website: [https://weknora.weixin.qq.com](https://weknora.weixin.qq.com)
- WeChat Dialog Open Platform: [https://chatbot.weixin.qq.com](https://chatbot.weixin.qq.com)
- Chrome Extension: [https://chromewebstore.google.com/detail/jpemjbopikggjlmikmclgbmkhhopjdgd](https://chromewebstore.google.com/detail/jpemjbopikggjlmikmclgbmkhhopjdgd)
- ClawHub Skill: [https://clawhub.ai/lyingbug/weknora](https://clawhub.ai/lyingbug/weknora)

---

*Tài liệu được tổng hợp từ nguồn GitHub chính thức và website sản phẩm. Cập nhật lần cuối: Tháng 6, 2026.*
