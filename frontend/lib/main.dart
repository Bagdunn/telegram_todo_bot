//$env:Path += ";C:\src\flutter\bin"
//import 'package:televerse/televerse.dart';
import 'package:flutter/material.dart';
import 'pages/farm_form_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDlJ9o2drj1LEx1M1V7Fwa4KMMGcoBnejM",
      authDomain: "gnomyboty.firebaseapp.com",
      projectId: "gnomyboty",
      storageBucket: "gnomyboty.firebasestorage.app",
      messagingSenderId: "451806234312",
      appId: "1:451806234312:web:077a3d58aaae78a5b087fd",
      measurementId: "G-53J42EGQQH",
    ),
  ); // Ініціалізація Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Form App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:FarmFormPage(), // Відразу відкриваємо форму
    );
  }
}



