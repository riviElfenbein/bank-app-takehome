# Development Process

## Purpose

Describe how this project was built, reviewed, and prepared for submission as an AI-assisted engineering deliverable.

## Audience

Staff iOS reviewers and future contributors.

## Table of Contents

- [Project Context](#project-context)
- [Development Phases](#development-phases)
- [Architecture Evolution](#architecture-evolution)
- [Engineering Standards](#engineering-standards)
- [Review and Validation](#review-and-validation)
- [Submission Documentation Process](#submission-documentation-process)
- [Cross References](#cross-references)

---

## Project Context

**Type:** iOS take-home assignment  
**Stack:** Swift 6, SwiftUI, Observation, iOS 26  
**Scope:** Two screens — transactions list + editable transaction detail  
**AI policy:** AI assistance permitted; transparency required  

Repository: https://github.com/riviElfenbein/bank-app-takehome

---

## Development Phases

### 1. Planning (Cursor Plan mode)

- Layer design: composition root → presentation models → views → design system
- Feature boundaries: `Features/TransactionsList`, `Features/TransactionDetail`
- State ownership: store as source of truth; draft/commit for editing
- Navigation: value-based `NavigationStack`
- Output: initial architecture roadmap (evolved into migration documented in git history)

### 2. Design extraction (Figma MCP + Agent)

- Read Figma community banking design via MCP tools
- Extract colors, typography, Transaction Details layout
- Build `BankDesignSystem` tokens and components
- **Developer scope trim:** omit transfer/success/home screens from app (README manual review)

### 3. Implementation (Cursor Agent mode)

- Xcode project + workspace + iOS 26 settings
- Domain models, `TransactionStore`, mock provider
- List and detail screens with Observation
- Architecture migration: formatters extraction, draft/commit, repository protocol
- Cursor rules for View responsibility and DI

### 4. Verification

- `xcodebuild` compile checks on iOS Simulator
- Manual simulator QA (see [REVIEW_LOG.md](REVIEW_LOG.md))
- Mock data: 10,000 transactions (1 exemplar + 9,999 generated) via AsyncStream batches of 500

### 5. Submission preparation (this documentation pass)

- Engineering audit (read-only)
- Architecture discovery interview
- Documentation suite generation
- Consistency review and engineering report

---

## Architecture Evolution

The codebase underwent a **presentation-driven migration** (complete in code):

| Before | After |
|--------|-------|
| Live store writes on keystroke | Draft strings + `commit()` on disappear |
| Formatting on domain types | `TransactionFormatters` + pure `Transaction` |
| Bindings directly to store | `@Bindable` draft properties |
| No repository protocol | `TransactionRepository` + `TransactionStore` conformance |

**Incomplete:** Presentation models still type concrete `TransactionStore` instead of protocol. Documented as debt in [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md) D13.

Historical migration details archived in git history of `docs/ARCHITECTURE.md`.

---

## Engineering Standards

Enforced via `.cursor/rules/`:

| Rule file | Enforces |
|-----------|----------|
| `swiftui_view_responsibility.mdc` | Views are layout-only |
| `swiftui_view_dependencies.mdc` | Views depend on models only; composition root owns infrastructure |
| `swiftui_engine.mdc` | SwiftUI identity and lifetime guidance |

Build settings:

- Swift 6, strict concurrency complete
- `@MainActor` on presentation models
- iOS 26 deployment target

---

## Review and Validation

### Automated

- Xcode build (`xcodebuild` — see README)
- No unit or UI test target (deferred — [ROADMAP.md](ROADMAP.md))

### Manual (developer)

| Check | Expected result |
|-------|-----------------|
| Launch app | UI immediate; progress loads 10,000 items |
| Scroll during/after load | Performance acceptable; tap any row |
| Edit recipient name on detail | Draft updates in place |
| Navigate back | Updated name appears in list |
| Build from clean clone | Compiles on Xcode 26+ |

Full log: [REVIEW_LOG.md](REVIEW_LOG.md)

---

## Submission Documentation Process

Nine-phase process for submission-quality documentation:

| Phase | Status | Output |
|-------|--------|--------|
| 0 Discovery | Complete | Internal model |
| 1 Engineering audit | Complete | Internal notes (removed from repo) |
| 2 Knowledge extraction | Complete | `ENGINEERING_DECISIONS.md` |
| 3 Architecture review | Complete | Drift analysis during doc pass |
| 4 Documentation planning | Complete | Doc inventory in submission plan |
| 5 Discovery interview | Complete | Confirmations captured in `ENGINEERING_DECISIONS.md` |
| 6 Documentation generation | Complete | Public docs in `docs/` |
| 7 Consistency review | Complete | Cross-doc alignment |
| 8 Submission review | Complete | `ENGINEERING_REPORT.md` |
| 9 Reflection | Complete | `LESSONS_LEARNED.md` |

---

## Cross References

- [AI_USAGE.md](AI_USAGE.md) — AI transparency
- [ARCHITECTURE.md](ARCHITECTURE.md) — as-built architecture
- [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md) — decision log
- [ENGINEERING_REPORT.md](ENGINEERING_REPORT.md) — submission assessment
