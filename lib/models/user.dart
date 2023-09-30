class User {
  int? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});

  // Convert user object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  // Convert a map to a user object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}
