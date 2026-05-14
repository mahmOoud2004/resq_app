<div align="center">

# ResQ

### Smart Emergency Response and AI Healthcare Assistant

<p>
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/State%20Management-Bloc-1E1E2F?style=for-the-badge" alt="Bloc" />
  <img src="https://img.shields.io/badge/Maps-Google%20Maps-34A853?style=for-the-badge&logo=googlemaps&logoColor=white" alt="Google Maps" />
  <img src="https://img.shields.io/badge/Networking-Dio-5B4B8A?style=for-the-badge" alt="Dio" />
  <img src="https://img.shields.io/badge/Status-Active%20Development-00A86B?style=for-the-badge" alt="Status" />
</p>

**Fast emergency requests. Live driver tracking. Smart health support. One mobile experience.**

</div>

---

## Overview

**ResQ** is a Flutter mobile application built to improve emergency response and healthcare support.
The app helps users request emergency services quickly, track drivers in real time, manage personal health information, and use smart assistant features.

The project is designed around three main roles:

- `User`
- `Driver`
- `Admin`

Each role has its own screens, actions, and workflow.
This makes the app easier to use and easier to manage.

---

## Why ResQ

In emergency situations, time is very important.
Traditional communication methods can be slow or unclear.
ResQ tries to solve this by combining:

- fast emergency request creation
- location sharing
- live map tracking
- driver-side request handling
- health reminders
- AI-powered support tools

The goal is simple:
make emergency help faster, clearer, and smarter.

---

## Core Features

### Emergency Response

- Quick emergency request creation
- Multiple service types
- Active request status tracking
- Cleaner request flow for users and drivers

### Live Maps and Tracking

- Real-time user location
- Real-time driver tracking
- Route drawing on the map
- Nearby hospital loading
- Navigation support for drivers

### Driver Workflow

- Driver availability toggle
- Nearby request list
- Request details screen
- Accept or reject request
- Active trip and arrival flow

### Admin Panel

- Dashboard and statistics
- Pending user review
- Users management
- Emergency monitoring

### Smart Health Support

- Medical profile onboarding
- Personalized local notifications
- Disease-based health reminders
- Daily awareness support

### AI Features

- Smart health assistant
- Medical text support
- Analysis history
- Chat-style support flow

---

## Main User Flows

### User Flow

1. User signs in or creates an account
2. App checks role and opens the correct area
3. User enters home screen
4. User selects emergency service
5. Request is sent with location
6. User tracks driver on map
7. Request completes after service arrives

### Driver Flow

1. Driver signs in
2. Driver opens driver home
3. Driver switches status to online
4. Nearby requests appear
5. Driver opens request details
6. Driver accepts request
7. Driver navigates to user
8. Driver completes the trip

### Admin Flow

1. Admin signs in
2. Admin opens dashboard
3. Admin reviews statistics and user data
4. Admin monitors request activity

---

## Tech Stack

| Area | Tools / Packages |
|---|---|
| Framework | Flutter |
| Language | Dart |
| State Management | `flutter_bloc` |
| Routing | `go_router` |
| Networking | `dio` |
| Local Storage | `shared_preferences`, `isar` |
| Maps | `google_maps_flutter` |
| Location | `geolocator`, `geocoding` |
| Notifications | `flutter_local_notifications` |
| Environment | `flutter_dotenv` |
| AI Support | `google_generative_ai` |

---

## Project Structure

```text
lib
├── config
│   └── routers
├── core
│   ├── constants
│   ├── error
│   ├── network
│   ├── storage
│   └── theme
├── features
│   ├── admin
│   ├── auth
│   ├── Chatbot
│   ├── driver_emergency
│   ├── emergency
│   ├── home
│   ├── map
│   ├── navigation
│   ├── profile
│   ├── smart_ai_assistant
│   ├── smart_health_notifications
│   └── splash
└── main.dart
```

This feature-based structure keeps the project modular and easier to maintain.

---

## Architecture Notes

The app uses a practical layered approach inside features:

- `presentation` for UI and state
- `data` for API, models, and repositories
- `domain` for core business contracts in some modules

Important patterns used in the project:

- Bloc / Cubit for state handling
- Repository pattern for cleaner data access
- Feature separation for scalability
- Global error handling for better stability

---

## Stability and Error Handling

The project includes several improvements for runtime safety:

- startup protection with guarded app bootstrap
- global Flutter error logging
- safer route payload validation
- cleaner Dio error mapping
- user-friendly error messages
- protected location and network flows

Examples of supported safe messages:

- `No internet connection`
- `Server is temporarily unavailable`
- `Something went wrong`
- `Please try again`

---

## Driver Availability Behavior

One of the important UX improvements in the driver flow is the **Driver Status** switch.

When the driver is:

- `Online`: request list is available and actions are enabled
- `Offline`: request list becomes empty and accepting new requests is disabled

This gives the driver a clearer working mode and avoids confusion.

---

## Supported Health Conditions

The smart notification module supports medical reminders for conditions such as:

- Diabetes
- Hypertension
- Asthma
- Heart Disease
- Epilepsy
- Kidney Disease
- Obesity
- Anemia

---

## Environment Configuration

The app uses a local `.env` file.

Example values may include:

```env
GOOGLE_MAPS_API_KEY=your_google_maps_key
```

Keep sensitive keys out of source code whenever possible.

---

## Getting Started

### 1. Clone the project

```bash
git clone <your-repository-url>
cd resq_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Add environment file

Create a `.env` file in the root folder and add the required keys.

### 4. Run the project

```bash
flutter run
```

---

## Useful Commands

### Get packages

```bash
flutter pub get
```

### Clean the project

```bash
flutter clean
```

### Run the app

```bash
flutter run
```

### Build APK

```bash
flutter build apk
```

---

## Android Notes

If you face Kotlin or Gradle cache issues on Windows:

1. Run:

```bash
flutter clean
flutter pub get
```

2. If needed, clear build caches inside the project.

3. Make sure `JAVA_HOME` points to a valid JDK or Android Studio JBR.

---

## Screens and Modules Included

Main areas already included in the project:

- Splash
- Authentication
- User Home
- Driver Home
- Admin Dashboard
- Emergency Tracking
- Maps
- Profile
- Smart Assistant
- Health Notifications
- Chatbot

---

## Project Strengths

- Real-world graduation project idea
- Multi-role system
- Map-based emergency workflow
- AI and health support features
- Clean modular structure
- Better focus on app stability

---

## Future Improvements

Possible future upgrades:

- stronger backend integration
- push notifications from server
- real ambulance center connection
- advanced analytics
- multilingual support
- better offline mode
- voice-based emergency request

---

## Documentation

A longer graduation-project style explanation is available here:

[Graduation_Project_Documentation.md](docs/Graduation_Project_Documentation.md)

---

## Team Note

ResQ is built as a graduation project with a practical social goal:
using mobile technology to make emergency support faster, clearer, and more helpful.

---

<div align="center">

### ResQ

**Emergency support, live tracking, and smart healthcare in one app.**

</div>
