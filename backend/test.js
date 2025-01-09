const TaskManager = require('./tasks/taskManager');

// Ініціалізація поточного часу
const currentTime = new Date('2025-01-09T11:30:00');

// Приклад завдань
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

// Ініціалізація менеджера завдань
const taskManager = new TaskManager(tasks, currentTime);

// Запуск обробки завдань
taskManager.processTasks();
