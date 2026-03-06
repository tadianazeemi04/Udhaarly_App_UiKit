# Udhaarly - Premium Item Lending App

Udhaarly is a modern iOS application designed for seamless item lending and borrowing. This week, we've focused on transforming the user experience with high-fidelity designs, interactive gestures, and robust data persistence.

## 🚀 Recent Progress (Weekly Highlights)

### 🎨 Visual & UI Redesign
- **Premium Aesthetics**: Implemented a consistent vibrant orange-to-red gradient theme across the platform.
- **Glassmorphism & Depth**: Added frosted glass card layouts (`GradientCardView`) and subtle drop shadows to create a floating, premium interface.
- **Dynamic Icons**: Standardized logo and icon rendering with template modes for crisp white displays on dark/vibrant backgrounds.

### 🔐 Authentication Overhaul
- **Signup Card Layout**: Restructured the Signup view into a modern floating card with refined typography and spacing.
- **Real-Time Validation**: 
    - Live regex-based email formatting checks.
    - Interactive password safety rules with visual checkmarks (`✓`) and dynamic color states (Neutral, Error, Valid).
- **Social Integration**: Seamless access via individual Google, Facebook, and Apple authentication buttons.
- **UX Improvements**: Implemented native keyboard avoidance using `NotificationCenter` to ensure form accessibility during input.

### 📲 Interactive Features
- **Fluid Home Navigation**: Replaced static transitions with a physics-based `UIPanGestureRecognizer` for the bottom drawer, making it respond naturally to user touch.
- **Product Management**: 
    - Developed the `AddProductViewController` for comprehensive inventory entry.
    - Integrated **SwiftData** for secure, low-latency local storage of product items including imagery and pricing.

## 🛠 Tech Stack
- **Language**: Swift
- **Frameworks**: UIKit (Compositional Layouts, AutoLayout)
- **Persistence**: SwiftData
- **UI Components**: CoreGraphics (Gradients, Bezier Paths), UIVisualEffectView (Blur Effects)

---
*Developed as part of the Udhaarly Final Year Project (FYP).*
