# Internal Audit Brief

> **Internal working document.** Not linked from README. Source input for submission documentation.
> Generated from repository audit (Phases 0–3). Do not treat as public narrative.

## Topology

- **App:** `BankApp` — iOS 26, Swift 6, strict concurrency, single target, no tests
- **Package:** `BankDesignSystem` — local SPM, iOS 26, zero dependencies
- **Docs:** `README.md`, `docs/ARCHITECTURE.md` (pre-rewrite: dual-era content)
- **Rules:** `.cursor/rules/swiftui_*.mdc` (3 files)

## As-Built Architecture

```
AppRootView (composition root, @State store + listModel)
  └── NavigationStack
        ├── TransactionsListView → TransactionsListModel → TransactionRepository
        └── navigationDestination(Transaction.ID) → TransactionDetailView → TransactionDetailModel
```

- **State:** Observation (`@Observable`, `@Bindable`, `@State` for store lifetime)
- **Persistence:** In-memory `TransactionStore` (@Observable), conforms to `TransactionRepository`
- **Edit flow:** Draft strings in detail model → `commit()` on `onDisappear` → store mutation → list refresh via Observation
- **Formatting:** `TransactionFormatters` (presentation); `Transaction` pure data; `Money.formatted` + `Money.parse`
- **Design system:** Dumb components in SPM; app pre-formats strings

## Drift Resolved (Submission Process)

| Issue | Was | Resolution |
|-------|-----|------------|
| Mock count | `generateBulk(count: 1)` → 2 items | Fixed to 120 per README assignment spec |
| Model deps | Concrete `TransactionStore` | Typed as `TransactionRepository` |
| ARCHITECTURE.md | Pre/post migration mixed | Replaced with as-built doc |
| Field count docs | "Eight fields" | Nine draft fields (withdrawal label + last4 separate) |

## Open Items (Documented Assumptions)

| Topic | Resolution source | Label |
|-------|-------------------|-------|
| Silent parse on commit | ARCHITECTURE.md §6 planning assumption | Inferred — high confidence |
| Commit on disappear (no cancel) | ARCHITECTURE.md §6 assumption | Inferred — high confidence |
| @Observable store for refresh | ARCHITECTURE.md §3 observation strategy | Confirmed by implementation + docs |
| Unused DS components | README manual review — Figma scope trim | Confirmed by developer (README) |
| All detail fields editable | ARCHITECTURE.md confirmed product decision | Confirmed by developer (ARCHITECTURE) |
| No test target | ARCHITECTURE.md §6 deferral | Confirmed by implementation |

## Core Decisions (Summary)

D1 Observation · D3 Composition root · D4 In-memory store · D5 Observable store refresh · D6 Draft/commit on back · D7 DS SPM · D8 DS domain-agnostic · D9 Value NavigationStack · D11 Formatters extracted · D12 Two-screen scope

## Strengths

Presentation-driven layering; commit-on-back editing; pure domain; isolated DS; cursor rules enforce View/Model boundary; Swift 6 + Observation

## Weaknesses / Risks

No automated tests; silent parse failures; unused DS/domain enum cases; preview helpers in app target; iOS 26-only

## Document Ownership (Single Source of Truth)

| Concept | Owner |
|---------|-------|
| Run / verify | README.md |
| As-built architecture | ARCHITECTURE.md |
| Design system | DESIGN_SYSTEM.md |
| Decisions | ENGINEERING_DECISIONS.md |
| AI transparency | AI_USAGE.md |
| Process | DEVELOPMENT_PROCESS.md |
| Future work | ROADMAP.md |
| Submission assessment | ENGINEERING_REPORT.md |
