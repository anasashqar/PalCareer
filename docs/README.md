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

| Layer | Technology |
|-------|------------|
| Frontend | Flutter (Android — minSdk 21) |
| State Management | Riverpod |
| Auth | Firebase Authentication (Google Sign-In) |
| Database | Cloud Firestore |
| Push Notifications | Firebase Cloud Messaging (FCM) |
| Backend Logic | Firebase Cloud Functions (Node.js) |
| Local Storage | Hive |
| i18n | Flutter Localizations |

---

## 📁 Project Structure

```
lib/
├── core/                    # Shared utilities, constants, theme
│   ├── constants/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/                # Login, splash, session management
│   ├── onboarding/          # Field selection, preferences
│   ├── jobs/                # Feed, filters, job detail
│   ├── notifications/       # FCM handling, notification center
│   └── profile/             # User profile, settings, edit
├── shared/                  # Reusable widgets, models, services
│   ├── models/
│   ├── services/
│   └── widgets/
└── main.dart
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

| Area | Status | Notes |
|------|--------|-------|
| Auth (Google Sign-In) | 🟡 In progress | UI/Mock Built |
| Splash Screen | ✅ Done | |
| Onboarding | 🔲 Not started | |
| Jobs Feed | 🔲 Not started | |
| Job Detail | 🔲 Not started | |
| Push Notifications | 🔲 Not started | |
| Notification Center | 🔲 Not started | |
| Profile & Settings | 🔲 Not started | |
| i18n (AR/EN) | 🔲 Not started | |
| Cloud Functions | 🔲 Not started | |
| Firebase Security Rules | 🔲 Not started | |

> 🔲 Not started &nbsp;|&nbsp; 🟡 In progress &nbsp;|&nbsp; ✅ Done

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
| [`FEATURES.md`](./FEATURES.md) | Full feature list for V1 and V2 |
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
