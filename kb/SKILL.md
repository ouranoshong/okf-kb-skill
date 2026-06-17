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
