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

## 🚦 Project Status

For detailed feature tracking and current project status, please refer to the [`FEATURES.md`](./FEATURES.md) document.

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
