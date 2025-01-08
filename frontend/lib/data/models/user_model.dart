class User {
  final String id; // Унікальний ідентифікатор (UID Firebase)
  final String username; // Нік користувача
  final String role; // Роль (наприклад, 'admin' або 'farmer')
  final List<int> farms; // Ідентифікатори фармілок, які цей юзер фармить

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.farms,
  });

  // Конвертація з/в Firebase
  factory User.fromMap(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      username: data['username'] ?? '',
      role: data['role'] ?? 'farmer',
      farms: List<int>.from(data['farms'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'role': role,
      'farms': farms,
    };
  }
}
