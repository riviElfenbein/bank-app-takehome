# Engineering Decisions

## Purpose

Record significant architectural and engineering decisions for the Banking App take-home project. Each entry includes evidence, trade-offs, and a confidence label.

## Audience

Staff iOS engineers, reviewers, and future contributors.

## Table of Contents

- [Confidence Labels](#confidence-labels)
- [Core Decisions](#core-decisions)
- [Supporting Decisions](#supporting-decisions)
- [Known Debt and Open Items](#known-debt-and-open-items)
- [Cross References](#cross-references)

---

## Confidence Labels

| Label | Meaning |
|-------|---------|
| **Confirmed by implementation** | Directly evidenced in source code |
| **Confirmed by developer** | Stated in README, interview, or confirmed product decisions |
| **Inferred — high confidence** | Strong documentation or code evidence; not re-confirmed in interview |
| **Inferred — medium confidence** | Reasonable inference; may need validation |
| **Requires confirmation** | Documented intent incomplete or deferred |

Developer confirmation overrides inference where noted in decision entries.

---

## Core Decisions

### D1 — Observation for state management

| | |
|---|---|
| **Decision** | Use Swift Observation (`@Observable`, `@Bindable`) for feature models and store |
| **Problem** | Assignment requires Observation; avoid ObservableObject/Combine boilerplate |
| **Evidence** | `TransactionStore`, `TransactionsListModel`, `TransactionDetailModel`; README requirements |
| **Trade-offs** | iOS 26+ only; nested observation through computed properties is implicit |
| **Alternatives** | ObservableObject — not used |
| **Future impact** | Standard pattern for new features |
| **Confidence** | Confirmed by developer (README) + Confirmed by implementation |

---

### D2 — Presentation models own feature behavior

| | |
|---|---|
| **Decision** | `TransactionsListModel` and `TransactionDetailModel` own commands, formatting orchestration, and repository interaction |
| **Problem** | Keep views declarative; centralize business behavior |
| **Evidence** | Feature model files; `.cursor/rules/swiftui_view_responsibility.mdc` |
| **Trade-offs** | More types than inline view logic |
| **Alternatives** | View-owned store access — rejected by cursor rules |
| **Future impact** | New screens follow `Features/<Name>/<Name>Model.swift` |
| **Confidence** | Confirmed by implementation |

---

### D3 — Composition root with manual injection

| | |
|---|---|
| **Decision** | `AppRootView` owns store and constructs models; feature views receive ready-made `@Bindable` models |
| **Problem** | Explicit dependency graph; no `@Environment` store leakage |
| **Evidence** | `BankApp/App/AppRootView.swift`; cursor rules § Composition Root |
| **Trade-offs** | Root wiring grows with features |
| **Alternatives** | Environment-based DI — prohibited by project rules |
| **Future impact** | Each feature adds composition root wiring |
| **Confidence** | Confirmed by implementation |

---

### D4 — In-memory store as source of truth

| | |
|---|---|
| **Decision** | `TransactionStore` holds `[Transaction]` in memory; no disk or network persistence |
| **Problem** | Take-home scope; simple read/update for two screens |
| **Evidence** | `BankApp/Services/TransactionStore.swift` |
| **Trade-offs** | Data lost on relaunch |
| **Alternatives** | Core Data / API — out of scope |
| **Future impact** | Production would replace or wrap store |
| **Confidence** | Confirmed by implementation |

---

### D5 — Observable store for cross-screen refresh

| | |
|---|---|
| **Decision** | `@Observable` on `TransactionStore` so list `rows` refresh after detail `commit()` |
| **Problem** | List must update on back navigation without explicit callbacks |
| **Evidence** | Observable store; list reads `repository.transactions`; ARCHITECTURE.md observation strategy |
| **Trade-offs** | Couples persistence to UI observation; complicates protocol-only repository later |
| **Alternatives** | Plain repository + manual reload — documented, not chosen |
| **Future impact** | Protocol-typed non-observable repo needs alternate refresh wiring |
| **Confidence** | Confirmed by implementation; rationale — Inferred — high confidence |

---

### D6 — Draft-then-commit on navigation back

| | |
|---|---|
| **Decision** | Detail edits live in draft strings; `commit()` on `onDisappear`; no save button |
| **Problem** | Assignment: list updates on back only; avoid mid-edit list churn |
| **Evidence** | `TransactionDetailModel` draft properties; `TransactionDetailView.onDisappear`; README |
| **Trade-offs** | Commits on any disappear; no cancel-without-save |
| **Alternatives** | Live commit per keystroke — migrated away |
| **Future impact** | Save/Cancel UX needs new commands |
| **Confidence** | Confirmed by developer (README) + Confirmed by implementation |

---

### D7 — BankDesignSystem as local SPM

| | |
|---|---|
| **Decision** | Design tokens and components in `Packages/BankDesignSystem` |
| **Problem** | Assignment requires separate Design System package |
| **Evidence** | `Package.swift`; app imports `BankDesignSystem` |
| **Trade-offs** | Package overhead for small app |
| **Alternatives** | In-app design folder — rejected by assignment |
| **Future impact** | Package can grow independently |
| **Confidence** | Confirmed by developer (README) |

---

### D8 — Domain-agnostic design system components

| | |
|---|---|
| **Decision** | DS components accept primitives only — no app model imports |
| **Problem** | Reusable UI boundary |
| **Evidence** | All DS component APIs; zero package dependencies |
| **Trade-offs** | Call sites pre-format strings |
| **Alternatives** | Domain-aware components — not used |
| **Future impact** | DS stays portable |
| **Confidence** | Confirmed by implementation |

---

### D9 — Value-based NavigationStack

| | |
|---|---|
| **Decision** | `NavigationLink(value: Transaction.ID)` + `.navigationDestination(for:)` |
| **Problem** | Type-safe navigation; stable identity for long list |
| **Evidence** | `AppRootView.swift`, `TransactionsListView.swift` |
| **Trade-offs** | Single stack; no programmatic path yet |
| **Alternatives** | Destination-based links — not used |
| **Future impact** | Extends to other ID types |
| **Confidence** | Confirmed by implementation |

---

### D10 — New detail model per push

| | |
|---|---|
| **Decision** | Fresh `TransactionDetailModel` per `navigationDestination` invocation |
| **Problem** | Draft scoped to one edit session |
| **Evidence** | Model constructed in destination closure; `committedSnapshot` at init |
| **Trade-offs** | No state restoration across pop/push |
| **Alternatives** | Cached detail model — not used |
| **Future impact** | iPad multi-pane would need different lifetime |
| **Confidence** | Inferred — high confidence (ARCHITECTURE §6 assumption) |

---

### D11 — Presentation formatters extracted from domain

| | |
|---|---|
| **Decision** | `TransactionFormatters` owns screen strings; `Transaction` is pure data |
| **Problem** | Domain should not encode UI locale/format rules |
| **Evidence** | `Transaction.swift` (fields only); `TransactionFormatters.swift` |
| **Trade-offs** | `Money.formatted` remains on domain (see D22) |
| **Alternatives** | Formatters on domain types — migrated away |
| **Future impact** | Locale changes localize to formatters |
| **Confidence** | Confirmed by implementation |

---

### D12 — Two-screen product scope

| | |
|---|---|
| **Decision** | Ship list + detail only; omit Figma transfer/success/home flows |
| **Problem** | Assignment scope control |
| **Evidence** | README manual review; only two feature folders |
| **Trade-offs** | Unused DS components remain in package |
| **Alternatives** | Full Figma flow — declined |
| **Future impact** | DS backlog maps to unbuilt screens |
| **Confidence** | Confirmed by developer (README) |

---

## Supporting Decisions

### D13 — TransactionRepository protocol (incomplete adoption)

| | |
|---|---|
| **Decision** | Introduce `TransactionRepository` protocol; `TransactionStore` conforms |
| **Problem** | Persistence boundary for testability |
| **Evidence** | `TransactionRepository.swift`; store extension |
| **Trade-offs** | Models still store concrete `TransactionStore` — boundary incomplete |
| **Alternatives** | Concrete store only — pre-migration |
| **Future impact** | Type models as protocol when tests added |
| **Confidence** | Confirmed by implementation; protocol DI completion — **Requires confirmation** |

---

### D14 — TransactionRowState snapshots

| | |
|---|---|
| **Decision** | List builds immutable row snapshots with pre-formatted strings |
| **Evidence** | `TransactionsListModel.rowState(for:)`; `TransactionListContent(rows:)` |
| **Confidence** | Confirmed by implementation |

---

### D15 — DetailDraftSnapshot dirty tracking

| | |
|---|---|
| **Decision** | `commit()` no-ops when draft equals `committedSnapshot` |
| **Evidence** | `TransactionDetailModel.hasUncommittedChanges` |
| **Confidence** | Confirmed by implementation |

---

### D16 — Search debounce in list model (200ms)

| | |
|---|---|
| **Decision** | Model owns debounce; view triggers via `.task(id: searchText)` |
| **Evidence** | `TransactionsListModel.applyDebouncedSearch()` |
| **Confidence** | Confirmed by implementation |

---

### D17 — MockTransactionProvider separate from store

| | |
|---|---|
| **Decision** | Seed data in `MockTransactionProvider`; loaded via `TransactionLoader` AsyncStream, not synchronous store init |
| **Evidence** | `TransactionLoader.swift`, `MockTransactionProvider.transactionStream`; empty default `TransactionStore.init` |
| **Confidence** | Confirmed by implementation |

---

### D18 — Silent partial commit on parse failure

| | |
|---|---|
| **Decision** | Invalid money/date on commit skips that field; no user-visible error |
| **Evidence** | `commit()` optional parsing; no error UI |
| **Trade-offs** | User may believe invalid value saved |
| **Alternatives** | Block commit; inline errors — not implemented |
| **Confidence** | **Inferred — high confidence** (ARCHITECTURE §6 assumption; not re-confirmed in interview) |

---

### D19 — @MainActor on presentation models

| | |
|---|---|
| **Decision** | Both feature models are `@MainActor @Observable` |
| **Evidence** | Model declarations; `SWIFT_STRICT_CONCURRENCY = complete` |
| **Confidence** | Confirmed by implementation |

---

### D20 — Preview injection pattern

| | |
|---|---|
| **Decision** | Previews construct store outside view, inject model |
| **Evidence** | `#Preview` blocks; cursor rules § Previews |
| **Confidence** | Confirmed by implementation |

---

### D22 — Dual formatting: Money + TransactionFormatters

| | |
|---|---|
| **Decision** | `Money.formatted` for currency; `TransactionFormatters` for screen-specific rules |
| **Evidence** | Both used in list and detail paths |
| **Confidence** | Confirmed by implementation |

---

### D27 — All nine detail fields editable

| | |
|---|---|
| **Decision** | All detail form fields editable and committed, not recipient-only |
| **Evidence** | Nine `$model.draft*` bindings; ARCHITECTURE confirmed product decision |
| **Confidence** | Confirmed by developer (ARCHITECTURE) |

---

### D30 — AsyncStream batch loading for 10K transactions

| | |
|---|---|
| **Decision** | Load 10,000 transactions via `AsyncStream<TransactionBatch>` in batches of 500; background generation in `Task.detached`, append on `@MainActor` store |
| **Problem** | Long-list assignment at scale; avoid blocking launch; demonstrate Swift 6 concurrency boundaries |
| **Evidence** | `MockTransactionLoader`, `TransactionsListModel.load(using:)`, `TransactionStore.appendBatch`, progress UI |
| **Trade-offs** | Full array sorted once off main thread before streaming; search remains O(n); 50ms simulated batch delay |
| **Alternatives** | Synchronous init — rejected; actor-isolated store — deferred |
| **Future impact** | Replace mock stream with paginated API or SSE |
| **Confidence** | Confirmed by implementation |

---

### Mock data — 10,000 transactions

| | |
|---|---|
| **Decision** | 1 Figma exemplar + 9,999 generated items; streamed in batches of 500; previews use 50-item sync subset |
| **Problem** | Assignment long-list verification at scale |
| **Evidence** | `TransactionLoadConfiguration.totalCount`; README mock data section |
| **Note** | Replaced earlier 121-item prototype with 10K AsyncStream loading |
| **Confidence** | Confirmed by implementation |

---

## Known Debt and Open Items

| Item | Status | Owner doc |
|------|--------|-----------|
| Models use concrete `TransactionStore` not protocol | Requires confirmation | This doc D13 |
| Silent parse UX | Inferred — high confidence | This doc D18 |
| No test target | Deferred | [ROADMAP.md](ROADMAP.md) |
| Unused DS components | Inferred backlog | [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) |
| Unused domain enum cases (`pending`, `mastercard`) | Future work | [ROADMAP.md](ROADMAP.md) |

---

## Cross References

- [ARCHITECTURE.md](ARCHITECTURE.md) — as-built layers and flows
- [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) — component inventory
- [AI_USAGE.md](AI_USAGE.md) — how decisions were implemented with AI assistance
- [ROADMAP.md](ROADMAP.md) — deferred work
