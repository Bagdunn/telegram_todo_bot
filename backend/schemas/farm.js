const admin = require('firebase-admin');
const db = admin.firestore();

// Додавання нової фармілки
const addFarm = async (name, link, reminderPeriod, missedTaskInterval, isDaily, reminderTime, users) => {
  // Збереження фармілки в БД
  const farmRef = await db.collection('farms').add({
    name,
    link,
    reminderPeriod,
    missedTaskInterval,
    isDaily,
    reminderTime,
    users,
    created_at: admin.firestore.FieldValue.serverTimestamp(),
  });

  console.log(`Farm ${name} added with ID: ${farmRef.id}`);

  // Додаємо фармілку в графік користувачів
  for (const user of users) {
    const usersRef = db.collection('users');
    const snapshot = await usersRef.where('telegram_name', '==', user).get();

    if (!snapshot.empty) {
      snapshot.forEach(async (doc) => {
        await usersRef.doc(doc.id).update({
          farms_queue: admin.firestore.FieldValue.arrayUnion(farmRef.id),
        });
      });
      console.log(`Farm ${name} added to user's schedule: ${user}`);
    }
  }
};

module.exports = { addFarm };
