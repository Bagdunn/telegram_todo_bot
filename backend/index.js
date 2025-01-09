require('dotenv').config();
const admin = require('firebase-admin');

admin.initializeApp({
    credential: admin.credential.cert(process.env.FIREBASE_SERVICE_ACCOUNT_KEY),
    databaseURL: process.env.FIREBASE_DATABASE_URL
});

const { addOrUpdateUser } = require('./schemas/user');
const { getUserQueue } = require('./schemas/user');
const TelegramBot = require('node-telegram-bot-api');
//const schedule = require('node-schedule');
const TaskManager = require('./tasks/taskManager');
//var serviceAccount = require("C:\\Users\\ibodi\\StudioProjects\\telegram_todo_bot\\backend\\gnomyboty-firebase-adminsdk-1ta4u-1a524e795b.json");

// Ініціалізація Firebase


const tasks = [
    {
      id: 'task_1',
      name: 'Collect daily reward',
      isDaily: true,
      isOnce: false,
      dailyTime: new Date('2025-01-09T12:00:00'),
      taskPeriod: 120, // Інтервал виконання (хвилин)
      remindPeriod: 45, // Інтервал нагадувань (хвилин)
      lastTaskTime: null,
      lastReminder: null,
      users: [
        { username: 'user1', completed: false },
        { username: 'user2', completed: false },
      ],
    },
    {
      id: 'task_2',
      name: 'Farm crypto',
      isDaily: false,
      isOnce: false,
      dailyTime: null,
      taskPeriod: 180,
      remindPeriod: 60,
      lastTaskTime: new Date('2025-01-09T09:30:00'),
      lastReminder: new Date('2025-01-09T11:00:00'),
      users: [
        { username: 'user1', completed: true },
        { username: 'user2', completed: false },
      ],
    },
  ];

  const taskManager = new TaskManager(tasks, currentTime);

  taskManager.processTasks();

const db = admin.firestore();

// Ініціалізація Telegram бота
console.log(process.env.BOT_TOKEN);
const BotToken = process.env.BOT_TOKEN;
console.log(BotToken);
const bot = new TelegramBot(BotToken, { polling: true });



// Функція для отримання даних з Firebase
async function getTasks() {
    const tasksSnapshot = await db.collection('tasks').get();
    return tasksSnapshot.docs.map(doc => doc.data());
}

//Обробка команди /start
bot.onText(/\/addtask/, (msg) => {
    const webAppButton = {
        text: 'Перейти до веб-додатку',
        web_app: {
            url: 'https://e472-185-181-36-63.ngrok-free.app' // Ваша URL для веб-додатку
        }
    };

    bot.sendMessage(msg.chat.id, 'Привіт! Нажміть на кнопку, щоб перейти до веб-додатку.', {
        reply_markup: {
            inline_keyboard: [[webAppButton]]
        }
    });
});

// bot.start(async (ctx) => {
//     const chatId = ctx.chat.id;
//     const name = ctx.from.username ? `@${ctx.from.username}` : `id${ctx.from.id}`;

//     // Додаємо або оновлюємо користувача
//     const user = await addOrUpdateUser(name, chatId);

//     // Виводимо інформацію про користувача з бази даних
//     const userInfo = `
//       Ваш ID: ${user.user_id}
//       Telegram Name: ${user.telegram_name}
//       Chat ID: ${user.chat_id}
//       Farms Queue: ${user.farms_queue.length ? user.farms_queue.join(', ') : 'Немає фармілок'}
//     `;

//     await ctx.reply(`Ваші дані з бази даних:\n${userInfo}`);
// });

bot.onText(/\/start/, async (msg) => {
    const chatId = msg.chat.id;
    const name = msg.from.username ? `@${msg.from.username}` : `id${msg.from.id}`;

    try {
        // Додаємо або оновлюємо користувача
        const user = await addOrUpdateUser(name, chatId);

        // Формуємо інформацію для відповіді
        const userInfo = `
Ваш ID: ${user.user_id}
Telegram Name: ${user.telegram_name}
Chat ID: ${user.chat_id}
Farms Queue: ${user.farms_queue.length ? user.farms_queue.join(', ') : 'Немає фармілок'}
        `;

        // Надсилаємо повідомлення користувачу
        bot.sendMessage(chatId, `Ваші дані з бази даних:\n${userInfo}`);
    } catch (error) {
        console.error("Помилка обробки команди /start:", error);
        bot.sendMessage(chatId, "Сталася помилка при обробці вашого запиту. Спробуйте ще раз пізніше.");
    }
});

bot.onText(/\/info/, async(msg) => {
    const chatId = msg.chat.id;
    const name = msg.from.username ? `@${msg.from.username}` : `id${msg.from.id}`;

    try {
    const userInfo = `
Ваш ID: ${user.user_id}
Telegram Name: ${user.telegram_name}
Chat ID: ${user.chat_id}
Farms Queue: ${user.farms_queue.length ? user.farms_queue.join(', ') : 'Немає фармілок'}
        `;

        // Надсилаємо повідомлення користувачу
        bot.sendMessage(chatId, `Ваші дані з бази даних:\n${userInfo}`);
    } catch (error) {
        console.error("Помилка обробки команди /start:", error);
        bot.sendMessage(chatId, "Сталася помилка при обробці вашого запиту. Спробуйте ще раз пізніше.");
    }
})

bot.onText(/\/queue/, async (msg) => {
    const chatId = msg.chat.id;
    const username = msg.from.username ? `@${msg.from.username}` : `id${msg.from.id}`;

    try {
        const queue = await getUserQueue(username);

        if (queue.length === 0) {
            return bot.sendMessage(chatId, 'У вас немає активних фармілок.');
        }

        const response = queue
            .map(task => `
Назва: ${task.name}
Посилання: ${task.link}
Наступне нагадування: ${task.nextReminder}
Пропущені: ${task.missedCount}
Стан: ${task.isOverdue}
            `.trim())
            .join('\n\n');

        bot.sendMessage(chatId, `Ваші фармілки:\n\n${response}`);
    } catch (error) {
        console.error(error);
        bot.sendMessage(chatId, 'Сталася помилка при завантаженні фармілок.');
    }
});
// Запуск бота
// bot.launch();
// console.log('Bot started!');

// ... решта коду для обробки команд та взаємодії з Firebase