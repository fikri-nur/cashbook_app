import 'package:flutter/material.dart';
import 'package:cashbook_app/helpers/database_helper.dart';

class CashFlowScreen extends StatefulWidget {
  @override
  _CashFlowScreenState createState() => _CashFlowScreenState();
}

class _CashFlowScreenState extends State<CashFlowScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    List<Map<String, dynamic>> transactions =
        await _databaseHelper.queryAllTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cash Flow'),
      ),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> transaction = _transactions[index];
          IconData icon;
          Color iconColor;
          Text text;
          if (transaction['type'] == 'income') {
            icon = Icons.arrow_back;
            iconColor = Colors.green;
            text = Text ('[ + ] Pemasukan: Rp.${transaction['amount']}0', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold));
          } else {
            icon = Icons.arrow_forward;
            iconColor = Colors.red;
            text = Text ('[ - ] Pengeluaran: Rp.${transaction['amount']}0', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
          }
          return ListTile(
            title: text,
            subtitle: Text(
                'Tanggal: ${transaction['date']}\nKeterangan: ${transaction['description']}', style: TextStyle(color: Colors.black, )),
            trailing: Icon(
              icon,
              color: iconColor,
              size: 32.0,
            ),
          );
        },
      ),
    );
  }
}
