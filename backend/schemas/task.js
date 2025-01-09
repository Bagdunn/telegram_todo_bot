//const admin = require('../firebase');
const admin = require('firebase-admin');
const db = admin.firestore();

/**
 * Отримати всі задачі, прив’язані до користувача
 */
async function getUserTasks(userId) {
    const tasksRef = db.collection('tasks');
    const snapshot = await tasksRef.where('users', 'array-contains', userId).get();

    if (snapshot.empty) {
        return [];
    }

    const tasks = [];
    snapshot.forEach(doc => {
        tasks.push({ id: doc.id, ...doc.data() });
    });

    return tasks;
}

/**
 * Прорахувати стан задачі
 */
function calculateTaskState(task) {
    const now = new Date();
    const createdAt = task.created_at.toDate(); // Якщо це Firestore Timestamp
    const reminderTime = parseReminderTime(task.reminderTime);
    const interval = task.reminderPeriod * 60 * 1000; // Період нагадувань у мілісекундах

    // Наступне нагадування
    const nextReminder = new Date(createdAt);
    nextReminder.setHours(reminderTime.hours, reminderTime.minutes, 0);
    while (nextReminder <= now) {
        nextReminder.setTime(nextReminder.getTime() + interval);
    }

    // Пропущені нагадування
    const missedCount = Math.max(0, Math.floor((now - createdAt) / (task.missedTaskInterval * 60 * 1000)));

    return {
        nextReminder,
        missedCount,
        isOverdue: missedCount > 0,
    };
}

/**
 * Парсинг часу нагадування (формат "4:50 AM")
 */
function parseReminderTime(timeString) {
    const [time, period] = timeString.split(' '); // Розділяємо "4:50 AM"
    let [hours, minutes] = time.split(':').map(Number);
    if (period === 'PM' && hours !== 12) hours += 12;
    if (period === 'AM' && hours === 12) hours = 0;
    return { hours, minutes };
}

module.exports = {
    getUserTasks,
    calculateTaskState,
};
