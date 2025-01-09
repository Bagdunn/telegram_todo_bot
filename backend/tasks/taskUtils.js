// Розрахунок наступного часу виконання завдання
function calculateNextTaskTime(lastTaskTime, taskPeriod) {
    return new Date(lastTaskTime.getTime() + taskPeriod * 60 * 1000); // Додаємо taskPeriod хвилин
  }
  
  // Перевірка, чи настав час для нагадування
  function isReminderDue(task, currentTime) {
    if (!task.lastReminder) return false; // Якщо нагадування ще не було
    const nextReminderTime = new Date(task.lastReminder.getTime() + task.remindPeriod * 60 * 1000);
    return currentTime >= nextReminderTime && !task.completed;
  }
  
  module.exports = {
    calculateNextTaskTime,
    isReminderDue,
  };
  