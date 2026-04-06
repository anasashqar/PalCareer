# CLAUDE.md — PalCareer Project Rules

> هذا الملف يحدد القواعد الملزمة لكل كود يُكتب في هذا المشروع.  
> يجب على أي مساعد ذكاء اصطناعي أو مطوّر قراءة هذا الملف أولاً قبل الشروع في أي تعديل.

---

## 📌 Project Identity

- **App Name**: PalCareer
- **Platform**: Android only (Flutter — minSdk 21 / Android 5.0+)
- **Type**: Personal project, solo developer
- **Market**: Palestine 🇵🇸
- **Languages**: Arabic (primary) + English — auto-detected from device locale
- **Current Phase**: V1 MVP
- **Current Status**: UI Mockups complete (all screens built with mock data). Next: Firebase integration.

> ⚠️ **ملاحظة التطوير:** جميع الشاشات مبنية حالياً بواجهات كاملة وبيانات وهمية (Mock).
> الـ `AuthRepository` يستخدم `MockAuthRepository`، والوظائف تُجلب من `FutureProvider` ببيانات ثابتة.
> الخطوة التالية هي استبدال كل Mock بربط Firebase حقيقي.

---

## 🏗️ Architecture Rules

### State Management
- **Use Riverpod exclusively** — no Provider, GetX, or Bloc
- Every feature must have its own `*_provider.dart` file
- Use `AsyncNotifierProvider` for async operations
- Use `StateNotifierProvider` for complex mutable state
- Use `Provider` for simple read-only derived state

### Folder Structure — Feature-First
```
lib/
├── core/
│   ├── constants/       # app_colors.dart, app_strings.dart, firestore_keys.dart
│   ├── theme/           # app_theme.dart
│   ├── router/          # app_router.dart (GoRouter)
│   └── utils/           # extensions, helpers
├── features/
│   ├── auth/
│   │   ├── data/        # auth_service.dart
│   │   ├── providers/   # auth_provider.dart
│   │   └── screens/     # login_screen.dart, splash_screen.dart
│   ├── onboarding/
│   ├── jobs/
│   ├── notifications/
│   └── profile/
├── shared/
│   ├── models/          # user_model.dart, job_model.dart
│   ├── services/        # firestore_service.dart, fcm_service.dart
│   └── widgets/         # job_card.dart, empty_state.dart, ...
└── main.dart
```

### Navigation
- Use **GoRouter** for all navigation
- Route names must be defined as constants in `core/router/app_router.dart`
- Deep linking must be supported (for notification tap → job detail)

---

## 🗄️ Firestore Rules

### Bilingual Fields
All user-facing text fields in the `jobs` collection MUST be stored as a localized Map:
```dart
// ✅ Correct
title: { "ar": "مطور Flutter", "en": "Flutter Developer" }
description: { "ar": "...", "en": "..." }
requirements: { "ar": [...], "en": [...] }

// ❌ Wrong
title: "مطور Flutter"
```

### Firestore Keys
- All Firestore field names must be defined as string constants in `core/constants/firestore_keys.dart`
- Never hardcode strings like `'isActive'` or `'fields'` directly in queries

```dart
// ✅ Correct
.where(FirestoreKeys.isActive, isEqualTo: true)

// ❌ Wrong
.where('isActive', isEqualTo: true)
```

### Collections
| Collection | Description |
|------------|-------------|
| `users` | User profiles and preferences |
| `jobs` | Job listings (written + managed by Admin only) |

---

## 🌍 Internationalization (i18n) Rules

- Use `flutter_localizations` package
- All UI strings must be in ARB files — **never hardcode strings in widgets**
- ARB files location: `lib/l10n/app_ar.arb` and `lib/l10n/app_en.arb`
- RTL layout is required for Arabic — use `Directionality` widget where needed
- Generated localizations file: `AppLocalizations`

```dart
// ✅ Correct
Text(context.l10n.jobApplyNow)

// ❌ Wrong
Text('تقدم الآن')
```

---

## 📦 Packages Policy

### Approved Packages (use freely)
| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Navigation |
| `firebase_core` | Firebase init |
| `firebase_auth` | Authentication |
| `cloud_firestore` | Database |
| `firebase_messaging` | Push notifications |
| `hive_flutter` | Local storage (notification history) |
| `url_launcher` | Open apply links in browser |
| `google_sign_in` | Google auth |
| `package_info_plus` | Read app version from pubspec |
| `flutter_localizations` | i18n |
| `cached_network_image` | Image caching (V2: company logos) |

### Rules
- Do NOT add new packages without documenting why in a comment or PR note
- Prefer Firebase ecosystem packages over third-party alternatives
- Always pin major versions (avoid `^` on breaking packages)

---

## 🎨 UI / Design Rules

- **Design Source**: The UI/UX is designed in **Stitch** (Project ID: `4938486804408641289`).
- **Design System**: "The Civic Curator" focusing on an editorial, high-end feel (Deep Sea #004655, Teal Horizon #0E7C7B).
- Visual identity is defined in `core/theme/app_theme.dart` ✅ (مُنفَّذ)
- Color constants are in `core/theme/app_colors.dart` ✅ (مُنفَّذ)
- All colors must come from `AppTheme` / `AppColors` — never use raw `Color(0xFF...)` in widgets
- Use Material 3 design system (`useMaterial3: true`) ✅ (مُنفَّذ)
- Bottom Navigation Bar: **2 tabs only** — Home + Profile ✅ (مُنفَّذ في `main_scaffold_view.dart`)
- `BottomNavigationBar` must persist across all main screens ✅ (مُنفَّذ عبر `StatefulShellRoute`)

---

## 🔔 Notifications Rules

- FCM Token must be refreshed and saved to Firestore on every login
- Notification history is stored locally in **Hive**, NOT in Firestore
- Tapping a notification must deep-link directly to the job detail screen
- The notification payload must always include `jobId`

---

## 🛡️ Security Rules (Firestore)

```javascript
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}

match /jobs/{jobId} {
  allow read: if request.auth != null;
  allow write: if false; // Admin uses Firebase Console or Server SDK only
}
```

---

## ⚙️ Coding Conventions

- **Language**: Dart (Flutter)
- **Naming**: `snake_case` for files, `PascalCase` for classes, `camelCase` for variables
- **Models**: All models must be immutable using `copyWith` pattern
- **Error handling**: Use `AsyncValue` from Riverpod — never use raw try/catch silently
- **No business logic in widgets** — widgets are UI only

---

## 🚫 Absolute Don'ts

- ❌ Never use `setState` in a feature screen — use Riverpod
- ❌ Never hardcode Firestore field names as raw strings
- ❌ Never hardcode UI text strings directly in widgets
- ❌ Never store notification history in Firestore (use Hive)
- ❌ Never use a fixed number for job count on login screen (always fetch from Firestore)
- ❌ Do not add iOS-specific code or configurations in V1

---

## 📋 Out of Scope (V1)

These features are explicitly excluded from V1 and must not be implemented:

- Uploading CV / resume
- In-app job application
- Company profiles
- Admin web panel
- iOS support
- Email/password login
- Automated scraping (Cloud Functions for scraping)
- Google Play Store release (happens after MVP validation)
