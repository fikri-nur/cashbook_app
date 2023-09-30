import 'package:flutter/material.dart';
import 'package:cashbook_app/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashbook App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        // '/settings': (context) => SettingsScreen(userId: 1,),
      },
    );
  }
}
