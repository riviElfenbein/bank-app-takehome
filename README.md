# Banking App — Take-Home Assignment

**Repository:** https://github.com/riviElfenbein/bank-app-takehome

A SwiftUI banking app (iOS 26) with a long transactions list and a detail screen where the recipient name can be edited and immediately reflected in the list.

## For Reviewers

Start here — most reviewers need only this page plus one architecture doc.

1. **Run** — open `BankApp.xcworkspace`, iOS 26 Simulator, ⌘R
2. **Demo** — watch 10K load progress → scroll → open detail → edit **Name of the recipient** → back → name updates in list
3. **Architecture** — [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) (layers, AsyncStream loading, edit flow)
4. **Key decisions** — [docs/ENGINEERING_DECISIONS.md](docs/ENGINEERING_DECISIONS.md) — see **D5** (observable store), **D6** (draft/commit), **D30** (10K AsyncStream)
5. **Known gaps** — no unit tests; models type concrete `TransactionStore`; silent parse on invalid input; 4 unused DS components from scoped-out Figma screens

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

1. Launch the app — UI appears immediately; a progress bar loads **10,000** transactions in batches
2. Scroll during and after loading; tap any transaction (including items deep in the list)
3. On the Details screen, edit **Name of the recipient**
4. Navigate back — the updated name appears immediately in the list

## Architecture (Summary)

Full details: **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**

- **`TransactionLoader`** — `AsyncStream` batch loading protocol; **`MockTransactionLoader`** streams 10K mock transactions
- **`TransactionRepository`** — persistence protocol; **`TransactionStore`** — `@MainActor` `@Observable` in-memory implementation with O(1) lookup
- **Presentation models** — `TransactionsListModel`, `TransactionDetailModel` (draft state, formatting, `commit()`)
- **`TransactionFormatters`** — shared presentation formatting (dates, money, status titles)
- **`NavigationStack`** — value-based navigation using `Transaction.ID`
- **`BankDesignSystem`** — local Swift Package with tokens and reusable components
- **Edit flow** — Detail screen drafts edits in `TransactionDetailModel`; `commit()` on navigation back updates the store; list row cache patches via `dataRevision`

```
AppRootView  (composition root)
  └── NavigationStack
        ├── TransactionsListView      → TransactionsListModel → AsyncStream load → TransactionStore
        └── TransactionDetailView     → TransactionDetailModel → commit() → TransactionStore
```

> Presentation models currently depend on concrete `TransactionStore` (protocol DI incomplete). See [docs/ENGINEERING_DECISIONS.md](docs/ENGINEERING_DECISIONS.md) D13.

## Documentation

| Document | Purpose |
|----------|---------|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | As-built architecture and scale |
| [ENGINEERING_DECISIONS.md](docs/ENGINEERING_DECISIONS.md) | Decision log (start with D5, D6, D30) |
| [AI_USAGE.md](docs/AI_USAGE.md) | AI collaboration transparency |
| [DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) | BankDesignSystem package |
| [ROADMAP.md](docs/ROADMAP.md) | Intentional debt and future work |

Additional process docs (`DEVELOPMENT_PROCESS`, `REVIEW_LOG`, etc.) live under `docs/` but are not required for review.

## Project Structure

```
bank/
├── BankApp.xcworkspace
├── docs/                 Engineering documentation
├── BankApp/
│   ├── App/              AppRootView
│   ├── Features/         TransactionsList, TransactionDetail, Shared
│   ├── Models/           Transaction, Money, PaymentCard
│   ├── Services/         TransactionLoader, TransactionRepository, TransactionStore, MockTransactionProvider
│   └── Preview Support/
└── Packages/
    └── BankDesignSystem/ tokens + components
```

## Mock Data

- **1** fixed Figma exemplar transaction (Alexander Dmitrievich V.)
- **9,999** programmatically generated transactions (merchant names, amounts, dates spread over 365 days)
- **Total: 10,000** items, sorted by date descending
- Loaded via **`AsyncStream`** in batches of **500** (background generation, progressive UI)
- Previews use a **50-item** sync subset — see `PreviewTransactionStore`

## Tech Stack

- Swift 6, SwiftUI, Observation
- iOS 26 deployment target
- Local Swift Package: `BankDesignSystem`

---

## AI & Tools Disclosure

This project was built with AI assistance as permitted by the assignment. Full transparency: **[docs/AI_USAGE.md](docs/AI_USAGE.md)**

| Stage | Work Done | Tool | Model |
|-------|-----------|------|-------|
| **1. Architecture & planning** | Layer design, feature boundaries, state ownership, navigation strategy, implementation roadmap | [Cursor](https://cursor.com) (Plan mode) | Cursor Agent (Composer) |
| **2. Design analysis** | Extracted colors, typography, components, and screen layout from the Figma file | Cursor + **Figma MCP** | Cursor Agent (Composer) |
| **3. Xcode project & workspace** | App target, iOS 26 settings, local package wiring, asset catalog | Cursor (Agent mode) + **Xcode 26** | Cursor Agent (Composer) |
| **4. Design System package** | Tokens and components | Cursor (Agent mode) | Cursor Agent (Composer) |
| **5. App implementation** | Models, store, list & detail screens, navigation, previews | Cursor (Agent mode) | Cursor Agent (Composer) |
| **6. Long transaction list** | AsyncStream batch loader — 10K items (500 per batch) | Cursor (Agent mode) | Cursor Agent (Composer) |
| **7. Build verification** | Compile checks on iOS Simulator | **Xcode 26** — `xcodebuild` | — |
| **8. Documentation** | Architecture, decisions, README | Cursor (Agent mode) | Cursor Agent (Composer) |
| **9. GitHub publish** | Repository hosting | **Git** + **GitHub CLI** | — |

### Manual Review (by developer)

- Simulator smoke test: progressive 10K load, scroll during load, edit name, verify list update on back
- Scope decisions: omitted transfer/success screens from Figma (out of assignment scope)
- Final README and architecture docs reviewed before submission

### External Services Used

| Service | Purpose |
|---------|---------|
| Figma MCP | Read design tokens and Transaction Details screen structure |
| GitHub | Host and submit the repository |
| Xcode / iOS Simulator | Build and run the app |
