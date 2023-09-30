import 'package:flutter/material.dart';
import 'package:cashbook_app/helpers/database_helper.dart';

class OutcomeScreen extends StatefulWidget {
  @override
  _OutcomeScreenState createState() => _OutcomeScreenState();
}

class _OutcomeScreenState extends State<OutcomeScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _resetFields() {
    _dateController.text = '01/01/2021';
    _amountController.text = '';
    _descriptionController.text = '';
  }

  void _saveOutcome() async {
    String date = _dateController.text;
    double amount = double.tryParse(_amountController.text) ?? 0;
    String description = _descriptionController.text;

    if (date.isEmpty || amount <= 0 || description.isEmpty) {
      // Menampilkan dialog jika input tidak valid
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Please enter valid date, amount, and description.'),
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
      // Menyimpan data pengeluaran ke database
      await _databaseHelper.insertOutcome(date, amount, description);
      // Mereset input fields
      _resetFields();
      // Menampilkan snackbar jika data berhasil disimpan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Outcome saved successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Add Outcome'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    setState(() {
                      _dateController.text = formattedDate;
                    });
                  }
                },
                decoration: InputDecoration(labelText: 'Date'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _saveOutcome,
                child: Text('Save Outcome'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _resetFields();
                },
                child: Text('Reset'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
