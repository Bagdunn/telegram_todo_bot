import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmFormPage extends StatefulWidget {
  @override
  _FarmFormPageState createState() => _FarmFormPageState();
}

class _FarmFormPageState extends State<FarmFormPage> {
  // Контролери для текстових полів
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  // Список для зберігання вибраних користувачів
  List<String> users = [];
  
  // Періодичність нагадування (вибір з 1-12 годин)
  int reminderPeriod = 1;
  
  // Графік (коли буде виконано)
  bool isDaily = false;
  TimeOfDay? reminderTime;

  // Функція для додавання користувача
  void _addUser() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _userController = TextEditingController();
        return AlertDialog(
          title: Text('Додати користувача'),
          content: TextField(
            controller: _userController,
            decoration: InputDecoration(labelText: 'Введіть ім\'я користувача'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_userController.text.isNotEmpty) {
                  setState(() {
                    users.add(_userController.text);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Додати'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Скасувати'),
            ),
          ],
        );
      },
    );
  }

  // Функція для видалення користувача
  void _removeUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  // Функція для збереження даних у Firestore
  Future<void> _saveFarm() async {
    try {
      final String name = _nameController.text;
      final String link = _linkController.text;

      // Валідація
      if (name.isEmpty || link.isEmpty || reminderTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Будь ласка, заповніть усі поля коректно.")),
        );
        return;
      }

      // Збереження в Firestore
      await FirebaseFirestore.instance.collection('farms').add({
        'name': name,
        'link': link,
        'reminderPeriod': reminderPeriod,
        'isDaily': isDaily,
        'reminderTime': reminderTime?.format(context),
        'users': users,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Очищення форми
      _nameController.clear();
      _linkController.clear();
      setState(() {
        users.clear();
        reminderPeriod = 1;
        isDaily = false;
        reminderTime = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Дані успішно збережено!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Сталася помилка: $e")),
      );
    }
  }

  // Функція для вибору часу нагадування
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        reminderTime = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Форма додавання фармілки"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Назва додатку"),
            ),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(labelText: "Посилання на додаток"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Періодичність нагадування: "),
                DropdownButton<int>(
                  value: reminderPeriod,
                  onChanged: (int? newValue) {
                    setState(() {
                      reminderPeriod = newValue!;
                    });
                  },
                  items: List.generate(
                    12,
                        (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text("${index + 1} година"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isDaily,
                  onChanged: (bool? value) {
                    setState(() {
                      isDaily = value!;
                    });
                  },
                ),
                Text("Щоденне нагадування"),
              ],
            ),
            if (isDaily) ...[
              ListTile(
                title: Text(
                  reminderTime == null
                      ? "Не обрано час"
                      : "Час нагадування: ${reminderTime?.format(context)}",
                ),
                trailing: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ),
            ],
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Користувачі:"),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addUser,
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeUser(index),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveFarm,
              child: Text("Зберегти"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Звільнення контролерів
    _nameController.dispose();
    _linkController.dispose();
    super.dispose();
  }
}