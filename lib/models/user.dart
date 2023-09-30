class User {
  int? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});

  // Konversi objek user menjadi map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  // Konversi map menjadi objek user
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}
