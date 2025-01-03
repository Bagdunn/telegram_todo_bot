//$env:Path += ";C:\src\flutter\bin"
//import 'package:televerse/televerse.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Form App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FarmFormPage(),//FarmFormPage(),  // Відразу відкриваємо форму
    );
  }
}

class TestFirestore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Test')),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('test').add({'name': 'Flutter'}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(child: Text('Data added to Firestore!'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


