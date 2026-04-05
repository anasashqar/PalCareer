# PRD — تطبيق الوظائف الفلسطيني
**النسخة:** 1.1  
**التاريخ:** أبريل 2026  
**المنصة:** Android (Flutter + Firebase)  
**الجمهور المستهدف:** طلاب وخريجون جدد في فلسطين

---

## 1. نظرة عامة على المنتج

تطبيق Android بسيط يعرض فرص العمل في فلسطين للطلاب والخريجين الجدد، بناءً على اهتماماتهم ومستواهم التعليمي. المحتوى يُدار يدوياً من قِبل مدير النظام عبر Firebase، ويصل للمستخدمين عبر إشعارات فورية مخصصة.

---

## 2. الأهداف

- توصيل فرص العمل المناسبة للمستخدم بشكل فوري ودقيق
- تجربة تسجيل خفيفة وسريعة (Google Sign-In + 3 أسئلة فقط)
- لوحة تحكم بسيطة لمدير النظام دون الحاجة لباك-إند مخصص

---

## 3. المستخدمون

### 3.1 المستخدم العادي (Seeker)
- طالب أو خريج جديد في فلسطين
- يبحث عن وظائف تناسب تخصصه ومستواه
- يريد أن يعلم فور نشر وظيفة تناسبه

### 3.2 مدير النظام (Admin)
- الشخص المسؤول عن إضافة وتحديث الوظائف
- يعمل من Firebase Console أو لوحة تحكم Flutter Web مستقبلاً
- لا يحتاج تطبيق منفصل في المرحلة الأولى

---

## 4. المتطلبات الوظيفية

### 4.1 مسار المستخدم العادي

#### Splash Screen
- يظهر شعار التطبيق واسمه لمدة 2 ثوانٍ
- يُعيد توجيه المستخدم تلقائياً:
  - إذا مسجّل ومكمل Onboarding → الشاشة الرئيسية
  - إذا مسجّل وغير مكمل Onboarding → شاشة الأسئلة
  - إذا غير مسجّل → شاشة تسجيل الدخول

#### شاشة تسجيل الدخول

**الهدف من الشاشة:** نقطة الدخول الأولى — تُعرّف المستخدم بالمنصة وتحفّزه على البدء.

**المحتوى المرئي:**
- شعار التطبيق واسمه
- عنوان رئيسي يعكس هوية المنصة: منصة توظيف للسوق الفلسطيني
- عداد ديناميكي يجلب عدد الوظائف الفعلي من Firestore ويعرضه — مثال: "أكثر من 48 فرصة متاحة الآن" — **لا يُستخدم رقم ثابت في الكود**
- وصف قصير يُمهّد للمستخدم أن الوظائف ستُخصَّص له بعد تحديد اهتماماته
- زر واحد: "تسجيل الدخول بـ Google"

**السلوك التقني:**
- استخدام Firebase Authentication (Google Provider)
- بعد أول دخول ناجح → الانتقال لشاشة اختيار التخصص
- بعد دخول مكرر (مستخدم قديم) → الانتقال مباشرة للشاشة الرئيسية

---

#### شاشة اختيار التخصص (Onboarding — الخطوة الأولى)

**الهدف من الشاشة:** فلترة الوظائف واقتراح الفرص المناسبة بناءً على مجال المستخدم.

**المحتوى المرئي:**
- عنوان: "ما تخصصك أو مجالك؟"
- شبكة خيارات قابلة للاختيار (Chips أو Cards):

| الخيار | القيمة المحفوظة |
|--------|----------------|
| تقنية المعلومات | `it` |
| هندسة | `engineering` |
| إدارة أعمال | `business` |
| محاسبة | `accounting` |
| تعليم | `education` |
| تسويق | `marketing` |
| طب وصحة | `healthcare` |
| حقوق | `law` |
| أخرى | `other` |

- يمكن اختيار أكثر من تخصص
- خيار "تقنية المعلومات" يظهر أولاً وبتمييز بصري (حسب رؤية المصمم)
- زر "التالي" يُفعَّل فقط بعد اختيار خيار واحد على الأقل

---

#### شاشة اختيار مستوى الدوام (Onboarding — الخطوة الثانية)

**المحتوى المرئي:**
- سؤال: "ما مستواك التعليمي؟" — خيار واحد: طالب جامعي / خريج جديد
- سؤال: "ما نوع الدوام الذي تفضله؟" — اختيار متعدد: دوام كامل / دوام جزئي / عن بُعد
- زر "ابدأ" → يحفظ البيانات في Firestore وينتقل للشاشة الرئيسية

**البيانات المحفوظة بعد Onboarding:**
```
users/{userId}
├── fields: ["it"]                          // التخصصات المختارة
├── educationLevel: "graduate"              // المستوى التعليمي
├── preferredJobTypes: ["full_time", "remote"]
└── onboardingCompleted: true
```

---

#### الشاشة الرئيسية

**الهدف من الشاشة:** عرض الوظائف المخصصة للمستخدم مع إبراز أفضل تطابق.

**المحتوى المرئي:**
- شريط علوي: اسم المستخدم + أيقونة الإشعارات
- شريط فلاتر أفقي قابل للتمرير: التخصص + نوع الدوام
- قائمة وظائف (ListView) مرتبة من الأحدث للأقدم

**تمييز بطاقات الوظائف:**
- وظيفة بتطابق تام (مثال: مهندس برمجيات لمستخدم اختار IT) → تظهر أولاً وببطاقة مميزة بصرياً (لون أو شارة "يناسبك")
- وظائف بتطابق جزئي (مثال: مصمم UI/UX) → تظهر بعدها كاقتراحات بديلة

**محتوى كل بطاقة:**
- اسم الوظيفة (عريض)
- اسم الشركة + الموقع
- نوع الدوام (Chip) + مستوى الخبرة (Chip)
- المهارات المطلوبة (Chips صغيرة — مثال: React, Flutter)
- تاريخ النشر
- شارة "جديد" تظهر تلقائياً إذا `publishedAt` أقل من 3 أيام (محسوبة في Flutter، لا حقل إضافي في Firestore)

**منطق الترتيب في Firestore Query:**
```dart
FirebaseFirestore.instance
  .collection('jobs')
  .where('isActive', isEqualTo: true)
  .where('fields', arrayContainsAny: user.fields)
  .orderBy('publishedAt', descending: true)
```

---

#### شاشة تفاصيل الوظيفة

**الهدف من الشاشة:** عرض كامل لفرصة واحدة وتحفيز المستخدم على التقديم.

**المحتوى المرئي (مثال: مطور تطبيقات Flutter):**
- المسمى الوظيفي بخط كبير وواضح في أعلى الشاشة
- اسم الشركة + الموقع + نوع الدوام
- تاريخ النشر
- قسم "المتطلبات": قائمة نقاط بالمهارات والخبرات المطلوبة
- قسم "المسؤوليات": قائمة نقاط بمهام الوظيفة
- زر ثابت في أسفل الشاشة: "تقدم الآن" → يفتح رابط التقديم في المتصفح الخارجي

---

#### شاشة مركز الإشعارات

**الهدف من الشاشة:** عرض سجل الإشعارات الواردة للمستخدم.

**المحتوى المرئي:**
- قائمة الإشعارات مرتبة من الأحدث للأقدم
- كل إشعار يعرض: اسم الوظيفة + اسم الشركة + وقت الإشعار
- الإشعارات غير المقروءة تظهر بخلفية مميزة
- الضغط على أي إشعار → يفتح تفاصيل الوظيفة المرتبطة ويحدد الإشعار كمقروء

**الإشعارات المتوقع ظهورها لمستخدم اختار تخصص IT:**
- Senior Android Developer
- Software Engineer (Android SDK)
- Flutter Mobile Developer
- Android Developer (Internship)

**التخزين:** سجل الإشعارات يُحفظ محلياً على الجهاز (SharedPreferences أو Hive) — لا يحتاج Firestore collection منفصلة في V1.

---

#### شاشة الملف الشخصي

**الهدف من الشاشة:** إعدادات الحساب التي تُبنى عليها اقتراحات الوظائف.

**المحتوى المرئي:**
- صورة المستخدم واسمه من Google Account (مع أيقونة تعديل الصورة)
- وصف مهني يُولَّد تلقائياً من بيانات Onboarding — مثال: "مطور برمجيات طموح" لمن اختار IT

**قائمة الخيارات (List Items):**

| العنصر | الوصف |
|--------|-------|
| تعديل الملف الشخصي | يفتح شاشة تعديل التخصص ونوع الدوام |
| إعدادات الإشعارات | تفعيل/تعطيل الإشعارات (مع نقطة حمراء إذا في إشعارات جديدة) |
| عن التطبيق | معلومات التطبيق والإصدار |
| تسجيل الخروج | بلون أحمر مميز |

- رقم الإصدار يظهر في أسفل الشاشة — يُقرأ تلقائياً من `pubspec.yaml`
- Bottom Navigation Bar: زرّان فقط — الرئيسية + حسابي

**شاشة "تعديل الملف الشخصي" (Sub-screen):**
- التخصص / المجال (نفس خيارات Onboarding)
- نوع الدوام المفضل
- زر "حفظ التغييرات" → يحدث بيانات المستخدم في Firestore ويُعيد فلترة الوظائف تلقائياً

**ملاحظة:** الشاشة لا تعرض وظائف — هي صفحة إعدادات بحتة.

---

#### الإشعارات (Push Notifications)
- عند إضافة وظيفة جديدة من Admin تُطابق اهتمامات المستخدم، يصله Push Notification عبر FCM
- نص الإشعار: `"وظيفة جديدة: [اسم الوظيفة] في [اسم الشركة]"`
- الضغط على الإشعار يفتح تفاصيل الوظيفة مباشرة
- يُضاف الإشعار تلقائياً لسجل مركز الإشعارات داخل التطبيق

---

### 4.2 مسار مدير النظام (Admin)

في المرحلة الأولى: الإدارة مباشرة من Firebase Console.

#### هيكل Firestore لكل وظيفة:
```
jobs/{jobId}
├── title: String              // اسم الوظيفة
├── company: String            // اسم الشركة
├── location: String           // الموقع (مثال: رام الله)
├── jobType: String            // "full_time" | "part_time" | "remote"
├── level: String              // "مبتدئ" | "متوسط" | "أول"
├── skills: Array<String>      // ["Flutter", "Dart", "Firebase", ...]
├── applyLink: String          // رابط التقديم
├── publishedAt: Timestamp     // تاريخ النشر
├── description: String        // وصف الوظيفة العام (200-500 حرف)
├── requirements: Array<String>  // قائمة المتطلبات
├── responsibilities: Array<Map> // [{title: String, details: String}]
├── fields: Array<String>      // ["it", "engineering", "business", ...]
└── isActive: Boolean          // true = ظاهرة للمستخدمين

// حقول مستقبلية (V2):
// companyLogo: String         // URL شعار الشركة
```

#### الـ Matching Logic:
عند إضافة وظيفة جديدة:
1. Cloud Function تُشغَّل عند كل `onCreate` في مجموعة `jobs`
2. تقرأ بيانات المستخدمين من `users/{userId}`
3. تُقارن `job.fields` مع `user.fields` و `job.jobType` مع `user.preferredJobTypes`
4. ترسل FCM Notification لكل مستخدم مُطابق

---

## 5. التصميم التقني

### Stack
| الطبقة | التقنية |
|--------|---------|
| Frontend | Flutter (Android) |
| Auth | Firebase Authentication (Google) |
| Database | Cloud Firestore |
| Notifications | Firebase Cloud Messaging (FCM) |
| Backend Logic | Firebase Cloud Functions (Node.js) |
| Hosting | لا يلزم (كل شيء في Firebase) |

### هيكل Firestore

```
/users/{userId}
    name: String
    email: String
    photoUrl: String
    fields: Array<String>
    educationLevel: String        // "student" | "graduate"
    preferredJobTypes: Array<String>
    fcmToken: String
    onboardingCompleted: Boolean
    createdAt: Timestamp

/jobs/{jobId}
    title: String
    company: String
    location: String
    jobType: String              // "full_time" | "part_time" | "remote"
    level: String                // "مبتدئ" | "متوسط" | "أول"
    skills: Array<String>        // المهارات المطلوبة
    applyLink: String
    description: String
    requirements: Array<String>  // قائمة المتطلبات
    responsibilities: Array<Map> // [{title, details}]
    fields: Array<String>
    publishedAt: Timestamp
    isActive: Boolean
    // companyLogo: String       // V2
```

### Cloud Function المطلوبة
```javascript
// تُشغَّل عند إضافة وظيفة جديدة
exports.notifyMatchingUsers = functions.firestore
  .document('jobs/{jobId}')
  .onCreate(async (snap, context) => {
    const job = snap.data();
    if (!job.isActive) return;

    const usersSnap = await admin.firestore().collection('users').get();
    const tokens = [];

    usersSnap.forEach(doc => {
      const user = doc.data();
      const fieldMatch = user.fields?.some(f => job.fields?.includes(f));
      const typeMatch = user.preferredJobTypes?.includes(job.jobType);
      if (fieldMatch || typeMatch) tokens.push(user.fcmToken);
    });

    if (tokens.length === 0) return;

    return admin.messaging().sendMulticast({
      tokens,
      notification: {
        title: `وظيفة جديدة: ${job.title}`,
        body: `${job.company} — ${job.location}`,
      },
      data: { jobId: context.params.jobId }
    });
  });
```

---

## 6. خطة العمل (أسبوع واحد)

> **📌 آخر تحديث: 5 أبريل 2026**
> المرحلة الأولى (UI + البنية التحتية) مكتملة. جميع الشاشات مبنية كـ Mock.
> المطلوب الآن: ربط Firebase الحقيقي.

### ✅ مرحلة 1 — UI + Infrastructure (مكتملة)
- [x] إنشاء مشروع Flutter مع هيكل Feature-First
- [x] إعداد pubspec.yaml بجميع الحزم المطلوبة
- [x] نظام التصميم (Theme — The Civic Curator)
- [x] GoRouter + StatefulShellRoute (Bottom Navigation)
- [x] شاشة Splash مع أنيميشن
- [x] شاشة تسجيل الدخول بـ Google (Mock UI)
- [x] شاشة Onboarding (خطوتين) مع Provider
- [x] الشاشة الرئيسية + JobCard + بيانات وهمية
- [x] شاشة تفاصيل الوظيفة كاملة
- [x] شاشة مركز الإشعارات (UI أساسي)
- [x] شاشة الملف الشخصي (UI أساسي)
- [x] Data Models (UserModel + JobModel)
- [x] i18n: ملفات ARB + Generated Localizations (جزئي)

### 🔲 مرحلة 2 — Firebase Integration (لم تبدأ)
- [ ] ربط Firebase (`Firebase.initializeApp()`)
- [ ] Firebase Auth الحقيقي (استبدال MockAuthRepository)
- [ ] حفظ بيانات المستخدم الجديد في Firestore
- [ ] حفظ بيانات Onboarding في Firestore
- [ ] جلب الوظائف من Firestore (استبدال Mock Data)
- [ ] التوجيه الذكي في Splash Screen
- [ ] شريط الفلاتر الأفقي + عداد الوظائف الديناميكي
- [ ] `url_launcher` لزر "تقدم الآن"
- [ ] تعديل الملف الشخصي + حفظ في Firestore

### 🔲 مرحلة 3 — Notifications (لم تبدأ)
- [ ] إعداد FCM في Flutter (foreground + background + terminated)
- [ ] حفظ FCM Token في Firestore عند كل تسجيل دخول
- [ ] كتابة Cloud Function للـ matching وإرسال الإشعار
- [ ] شاشة مركز الإشعارات الفعلية (سجل محلي بـ Hive)
- [ ] منطق "مقروء / غير مقروء" وفتح تفاصيل الوظيفة عند الضغط
- [ ] اختبار الإشعار end-to-end

### 🔲 مرحلة 4 — Testing & Launch (لم تبدأ)
- [ ] اختبار كامل على جهاز حقيقي
- [ ] معالجة الحالات الاستثنائية (لا إنترنت، لا وظائف، إلخ)
- [ ] ترجمة جميع النصوص المتبقية
- [ ] إضافة بيانات تجريبية (5–10 وظائف)
- [ ] توليد APK للاختبار (flutter build apk --release)
- [ ] مراجعة Firebase Security Rules
- [ ] توزيع على مجموعة تجريبية عبر Firebase App Distribution

---

## 7. Firebase Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // المستخدم يقرأ ويعدل بياناته فقط
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // الوظائف: القراءة للجميع المسجلين، الكتابة لـ Admin فقط
    match /jobs/{jobId} {
      allow read: if request.auth != null;
      allow write: if false; // Admin يكتب من Firebase Console أو Server SDK
    }
  }
}
```

---

## 8. الحالات الاستثنائية

| الحالة | السلوك المطلوب |
|--------|----------------|
| لا يوجد إنترنت | عرض رسالة "تحقق من الاتصال" |
| لا توجد وظائف مطابقة | عرض شاشة فارغة مع نص "لا توجد وظائف حالياً" |
| جلسة منتهية | إعادة التوجيه لشاشة الدخول |
| FCM Token منتهي | تحديث Token تلقائياً عند فتح التطبيق |

---

## 9. ما هو خارج النطاق (V1)

- ❌ حفظ الوظائف (Bookmark) — مرحلة 2
- ❌ رفع السيرة الذاتية — مرحلة 2
- ❌ إشعارات داخل التطبيق (In-App Notifications) — مرحلة 2
- ❌ تقييم الوظائف أو التعليقات — مرحلة 2
- ❌ شعار الشركة (companyLogo) — مرحلة 2
- ❌ لوحة تحكم Flutter Web — مرحلة 2
- ❌ تسجيل الدخول بالإيميل — مرحلة 2
- ❌ دعم iOS — مرحلة 2

---

## 10. مقاييس النجاح (بعد الإطلاق)

| المقياس | الهدف خلال شهر |
|---------|----------------|
| عدد التحميلات | +100 مستخدم |
| معدل إكمال Onboarding | > 80% |
| معدل فتح الإشعارات | > 40% |
| معدل الضغط على "تقدم الآن" | > 20% من المشاهدات |
