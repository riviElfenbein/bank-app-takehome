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
- [Documentation and Audit Process](#documentation-and-audit-process)
- [Cross References](#cross-references)

---

## Transparency Policy

AI is an **engineering tool**. It did not replace:

- Architecture decisions
- Scope control
- Manual simulator verification
- Final documentation review

This document states what AI contributed. For decision rationale, see [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md). For process, see [DEVELOPMENT_PROCESS.md](DEVELOPMENT_PROCESS.md).

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
| **Architecture & planning** | Layer design, feature boundaries, navigation strategy, migration roadmap | Scope approval, product decisions (all fields editable, commit on back) |
| **Design analysis** | Figma MCP extraction of colors, typography, components | Scope trim — omitted unbuilt Figma screens |
| **Xcode project setup** | App target, package wiring, settings | Xcode verification |
| **Design System package** | Token and component implementation | — |
| **App implementation** | Models, store, views, navigation, previews | — |
| **Long transaction list** | Mock provider refactor (121 items) | Confirmed mock count bug fix (2026-06-29) |
| **Build verification** | xcodebuild compile checks | Simulator runs |
| **Documentation** | Architecture doc, README, submission docs, audit | Final README review; interview confirmations |
| **Engineering audit** | Read-only codebase audit, consistency review, knowledge extraction | Mock count confirmation |

---

## Where AI Helped

- **Boilerplate and structure** — Xcode project layout, SPM package, feature folder organization
- **Design-to-code** — Figma tokens → `DSColors`, `DSTypography`; component scaffolding
- **Migration execution** — Draft/commit refactor, formatters extraction, cursor rules
- **Documentation drafting** — Architecture, decisions log, submission package
- **Audit and analysis** — Subsystem inventory, drift detection, decision extraction

---

## Where Engineering Judgement Applied

| Decision | Judgement |
|----------|-----------|
| Two-screen scope only | Developer omitted transfer/success/home (README manual review) |
| All detail fields editable | Confirmed product decision — not recipient-only minimum |
| Commit on back, no save button | Assignment requirement — architectural choice |
| Observable store for list refresh | Accepted coupling for simplicity at this scale |
| iOS 26 only | Assignment constraint |
| Mock count = 120 bulk | Developer confirmed `count: 1` was a bug (2026-06-29) |
| Protocol DI incomplete | Not changed without developer confirmation — documented as debt |

**Where AI suggestions may have been rejected or deferred:** Full Figma screen set, immediate test target, protocol-typed model dependencies (pending confirmation).

---

## Manual Review

From README and [REVIEW_LOG.md](REVIEW_LOG.md):

- Simulator smoke test: scroll long list, edit recipient name, verify list update on back
- Scope decisions: omitted Figma screens outside assignment
- Final README review before submission
- Mock data count verification (121 items)

---

## Documentation and Audit Process

Submission documentation produced via structured process:

1. **Phases 0–3** — Read-only audit, knowledge extraction, architecture consistency review
2. **Phase 5** — Architecture discovery interview (developer confirmation for mock count; other items from README/ARCHITECTURE with confidence labels)
3. **Phases 6–9** — Documentation generation, consistency review, engineering report, lessons learned

Internal working artifacts (not public TOC): `_AUDIT_BRIEF.md`, `_INTERVIEW_NOTES.md`.

---

## Cross References

- [README.md](../README.md) — original AI disclosure table
- [DEVELOPMENT_PROCESS.md](DEVELOPMENT_PROCESS.md) — full process narrative
- [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md) — decisions with confidence labels
- [LESSONS_LEARNED.md](LESSONS_LEARNED.md) — retrospective on AI-assisted documentation
