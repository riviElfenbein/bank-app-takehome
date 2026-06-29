# Roadmap

## Purpose

Distinguish **intentional debt**, **deferred work**, and **potential production evolution** for the Banking App.

## Audience

Reviewers and future contributors.

## Table of Contents

- [Current Scope](#current-scope)
- [Intentional Debt](#intentional-debt)
- [Deferred Work](#deferred-work)
- [Production Evolution](#production-evolution)
- [Cross References](#cross-references)

---

## Current Scope (Shipped)

- Transactions list with search (**10,000** mock items via AsyncStream)
- Transaction detail with nine editable fields
- Commit-on-back edit flow
- Local `BankDesignSystem` SPM (7/11 components used)
- In-memory persistence
- iOS 26, Swift 6, Observation

---

## Intentional Debt

Items accepted for take-home scope; documented, not hidden.

| Item | Rationale | Decision ref |
|------|-----------|--------------|
| In-memory store only | Assignment scope | D4 |
| No test target | Time/scope deferral | D29 |
| Models use concrete `TransactionStore` | Protocol DI not confirmed for code change | D13 |
| Silent parse failures on commit | Planning assumption; no validation UI | D18 |
| Unused DS components in package | Figma backlog for omitted screens | DESIGN_SYSTEM |
| Unused domain enums (`pending`, `failed`, `mastercard`, `mir`) | Future UI not built | — |
| Preview helpers in app target | Simplicity; not `#if DEBUG` gated | — |
| `Money.formatted` + `TransactionFormatters` dual path | Pragmatic split | D22 |
| Full array sort before stream begins | Simplifies batch order; one background pass | D30 |

---

## Deferred Work

| Item | Priority | Blocked by |
|------|----------|------------|
| Protocol-typed model dependencies | Medium | Developer confirmation |
| Unit tests for `commit()` parsing and dirty guard | Medium | Test target creation |
| Validation UX (inline errors on bad parse) | Low | Product decision |
| Cancel/discard draft without save | Low | Requires Save/Cancel UI |
| Trim or document unused DS components explicitly in package README | Low | Scope confirmation |
| Full-text search index | Low | Product requirements |
| Real API pagination replacing mock stream | Medium | Backend availability |
| Localization / locale strategy for formatters | Low | Product requirements |

---

## Production Evolution

If this became production software, likely **first changes**:

1. **Persistence** — Core Data, SwiftData, or API-backed repository replacing in-memory store
2. **Networking** — Remote transaction sync via paginated API or SSE; replace mock `AsyncStream`
3. **Testing** — Unit tests for presentation model `commit()`; UI tests for edit flow
4. **Complete protocol DI** — Models depend on `TransactionRepository`; mock for tests
5. **Validation layer** — User-visible errors; block or partial commit policy
6. **Authentication** — Session, secure storage
7. **Design system** — Asset catalog tokens, dark mode, trim unused Figma components or build missing screens

Likely **unchanged**:

- Presentation model pattern (View → Model → Repository)
- Composition root DI (possibly extended, not replaced with global singleton)
- Draft/commit pattern for multi-field edits
- Design system package boundary
- Value-based navigation foundation

---

## Cross References

- [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md) — decision log
- [ARCHITECTURE.md](ARCHITECTURE.md) — known limitations
- [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) — unused components
- [ENGINEERING_REPORT.md](ENGINEERING_REPORT.md) — submission assessment
