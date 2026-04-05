<div dir="rtl">

# PalCareer — منصة التوظيف الفلسطينية الذكية

> وظائف مُرشَّحة بذكاء بدلاً من البحث اليدوي

</div>

---

## 🇵🇸 About / عن المشروع

**PalCareer** is a smart job-matching Android app built for Palestinian students and fresh graduates.  
Instead of searching through dozens of irrelevant listings, PalCareer learns your field and preferences during onboarding, then automatically surfaces the most relevant opportunities — and notifies you the moment a matching job is posted.

---

**PalCareer** هو تطبيق Android ذكي لمطابقة الوظائف، مبني للطلاب والخريجين الجدد في فلسطين.  
بدلاً من البحث اليدوي عبر عشرات الإعلانات، يتعلّم PalCareer تخصصك وتفضيلاتك خلال التسجيل، ثم يعرض لك الفرص الأنسب تلقائياً ويُنبّهك فور نشر وظيفة تناسبك.

---

## ✨ Key Features / الميزات الرئيسية

| | Feature | الميزة |
|---|---------|--------|
| 🎯 | Smart job matching based on your field & preferences | مطابقة ذكية للوظائف |
| 🔔 | Instant push notification when a matching job is posted | إشعار فوري عند نشر وظيفة مطابقة |
| ⚡ | Fast onboarding — 2 steps only | تسجيل سريع في خطوتين |
| 🌍 | Full Arabic & English support | دعم العربية والإنجليزية |
| 📱 | Lightweight native Android app | تطبيق Android خفيف الوزن |

---

## 🏗️ Tech Stack

| Layer | Technology | Status |
|-------|------------|--------|
| Frontend | Flutter (Android — minSdk 21) | ✅ Active |
| State Management | Riverpod | ✅ Active |
| Navigation | GoRouter (StatefulShellRoute) | ✅ Active |
| Auth | Firebase Authentication (Google Sign-In) | 🔲 Mock only |
| Database | Cloud Firestore | 🔲 Not connected |
| Push Notifications | Firebase Cloud Messaging (FCM) | 🔲 Not started |
| Backend Logic | Firebase Cloud Functions (Node.js) | 🔲 Not started |
| Local Storage | Hive | 🔲 Not started |
| i18n | Flutter Localizations (AR/EN) | 🟡 Partial |
| Design | Stitch (UI/UX) | ✅ Done |

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/           # app_colors, app_strings, firestore_keys (فارغ)
│   ├── router/              # app_router.dart + main_scaffold_view.dart ✅
│   ├── theme/               # app_colors.dart + app_theme.dart ✅
│   └── utils/               # (فارغ)
├── features/
│   ├── auth/
│   │   ├── data/            # auth_service.dart (فارغ)
│   │   ├── providers/       # auth_provider.dart ✅
│   │   ├── repositories/    # auth_repository.dart (Mock) ✅
│   │   ├── screens/         # login_screen.dart, splash_screen.dart
│   │   └── views/           # splash_view.dart ✅, login_view.dart ✅
│   ├── onboarding/
│   │   ├── providers/       # onboarding_provider.dart ✅
│   │   └── screens/         # onboarding_screen.dart ✅
│   ├── jobs/
│   │   ├── providers/       # jobs_provider.dart (Mock Data) ✅
│   │   ├── screens/         # jobs_feed_screen.dart ✅, job_details_screen.dart ✅
│   │   └── widgets/         # job_card.dart ✅
│   ├── notifications/
│   │   └── screens/         # notifications_screen.dart (UI فقط) ✅
│   └── profile/
│       └── screens/         # profile_screen.dart (UI فقط) ✅
├── shared/
│   ├── models/              # user_model.dart ✅, job_model.dart ✅
│   ├── services/            # firestore_service.dart (فارغ), fcm_service.dart (فارغ)
│   └── widgets/             # (فارغ)
├── l10n/
│   ├── app_ar.arb ✅
│   ├── app_en.arb ✅
│   └── generated/ ✅
└── main.dart ✅
```

---

## 🗄️ Firestore Structure

```
/users/{userId}
    name: String
    email: String
    photoUrl: String
    fields: Array<String>            // ["it", "engineering", ...]
    educationLevel: String           // "student" | "graduate"
    preferredJobTypes: Array<String> // ["full_time", "part_time", "remote"]
    fcmToken: String
    onboardingCompleted: Boolean
    createdAt: Timestamp

/jobs/{jobId}
    title: { ar: String, en: String }
    company: String
    location: String
    jobType: String                  // "full_time" | "part_time" | "remote"
    level: String                    // "مبتدئ" | "متوسط" | "أول"
    skills: Array<String>
    applyLink: String
    description: { ar: String, en: String }
    requirements: { ar: Array<String>, en: Array<String> }
    responsibilities: { ar: Array<Map>, en: Array<Map> }
    fields: Array<String>
    publishedAt: Timestamp
    isActive: Boolean
    // companyLogo: String           // V2
```

---

## 🚦 Project Status

| Area | Status | Details |
|------|--------|---------|
| Project Setup (Flutter + deps) | ✅ Done | pubspec.yaml + folder structure |
| Design System / Theme | ✅ Done | The Civic Curator theme applied |
| Navigation / Routing | ✅ Done | GoRouter + StatefulShellRoute |
| Splash Screen | ✅ Done (UI) | Animation + auto-navigate (no smart routing yet) |
| Login Screen | ✅ Done (UI) | Google button + Mock Auth |
| Onboarding (2 steps) | ✅ Done (UI) | Field + level + work type selection |
| Jobs Feed | ✅ Done (UI) | Mock data, job cards with badges |
| Job Detail | ✅ Done (UI) | Requirements + responsibilities + apply button |
| Notification Center | 🟡 UI only | Basic screen, no real data |
| Profile & Settings | 🟡 UI only | Basic screen, no real data |
| Data Models | ✅ Done | UserModel + JobModel with Firestore conversion |
| i18n (AR/EN) | 🟡 Partial | ARB files created, some hardcoded strings remain |
| Firebase Auth (real) | 🔲 Not started | MockAuthRepository in use |
| Firestore Integration | 🔲 Not started | Services files empty |
| Push Notifications (FCM) | 🔲 Not started | — |
| Cloud Functions | 🔲 Not started | — |
| Hive (local storage) | 🔲 Not started | — |
| Firebase Security Rules | 🔲 Not started | — |
| Error Handling / Edge Cases | 🔲 Not started | — |
| APK Build & Distribution | 🔲 Not started | — |

> 🔲 Not started &nbsp;|&nbsp; 🟡 Partial / UI only &nbsp;|&nbsp; ✅ Done

---

## 🎯 Target Audience

- Palestinian university students
- Fresh graduates (0–2 years experience)
- Seeking jobs inside Palestine

---

## 🎨 UI/UX Design

The visual designs and user interfaces are built and managed in **Stitch**.
* **Stitch Project ID:** `4938486804408641289`
* **Design System:** "The Civic Curator" (Deep Sea #004655, Teal Horizon #0E7C7B, Gold #D4AF37)
* **Screens Included:** Login, Onboarding, Jobs Feed, Job Detail, Notification Center, Profile & Settings.

---

## 📋 Documentation

| File | Description |
|------|-------------|
| [`FEATURES.md`](./FEATURES.md) | Full feature list with progress tracking |
| [`USERS.md`](./USERS.md) | Target users and their journeys |
| [`CLAUDE.md`](./CLAUDE.md) | Project rules and coding conventions |
| [`PRD_Jobs_App.md`](./PRD_Jobs_App.md) | Full Product Requirements Document |

---

## 📦 Distribution Plan

1. **Phase 1** — APK internal testing (friends & early adopters)
2. **Phase 2** — Validate product-market fit
3. **Phase 3** — Google Play Store launch

---

## 👤 Author

Personal project by a solo developer.  
Built with ❤️ for the Palestinian job market.
