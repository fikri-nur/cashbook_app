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
            title: Text('Masukan Tidak Valid'),
            content: Text(
                'Silakan masukkan tanggal, jumlah, dan keterangan yang valid.'),
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
          content: Text('Pengeluaran berhasil disimpan!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Tambah Pengeluaran',
        ),
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
                decoration: InputDecoration(labelText: 'Tanggal'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Nominal'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Keterangan'),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  _resetFields();
                },
                child: Text('Reset'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveOutcome,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                )
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Text('Kembali'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
