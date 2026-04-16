# Udhaarly 🤝
### Peer-to-Peer Product Lending & Borrowing Platform

**Udhaarly** is a premium, secure, and community-driven iOS application that enables users to lend and borrow products within their circles. Built with a modern "Glassmorphism" aesthetic, it prioritizes trust, ease of use, and professional functionality.

---

## 🚀 Key Features

### 📦 Marketplace & Discovery
- **Dynamic Dashboard**: Explore products by categories (Electronics, Home, Tools, etc.) with a vibrant, high-performance interface.
- **Advanced Search**: Quickly find the items you need using the integrated search system.
- **Product Details**: Comprehensive product views including descriptions, conditions, and lender profiles.

### 💬 Seamless Communication
- **Real-Time Chat**: Direct messaging between lenders and borrowers to discuss details and coordinate handovers.
- **Smart Inbox**: Organized conversations displaying real user identities and profile status.
- **Interaction Feedback**: Integrated review system to build platform-wide trust and reliability.

### 🔐 Security & Persistence
- **Secure Authentication**: Custom email-based login with OTP (One-Time Password) verification.
- **Encrypted Storage**: Sensitive user credentials managed securely via **Apple Keychain Services**.
- **SwiftData Integration**: High-performance local persistence for chats, listings, and user preferences.

### 🛠 Administrative Control
- **Admin Dashboard**: Exclusive access for platform owners to monitor activity, manage listings, and ensure community safety.

---

## 🎨 Design Philosophy

Udhaarly features a **Premium Design System** characterized by:
- **Glassmorphism**: Elegant translucent layers and soft shadows for a modern feel.
- **Dynamic Gradients**: Vibrant orange-to-red brand palettes that provide a energetic yet professional look.
- **Micro-Animations**: Smooth transitions and entry animations (using spring dynamics) that make the app feel alive.
- **Custom Typography**: Clean, legible font hierarchies across all modules.

---

## 💻 Technology Stack

| Component | Technology |
| --- | --- |
| **Core** | Swift 5.10 |
| **UI Framework** | UIKit (Programmatic UI) |
| **Persistence** | SwiftData |
| **Security** | Keychain Services / BCrypt-style hashing |
| **Networking** | URLSession (REST API Ready) |
| **Asset Management** | XCAssets with Single-Size Vector Support |

---

## 📂 Project Structure

The project follows a **Feature-Based Modular Architecture**:

- `Modules/Authentication`: Secure entry flows and profile setup.
- `Modules/Dashboard`: Main marketplace, search, and discovery.
- `Modules/Chats`: Real-time messaging and inbox management.
- `Modules/Home`: User settings, reviews, and saved addresses.
- `Modules/Persistence`: Centralized data management and notification services.
- `Common`: Shared UI components, gradients, and legal content.

---

## 🛠 Setup & Installation

1. Clone the repository:
   ```bash
   git clone [repository-url]
   ```
2. Open `UdhaarlyApp.xcodeproj` in **Xcode 15.0+**.
3. Ensure the deployment target is set to **iOS 17.0+** (Required for SwiftData).
4. Build and Run on your simulator or physical device.

---
*Developed as a Final Year Project (FYP) by Tadian Ahmad Azeemi.*
