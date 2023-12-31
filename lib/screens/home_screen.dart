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
              Text('Hello, $loggedInUser!',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 24)),
              SizedBox(height: 10),
              Text(
                'Rangkuman Bulan ini',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                'Pengeluaran: Rp.${totalOutcome}0',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Text(
                'Pemasukan: Rp.${totalIncome}0',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.brown, // Warna border (bisa disesuaikan)
                    width: 2.0, // Lebar border (bisa disesuaikan)
                  ),
                ),
                child: Image.asset(
                  'assets/icon/line-chart.png',
                  width:
                      196, // Ukuran gambar sedikit lebih kecil dari lebar container untuk memperlihatkan border
                  height:
                      196, // Ukuran gambar sedikit lebih kecil dari tinggi container untuk memperlihatkan border
                ),
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
          width: 72, // Lebar gambar
          height: 72, // Tinggi gambar
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
            icon: Image.asset(iconPath, height: 36), // Lebar ikon
          ),
        ),
        SizedBox(height: 8), // Jarak antara ikon dan teks
        Text(text,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 16)),
      ],
    );
  }
}
