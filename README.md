<div align="center">

# 💪 HealthFit Life — Health & Fitness Tracker

**A comprehensive Flutter app for tracking your daily health and fitness**  
Step Counter · Workouts · Nutrition · Sleep · BMI · Water Intake · Meditation

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore%20%7C%20FCM-FFCA28?logo=firebase)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-Android-lightgrey)](https://flutter.dev)
[![Play Store](https://img.shields.io/badge/Google%20Play-Download-green?logo=google-play)](https://play.google.com/store/apps/details?id=com.siratalmustaqeem.healthfitlife)

</div>

---

## 📱 Screenshots

> Add screenshots to a `/screenshots` folder and reference them here.

---

## ✨ Features

### 👟 Step Counter
- Real-time step tracking using device accelerometer via `pedometer`
- Foreground service ensures continuous tracking even when app is backgrounded (`flutter_foreground_task`)
- Daily step goal with progress visualization
- Steps synced to Firebase for logged-in users

### 💧 Water Intake Tracker
- Customizable daily water goal
- Intake logging with progress ring
- Local reminder notifications via `flutter_local_notifications`

### 🏋️ Workout Logger
- Log exercises with sets, reps, and weight
- Full workout history with interactive charts via `fl_chart`
- Background scheduling via `workmanager`

### 🧮 BMI & Calorie Calculator
- BMI calculator with category classification
- Daily calorie goal based on user profile
- Offline profile storage using **Isar** local database

### 🥗 Nutrition & Meal Tracking
- Log meals with calorie and macro breakdown
- Daily nutrition analytics with charts
- Streak visualization for consistent logging habits

### 😴 Sleep Tracker
- Log sleep sessions with duration tracking
- Streak calendar view via `table_calendar`
- Hydration and workout reminders

### 🧘 Breathing & Meditation
- Guided breathing sessions with animated timers
- Meditation sessions for stress relief and focus

### 📊 Reports & Export
- PDF report generation via `pdf` + `printing`
- CSV data export via `csv` + `share_plus`

### 👤 Authentication & Cloud Sync
- Email/password and Google Sign-In via **Firebase Auth**
- Secure token storage with `flutter_secure_storage`
- Cloud sync via **Firestore** and **Firebase Storage**
- Analytics via **Firebase Analytics**

---

## 🏗️ Architecture

This project follows **Clean Architecture** with **Riverpod** as the state management solution, using code generation for scalability and maintainability.

```
lib/
├── app.dart                    # App entry, MaterialApp.router, theme
├── main.dart                   # Firebase init, Isar init, foreground service
├── core/
│   ├── router/                 # GoRouter with appRouterProvider
│   └── theme/                  # Light & dark AppTheme
├── data/
│   ├── repositories/           # Auth, Step, and other repositories
│   └── services/               # IsarService, NotificationService, StepForegroundService
└── features/
    ├── steps/                  # Step counter feature
    ├── workout/                # Workout logger
    ├── nutrition/              # Meal & nutrition tracking
    ├── sleep/                  # Sleep tracker
    ├── water/                  # Water intake
    ├── bmi/                    # BMI & calorie calculator
    ├── meditation/             # Breathing & meditation
    └── settings/               # Theme provider, user preferences
```

**State Management:** Riverpod (`flutter_riverpod`) with `riverpod_annotation` code generation  
**Navigation:** GoRouter (`go_router`) with provider-driven routing  
**Local DB:** Isar (fast NoSQL, code-generated schemas via `isar_generator`)  
**Remote DB:** Firebase Firestore  
**Code Generation:** `build_runner`, `freezed`, `json_serializable`, `riverpod_generator`

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.x / Dart 3.x |
| **State Management** | Riverpod (with code generation) |
| **Navigation** | GoRouter |
| **Local Database** | Isar |
| **Remote Database** | Cloud Firestore |
| **Authentication** | Firebase Auth, Google Sign-In |
| **File Storage** | Firebase Storage |
| **Analytics** | Firebase Analytics |
| **Notifications** | flutter_local_notifications |
| **Background Tasks** | workmanager, flutter_foreground_task |
| **Step Tracking** | pedometer, Health API |
| **Charts** | fl_chart |
| **PDF Export** | pdf, printing |
| **CSV Export** | csv, share_plus |
| **Secure Storage** | flutter_secure_storage |
| **UI** | google_fonts, lottie, shimmer, flutter_svg |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.x`
- Dart SDK `^3.11.5`
- Android Studio
- A Firebase project with **Auth, Firestore, Storage, and Analytics** enabled

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/Faisal60177/health_and_fitness.git
cd health_and_fitness

# 2. Install dependencies
flutter pub get

# 3. Run code generation
dart run build_runner build --delete-conflicting-outputs

# 4. Add Firebase config
#    Android: place google-services.json → android/app/

# 5. Run the app
flutter run
```

> **Note:** `firebase_options.dart` is git-ignored. Generate it with:
> ```bash
> flutterfire configure
> ```

---

## 🔒 Permissions

| Permission | Purpose |
|---|---|
| `ACTIVITY_RECOGNITION` | Step counting via pedometer |
| `ACCESS_FINE_LOCATION` | Health data context |
| `FOREGROUND_SERVICE` | Continuous step tracking |
| `POST_NOTIFICATIONS` | Workout & hydration reminders |
| `INTERNET` | Firebase sync |
| `RECEIVE_BOOT_COMPLETED` | Reschedule background tasks on reboot |

---

## 🧑‍💻 Developer Notes

- **Isar** is initialized before `runApp()` to ensure the database is ready for all providers on first frame.
- **Foreground service** for step tracking starts automatically if a user is already logged in, ensuring no steps are missed after app restart.
- **Clean Architecture** separates data, domain, and feature layers — repositories handle all data access, keeping UI and providers free of direct database or Firebase calls.
- **Theme** is controlled globally by `themeNotifierProvider` (Riverpod), supporting both light and dark mode with `MaterialApp.router`.
- **GoRouter** is provided via `appRouterProvider`, allowing auth-state-driven redirects without nested navigator boilerplate.

---

## 🔗 Links

- 🌐 [Google Play Store](https://play.google.com/store/apps/details?id=com.siratalmustaqeem.healthfitlife)
- 💻 [GitHub Repository](https://github.com/Faisal60177/health_and_fitness)

---

## 📄 License

This project is privately maintained. All rights reserved.

---

<div align="center">
  Made with ❤️ using Flutter &nbsp;|&nbsp; Stay Healthy, Stay Consistent 💪
</div>