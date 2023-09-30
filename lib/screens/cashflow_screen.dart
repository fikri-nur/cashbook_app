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
          if (transaction['type'] == 'income') {
            icon = Icons.arrow_downward;
            iconColor = Colors.green;
          } else {
            icon = Icons.arrow_upward;
            iconColor = Colors.red;
          }
          return ListTile(
            title: Text('Amount: Rp.${transaction['amount']}0'),
            subtitle: Text(
                'Date: ${transaction['date']}\nDescription: ${transaction['description']}'),
            trailing: Icon(
              icon,
              color: iconColor,
            ),
          );
        },
      ),
    );
  }
}
