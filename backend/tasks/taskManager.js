const { calculateNextTaskTime, isReminderDue } = require('./taskUtils');

class TaskManager {
  constructor(tasks, currentTime) {
    this.tasks = tasks; // Масив завдань
    this.currentTime = currentTime; // Поточний час
  }

  // Основна функція для обробки завдань
  processTasks() {
    this.tasks.forEach((task) => {
      console.log(`\nProcessing task: ${task.name}`);
      
      // Щоденне завдання
      if (task.isDaily && this.isTimeForDaily(task)) {
        this.sendReminder(task, 'Daily reminder');
      }

      // Інтервальне завдання
      if (task.taskPeriod > 0 && this.isTimeForTaskPeriod(task)) {
        this.sendReminder(task, 'Periodic reminder');
        task.lastTaskTime = this.currentTime;
      }

      // Перевірка чи потрібне нагадування
      if (isReminderDue(task, this.currentTime)) {
        this.sendReminder(task, 'Follow-up reminder');
        task.lastReminder = this.currentTime;
      }
    });
  }

  // Перевірка щоденних завдань
  isTimeForDaily(task) {
    return this.currentTime >= task.dailyTime && task.lastTaskTime !== task.dailyTime;
  }

  // Перевірка інтервальних завдань
  isTimeForTaskPeriod(task) {
    if (!task.lastTaskTime) return true; // Якщо завдання ще не виконувалося
    const nextTaskTime = calculateNextTaskTime(task.lastTaskTime, task.taskPeriod);
    return this.currentTime >= nextTaskTime;
  }

  // Відправка повідомлення
  sendReminder(task, type) {
    console.log(`${type} for task "${task.name}" to users:`);
    task.users.forEach(user => {
      if (!user.completed) console.log(`- @${user.username}`);
    });
  }
}

module.exports = TaskManager;
