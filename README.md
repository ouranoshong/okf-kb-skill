# kb — OKF Knowledge Base Skill

A skill for managing knowledge bases using [Open Knowledge Format (OKF)](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md). Inspired by [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

## What It Does

Teaches your AI agent to operate an OKF knowledge base — Markdown files + YAML frontmatter, no vector DB, no special tooling.

| Operation | Description |
|-----------|-------------|
| **Init** | Create the full knowledge base directory structure |
| **Ingest** | Compile raw sources into structured OKF Concepts |
| **Query** | Answer questions based on the knowledge base |
| **Lint** | Health check — orphans, contradictions, stale content |
| **Update** | Merge new info into existing Concepts |
| **Create Entity** | Create reusable entity pages for people, companies, tools |

## Quick Start

### 1. Copy the skill

```bash
# For oh-my-pi
cp -r kb/ ~/.omp/skills/kb/

# For adk-rust
cp -r kb/ .skills/kb/

# For jcode
cp -r kb/ .jcode/skills/kb/
```

### 2. Ask your agent to initialize

```
使用 kb skill 初始化知识库
```

This creates:

```
knowledge-base/
├── SCHEMA.md              # Type system + frontmatter spec
├── CONVENTIONS.md         # Naming + quality rules
├── index.md               # Root index
├── log.md                 # Change history
├── raw/                   # Original sources (read-only)
├── concepts/              # OKF Concept documents
│   ├── technology/
│   ├── architecture/
│   ├── protocols/
│   ├── research/
│   └── playbook/
├── entities/              # Reusable entity pages
└── assets/                # Diagrams, images
```

### 3. Ingest sources

```
将 raw/articles/ 下的所有文档编译为 Concept
```

### 4. Query

```
基于知识库回答：什么是 Actor Model？
```

## Concept Types

| Type | Use For | Required Sections |
|------|---------|-------------------|
| `Technology` | Frameworks, tools, concepts | Overview, Key Concepts, Trade-offs |
| `Architecture` | Design decisions | Problem, Decision, Consequences |
| `Protocol` | Communication specs | Overview, Message Format, Examples |
| `Research` | Papers, analysis | Summary, Key Findings, Limitations |
| `Playbook` | Runbooks, how-tos | Trigger, Steps, Verification |
| `Entity` | People, companies, products | Overview, Key Facts |
| `Reference` | API docs, config | Schema, Examples |
| `Metric` | Definitions, formulas | Definition, Formula, Thresholds |
| `Decision` | ADR-style records | Context, Decision, Consequences |

## Example Concept

```markdown
---
type: Technology
title: Actor Model
description: Concurrent computing model based on message passing
source: /raw/papers/actor-model-1973.pdf
tags: [concurrency, distributed-systems]
confidence: high
related:
  - /concepts/technology/csp.md
timestamp: 2026-06-17T00:00:00Z
---

# Overview

Actor Model is a concurrent computation model where each Actor...

# Key Concepts

| Concept | Description |
|---------|-------------|
| Actor | Independent unit of computation |
| Mailbox | Message queue, one per Actor |

# Trade-offs

| Pros | Cons |
|------|------|
| Natural fit for distributed | Hard to debug |

# Citations

[1] Hewitt, Carl (1973). "A Universal Modular ACTOR Formalism for AI"
```

## Architecture

See [research-docs/08-okf-knowledge-base-architecture.md](research-docs/08-okf-knowledge-base-architecture.md) for the full architecture design.

## References

- [OKF Specification v0.1](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
- [Karpathy LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [Google Cloud Blog: How OKF improves data sharing](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing/)

## License

MIT
