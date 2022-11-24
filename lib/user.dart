class User {
  final String id;
  final String username;
  final String password;
  final String email;
  final String name;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
        'email': email,
        'name': name,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        password: json['password'],
        email: json['email'],
        name: json['name'],
      );
}
