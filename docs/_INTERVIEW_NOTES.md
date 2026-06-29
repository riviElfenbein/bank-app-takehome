# Architecture Discovery Interview Notes

> **Internal working document.** Captures developer confirmations and documented intent used during submission documentation.
> Not linked from README public TOC.

## Interview Method

Phase 5 conducted via structured confirmation. Developer answered blocking conflict batch on 2026-06-29.

---

## Topic 1 — Project Goals and Constraints

**Question:** Why was this project built, and which constraints came from the assignment vs self-imposed?

**Answer (from README + repository evidence):**

| Constraint | Source | Confidence |
|------------|--------|------------|
| iOS 26, SwiftUI, Observation | Assignment requirement | Confirmed by developer (README) |
| Separate Design System SPM | Assignment requirement | Confirmed by developer (README) |
| Two screens: list + detail | Assignment requirement | Confirmed by developer (README) |
| Edit recipient on detail, list updates on back, no save button | Assignment requirement | Confirmed by developer (README) |
| Long transaction list (121 items) | Assignment + README verification steps | **Confirmed by developer (2026-06-29): mock count=1 was a bug** |
| AI assistance permitted and disclosed | Assignment | Confirmed by developer (README) |

**Self-imposed (README manual review):**

- Omitted transfer/success/home screens from Figma — out of assignment scope
- Figma + Dribbble as design references

---

## Topic 2 — Product Scope and Omissions

**Question:** What was intentionally omitted?

**Answer (README L110):**

- Transfer flow, success screen, home quick actions from Figma — **intentionally omitted**
- Label: **Confirmed by developer (README manual review section)**

**Future work vs debt:** See [ROADMAP.md](ROADMAP.md)

---

## Topic 3 — Mock Data Count Conflict

**Conflict:** README documented 121 items; code had `generateBulk(count: 1)`.

**Developer answer (2026-06-29):** Mock count=1 **was a bug**. Restore 120 bulk + 1 exemplar = 121 total.

**Action taken:** `MockTransactionProvider.generateBulk(count: 120)` — code fix applied.

**Confidence:** Confirmed by developer

---

## Topic 4 — Observation and State Ownership

**Question:** Why Observation, and why is the store `@Observable`?

**Answer (evidence-based, not re-confirmed in interview batch):**

- Observation: assignment requirement (README)
- `@Observable` store: list refreshes after detail `commit()` without explicit callback wiring (ARCHITECTURE.md §3 observation strategy)

**Confidence:** Confirmed by implementation; observable store rationale — Inferred — high confidence (ARCHITECTURE §3)

---

## Topic 5 — Composition Root and DI

**Question:** Why manual constructor injection at `AppRootView` instead of `@Environment`?

**Answer (cursor rules + implementation):**

- Views depend on presentation models only
- Infrastructure constructed at composition root
- Documented in `.cursor/rules/swiftui_view_dependencies.mdc`

**Confidence:** Confirmed by implementation + cursor rules

---

## Topic 6 — Repository Protocol vs Concrete Store

**Conflict:** `TransactionRepository` protocol exists; models store `TransactionStore` concretely; migration checklist marked complete.

**Developer answer:** Not selected in confirmation batch — **not confirmed for code change**.

**Documented stance:**

- Protocol introduced for persistence boundary (Phase 1 migration intent)
- Models still type concrete `TransactionStore` — **architectural debt / incomplete Phase 1**
- Parameter label `repository:` with concrete type is intentional naming, not protocol typing

**Confidence:** Confirmed by implementation; completion of protocol DI — Requires confirmation (deferred)

---

## Topic 7 — Draft Commit and Parse Failure UX

**Question:** What happens when money/date parse fails on commit?

**Developer answer:** Not selected in confirmation batch.

**Documented assumption (ARCHITECTURE.md §6):**

- Keep last valid domain value for invalid fields
- Commit valid fields; silent no-op per field
- No error banners

**Confidence:** Inferred — high confidence (ARCHITECTURE §6 planning assumption, not re-confirmed by developer in interview)

**Commit trigger:** `onDisappear` calls `commit()` — same as back navigation (ARCHITECTURE §6 assumption)

---

## Topic 8 — Design System Scope and Unused Components

**Question:** Why do unused components exist (`DSPrimaryButton`, `DSQuickActionTile`, etc.)?

**Developer answer:** Not selected in confirmation batch.

**Documented intent (README L110):** Figma screens omitted from app scope; components extracted during design analysis remain in package.

**Confidence:** Inferred — high confidence (README scope trim + README stage 2/4 AI workflow)

**Unused components:** Intentional backlog for unbuilt Figma screens — not dead code to delete without confirmation.

---

## Topic 9 — Formatting Ownership

**Question:** Why both `Money.formatted` and `TransactionFormatters`?

**Answer (implementation):**

- `Money.formatted` — general currency display for domain value type
- `TransactionFormatters` — screen-specific rules (hero minus strip, commission copy, list subtitle, date formats)

**Confidence:** Confirmed by implementation; split rationale — Inferred — high confidence

---

## Topic 10 — All Fields Editable

**Question:** Why all nine detail fields editable vs recipient-only?

**Answer (ARCHITECTURE.md confirmed product decision L9):** All detail fields remain editable — preserves Figma detail form scope.

**Developer answer:** Not re-confirmed in interview batch; ARCHITECTURE marked as confirmed product decision.

**Confidence:** Confirmed by developer (ARCHITECTURE.md confirmed product decisions section)

---

## Topic 11 — AI Collaboration Workflow

**Answer source:** README AI & Tools Disclosure table (L91–105) + manual review (L107–111)

| Stage | AI role | Developer role |
|-------|---------|----------------|
| Architecture planning | Cursor Plan mode | Scope decisions |
| Figma extraction | Figma MCP + Agent | — |
| Implementation | Cursor Agent | Manual simulator QA |
| Documentation | Cursor Agent | Final README review |
| Scope trim | — | Omitted Figma screens |

**Confidence:** Confirmed by developer (README)

---

## Topic 12 — Manual Engineering and Review

**From README L107–111:**

- Simulator smoke test: scroll long list, edit name, verify list update on back
- Scope decisions: omitted transfer/success screens
- Final README review before submission

**Confidence:** Confirmed by developer (README)

---

## Topic 13 — Future Evolution (If Production)

**Not interviewed.** Documented in [ROADMAP.md](ROADMAP.md) as inferred future work.

---

## Summary: Developer-Confirmed vs Inferred

| Item | Status |
|------|--------|
| Mock count 121 | **Confirmed by developer** — bug fixed |
| Two-screen scope | Confirmed by developer (README) |
| All fields editable | Confirmed by developer (ARCHITECTURE) |
| AI workflow table | Confirmed by developer (README) |
| Manual review steps | Confirmed by developer (README) |
| Protocol DI in models | Requires confirmation — deferred |
| Silent parse UX | Inferred — high confidence (ARCHITECTURE §6) |
| Unused DS backlog | Inferred — high confidence (README scope) |
| @Observable store tradeoff | Inferred — high confidence (ARCHITECTURE §3) |

---

## Re-evaluation After Answers

- Mock data code and README now aligned (121 items)
- Protocol DI remains documented debt — do not claim checklist item complete in public docs
- Parse UX and unused DS documented as assumptions, not fabricated developer quotes
