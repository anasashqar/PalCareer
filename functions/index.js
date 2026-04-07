const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onJobAdded = functions.firestore
  .document("jobs/{jobId}")
  .onCreate(async (snap, context) => {
    const jobData = snap.data();

    // 1. Anti-Spam Check: Ignore bulk uploads immediately
    if (jobData.isBulk === true || jobData.silentUpload === true) {
      console.log(`Job ${snap.id} is marked as bulk/silent. Skipping push notification.`);
      return null;
    }

    // 2. Targeting Check: Must have a category to notify matching users
    const categoryId = jobData.categoryId;
    if (!categoryId) {
      console.log(`Job ${snap.id} has no categoryId. Skipping.`);
      return null;
    }

    // Prepare Title based on available languages
    let jobTitle = "وظيفة جديدة المتاحة";
    if (jobData.title) {
        jobTitle = jobData.title.ar || jobData.title.en || jobTitle;
    }
    const companyName = jobData.company || "شركة";

    // 3. Topic definition matching our Flutter client app rules
    // We sanitize topic similarly just in case
    const safeTopic = categoryId.replace(/[^a-zA-Z0-9-_.~%]+/g, "_");
    const topic = `sector_${safeTopic}`;

    const payload = {
      notification: {
        title: "فرصة عمل تتناسب مع مجالك! 🚀",
        body: `أعلنت ${companyName} للتو عن شاغر: ${jobTitle}. قدم الآن!`,
      },
      android: {
        priority: "high", // 👈 ضروري جداً لظهور الإشعار فوراً
        notification: {
          sound: "default",
          channelId: "high_importance_channel", // 👈 يجب أن يطابق ما وضعناه في الـ AndroidManifest
          priority: "high",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        }
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        jobId: snap.id,
        type: "NEW_JOB",
      },
      topic: topic,
    };
    
    try {
      const response = await admin.messaging().send(payload);
      console.log(`Successfully sent message to topic ${topic}:`, response);
      return response;
    } catch (error) {
      console.error(`Error sending message to topic ${topic}:`, error);
      return null;
    }
  });
