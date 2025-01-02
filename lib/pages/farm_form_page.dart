import 'package:flutter/material.dart';

class FarmFormPage extends StatelessWidget {
  const FarmFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редагувати фармілку'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Назва фармілки',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Введіть назву',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'URL фармілки',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Введіть URL',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Графік збирання',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Кожні N годин',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Щоденно о HH:MM',
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Нагадування (хвилин)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Частота нагадувань (хвилини)',
                ),
                keyboardType: TextInputType.number,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Реалізувати логіку збереження
                  },
                  child: const Text('Зберегти'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
