// Map<int, String> userStates = {};
import 'package:televerse/televerse.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  dotenv.load();
  String botToken = dotenv.env['BOT_TOKEN'] ?? '';
  // Створення нового бота за допомогою токену
  final bot = Bot(botToken);  // Замініть на свій токен
  var keyboard = InlineKeyboard();
  keyboard.addWebApp('TEsty', 'https://464c-185-181-36-63.ngrok-free.app');

  Map<int, String> userStates = {};
  // Запускаємо бота
  
  bot.command('start', (ctx) async {
  await ctx.reply('Натисніть кнопку, щоб відкрити форму редагування фармілки:', replyMarkup: keyboard);}
  );

  // Ініціалізація обробників команд і текстових повідомлень
  bot.command('addfarm', (ctx) async {
    await ctx.reply("Це фармілка, яка на щоденній основі, репетативна або обидва варіанти? (Напишіть 'щоденна', 'репетативна' або 'обидва')");
    userStates[ctx.from!.id] = 'waiting_for_farm_type';
  });

  bot.text('щоденна', (ctx) async {
    await ctx.reply("Введіть назву фармілки:");
    userStates[ctx.from!.id] = 'waiting_for_farm_name_daily';
  });

  bot.text('репетативна', (ctx) async {
    await ctx.reply("Введіть назву фармілки:");
    userStates[ctx.from!.id] = 'waiting_for_farm_name_repetitive';
  });

  bot.text('обидва', (ctx) async {
    await ctx.reply("Введіть назву фармілки:");
    userStates[ctx.from!.id] = 'waiting_for_farm_name_both';
  });

  bot.text('.*', (ctx) async {
    String farmName = ctx.message?.text ?? 'Невизначена назва';
    await ctx.reply("Назва фармілки: $farmName");

    // Зберігаємо назву фармілки для подальшого використання
    userStates[ctx.from!.id] = 'waiting_for_farm_url';
  });

  bot.text('.*', (ctx) async {
    String farmUrl = ctx.message?.text ?? 'Невизначений URL';
    await ctx.reply("URL фармілки: $farmUrl");

    // Зберігаємо URL фармілки для подальшого використання
    userStates[ctx.from!.id] = 'waiting_for_farm_schedule';
  });

  bot.text('.*', (ctx) async {
    String scheduleInfo = ctx.message?.text ?? 'Невизначений графік';
    await ctx.reply("Графік фармілки: $scheduleInfo");

    // Зберігаємо графік для подальшого використання
    userStates[ctx.from!.id] = 'waiting_for_reminder_frequency';
  });

  bot.text('.*', (ctx) async {
    String reminderFrequency = ctx.message?.text ?? 'Невизначена частота нагадувань';
    await ctx.reply("Частота нагадувань: $reminderFrequency");

    // Зберігаємо частоту нагадувань для подальшого використання
    userStates[ctx.from!.id] = 'waiting_for_farm_reminder_time';
  });

  bot.text('.*', (ctx) async {
    String reminderTime = ctx.message?.text ?? 'Невизначений час нагадування';
    await ctx.reply("Час нагадування: $reminderTime");

    // Завершуємо налаштування фармілки
    userStates.remove(ctx.from!.id);
    await ctx.reply("Фарміку налаштовано успішно!");
  });

  bot.start();
  print('Bot Started');
}
