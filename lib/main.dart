//$env:Path += ";C:\src\flutter\bin"
import 'package:televerse/televerse.dart';
import 'bot/bot_service.dart';

void main() {
  // Створення нового бота за допомогою токену
  final bot = Bot("7971942023:AAFNuEquBmFZiycNh3-PhMclyIBsfXcEuGA");  // Замініть на свій токен

  // Запускаємо бота
  bot.start();
}