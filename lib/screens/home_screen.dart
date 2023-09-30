import 'package:flutter/material.dart';
import 'package:cashbook_app/helpers/user_provider.dart';
import 'package:cashbook_app/helpers/database_helper.dart';
import 'package:cashbook_app/screens/login_screen.dart';
import 'package:cashbook_app/screens/income_screen.dart';
import 'package:cashbook_app/screens/outcome_screen.dart';
import 'package:cashbook_app/screens/cashflow_screen.dart';
import 'package:cashbook_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  double totalIncome = 0;
  double totalOutcome = 0;

  @override
  void initState() {
    super.initState();
    _loadTotal();
  }

  void _loadTotal() async {
    double income = await _databaseHelper.getTotalIncome() ?? 0;
    double outcome = await _databaseHelper.getTotalOutcome() ?? 0;
    setState(() {
      totalIncome = income;
      totalOutcome = outcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    String loggedInUser = Provider.of<UserProvider>(context).loggedInUser;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Cashbook'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hello, $loggedInUser!', style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              Text(
                'Rangkuman Bulan ini',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Pengeluaran: Rp.${totalOutcome}0',
                style: TextStyle(fontSize: 18, color: Colors.red) ,
              ),
              SizedBox(height: 5),
              Text(
                'Pemasukan: Rp.${totalIncome}0',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
              SizedBox(height: 10),
              Image.asset(
                'assets/icon/line-chart.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuButton(context, 'Pemasukan', () {
                    // Navigasi ke halaman tambah pemasukan
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IncomeScreen()));
                  }, 'assets/icon/income.png', true), // Tambahkan true di sini
                  _buildMenuButton(context, 'Pengeluaran', () {
                    // Navigasi ke halaman tambah pengeluaran
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OutcomeScreen()));
                  }, 'assets/icon/outcome.png',
                      true), // Tambahkan path ikon untuk tambah pengeluaran
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuButton(context, 'Cash Flow', () {
                    // Navigasi ke halaman detail cash flow
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CashFlowScreen()));
                  }, 'assets/icon/cashflow.png',
                      true), // Tambahkan path ikon untuk detail cash flow
                  _buildMenuButton(context, 'Pengaturan', () {
                    // Navigasi ke halaman pengaturan
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                                  username: loggedInUser,
                                )));
                  }, 'assets/icon/settings.png',
                      true), // Tambahkan path ikon untuk pengaturan
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildMenuButton(BuildContext context, String text,
      VoidCallback onPressed, String iconPath, bool isIncomeButton) {
    return Column(
      children: [
        Container(
          width: 64, // Lebar gambar
          height: 64, // Tinggi gambar
          margin: isIncomeButton
              ? EdgeInsets.only(right: 12)
              : EdgeInsets.zero, // Margin hanya untuk tombol "Tambah Pemasukan"
          decoration: BoxDecoration(
            color: Colors.brown, // Warna latar belakang tombol
            borderRadius:
                BorderRadius.circular(12), // Bentuk tombol (kotak persegi)
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Image.asset(iconPath, height: 32), // Lebar ikon
          ),
        ),
        SizedBox(height: 8), // Jarak antara ikon dan teks
        Text(text),
      ],
    );
  }
}
