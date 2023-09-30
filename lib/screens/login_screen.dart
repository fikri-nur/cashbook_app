import 'package:flutter/material.dart';
import 'package:cashbook_app/models/user.dart';
import 'package:cashbook_app/helpers/database_helper.dart';
import 'package:cashbook_app/screens/register_screen.dart';
import 'package:cashbook_app/screens/home_screen.dart';
import 'package:cashbook_app/helpers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _loginUser() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Memeriksa apakah username dan password sesuai dengan yang ada di database
    User? user = await _databaseHelper.getUserByUsername(username);

    if (user != null && user.password == password) {
      // Jika autentikasi berhasil, lanjutkan ke halaman beranda
      Provider.of<UserProvider>(context, listen: false)
          .setLoggedInUser(username);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      // Jika autentikasi gagal, tampilkan pesan error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Authentication Failed'),
            content: Text('Invalid username or password.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Login'),
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
                Text('Cashbook App',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center),
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
                  onPressed: _loginUser,
                  child: Text('Login'),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // Navigasi ke halaman registrasi
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text('Belum punya akun? Registrasi disini.'),
                ),
              ],
            ),
          ),
        ));
  }
}
