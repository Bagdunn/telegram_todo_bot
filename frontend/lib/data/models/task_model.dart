class Task {
  int id;
  int farmId;
  int userId;
  DateTime nextReminder; // Час наступного сповіщення
  bool isCompleted;

  Task({
    required this.id,
    required this.farmId,
    required this.userId,
    required this.nextReminder,
    this.isCompleted = false,
  });
}