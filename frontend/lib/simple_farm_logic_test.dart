import 'simple_farm_logic.dart';

void main() {
  final FarmLogic logic = FarmLogic();

  // Поточний час
  final now = DateTime.now();

  // Тестові дані
  final farms = [
    {
      'name': 'Farm 1',
      'link': 'http://example.com',
      'nextHarvestTime': now.add(Duration(hours: 2)),
    },
    {
      'name': 'Farm 2',
      'link': 'http://example2.com',
      'nextHarvestTime': now.subtract(Duration(minutes: 15)),
    },
  ];

  // Виклик логіки перевірки нагадувань
  final reminders = logic.checkReminders(farms, now);

  // Виведення результатів у консоль
  for (var reminder in reminders) {
    print("Тип: ${reminder['type']}, Назва: ${reminder['name']}, Лінк: ${reminder['link']}");
  }
}
