class Farm {
  int id;
  String name;
  String url;
  String type; // Тип завдання ('daily', 'timer')
  int intervalHours; // Інтервал для таймерів
  List<int> userIds; // Закріплені аккаунти

  Farm({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.intervalHours,
    required this.userIds,
  });
}