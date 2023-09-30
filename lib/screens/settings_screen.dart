import 'package:flutter/material.dart';
import 'package:cashbook_app/helpers/database_helper.dart';
import 'package:cashbook_app/models/user.dart';

class SettingsScreen extends StatefulWidget {
  final String username;

  SettingsScreen({required this.username});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isCurrentPasswordCorrect = true;

  void _changePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    User? user = await _databaseHelper.getUserByUsername(widget.username);

    if (user != null && user.password == currentPassword) {
      if (newPassword == confirmPassword) {
        // Simpan password baru ke dalam database
        user.password = newPassword;
        await _databaseHelper.updateUser(user);
        setState(() {
          _isCurrentPasswordCorrect = true;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Password has been changed successfully.'),
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
        setState(() {
          _isCurrentPasswordCorrect = true;
        });
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('New password and confirm password do not match.'),
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
    } else {
      setState(() {
        _isCurrentPasswordCorrect = false;
      });
    }
  }

  Future<void> _exportDatabase() async {
    try {
      String exportedPath = await _databaseHelper.exportDatabase();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Database Exported'),
            content: Text('Database has been exported to: $exportedPath'),
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
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to export database: $e'),
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
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text('Username: ${widget.username}', style: TextStyle(fontSize: 24)),
          SizedBox(height: 10.0),
          Text('Ubah Password', style: TextStyle(fontSize: 18)),
          TextField(
            controller: _currentPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password Saat Ini'),
          ),
          SizedBox(height: 5.0),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password Baru'),
          ),
          SizedBox(height: 5.0),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Konfirmasi Password Baru'),
          ),
          ElevatedButton(
            onPressed: _changePassword,
            child: Text('Ubah Password'),
          ),
          ElevatedButton(
            onPressed: _exportDatabase,
            child: Text('Export Database'),
          ),
          if (!_isCurrentPasswordCorrect)
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'Password saat ini salah. Silakan coba lagi.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/logo/2141764163.jpg'),
                ),
                SizedBox(height: 16.0),
                Text('Aplikasi ini dibuat oleh:',
                    style: TextStyle(fontSize: 20.0)),
                Text(
                  'Nama: Amiruddin Fikri Nur',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'NIM: 2141764163',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Tanggal: 30 September 2023',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
