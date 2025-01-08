import 'package:cloud_firestore/cloud_firestore.dart';

class FarmLogic {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Завантаження всіх даних із колекції 'farms'
  Future<List<Map<String, dynamic>>> fetchFarms() async {
    try {
      final snapshot = await _firestore.collection('farms').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Помилка завантаження даних: $e");
      return [];
    }
  }

  // Перевірка, чи потрібно надсилати нагадування
  List<Map<String, dynamic>> checkReminders(
      List<Map<String, dynamic>> farms, DateTime currentTime) {
    List<Map<String, dynamic>> pendingReminders = [];

    for (var farm in farms) {
      final reminderPeriod = farm['reminderPeriod'] ?? 1; // Години
      final missedTaskInterval = farm['missedTaskInterval'] ?? 30; // Хвилини
      final lastReminder = farm['lastReminder'] != null
          ? (farm['lastReminder'] as Timestamp).toDate()
          : null;
      final isDaily = farm['isDaily'] ?? false;
      final reminderTime = farm['reminderTime']; // У форматі "HH:MM"

      if (lastReminder != null) {
        final timeSinceLastReminder =
            currentTime.difference(lastReminder).inMinutes;

        // Якщо пропущено активність
        if (timeSinceLastReminder >= reminderPeriod * 60) {
          pendingReminders.add({
            'name': farm['name'],
            'link': farm['link'],
            'type': 'normal', // Звичайне нагадування
          });
        } else if (timeSinceLastReminder >= missedTaskInterval) {
          pendingReminders.add({
            'name': farm['name'],
            'link': farm['link'],
            'type': 'missed', // Нагадування про пропущене завдання
          });
        }
      }

      // Додаткова перевірка для щоденних нагадувань
      if (isDaily && reminderTime != null) {
        final parsedTime = _parseTime(reminderTime);
        if (_isTimeToRemind(parsedTime, currentTime)) {
          pendingReminders.add({
            'name': farm['name'],
            'link': farm['link'],
            'type': 'daily', // Щоденне нагадування
          });
        }
      }
    }

    return pendingReminders;
  }

  // Парсинг часу у форматі "HH:MM"
  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  // Перевірка, чи настав час для щоденного нагадування
  bool _isTimeToRemind(DateTime reminderTime, DateTime currentTime) {
    return currentTime.hour == reminderTime.hour &&
        currentTime.minute == reminderTime.minute;
  }
}
