# تعديل هيكل الوظائف لدعم أقسام وتخصصات متعددة

الهدف من هذا التغيير هو السماح بربط الوظيفة الواحدة بأكثر من قسم (Category) وتخصص (Sub-Category) بدلاً من قسم وتخصص واحد فقط، مما يسهل استهداف الوظائف لعدة تخصصات في نفس الوقت.

## User Review Required

> [!WARNING]
> **تعديل الاستعلامات في قاعدة البيانات (Firestore):**
> نظراً لأننا سنقوم بتغيير نوع الحقل في قاعدة بيانات Firebase من نص عادي (String) إلى قائمة نصوص (Array/List)، فهذا يعني أن الوظائف الحالية المضافة مسبقاً يجب تحديثها لكي تظهر للمستخدمين لأن الاستعلام الجديد سيبحث داخل مصفوفة (Array). 
> **سأقوم بكتابة سكريبت صغير أو دالة نقوم بتشغيلها مرة واحدة لتحديث الوظائف القديمة.** هل توافق على ذلك؟

## Proposed Changes

### 1- تعديل نموذج البيانات (Job Model)
سنقوم بتطوير `JobModel` ليستقبل قائمة من الأقسام والتخصصات، مع إبقاء دعم للملفات القديمة (Backward compatibility) لقراءتها إن وُجدت.

#### [MODIFY] [job_model.dart](file:///c:/Projects/PalCareer/lib/shared/models/job_model.dart)
- استبدال الحقل `categoryId` بـ `categoryIds` (List<String>)
- استبدال الحقل `subCategoryId` بـ `subCategoryIds` (List<String>)
- تعديل الدوال `fromMap` و `toMap` و `copyWith`.

### 2- تعديل مزودي البيانات (Providers)
سنقوم بتحديث الاستعلامات (Queries) لتستخدم الخاصية المخصصة للمصفوفات في Firestore وهي `arrayContainsAny` بدلاً من `whereIn`.

#### [MODIFY] [jobs_provider.dart](file:///c:/Projects/PalCareer/lib/features/jobs/providers/jobs_provider.dart)
- تعديل الاستعلامات في فئات (Best Matches) و (Good Matches) لتستخدم `arrayContainsAny`.

#### [MODIFY] [notifications_provider.dart](file:///c:/Projects/PalCareer/lib/features/notifications/providers/notifications_provider.dart)
- تعديل الاستعلامات المسؤولة عن جلب الإشعارات حسب اهتمامات المستخدم لتستخدم `arrayContainsAny`.

### 3- تحديث واجهة المستخدم
بعض الواجهات تعتمد على القسم، مثل عرض "الوظائف المشابهة". سنقوم بتحديثها لتعمل مع النظام الجديد.

#### [MODIFY] [job_details_screen.dart](file:///c:/Projects/PalCareer/lib/features/jobs/screens/job_details_screen.dart)
- تعديل جزء "الوظائف المشابهة" للبحث عن التقاطع بين الأقسام بدلاً من التطابق في قسم واحد.

## Open Questions

> [!IMPORTANT]  
> 1. بخصوص لوحة التحكم (Admin Panel) التي تقوم بنشر الوظائف: هل هي موجودة داخل نفس التطبيق أم تمتلك لوحة تحكم أو تطبيق منفصل؟ لو كانت في لوحة تحكم منفصلة، ستحتاج لوحة التحكم لتحديث مشابه لتسمح للمدير باختيار عدة تخصصات عند نشرالوظيفة.
> 2. بخصوص الوظائف القديمة الموجودة حالياً على النظام: سأقوم بعمل سكريبت لتحديثها من `categoryId` كرمز واحد إلى `[categoryIds]` كمصفوفة. هل أبدأ في كتابة التعديلات البرمجية؟

## Verification Plan

### Manual Verification
- التحقق من صفحة استكشاف الوظائف وظهور الوظائف بشكل سليم.
- التحقق من وصول الإشعارات بشكل متوافق.
- التأكد من عدم تحطم واجهة وتفاصيل الوظيفة.
