# Banking App — Take-Home Assignment

**Repository:** https://github.com/riviElfenbein/bank-app-takehome

A SwiftUI banking app (iOS 26) with a long transactions list and a detail screen where the recipient name can be edited and immediately reflected in the list.

## Requirements Implemented

- SwiftUI, iOS 26 deployment target
- Observation framework for state management
- Separate Swift Package for the Design System
- Two screens: Transactions List + Transaction Details
- Editable transaction name on the detail screen — updates appear in the list on back navigation (no save button)

## Design References

- [Figma — Banking App (Community)](https://www.figma.com/design/rlimJjeBmjIy1Y45ddarZV/Banking-App--Community-)
- [Dribbble — Banking App](https://dribbble.com/shots/19561980-Banking-App)

## How to Run

1. Open `BankApp.xcworkspace` in **Xcode 26+**
2. Select an **iOS 26 Simulator** (e.g. iPhone 16)
3. Press **Run** (⌘R)

Or from the terminal:

```bash
cd bank
xcodebuild -project BankApp.xcodeproj -scheme BankApp \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' build
```

## How to Verify the Core Requirement

1. Launch the app — the **Transactions** screen shows **121+** items
2. Scroll down and tap any transaction (including items deep in the list)
3. On the Details screen, edit **Name of the recipient**
4. Navigate back — the updated name appears immediately in the list

## Architecture

- **`TransactionStore`** — `@Observable` single source of truth for `[Transaction]`
- **`NavigationStack`** — value-based navigation using `Transaction.ID`
- **`BankDesignSystem`** — local Swift Package with tokens (colors, typography, spacing) and reusable components
- **Edit flow** — Detail screen writes to the store via `updateRecipientName`; Observation refreshes the list automatically

```
AppRootView
  └── NavigationStack
        ├── TransactionsListView   (reads store)
        └── TransactionDetailView  (mutates store via Binding)
```

## Project Structure

```
bank/
├── BankApp.xcworkspace
├── BankApp/
│   ├── App/              AppRootView
│   ├── Features/         TransactionsList, TransactionDetail
│   ├── Models/           Transaction, Money, PaymentCard
│   ├── Services/         TransactionStore, MockTransactionProvider
│   └── Preview Support/
└── Packages/
    └── BankDesignSystem/ tokens + components
```

## Mock Data

- **1** fixed Figma exemplar transaction (Alexander Dmitrievich V.)
- **120** programmatically generated transactions (merchant names, amounts, dates spread over 365 days)
- **Total: 121** items, sorted by date descending

## Tech Stack

- Swift 6, SwiftUI, Observation
- iOS 26 deployment target
- Local Swift Package: `BankDesignSystem`

---

## AI & Tools Disclosure

This project was built with AI assistance as permitted by the assignment. Below is a breakdown of **what was done**, **which tool**, and **which model** was used at each stage.

| Stage | Work Done | Tool | Model |
|-------|-----------|------|-------|
| **1. Architecture & planning** | Layer design, feature boundaries, state ownership, navigation strategy, implementation roadmap | [Cursor](https://cursor.com) (Plan mode) | Cursor Agent (Composer) |
| **2. Design analysis** | Extracted colors, typography, components, and screen layout from the Figma file | Cursor + **Figma MCP** (`get_design_context`, `get_metadata`, `get_variable_defs`) | Cursor Agent (Composer) |
| **3. Xcode project & workspace** | App target, iOS 26 settings, local package wiring, asset catalog | Cursor (Agent mode) + **Xcode 26** / `xcodebuild` | Cursor Agent (Composer) |
| **4. Design System package** | Tokens (`DSColors`, `DSTypography`, …) and components (`DSLabeledRow`, `DSTransactionRow`, …) | Cursor (Agent mode) | Cursor Agent (Composer) |
| **5. App implementation** | Models, `@Observable` store, list & detail screens, navigation, previews | Cursor (Agent mode) | Cursor Agent (Composer) |
| **6. Long transaction list** | Refactored `MockTransactionProvider` — 1 Figma exemplar + 120 generated items | Cursor (Agent mode) | Cursor Agent (Composer) |
| **7. Build verification** | Compile checks on iOS Simulator | **Xcode 26** — `xcodebuild` | — (local toolchain) |
| **8. README & documentation** | Run instructions, architecture summary, AI disclosure (this file) | Cursor (Agent mode) | Cursor Agent (Composer) |
| **9. GitHub publish** | `git init`, commit, push | **Git** + **GitHub CLI** (`gh repo create`) | — (local CLI) |

### Manual Review (by developer)

- Simulator smoke test: scroll long list, edit name, verify list update on back
- Scope decisions: omitted transfer/success screens from Figma (out of assignment scope)
- Final README review before submission

### External Services Used

| Service | Purpose |
|---------|---------|
| Figma MCP | Read design tokens and Transaction Details screen structure |
| GitHub | Host and submit the repository |
| Xcode / iOS Simulator | Build and run the app |
