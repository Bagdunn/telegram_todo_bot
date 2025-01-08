class FarmLogic {
  /// Перевірка нагадувань
  List<Map<String, String>> checkReminders(List<Map<String, dynamic>> farms, DateTime now) {
    final List<Map<String, String>> reminders = [];

    for (var farm in farms) {
      final nextHarvestTime = farm['nextHarvestTime'] as DateTime;
      final name = farm['name'] as String;
      final link = farm['link'] as String;

      // Якщо час збору пропущено
      if (now.isAfter(nextHarvestTime)) {
        reminders.add({
          'type': 'Missed',
          'name': name,
          'link': link,
        });
      } else {
        reminders.add({
          'type': 'Upcoming',
          'name': name,
          'link': link,
        });
      }
    }

    return reminders;
  }
}
