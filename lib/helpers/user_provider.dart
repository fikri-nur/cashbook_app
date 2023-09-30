import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _loggedInUser = ''; // Variabel untuk menyimpan username pengguna yang login

  // Getter untuk mendapatkan username pengguna yang login
  String get loggedInUser => _loggedInUser;

  // Fungsi untuk mengatur username pengguna yang login
  void setLoggedInUser(String username) {
    _loggedInUser = username;
    notifyListeners(); // Memberi tahu listener (widget) bahwa ada perubahan pada data
  }
}