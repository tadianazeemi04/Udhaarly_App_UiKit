# 🚀 Recent Updates (March 16, 2026)

Today’s session focused on expanding the core functionality of the Udhaarly app by implementing the **Requests Management** module and refining the global user experience across existing screens.

---

### 📋 Requests & Transaction Management
Successfully built the "Requests" module from high-fidelity mockups to handle the borrow-lend ecosystem:
- **Dual-Mode UI**: Implemented a responsive Borrow/Lend toggle with dynamic color states to distinguish between incoming and outgoing requests.
- **Detailed Request Cards**: 
    - Designed custom `RequestCardView` components that display user identity (masked phone for privacy), product images, and pricing.
    - Added conditional action buttons (**Cancel**, **Chat**, **Accept**) for borrowers and a **“Pending”** status for lenders.
- **Independent Navigation**: Integrated the module into the main flow while ensuring it opens in a dedicated view by automatically hiding the main tab bar (`hidesBottomBarWhenPushed`).

### 🎨 Visual & UX Refinements
- **Tactile Feedback**: Upgraded `SettingsRowView` with a custom touch-handling system. All settings rows now provide subtle background highlights when tapped, significantly improving the "feel" of the interface.
- **Navigation Logic**: Linkage established between the **User Profile** and the new **Requests** screen, completing another critical piece of the app's secondary navigation loop.
- **UI Consistency**: Maintained brand alignment by leveraging the existing gradient header system and centralized color tokens.

---

## 📂 Architecture & Key Files

| Module | Purpose |
| :--- | :--- |
| `RequestsViewController.swift` | Orchestrates the Borrow/Lend request views and tab logic. |
| `RequestCardView.swift` | A high-fidelity reusable component for transaction details. |
| `UserSettingViewController.swift` | Refactored to handle expanded navigation and row interaction feedback. |

---

## 🛠 Tech Stack Update
- **Patterns**: Conditional UI Rendering, Segmented Control Logic.
- **UI Components**: UIStackView (Dynamic List Management), UITapGestureRecognizer + Touch Overrides (Feedback).
- **UX**: Smart Tab Bar Management (`hidesBottomBarWhenPushed`).

---
*Developed as part of the Udhaarly Final Year Project (FYP).*
