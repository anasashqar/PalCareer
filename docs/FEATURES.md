# FEATURES.md — PalCareer
> وثيقة الميزات الرسمية للمشروع  
> آخر تحديث: 5 أبريل 2026

---

## 📊 ملخص التقدم

| المجال | الحالة | النسبة |
|--------|--------|--------|
| البنية التحتية والأساسيات | ✅ مكتمل | 100% |
| واجهات المستخدم (UI Screens) | ✅ مكتمل (Mock) | 100% |
| نظام التصميم (Theme) | ✅ مكتمل | 100% |
| تعدد اللغات (i18n) | 🟡 جزئي | 80% |
| ربط Firebase (Auth + Firestore) | 🔄 قيد العمل | 5% |
| الإشعارات (FCM + Cloud Functions) | 🔲 لم يبدأ | 0% |
| التخزين المحلي (Hive) | 🔲 لم يبدأ | 0% |
| الاختبار والإطلاق | 🔲 لم يبدأ | 0% |

> **التقدم الإجمالي ≈ 45%** — المرحلة الأولى (Mock UI + Navigation + State Management) اكتملت تماماً. بدأنا المرحلة الثانية: ربط Firebase.

---

## ✅ ما تم إنجازه

### 🏗️ البنية التحتية (Infrastructure)
- [x] إنشاء مشروع Flutter مع هيكل Feature-First
- [x] إعداد `pubspec.yaml` بجميع الحزم المطلوبة
- [x] نظام التنقل بـ GoRouter مع جميع المسارات (`/`, `/login`, `/onboarding`, `/home`, `/profile`, `/job-details`, `/notifications`)
- [x] `StatefulShellRoute` لـ Bottom Navigation (Home + Profile)
- [x] `MainScaffoldView` مع BottomNavigationBar (تبويبان)
- [x] Riverpod كـ State Management (ProviderScope في main.dart)

### 🎨 نظام التصميم (Design System — "The Civic Curator")
- [x] `AppColors` — الألوان الأساسية (Deep Sea #004655, Teal Horizon #0E7C7B, Gold #D4AF37)
- [x] `AppTheme.lightTheme` — Material 3 مع Google Fonts
- [x] تطبيق التصميم عبر `MaterialApp.router`

### 🌍 تعدد اللغات (i18n) — جزئي
- [x] ملفات `app_ar.arb` و `app_en.arb` مع مفاتيح أساسية
- [x] ملفات الترجمة المُولَّدة (`AppLocalizations`)
- [x] إعداد `localizationsDelegates` و `supportedLocales` في main.dart
- [x] اللغة الافتراضية: العربية
- [ ] ⬅️ **لم يكتمل**: اكتشاف اللغة تلقائياً من إعدادات الهاتف (حالياً hardcoded `Locale('ar')`)
- [ ] ⬅️ **لم يكتمل**: بعض الشاشات تحتوي نصوصاً مباشرة غير مترجمة

### 📱 شاشة Splash
- [x] عرض الشعار واسم التطبيق مع أنيميشن
- [x] `SplashView` مع انتقال آلي بعد تأخير
- [ ] ⬅️ التوجيه الذكي (حالياً ينتقل دائماً لـ Login — بحاجة لربط Firebase Auth)

### 🔐 شاشة تسجيل الدخول (Login)
- [x] واجهة كاملة: شعار + عنوان + وصف + زر Google Sign-In
- [x] `AuthProvider` + `AuthNotifier` (StateNotifier)
- [x] `AuthRepository` (Abstract) + `MockAuthRepository`
- [x] حالة التحميل (Loading state) في الزر
- [ ] ⬅️ ربط Firebase Auth الحقيقي (العمل الحالي mock فقط)
- [ ] ⬅️ عداد الوظائف الديناميكي من Firestore (غير موجود بعد)
- [ ] ⬅️ حفظ بيانات المستخدم الجديد في Firestore

### 🚀 شاشة الـ Onboarding
- [x] واجهة خطوتين كاملة مع PageView
- [x] الخطوة 1: اختيار التخصص (9 خيارات، اختيار متعدد، Chips)
- [x] الخطوة 2: اختيار المستوى التعليمي + نوع الدوام المفضل
- [x] `OnboardingProvider` + `OnboardingNotifier` (StateNotifier)
- [x] التحقق من اكتمال كل خطوة قبل الانتقال
- [ ] ⬅️ حفظ بيانات الـ Onboarding في Firestore
- [ ] ⬅️ التحقق من اكتمال الـ Onboarding عند كل دخول

### 🏠 الشاشة الرئيسية (Jobs Feed)
- [x] واجهة عرض الوظائف مع بيانات وهمية (3 وظائف mock)
- [x] `JobsFeedScreen` مع قائمة وظائف
- [x] `JobCard` widget كامل (اسم الوظيفة + الشركة + الموقع + نوع الدوام + التاريخ)
- [x] `JobsProvider` (FutureProvider) مع mock data
- [x] شارة "يناسبك" للوظائف ذات التطابق التام
- [x] شارة "جديد" تلقائية (< 3 أيام)
- [ ] ⬅️ جلب الوظائف من Firestore (حالياً بيانات وهمية)
- [ ] ⬅️ شريط فلاتر أفقي قابل للتمرير
- [ ] ⬅️ عداد ديناميكي لعدد الوظائف
- [x] حالة "لا توجد وظائف مطابقة" (Empty State)

### 📄 تفاصيل الوظيفة
- [x] `JobDetailsScreen` كاملة (المسمى + الشركة + الموقع + النوع + التاريخ)
- [x] قسم المتطلبات (قائمة نقاط)
- [x] قسم المسؤوليات (قائمة نقاط)
- [x] زر "تقدم الآن" ثابت أسفل الشاشة
- [ ] ⬅️ ربط `url_launcher` فعلياً لفتح رابط التقديم

### 🗂️ مركز الإشعارات
- [x] `NotificationsScreen` مع واجهة أساسية
- [ ] ⬅️ عرض سجل الإشعارات الفعلي
- [ ] ⬅️ تمييز المقروء/غير المقروء
- [ ] ⬅️ الضغط يفتح تفاصيل الوظيفة
- [ ] ⬅️ التخزين المحلي بـ Hive

### 👤 الملف الشخصي
- [x] `ProfileScreen` مع واجهة كاملة
- [ ] ⬅️ صورة المستخدم واسمه من Google Account (حالياً placeholder)
- [ ] ⬅️ وصف مهني مُولَّد من Onboarding
- [ ] ⬅️ تعديل التخصص ونوع الدوام + حفظ في Firestore
- [ ] ⬅️ إعدادات الإشعارات
- [ ] ⬅️ صفحة "عن التطبيق" مع رقم الإصدار
- [ ] ⬅️ تسجيل الخروج الفعلي

### 📦 الموديلات (Data Models)
- [x] `UserModel` — مع `copyWith` وتحويل Firestore
- [x] `JobModel` — مع حقول ثنائية اللغة (`Map<String, dynamic>`)

### 🗂️ ملفات فارغة (مُعدّة ولم تُملأ بعد)
- `core/constants/app_colors.dart` (فارغ — الألوان في `theme/app_colors.dart`)
- `core/constants/app_strings.dart` (فارغ)
- `core/constants/firestore_keys.dart` (فارغ)
- `features/auth/data/auth_service.dart` (فارغ)
- `features/auth/screens/login_screen.dart` (فارغ — المستخدم هو `views/login_view.dart`)
- `shared/services/firestore_service.dart` (فارغ)
- `shared/services/fcm_service.dart` (فارغ)

---

## 🔲 ما تبقى للمرحلة الأولى (V1)

### المرحلة التالية أ: ربط Firebase (أولوية قصوى)
- [ ] إعداد `Firebase.initializeApp()` في main.dart
- [ ] تنفيذ `FirebaseAuthRepository` الحقيقي (بدل MockAuthRepository)
- [ ] ربط Google Sign-In فعلياً
- [ ] حفظ بيانات المستخدم الجديد في Firestore عند أول دخول
- [ ] تجديد الجلسة تلقائياً (Persistent Auth State)
- [ ] تنفيذ `FirestoreService` لجلب/حفظ البيانات
- [ ] ملء `firestore_keys.dart` بثوابت أسماء الحقول
- [ ] التوجيه الذكي في Splash (مسجّل؟ Onboarding مكتمل؟)
- [ ] حفظ بيانات Onboarding في Firestore
- [ ] جلب الوظائف من Firestore (بدل Mock Data)
- [ ] شريط الفلاتر في الشاشة الرئيسية
- [ ] ربط `url_launcher` لزر "تقدم الآن"
- [ ] تسجيل الخروج الفعلي

### المرحلة التالية ب: الإشعارات
- [ ] إعداد FCM في Flutter
- [ ] حفظ FCM Token في Firestore عند كل دخول
- [ ] Cloud Function: `notifyMatchingUsers` عند `onCreate` في `jobs/`
- [ ] دعم الإشعار: Foreground / Background / Terminated
- [ ] شاشة مركز الإشعارات الفعلية
- [ ] التخزين المحلي بـ Hive (سجل الإشعارات)
- [ ] Deep link: الضغط على الإشعار → تفاصيل الوظيفة

### المرحلة التالية ج: التلميع والإطلاق
- [ ] اكتشاف اللغة تلقائياً من إعدادات الهاتف
- [ ] ترجمة جميع النصوص المتبقية
- [ ] الحالات الاستثنائية (لا إنترنت، انتهاء جلسة، Empty State)
- [ ] Firebase Security Rules
- [ ] اختبار شامل على جهاز حقيقي
- [ ] توليد APK للاختبار
- [ ] توزيع تجريبي عبر Firebase App Distribution

---

## 🔮 المرحلة الثانية (V2) — مستقبلاً

> هذه الميزات **خارج نطاق V1** ولن تُبنى الآن

| الميزة | ملاحظات |
|--------|---------|
| ❌ حفظ الوظائف (Bookmark) | — |
| ❌ رفع السيرة الذاتية | — |
| ❌ التقديم من داخل التطبيق | — |
| ❌ لوحة تحكم Flutter Web للـ Admin | بديل عن Firebase Console |
| ❌ قائمة التخصصات ديناميكية من لوحة التحكم | البنية جاهزة، التنفيذ لاحقاً |
| ❌ شعار الشركة (`companyLogo`) | حقل محجوز في Firestore |
| ❌ تسجيل الدخول بالإيميل | — |
| ❌ دعم iOS | — |
| ❌ تقييم الوظائف أو التعليقات | — |
| ❌ Scraping آلي (Cloud Function مجدوَل) | الآن: يدوي من Admin |
| ❌ نشر على Google Play Store | بعد اختبار MVP مع المجموعة الأولى |

---

## 🏗️ الـ Stack التقني

| الطبقة | التقنية | الحالة |
|--------|---------|--------|
| Frontend | Flutter (Android — API 21+) | ✅ مُعدّ |
| State Management | Riverpod | ✅ مُفعّل |
| Navigation | GoRouter | ✅ مُفعّل |
| Auth | Firebase Authentication (Google) | 🔲 Mock فقط |
| Database | Cloud Firestore | 🔲 غير مربوط |
| Notifications | Firebase Cloud Messaging (FCM) | 🔲 غير مُعدّ |
| Backend Logic | Firebase Cloud Functions (Node.js) | 🔲 غير مكتوب |
| Local Storage | Hive (لسجل الإشعارات) | 🔲 غير مُعدّ |
| i18n | Flutter Localizations (`flutter_localizations`) | 🟡 جزئي |
| Open Links | `url_launcher` | 🔲 غير مربوط |
| Hosting | لا يلزم (كل شيء في Firebase) | — |
