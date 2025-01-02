//$env:Path += ";C:\src\flutter\bin"
//import 'package:televerse/televerse.dart';
import 'package:flutter/material.dart';
import 'pages/farm_form_page.dart';
import 'bot/bot_service.dart';

void main() {
  // Створення нового бота за допомогою токену
  //final bot = Bot("7971942023:AAFNuEquBmFZiycNh3-PhMclyIBsfXcEuGA");  // Замініть на свій токен

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
      home: FarmFormPage(),  // Відразу відкриваємо форму
    );
  }
}


