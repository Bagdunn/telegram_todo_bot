import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Клас Farm
class Farm {
  final String name;
  final int reminderPeriod;
  final int missedTaskInterval;
  final DateTime lastReminder;

  Farm({
    required this.name,
    required this.reminderPeriod,
    required this.missedTaskInterval,
    required this.lastReminder,
  });

  /// Перетворення з JSON у об'єкт Farm
  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      name: json['name'] as String,
      reminderPeriod: json['reminderPeriod'] as int,
      missedTaskInterval: json['missedTaskInterval'] as int,
      lastReminder: (json['lastReminder'] as Timestamp).toDate(),
    );
  }

  /// Перетворення з об'єкта Farm у JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'reminderPeriod': reminderPeriod,
      'missedTaskInterval': missedTaskInterval,
      'lastReminder': lastReminder.toIso8601String(),
    };
  }
}

/// Логіка FarmLogic
class FarmLogic {
  final FirebaseFirestore firestore;

  FarmLogic({required this.firestore});

  /// Отримання списку ферм з бази даних
  Future<List<Farm>> fetchFarms() async {
    final snapshot = await firestore.collection('farms').get();
    return snapshot.docs.map((doc) => Farm.fromJson(doc.data())).toList();
  }
}

void main() async {
  /// Ініціалізація Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_SENDER_ID',
      projectId: 'YOUR_PROJECT_ID',
    ),
  );

  /// Тестування логіки
  final firestore = FirebaseFirestore.instance;
  final farmLogic = FarmLogic(firestore: firestore);

  try {
    final farms = await farmLogic.fetchFarms();
    for (var farm in farms) {
      print('Farm name: ${farm.name}');
      print('Reminder period: ${farm.reminderPeriod}');
      print('Missed task interval: ${farm.missedTaskInterval}');
      print('Last reminder: ${farm.lastReminder}');
      print('-------------------------');
    }
  } catch (e) {
    print('Error fetching farms: $e');
  }
}
