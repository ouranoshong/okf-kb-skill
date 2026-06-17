# kb — OKF 知识库 Skill

[![English](https://img.shields.io/badge/lang-EN-blue)](README.md)
[![中文](https://img.shields.io/badge/lang-中文-red)](README_CN.md)

一个基于 [Open Knowledge Format (OKF)](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) 的知识库管理 skill。灵感来自 [Karpathy 的 LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)。

> 📖 **[English Documentation →](README.md)**

## 功能介绍

教会你的 AI 代理操作 OKF 知识库——纯 Markdown + YAML frontmatter，无需向量数据库，无需特殊工具。

| 操作 | 说明 |
|------|------|
| **Init** | 创建完整的知识库目录结构 |
| **Ingest** | 将原始资料编译为结构化 OKF Concept |
| **Ingest Repo** | Clone git 文档仓库并从中创建 Concept |
| **Query** | 基于知识库回答问题 |
| **Lint** | 健康检查——孤立文档、矛盾内容、过期内容 |
| **Update** | 将新信息合并到已有 Concept |
| **Create Entity** | 创建可复用的实体页面（人物、公司、工具等） |

## 安装

告诉你的代理：

```
从 https://github.com/ouranoshong/okf-kb-skill.git 安装或更新 kb skill
```

代理应该：

1. 检查自身配置中可用的 skill 安装路径
2. 如果未安装：询问用户安装位置（项目级或全局），然后克隆并复制
3. 如果已安装：拉取最新更改并替换现有的 `kb/` 目录

## 快速开始

### 1. 让你的代理初始化

```
使用 kb skill 初始化知识库
```

将创建以下结构：

```
knowledge-base/
├── SCHEMA.md              # 类型系统 + frontmatter 规范
├── CONVENTIONS.md         # 命名 + 质量规则
├── index.md               # 根索引
├── log.md                 # 变更历史
├── raw/                   # 原始资料（只读）
├── concepts/              # OKF Concept 文档
│   ├── technology/
│   ├── architecture/
│   ├── protocols/
│   ├── research/
│   └── playbook/
├── entities/              # 可复用实体页面
└── assets/                # 图表、图片
```

### 2. 导入资料

```
将 raw/articles/ 下的所有文档编译为 Concept
```

### 3. 查询

```
基于知识库回答：什么是 Actor Model？
```

## Concept 类型

| 类型 | 用途 | 必需章节 |
|------|------|----------|
| `Technology` | 框架、工具、概念 | 概述、核心概念、权衡取舍 |
| `Architecture` | 设计决策 | 问题、决策、后果 |
| `Protocol` | 通信规范 | 概述、消息格式、示例 |
| `Research` | 论文、分析 | 摘要、主要发现、局限性 |
| `Playbook` | 操作手册、指南 | 触发条件、步骤、验证 |
| `Entity` | 人物、公司、产品 | 概述、关键事实 |
| `Reference` | API 文档、配置 | 规范、示例 |
| `Metric` | 定义、公式 | 定义、公式、阈值 |
| `Decision` | ADR 风格记录 | 背景、决策、后果 |

## 示例 Concept

```markdown
---
type: Technology
title: Actor Model
description: 基于消息传递的并发计算模型
source: /raw/papers/actor-model-1973.pdf
tags: [concurrency, distributed-systems]
confidence: high
related:
  - /concepts/technology/csp.md
timestamp: 2026-06-17T00:00:00Z
---

# 概述

Actor Model 是一种并发计算模型，每个 Actor...

# 核心概念

| 概念 | 描述 |
|------|------|
| Actor | 独立的计算单元 |
| Mailbox | 消息队列，每个 Actor 一个 |

# 权衡取舍

| 优点 | 缺点 |
|------|------|
| 天然适合分布式 | 难以调试 |

# 引用

[1] Hewitt, Carl (1973). "A Universal Modular ACTOR Formalism for AI"
```

## 架构设计

完整架构设计请参阅 [research-docs/08-okf-knowledge-base-architecture.md](research-docs/08-okf-knowledge-base-architecture.md)。

## 参考资料

- [OKF 规范 v0.1](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
- [Karpathy LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [Google Cloud 博客：OKF 如何改善数据共享](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing/)

## 许可证

MIT
