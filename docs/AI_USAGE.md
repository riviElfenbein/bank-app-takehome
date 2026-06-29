# AI Usage

## Purpose

Transparent disclosure of how AI tools were used in building this project, where engineering judgement remained with the developer, and where manual review occurred.

## Audience

Staff iOS reviewers evaluating AI-assisted engineering workflow.

## Table of Contents

- [Transparency Policy](#transparency-policy)
- [Tools Used](#tools-used)
- [Workflow by Stage](#workflow-by-stage)
- [Where AI Helped](#where-ai-helped)
- [Where Engineering Judgement Applied](#where-engineering-judgement-applied)
- [Manual Review](#manual-review)
- [Cross References](#cross-references)

---

## Transparency Policy

AI is an **engineering tool**. It did not replace:

- Architecture decisions
- Scope control
- Manual simulator verification
- Final documentation review

This document states what AI contributed. For decision rationale, see [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md).

**Never implied:** that AI autonomously designed or shipped the app without developer oversight.

---

## Tools Used

| Tool | Role |
|------|------|
| **Cursor** (Plan + Agent modes) | Architecture planning, implementation, documentation |
| **Figma MCP** | Design token and layout extraction from Figma file |
| **Xcode 26 / xcodebuild** | Build verification (local toolchain, not AI) |
| **Git / GitHub CLI** | Repository hosting (local CLI) |

Primary model during implementation: **Cursor Agent (Composer)** per README disclosure table.

---

## Workflow by Stage

| Stage | AI contribution | Developer contribution |
|-------|-------------------|------------------------|
| **Architecture & planning** | Layer design, feature boundaries, navigation strategy | Scope approval, product decisions (all fields editable, commit on back) |
| **Design analysis** | Figma MCP extraction of colors, typography, components | Scope trim — omitted unbuilt Figma screens |
| **Xcode project setup** | App target, package wiring, settings | Xcode verification |
| **Design System package** | Token and component implementation | — |
| **App implementation** | Models, store, views, navigation, previews | — |
| **Long transaction list** | AsyncStream batch loader for 10K items | Simulator QA; scale and concurrency trade-offs |
| **Build verification** | xcodebuild compile checks | Simulator runs |
| **Documentation** | Architecture doc, README, decisions log | Final README review |

---

## Where AI Helped

- **Boilerplate and structure** — Xcode project layout, SPM package, feature folder organization
- **Design-to-code** — Figma tokens → `DSColors`, `DSTypography`; component scaffolding
- **Migration execution** — Draft/commit refactor, formatters extraction, cursor rules
- **Documentation drafting** — Architecture, decisions log, README
- **Scale work** — AsyncStream loader, incremental row cache, loading UI

---

## Where Engineering Judgement Applied

| Decision | Judgement |
|----------|-----------|
| Two-screen scope only | Developer omitted transfer/success/home (README manual review) |
| All detail fields editable | Confirmed product decision — not recipient-only minimum |
| Commit on back, no save button | Assignment requirement — architectural choice |
| 10K via AsyncStream batches | Developer chose scale + concurrency demonstration |
| Observable store for list refresh | Accepted coupling for simplicity at this scale |
| iOS 26 only | Assignment constraint |
| Protocol DI incomplete | Documented as debt — models still type concrete store |

**Where AI suggestions may have been rejected or deferred:** Full Figma screen set, immediate test target, protocol-typed model dependencies.

---

## Manual Review

### AI-in-the-loop refactors

Developer refactors code independently; AI reviews the diff, suggests an `ai-in-the-loop:` commit message, and proposes doc/rule updates when conventions change. Example: flattening `patchRow(for:)` led to `swift_avoid_nested_nesting.mdc`.

From README manual review section:

- Simulator smoke test: progressive 10K load, scroll during load, edit recipient name, verify list update on back
- Scope decisions: omitted Figma screens outside assignment
- Final README and architecture docs reviewed before submission

---

## Cross References

- [README.md](../README.md) — run, verify, and AI disclosure table
- [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md) — decisions with confidence labels
- [ARCHITECTURE.md](ARCHITECTURE.md) — as-built architecture and AsyncStream loading
