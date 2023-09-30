import 'package:flutter/material.dart';
import 'package:cashbook_app/screens/login_screen.dart';
import 'package:cashbook_app/screens/home_screen.dart';
import 'package:cashbook_app/screens/income_screen.dart';
import 'package:cashbook_app/screens/outcome_screen.dart';
import 'package:cashbook_app/screens/cashflow_screen.dart';
import 'package:cashbook_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:cashbook_app/helpers/user_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request(); // Meminta izin akses penyimpanan

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}


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
        '/income': (context) => IncomeScreen(),
        '/outcome': (context) => OutcomeScreen(),
        '/cashflow': (context) => CashFlowScreen(),
        '/settings': (context) => SettingsScreen(
              username: Provider.of<UserProvider>(context).loggedInUser,
            )
      },
    );
  }
}