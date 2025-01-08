import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:telegram_todo_bot/data/time_model.dart'; // замініть на ваш шлях до файлу
//import 'package:telegram_todo_bot/time_logic.dart'; // замініть на ваш шлях до класу FarmLogic// Потрібно вказати правильний шлях до вашого файлу
// import 'package:flutter_test/flutter_test.dart';
// import 'package:firebase_core/firebase_core.dart'; // Додайте імпорт для firebase_core
// import 'package:cloud_firestore/cloud_firestore.dart'; // Додайте імпорт для Firestore
// import 'package:telegram_todo_bot/data/time_model.dart'; // Потрібно вказати правильний шлях до вашого файлу

void main() {
  setUpAll(() async {
    // Ініціалізація Firebase перед тестами
    //await Firebase.initializeApp();
    TestWidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDlJ9o2drj1LEx1M1V7Fwa4KMMGcoBnejM",
      authDomain: "gnomyboty.firebaseapp.com",
      projectId: "gnomyboty",
      storageBucket: "gnomyboty.firebasestorage.app",
      messagingSenderId: "451806234312",
      appId: "1:451806234312:web:077a3d58aaae78a5b087fd",
      measurementId: "G-53J42EGQQH"
    ),
  ); 
  });

  test('Тестування fetchFarms()', () async {
    // Створення тестових даних
    final testData = [
      {
        'name': 'Farm 1',
        'reminderPeriod': 1,
        'missedTaskInterval': 30,
        'lastReminder': DateTime.now().subtract(Duration(hours: 2)), // Наприклад, 2 години тому
        'isDaily': false,
        'reminderTime': null,
        'link': 'http://farm1.com'
      },
      {
        'name': 'Farm 2',
        'reminderPeriod': 1,
        'missedTaskInterval': 15,
        'lastReminder': DateTime.now().subtract(Duration(hours: 5)),
        'isDaily': true,
        'reminderTime': '08:00',
        'link': 'http://farm2.com'
      },
    ];

    final farmLogic = FarmLogic();

    // Виконання перевірки
    final currentTime = DateTime.now();
    final reminders = farmLogic.checkReminders(testData, currentTime);

    // Перевірка, чи повернуто правильні нагадування
    expect(reminders.length, equals(2)); // Наприклад, очікуємо два нагадування
    expect(reminders[0]['name'], equals('Farm 1')); // Перевірка першого елемента
    expect(reminders[1]['name'], equals('Farm 2')); // Перевірка другого елемента
  });
}
