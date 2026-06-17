---
name: kb
description: OKF knowledge base operations. Init, ingest raw sources into Concepts, query the knowledge base, run lint/health checks, and maintain cross-references. Use when creating, initializing, reading, updating, or auditing OKF-format knowledge bundles.
allowed-tools: read, write, edit, search, find, bash, task
---

# Knowledge Base (OKF)

OKF = Open Knowledge Format. Markdown files + YAML frontmatter. No vector DB, no special tooling — `cat` reads it, `git` diffs it.

## Directory Structure

```
knowledge-base/
├── SCHEMA.md              # Type system + frontmatter spec
├── CONVENTIONS.md         # Naming + quality rules
├── index.md               # Root index (progressive disclosure)
├── log.md                 # Change history
├── raw/                   # Original sources (READ-ONLY)
│   ├── papers/
│   ├── articles/
│   └── datasources/
├── concepts/              # OKF Concept documents
│   ├── index.md
│   ├── technology/        # Tech concepts, frameworks
│   ├── architecture/      # Architecture decisions
│   ├── protocols/         # Protocol specs
│   ├── research/          # Research notes
│   └── playbook/          # Runbooks, how-tos
├── entities/              # Reusable entity pages
└── assets/                # Diagrams, images
```

## Concept Types

Every Concept needs `type` in frontmatter. Allowed values:

| Type | Required Sections |
|------|-------------------|
| `Technology` | # Overview, # Key Concepts, # Trade-offs |
| `Architecture` | # Problem, # Decision, # Consequences |
| `Protocol` | # Overview, # Message Format, # Examples |
| `Research` | # Summary, # Key Findings, # Limitations |
| `Playbook` | # Trigger, # Steps, # Verification |
| `Entity` | # Overview, # Key Facts |
| `Reference` | # Schema, # Examples |
| `Metric` | # Definition, # Formula, # Thresholds |
| `Decision` | # Context, # Decision, # Consequences |

## Frontmatter Spec

```yaml
---
type: <Type>                    # REQUIRED
title: <string>                 # REQUIRED
description: <string>           # REQUIRED — one-line summary
resource: <URI>                 # optional — canonical URI of underlying asset
tags: [<string>, ...]           # optional — cross-cutting labels
source: <URI>                   # optional — raw source provenance
confidence: <high|medium|low>   # optional — information reliability
related:                        # optional — links to related Concepts
  - /concepts/technology/xxx.md
contradicts:                    # optional — known contradictions
  - /concepts/zzz.md
timestamp: <ISO 8601>           # last meaningful change
---
```

## Body Rules

- Use structured Markdown: headings, lists, tables, code blocks
- `# Citations` section MUST list all external references
- Cross-references use absolute paths: `[Title](/concepts/xxx/yyy.md)`
- Contradictions MUST be declared in `contradicts` frontmatter
- Filenames: `kebab-case.md`; directories: `lowercase`

## Operations

### Init (initialize knowledge base)

Create the full OKF bundle structure from scratch.

1. Create directory tree:
   ```
   mkdir -p knowledge-base/{raw/{papers,articles,datasources},concepts/{technology,architecture,protocols,research,playbook},entities,assets}
   ```
2. Write `SCHEMA.md` — type system + frontmatter spec (see Concept Types + Frontmatter Spec above)
3. Write `CONVENTIONS.md` — naming rules + quality standards + update rules
4. Write `index.md` — root index linking to all subdirectories
5. Write `log.md` — change history, first entry: `**Init** knowledge base initialized`
6. Write `concepts/index.md` — links to each type subdirectory
7. Write `concepts/<type>/index.md` for each type — empty section headers

**If `knowledge-base/` already exists**: read existing files, merge new schema entries, append to log. NEVER overwrite existing Concepts or index files.

### Ingest (raw → concepts)

1. Read source from `raw/`
2. Extract key entities, relationships, claims
3. Pick Concept Type from schema
4. Generate frontmatter + structured body
5. Scan existing Concepts for related/contradicting
6. Write Concept to appropriate `concepts/<type>/` directory
7. Update parent `index.md` with new entry
8. Append to `log.md`: date, source, concept ID, summary

**One source may produce multiple Concepts** — split by distinct knowledge unit. **One source may update multiple existing Concepts** — create/merge as needed.

### Ingest Repo (git clone → concepts)

Clone a git repository's documentation into `raw/` and systematically create OKF Concepts from it. Use for official docs repos, library references, API documentation, or any structured documentation hosted in git.

#### Step 1: Clone into raw/

```bash
cd <knowledge-base>/raw
git clone --depth 1 <repo-url> <repo-name>
```

- Use `--depth 1` to save space — only latest snapshot needed
- Name the directory descriptively: `cangjie-docs`, `react-docs`, `tokio-docs`
- Clone target: `<knowledge-base>/raw/<repo-name>/`

#### Step 2: Explore doc structure

Map the repository's documentation layout before writing any Concepts:

1. List top-level files — identify README, TOC, summary files
2. Find the docs directory — may be `docs/`, `doc/`, `website/`, `book/`, or root-level
3. Check for bilingual structure — `source_zh_cn/` + `source_en/` or similar
4. List topic subdirectories — these become natural Concept groupings
5. Count total `.md` files to gauge scope
6. Read 2-3 overview/summary files to understand content format and depth

**Use `task` with `explore` agent** for large repos (>50 files) to map the structure in parallel while cloning.

#### Step 3: Read key documents

Read overview files and the most important topic documents in parallel:

- **Overview files** (`*_overview.md`, `README.md`) — give the big picture
- **Summary/TOC files** (`summary_*.md`) — reveal the full topic tree
- **Core topic docs** — read 5-10 of the most important/foundational topics
- **Sample API docs** — understand the API documentation pattern (if applicable)

Group related topics: a single Concept file may cover 2-3 closely related topic directories if they share a cohesive theme (e.g., "JSON + Base64 + Hex" → one Encoding Concept).

#### Step 4: Create Concept files

Write Concepts in parallel using `write`. Each Concept follows the OKF schema:

```yaml
---
type: Technology
title: <Library/Tool Name> — <Specific Aspect>
description: <one-line summary>
source: /raw/<repo-name>/<path-to-source-doc>
tags: [<repo-tag>, <topic-tags>, stdx]
confidence: high
related:
  - /concepts/technology/<related-concept>.md
timestamp: 2026-06-17T00:00:00Z
---
```

**Body structure** (for Technology type):

```markdown
# Overview
<1-2 paragraph summary of what this covers>

# Key Concepts
<tables, code examples, API summaries —提炼, not copy-paste>

# Trade-offs
<pros/cons table — what to use when>

# Citations
[1] <source doc path>
```

**Grouping rules:**

| Repo structure | Concept grouping |
|----------------|-----------------|
| One topic per dir, many files | One Concept per topic dir |
| Related sub-packages (e.g., `crypto/common`, `crypto/digest`) | One Concept covering the group |
| Small utility packages (e.g., `base64`, `hex`) | Merge into one Concept (e.g., "Encoding") |
| Core language + extensions | Separate repo = separate Concept section |

**Content rules:**

- **提炼, not 复制**: Extract key ideas, APIs, patterns. Never paste entire docs.
- **Code examples**: Include 1-3 representative snippets, not exhaustive API listings.
- **Tables**: Use for API summaries, feature matrices, comparison tables.
- **Cross-reference**: Link to related Concepts (both within the same repo and across repos).
- **Source field**: Always point to the raw source doc path for traceability.

#### Step 5: Update indexes and log

1. **`concepts/index.md`** — add a new section for the repo:

   ```markdown
   ## <Repo/Project Name>

   Based on [<repo-name>](<repo-url>) — <one-line description>:

   | Concept | 说明 |
   |---------|------|
   | [concept-name](technology/concept-name.md) | description |
   ```

2. **`concepts/<type>/index.md`** — add entries for each new Concept

3. **`log.md`** — append ingestion record:

   ```markdown
   - **Cloned** `raw/<repo-name>/` ← git clone `<repo-url>` (<description>)
   - **Ingested** <repo-name> → created N concept files in `/concepts/technology/`:
     - `concept-1.md` — description
     - `concept-2.md` — description
   ```

#### Anti-Patterns for Repo Ingest

- **NEVER** clone the entire git history — use `--depth 1`
- **NEVER** create one Concept per file — group related topics into cohesive Concepts
- **NEVER** copy-paste doc content verbatim — extract and restructure
- **NEVER** skip the overview/summary reading step — you need the big picture first
- **NEVER** forget to cross-reference with existing Concepts in the knowledge base
- **AVOID** creating Concepts for trivially small docs (e.g., a single function reference) — merge into a parent Concept

### Query

1. Start from `concepts/index.md` or tag search
2. Load relevant Concepts by cross-references
3. Synthesize answer from loaded Concepts
4. If answer is high-value and reusable → create new Concept (don't let it rot in chat history)

**Scale strategy:**
- < 50k tokens: load entire wiki into context
- 50k–200k tokens: index navigation, load on demand
- \> 200k tokens: index + keyword search + embedding hybrid

### Lint (health check)

Check every Concept for:

| Check | Rule | Severity |
|-------|------|----------|
| Orphan | No inbound AND no outbound links | Warning |
| Undeclared contradiction | Content conflicts but `contradicts` empty | Error |
| Stale | `timestamp` > 6 months | Warning |
| Missing citations | Core claims lack `# Citations` | Warning |
| Broken link | Link target doesn't exist | Error |
| Missing frontmatter | REQUIRED field absent | Error |
| Type mismatch | Type doesn't match body content | Warning |

Auto-fix what's safe (broken links, missing timestamps). Flag the rest for human review.

### Update Existing Concept

1. Read current Concept
2. Compare new information against existing content
3. If contradiction found → declare in `contradicts` on BOTH sides
4. Merge non-conflicting new info into existing Concept
5. Update `timestamp`
6. Update `index.md` if description changed
7. Append to `log.md`

### Create Entity

Use `entities/` for things referenced by multiple Concepts (people, companies, products, tools). One page per entity. Link FROM Concepts TO entity, not the reverse.

## Anti-Patterns

- **NEVER** put raw sources into `concepts/` — raw stays in `raw/`, read-only
- **NEVER** create Concepts without `type`, `title`, `description` in frontmatter
- **NEVER** leave contradictions undeclared — explicit conflict > silent inconsistency
- **NEVER** use relative links for cross-references — always absolute paths from bundle root
- **NEVER** skip `# Citations` on claims sourced from external materials
- **NEVER** delete Concepts — mark as deprecated or merge, preserve history via git
- **AVOID** creating Concepts that only exist to link others — use `index.md` for navigation

## Index Files

Every directory gets an `index.md`. Format:

```markdown
# Section Name

* [Concept Title](relative-path) - description from frontmatter
* [Another Concept](relative-path) - description
```

No frontmatter in index files. Auto-generate from Concept frontmatter when possible.

## Log Format

Append to `log.md`:

```markdown
## YYYY-MM-DD

- **Init** knowledge base initialized
- **Ingested** `raw/papers/xyz.pdf` → created `/concepts/technology/abc.md`
- **Updated** `/concepts/architecture/def.md` — added new section on X
- **Contradiction** `/concepts/tech/a.md` conflicts with `/concepts/tech/b.md` — declared
- **Lint** fixed 2 broken links, flagged 3 stale Concepts
```

## References

- [OKF Spec v0.1](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md)
- [Karpathy LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- Full architecture: `research-docs/08-okf-knowledge-base-architecture.md`
