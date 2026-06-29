# Design System

## Purpose

Document the `BankDesignSystem` Swift Package: tokens, components, usage in the app, and scope relative to the Figma reference.

## Audience

UI contributors and Staff iOS reviewers.

## Table of Contents

- [Package Overview](#package-overview)
- [Design Principles](#design-principles)
- [Tokens](#tokens)
- [Components](#components)
- [Extensions](#extensions)
- [App Usage Map](#app-usage-map)
- [Figma Scope](#figma-scope)
- [Cross References](#cross-references)

---

## Package Overview

| Property | Value |
|----------|-------|
| **Path** | `Packages/BankDesignSystem` |
| **Product** | `BankDesignSystem` library |
| **Platform** | iOS 26 |
| **Swift tools** | 6.2 |
| **Dependencies** | None |

The app target imports `BankDesignSystem`. The package does **not** import app code.

---

## Design Principles

1. **Domain-agnostic** — components accept primitives (`String`, `Binding<String>`, booleans), never `Transaction` or store types
2. **Token-driven** — colors, typography, spacing, and radii centralized in `Tokens/`
3. **Composable** — small building blocks (`DSIconBadge`, `DSAmountLabel`) compose into rows and headers
4. **Prefix `DS`** — all public types use the `DS` prefix

See [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md) D7, D8.

---

## Tokens

| Token | File | Contents |
|-------|------|----------|
| `DSColors` | `Tokens/DSColors.swift` | `white`, `grey`, `dark`, `primary`, `success`, `labelSecondary`, `separator` |
| `DSTypography` | `Tokens/DSTypography.swift` | `title1`–`title4`, `caption`, `button` |
| `DSSpacing` | `Tokens/DSSpacing.swift` | `screenHorizontal`, `rowHeight`, `buttonHeight`, icon sizes, section spacing |
| `DSRadius` | `Tokens/DSRadius.swift` | `button`, `card`, `visaBadge` |
| `DSShadow` | `Tokens/DSShadow.swift` | `ShadowStyle`, `DSShadow.none` only |

Colors are hardcoded RGB values extracted from Figma — no asset catalog in the package.

---

## Components

| Component | Purpose | Used in app |
|-----------|---------|-------------|
| `DSLabeledField` | Editable labeled row with underline | Transaction Detail |
| `DSLabeledRow` | Read-only labeled row with optional accessory | **No** — Figma detail read-only variant |
| `DSTransactionRow` | List cell: initial, name, subtitle, amount | Transactions List |
| `DSPerformedHeader` | Success hero: checkmark, name, amount, commission, date | Transaction Detail |
| `DSStatusHeader` | Alternate status header | **No** — transfer/success flow |
| `DSCardSurface` | White card with top rounded corners | Transaction Detail |
| `DSSectionHeader` | Section title with info icon | Transaction Detail |
| `DSIconBadge` | Info, Visa, merchant initial variants | List, Detail |
| `DSAmountLabel` | Styled amount (hero / row / field) | Via row + header |
| `DSPrimaryButton` | Primary CTA button | **No** — success screen "To Main" |
| `DSQuickActionTile` | Home quick action tile | **No** — home screen |

**Used:** 7 of 11 components in shipped app screens.

---

## Extensions

| Extension | API | Used |
|-----------|-----|------|
| `View+DS` | `dsScreenBackground()` — grey full-screen background | List, Detail |
| `View+Keyboard` | `dsKeyboardDoneToolbar()`, `DSKeyboard.dismiss()` | App root |

---

## App Usage Map

### Transactions List

- `dsScreenBackground()`
- Custom header (not a DS component — uses `DSTypography`, `DSColors` directly)
- `DSTransactionRow` in `List`

### Transaction Detail

- `DSPerformedHeader` — hero section
- `DSCardSurface` — operation details card
- `DSSectionHeader` — "Operation details"
- `DSLabeledField` × 9 — editable fields
- `DSIconBadge` — Visa badge when card brand is Visa

Formatting (dates, amounts, subtitles) happens in the app layer via `TransactionFormatters` before passing strings to DS components.

---

## Figma Scope

**Design reference:** [Figma — Banking App (Community)](https://www.figma.com/design/rlimJjeBmjIy1Y45ddarZV/Banking-App--Community-)

**Implemented in app:** List screen + Transaction Details (editable form).

**Extracted to DS but not wired in app** (intentional scope trim per README manual review):

- Success / performed flow extras (`DSPrimaryButton`, alternate headers)
- Home quick actions (`DSQuickActionTile`)
- Read-only field variant (`DSLabeledRow`)

**Confidence:** Inferred — high confidence that unused components are Figma backlog, not accidental omission. Not re-confirmed in developer interview batch.

Unused components remain available if scope expands — see [ROADMAP.md](ROADMAP.md).

---

## Cross References

- [ARCHITECTURE.md](ARCHITECTURE.md) — design system boundary in layer model
- [ENGINEERING_DECISIONS.md](ENGINEERING_DECISIONS.md) — D7, D8, D12
- [AI_USAGE.md](AI_USAGE.md) — Figma MCP design extraction stage
