# ⌚️ Live Health Tracker – watchOS App

A SwiftUI-based watchOS app that **monitors real-time heart rate and step count** using **HealthKit**. It supports both **real device** and **simulator** environments with mock data. This app is built for Apple Watch and is easily extendable to sync data with an iOS app using WatchConnectivity.

---

## 📽 Demo

> Replace the link below with your actual YouTube/Vimeo demo video.


https://github.com/user-attachments/assets/6346c538-4b68-4621-bfe4-144311630446

---

## 🚀 Features

- 📡 Live heart rate tracking using `HKAnchoredObjectQuery`
- 🪜 Real-time step count updates
- 🧪 Simulator-friendly with mock data when HealthKit is not available
- 💡 MVVM architecture with delegation
- 🔁 Ready for data sync with iOS (via `WatchConnectivity`)
- 🧪 Unit testing support with mock delegate

---

## 🧱 File Structure

```
📦 WatchApp
├── 📁 Models
│   └── Health.swift                    # Codable struct to sync heart rate & steps
├── 📁 Views
│   └── HealthTrackerView.swift         # SwiftUI View with start/stop session UI
├── 📁 ViewModels
│   └── LiveHealthDataViewModel.swift   # ObservableObject view model
├── 📁 Managers
│   ├── LiveHealthKitManager.swift      # HealthKit live query logic
│   └── WatchAppSyncManager.swift       # iOS sync manager (optional)
├── 📁 Tests (add via test target)
│   └── LiveHealthKitManagerTests.swift # Unit tests using mock delegate
└── Info.plist                          # Permissions & metadata
```

---

## 💡 Architecture

- **MVVM + Delegation Pattern**
- `LiveHealthKitManager` handles all HealthKit logic and uses a delegate to notify the view model.
- `LiveHealthDataViewModel` listens to updates and exposes them to SwiftUI via `@Published`.
- `HealthTrackerView` binds to the view model to update the UI live.

---

## 🛠 Requirements

| Requirement       | Details             |
|-------------------|---------------------|
| Xcode Version     | 15.0+               |
| Language          | Swift 5.9+          |
| OS                | watchOS 10+         |
| Device            | Apple Watch / Simulator |

---

## 📝 Setup Instructions

### 📦 1. Clone the Repo

```bash
git clone https://github.com/yourusername/LiveHealthTracker.git
cd LiveHealthTracker
open LiveHealthTracker.xcodeproj
```

### 🧭 2. Add HealthKit Capability

- Select your **WatchKit Extension** target
- Go to **Signing & Capabilities → + Capability → HealthKit**

### 🔐 3. Add Info.plist Permissions

In `WatchKit Extension → Info.plist`, add:

```xml
<key>NSHealthShareUsageDescription</key>
<string>This app reads your heart rate and step count.</string>
```

---

## ▶️ How to Run

### 🖥 On Simulator (Mock Mode)
1. Select `WatchApp` scheme
2. Choose a Watch Simulator (e.g., Apple Watch Series 9)
3. Press **Cmd + R** to run
4. Click **Start Session** → View simulated updates

### ⌚ On Real Apple Watch (Live Mode)
1. Install on a real Apple Watch
2. Authorize Health permissions
3. Start a session → Live heart rate and steps will appear

---

## 🧪 Unit Testing

### ✅ Add Unit Test Target

1. **File → New → Target → Unit Testing Bundle**
2. Choose: `watchOS Unit Testing Bundle`
3. Name it `WatchAppTests`
4. ✅ Include `WatchKit Extension` target


### 💥 Common Fix for Test Error

If you see this:

> `TEST_HOST evaluates to ... Watch App.app/Watch App`

👉 Fix:
- Go to your test target’s **Build Settings**
- Find `TEST_HOST`
- **Clear the value** (leave it blank)

---

## 🔄 Watch to iOS Sync (Optional)

- App includes `WatchAppSyncManager.shared.sendDateToiOS(...)`
- You can extend this using `WatchConnectivity` to sync heart rate & steps to iOS

---

## 📂 Simulator Mode Notes

On the simulator:
- HealthKit is **not available**
- App simulates random heart rate (60–120 bpm) and step increases

This allows **debugging UI & data flow** even on simulator without a real device.

---

## 👤 Author

**Satyam Singh**  
iOS + watchOS Developer  
[LinkedIn](https://www.linkedin.com/in/satyamits/)

---

## 📄 License

This project is open-source and free to use for educational and non-commercial projects.

---
