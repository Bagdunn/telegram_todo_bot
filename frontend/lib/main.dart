//$env:Path += ";C:\src\flutter\bin"
//import 'package:televerse/televerse.dart';
import 'data/time_model.dart';
import 'package:flutter/material.dart';
import 'pages/farm_form_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Створення нового бота за допомогою токену
  //final bot = Bot("");  // Замініть на свій токен
  WidgetsFlutterBinding.ensureInitialized();
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
  ); // Ініціалізація Firebase

final FarmLogic logic = FarmLogic();

  // Поточний час
  final DateTime now = DateTime.now();

  // Завантаження даних із бази
  final farms = await logic.fetchFarms();

  // Перевірка нагадувань
  final reminders = logic.checkReminders(farms, now);

  // Вивід результатів (в консоль для тесту)
  for (var reminder in reminders) {
    debugPrint("Тип: ${reminder['type']}, Назва: ${reminder['name']}, Лінк: ${reminder['link']}");
  }


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Logic Tester',
      home: FarmTestPage(),
    );
  }
}

class FarmTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FarmLogic logic = FarmLogic();

    final now = DateTime.now();

    final farms = [
      {
        'name': 'Farm 1',
        'link': 'http://example.com',
        'reminderInterval': Duration(hours: 1),
        'nextHarvestTime': now.add(Duration(hours: 3)),
        'missedReminderInterval': Duration(minutes: 30),
      },
      {
        'name': 'Farm 2',
        'link': 'http://example2.com',
        'reminderInterval': Duration(hours: 2),
        'nextHarvestTime': now.subtract(Duration(minutes: 10)),
        'missedReminderInterval': Duration(minutes: 30),
      },
    ];

    final reminders = logic.checkReminders(farms, now);

    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Logic Tester'),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ListTile(
            title: Text('Назва: ${reminder['name']}'),
            subtitle: Text('Тип: ${reminder['type']}'),
            trailing: Text('Лінк: ${reminder['link']}'),
          );
        },
      ),
    );
  }
}


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Farm Form App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: FarmFormPage(),//FarmFormPage(),  // Відразу відкриваємо форму
//     );
//   }
// }

// class TestFirestore extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Firestore Test')),
//       body: FutureBuilder(
//         future: FirebaseFirestore.instance.collection('test').add({'name': 'Flutter'}),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Center(child: Text('Data added to Firestore!'));
//           }
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }


