const admin = require('firebase-admin');
const { getUserTasks, calculateTaskState } = require('./task');
require('dotenv').config();

// admin.initializeApp({
//     credential: admin.credential.cert(process.env.FIREBASE_SERVICE_ACCOUNT_KEY),
//     databaseURL: process.env.FIREBASE_DATABASE_URL
// });
const db = admin.firestore();

// Отримання наступного user_id з автоінкрементом
const getNextUserId = async () => {
  const counterRef = db.collection('meta').doc('user_counter');

  const result = await db.runTransaction(async (transaction) => {
    const counterDoc = await transaction.get(counterRef);
    let nextId = 1;

    if (counterDoc.exists) {
      nextId = counterDoc.data().last_id + 1;
      transaction.update(counterRef, { last_id: nextId });
    } else {
      transaction.set(counterRef, { last_id: nextId });
    }

    return nextId;
  });

  return result;
};

async function getUserQueue(userId) {
    const tasks = await getUserTasks(userId);
    const now = new Date();

    const taskStatuses = tasks.map(task => {
        const state = calculateTaskState(task);
        return {
            name: task.name,
            link: task.link,
            nextReminder: state.nextReminder.toLocaleString(),
            missedCount: state.missedCount,
            isOverdue: state.isOverdue ? '❌ Пропущено' : '✅ Вчасно',
        };
    });

    return taskStatuses;
}

// Додавання нового користувача або оновлення існуючого
const addOrUpdateUser = async (name, chatId) => {
  const usersRef = db.collection('users');
  const snapshot = await usersRef.where('telegram_name', '==', name).get();

  if (!snapshot.empty) {
    // Користувач існує, оновлюємо `chat_id`
    snapshot.forEach(async (doc) => {
      await usersRef.doc(doc.id).update({ chat_id: chatId });
    });
    console.log(`User ${name} updated with chat_id: ${chatId}`);
    return snapshot.docs[0].data(); // Повертаємо дані існуючого користувача
  } else {
    // Користувач не існує, створюємо нового
    const userId = await getNextUserId();
    const newUser = {
      user_id: userId,
      telegram_name: name,
      chat_id: chatId,
      farms_queue: [], // Пустий список фармілок
    };

    const userRef = await usersRef.add(newUser);
    console.log(`User ${name} added with user_id: ${userId}`);
    return newUser; // Повертаємо дані нового користувача
  }
};

// Отримання користувача по Telegram name
const getUserByName = async (name) => {
  const usersRef = db.collection('users');
  const snapshot = await usersRef.where('telegram_name', '==', name).get();

  if (!snapshot.empty) {
    return snapshot.docs[0].data(); // Повертаємо перший знайдений запис
  } else {
    console.log(`User with name ${name} not found`);
    return null;
  }
};

module.exports = { addOrUpdateUser, getUserByName, getUserQueue };
