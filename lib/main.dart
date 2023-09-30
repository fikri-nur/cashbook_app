import 'package:flutter/material.dart';
import 'package:cashbook_app/screens/login_screen.dart';
import 'package:cashbook_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:cashbook_app/helpers/user_provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: MyApp(),
      ),
    );
// void main() => runApp(MyApp());

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
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
