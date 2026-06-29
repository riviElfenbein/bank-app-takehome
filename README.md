# Banking App — Take-Home Assignment

**Repository:** https://github.com/riviElfenbein/bank-app-takehome

אפליקציית בנק ב-SwiftUI (iOS 26) עם רשימת transactions ארוכה ומסך פרטים עם עריכת שם.

## דרישות שמומשו

- SwiftUI, iOS 26
- Observation framework ל-state management
- Swift Package נפרד ל-Design System
- 2 מסכים: Transactions List + Transaction Details
- עריכת transaction name במסך details — העדכון מופיע מיד ברשימה בחזרה

## עיצוב

- [Figma — Banking App (Community)](https://www.figma.com/design/rlimJjeBmjIy1Y45ddarZV/Banking-App--Community-)
- [Dribbble reference](https://dribbble.com/shots/19561980-Banking-App)

## הרצה

1. פתחי את `BankApp.xcworkspace` ב-Xcode 26+
2. בחרי iOS 26 Simulator (למשל iPhone 16)
3. Run (⌘R)

או מהטרמינל:

```bash
cd bank
xcodebuild -project BankApp.xcodeproj -scheme BankApp \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' build
```

## איך לבדוק את הדרישה המרכזית

1. פתחי את האפליקציה — מסך **Transactions** עם 121+ פריטים
2. גללי למטה ובחרי transaction (גם באמצע/סוף הרשימה)
3. במסך Details, ערכי **Name of the recipient**
4. חזרי אחורה — השם ברשימה מתעדכן מיד (ללא כפתור Save)

## ארכיטקטורה

- **`TransactionStore`** — `@Observable`, מקור אמת יחיד ל-`[Transaction]`
- **`NavigationStack`** — ניווט לפי `Transaction.ID` (value-based)
- **`BankDesignSystem`** — package מקומי: tokens (צבעים, טיפוגרפיה, spacing) + components
- **Edit flow** — Details כותב ל-store דרך `updateRecipientName`; Observation מרענן את הרשימה אוטומטית

```
AppRootView
  └── NavigationStack
        ├── TransactionsListView  (read store)
        └── TransactionDetailView (mutate store via Binding)
```

## מבנה פרויקט

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

- **1** transaction קבוע מהפיגמה (Alexander Dmitrievich V.)
- **120** transactions שנוצרים programmatically (שמות merchants, סכומים, תאריכים על פני שנה)
- **סה"כ: 121** פריטים, ממוינים לפי תאריך יורד

## שימוש ב-AI

| נושא | AI (Cursor) | ידני |
|------|-------------|------|
| ארכיטקטורה | תכנון layers, state ownership, navigation | review והחלטות scope |
| Design System | tokens + components מהפיגמה | התאמה ל-SwiftUI / HIG |
| מסכים | TransactionsList + TransactionDetail | בדיקה בסימולטור |
| Mock data (רשימה ארוכה) | — | גנרטור programmatic + QA |
| README | טיוטה | עריכה וסיום |

## Tech Stack

- Swift 6, SwiftUI, Observation
- iOS 26 deployment target
- Local Swift Package: `BankDesignSystem`
