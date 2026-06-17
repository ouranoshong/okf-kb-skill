# kb — OKF Knowledge Base Skill

[![English](https://img.shields.io/badge/lang-EN-blue)](README.md)
[![中文](https://img.shields.io/badge/lang-中文-red)](README_CN.md)

A skill for managing knowledge bases using [Open Knowledge Format (OKF)](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md). Inspired by [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

> 📖 **[中文文档 / Chinese Documentation →](README_CN.md)**

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

## Installation

Tell your agent:

```
Install the kb skill from https://github.com/ouranoshong/okf-kb-skill.git
```

The agent should:

1. Check its own configuration for available skill installation paths
2. Ask the user where to install (project-level or global)
3. Clone the repository and copy the `kb/` directory to the chosen location

## Update

Tell your agent:

```
Update the kb skill from https://github.com/ouranoshong/okf-kb-skill.git
```

The agent should:

1. Pull the latest changes from the repository
2. Replace the existing `kb/` directory with the updated version
```
Initialize the knowledge base with kb skill
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
Compile all documents in raw/articles/ into Concepts
```

### 4. Query

```
Based on the knowledge base, answer: What is the Actor Model?
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
