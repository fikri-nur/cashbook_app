import 'package:cashbook_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cashbook_app/helpers/database_helper.dart';
import 'package:cashbook_app/models/user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _registerUser() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Menampilkan pesan jika input kosong
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Please enter both username and password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Membuat objek User
      User newUser = User(username: username, password: password);

      // Menyimpan pengguna ke dalam tabel users
      int userId = await _databaseHelper.insertUser(newUser);

      if (userId != -1) {
        // Jika penyimpanan berhasil
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registration Successful'),
              content: Text('User registered with username: $username'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Redirect pengguna ke halaman login
                    Navigator.popAndPushNamed(context, '/login');
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Jika penyimpanan gagal
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text('Failed to register user. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/logo/cashbook_logo.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Text('Cashbook App', style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
                SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: Text('Register'),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // Navigasi ke halaman registrasi
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Sudah punya akun? Login disini.'),
                ),
              ],
            ),
          ),
        ));
  }
}
