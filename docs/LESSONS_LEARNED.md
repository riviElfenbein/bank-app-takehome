# Lessons Learned

## Purpose

Retrospective on the engineering and documentation process for this AI-assisted submission — focused on **workflow**, not application features.

## Audience

The developer and reviewers interested in how AI-assisted engineering documentation was produced.

## Table of Contents

- [Process Overview](#process-overview)
- [What Could Be Inferred from Code](#what-could-be-inferred-from-code)
- [What Required Developer Input](#what-required-developer-input)
- [Incorrect Assumptions Corrected](#incorrect-assumptions-corrected)
- [Documentation Automation vs Human Input](#documentation-automation-vs-human-input)
- [Most Valuable Interview Topics](#most-valuable-interview-topics)
- [AI Collaboration Reflection](#ai-collaboration-reflection)
- [Recommendations for Future Submissions](#recommendations-for-future-submissions)
- [Cross References](#cross-references)

---

## Process Overview

This submission used a **nine-phase process**:

1. Read-only repository discovery and audit
2. Engineering knowledge extraction with confidence levels
3. Architecture consistency review (implementation vs docs vs intent)
4. Documentation planning with single source of truth map
5. Architecture discovery interview
6. Documentation generation
7. Consistency review
8. Submission assessment (ENGINEERING_REPORT)
9. This retrospective

**Principle throughout:** Never invent architecture. Never silently resolve doc/code conflicts.

---

## What Could Be Inferred from Code

High-confidence decisions derivable without developer interview:

| Decision | Evidence |
|----------|----------|
| Observation for state | Pervasive `@Observable` / `@Bindable` |
| Composition root DI | `AppRootView` owns store; views take models |
| Draft/commit edit flow | Draft properties + `onDisappear` + `commit()` |
| Domain-agnostic design system | Package has zero app imports |
| Value-based navigation | `NavigationLink(value:)` + `navigationDestination` |
| Formatters extracted | Pure `Transaction`; `TransactionFormatters` used |
| Feature folder structure | `Features/TransactionsList`, `TransactionDetail` |

~70% of ENGINEERING_DECISIONS entries are **Confirmed by implementation**.

---

## What Required Developer Input

| Topic | Why inference insufficient |
|-------|---------------------------|
| **Mock count = 1** | Code contradicted README; could be bug or intentional minimal dataset |
| **Protocol DI completion** | Target architecture says protocol; code uses concrete — intent unclear |
| **Silent parse UX** | Behavior exists; product policy not in code |
| **Unused DS components** | Could be dead code or intentional backlog |
| **AI rejection stories** | Not recorded in code — only in developer memory / README |

**Developer decisions during build:** Two-screen scope trim; 10K AsyncStream loading for scale demonstration; all detail fields editable.

**Not confirmed in interview batch:** Protocol DI, parse UX, unused DS — documented with confidence labels, not fabricated quotes.

---

## Incorrect Assumptions Corrected

| Assumption | Reality |
|------------|---------|
| Migration checklist "models use protocol" = done | Models still type concrete `TransactionStore` |
| ARCHITECTURE.md §1 describes current code | §1–§2 were pre-migration; replaced with as-built doc |
| README mock count matches runtime | Was drift; fixed after developer confirmation |
| "Eight editable fields" | Nine draft fields (withdrawal label + last4 separate) |

---

## Documentation Automation vs Human Input

| Document | Automation level | Human input needed |
|----------|------------------|-------------------|
| ARCHITECTURE.md | ~60% | Observable store tradeoff acceptance; debt honesty |
| ENGINEERING_DECISIONS.md | ~65% | Confidence labels; interview overrides |
| DESIGN_SYSTEM.md | ~80% | Figma scope trim narrative |
| AI_USAGE.md | ~50% | Manual review steps; rejection stories |
| DEVELOPMENT_PROCESS.md | ~30% | Process narrative; scope decisions |
| REVIEW_LOG.md | ~20% | Actual QA dates and outcomes |
| ENGINEERING_REPORT.md | ~50% | Readiness self-assessment |
| LESSONS_LEARNED.md | ~25% | This retrospective |
| README.md | ~70% | Final review; verification steps |

**Most auto-generatable:** DESIGN_SYSTEM, ARCHITECTURE (from code)  
**Most human-dependent:** REVIEW_LOG, DEVELOPMENT_PROCESS, LESSONS_LEARNED

---

## Most Valuable Interview Topics

1. **Mock data conflict** — only topic with explicit developer confirmation; prevented documenting a lie or wrong fix
2. **Product scope omissions** — README already had answer; validated Figma trim story
3. **Protocol DI** — surfacing "Requires confirmation" is more honest than claiming migration complete

**Less valuable if README exists:** Assignment constraints (already in README requirements section)

---

## AI Collaboration Reflection

### Where AI accelerated

- Initial architecture planning and migration roadmap
- Figma → design system token/component scaffolding
- Feature implementation boilerplate (models, views, store, navigation)
- Read-only audit across 36 Swift files in one pass
- Documentation drafting from structured audit output
- Consistency review across multiple markdown files

### Where AI was insufficient

- Confirming whether mock count drift was bug vs intent
- Recording what the developer rejected during implementation
- Assigning product meaning to silent parse behavior
- Deciding readiness score without developer QA attestation

### Where engineering judgement was essential

- Scope trim (two screens vs full Figma)
- Manual simulator verification
- All-fields-editable vs recipient-only minimum
- Final README and submission review
- Mock count confirmation and fix approval

---

## Recommendations for Future Submissions

1. **Audit before document** — prevents generating narrative from stale ARCHITECTURE.md
2. **Confidence labels on every decision** — avoids fabricated certainty
3. **One conflict at a time in interview** — or explicit batch with "not selected = not confirmed"
4. **Single source of truth map** — reduces duplication across README and docs/
5. **Separate code-fix approval from doc generation** — mock count fix required explicit confirmation
6. **Keep public README focused** — link only architecture, decisions, AI usage, design system, roadmap
7. **Archive migration docs** — don't leave pre/post migration in same file marked "complete"

---

## Cross References

- [ENGINEERING_REPORT.md](ENGINEERING_REPORT.md) — submission assessment
- [AI_USAGE.md](AI_USAGE.md) — transparency policy
- [DEVELOPMENT_PROCESS.md](DEVELOPMENT_PROCESS.md) — full process
- [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md) — decision log
