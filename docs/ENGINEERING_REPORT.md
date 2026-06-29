# Engineering Report

## Purpose

Staff-level assessment of this repository as an AI-assisted engineering submission for an iOS take-home assignment.

## Audience

Senior / Staff iOS engineers conducting technical review.

## Table of Contents

- [Executive Summary](#executive-summary)
- [Overall Readiness Score](#overall-readiness-score)
- [Evaluation by Dimension](#evaluation-by-dimension)
- [Strengths](#strengths)
- [Weaknesses](#weaknesses)
- [Risks](#risks)
- [Future Improvements](#future-improvements)
- [Submission Checklist](#submission-checklist)
- [Reflection Summary](#reflection-summary)
- [Cross References](#cross-references)

---

## Executive Summary

This repository delivers a **two-screen SwiftUI banking app** that meets the core assignment requirement: edit a transaction on detail, navigate back, and see the list update without a save button. Architecture is **presentation-driven** with Observation, a composition root, draft/commit editing, and an isolated design system package.

Documentation has been expanded beyond a typical take-home to include architecture, engineering decisions (with confidence labels), AI transparency, and an honest accounting of intentional debt.

**Primary differentiator for review:** Demonstrates engineering judgement through scope control, architecture migration, manual QA, transparent AI disclosure, and documented trade-offs — not merely generated code.

---

## Overall Readiness Score

### **8 / 10** — Ready for submission with known, documented gaps

| Score | Meaning |
|-------|---------|
| 9–10 | Production-polish; comprehensive tests; zero doc/code drift |
| **7–8** | **Solid take-home; clear architecture; honest documentation; minor debt** |
| 5–6 | Core works; significant gaps undocumented |
| 1–4 | Incomplete or misleading |

**Rationale:** Core requirement implemented with presentation-driven architecture and 10K AsyncStream loading. Deductions for: no test target, incomplete protocol DI, silent validation UX, and iOS 26-only constraint.

---

## Evaluation by Dimension

| Dimension | Rating | Notes |
|-----------|--------|-------|
| **Architecture** | Strong | Clear layers; composition root; draft/commit; honest debt disclosure |
| **SwiftUI** | Strong | Layout-only views; private content subviews; value navigation |
| **Observation** | Strong | Consistent `@Observable` + `@Bindable`; observable store refresh |
| **Design System** | Good | Clean package boundary; 4 unused components documented |
| **Code organization** | Strong | Feature folders; shared formatters; cursor rules |
| **Documentation** | Strong | Full suite with single source of truth map |
| **Developer experience** | Good | README run/verify; workspace; previews; no tests |
| **Maintainability** | Good | Presentation models scale; protocol DI incomplete |
| **Scalability** | Adequate | In-memory store; fine for demo; roadmap for production |
| **Engineering maturity** | Strong | Decisions logged; confidence labels; no fabricated intent |
| **AI-assisted workflow** | Strong | Transparent; manual review documented |
| **Interview readiness** | Strong | Can explain every major decision with evidence |

---

## Strengths

1. **Presentation-driven layering is real** — views do not touch the store; models own behavior
2. **Commit-on-back editing** — matches assignment; avoids mid-edit list churn
3. **Design system isolation** — SPM with zero app dependencies; dumb components
4. **Architecture migration completed in code** — formatters extracted, domain purified, draft state
5. **Engineering documentation suite** — decisions, AI usage, process, roadmap, review log
6. **Transparent AI disclosure** — stage-by-stage breakdown; manual review recorded
7. **Cursor rules** — enforceable View/Model boundaries for future contributors
8. **Long list scenario** — 10,000 mock items streamed in batches with progressive UI
9. **Swift 6 strict concurrency** — `@MainActor` presentation models

---

## Weaknesses

1. **No automated tests** — `commit()` parsing and dirty guard unverified by CI
2. **Incomplete protocol DI** — `TransactionRepository` exists; models use concrete store
3. **Silent parse failures** — no validation UX on bad money/date input
4. **Unused surface area** — DS components and domain enum cases without UI paths
5. **iOS 26 only** — limits reviewer environment
6. **Preview helpers in app target** — not debug-gated

---

## Risks

| Risk | Severity | Mitigation in docs |
|------|----------|-------------------|
| Reviewer expects protocol-typed models | Medium | D13 marked Requires confirmation |
| Invalid edit appears saved | Low | D18 documented as assumption |
| Observation breaks if store de-observed | Low | ROADMAP notes production change |
| Documentation drift over time | Medium | Single source of truth map |

---

## Future Improvements

From [ROADMAP.md](ROADMAP.md) — not submission blockers:

- Complete protocol DI + unit tests for `commit()`
- Validation UX for parse failures
- Persistence / API backend
- Trim or implement unused DS components
- Actor-isolated store

---

## Submission Checklist

### Build and run

- [ ] Open `BankApp.xcworkspace` in Xcode 26+
- [ ] Build succeeds on iOS Simulator
- [ ] App launches without crash

### Core requirement

- [ ] Progress bar loads **10,000** transactions; list scrollable during load
- [ ] Scroll deep in list after load; tap any transaction
- [ ] Edit **Name of the recipient** on detail
- [ ] Navigate back — updated name in list

### Documentation

- [ ] [README.md](../README.md) — run, verify, links
- [ ] [ARCHITECTURE.md](ARCHITECTURE.md) — as-built, no stale migration content
- [ ] [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md) — confidence labels
- [ ] [AI_USAGE.md](AI_USAGE.md) — transparency
- [ ] [ENGINEERING_REPORT.md](ENGINEERING_REPORT.md) — this document

### Transparency

- [ ] AI contribution documented
- [ ] Manual review documented
- [ ] No fabricated engineering decisions
- [ ] Known debt explicitly listed (protocol DI, tests, validation)

---

## Reflection Summary

Detailed retrospective: [LESSONS_LEARNED.md](LESSONS_LEARNED.md)

**Key points:**

- Most architecture is inferable from code; scale loading required explicit design (D30)
- Documentation benefited from focusing public docs on architecture and decisions
- AI accelerated implementation and drafting; scope trim and QA required human judgement
- Confidence labels prevent overstating certainty on parse UX and protocol DI

---

## Cross References

- [ARCHITECTURE.md](ARCHITECTURE.md)
- [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md)
- [AI_USAGE.md](AI_USAGE.md)
- [DEVELOPMENT_PROCESS.md](DEVELOPMENT_PROCESS.md)
- [LESSONS_LEARNED.md](LESSONS_LEARNED.md)
