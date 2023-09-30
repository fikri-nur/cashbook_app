import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cashbook_app/models/user.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // konstruktor tanpa nama
  DatabaseHelper();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cashbook.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<String> exportDatabase() async {
    // Dapatkan direktori penyimpanan eksternal
    Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      throw FileSystemException("External storage directory not found");
    }

    String backupDirPath =
        join(externalDir.path, 'CashbookBackup'); // Nama direktori backup

    // Periksa apakah direktori backup sudah ada. Jika tidak, buat direktori tersebut.
    if (!(await Directory(backupDirPath).exists())) {
      await Directory(backupDirPath).create(recursive: true);
    }

    String databasePath =
        join(await getDatabasesPath(), 'cashbook.db'); // Path database utama

    // Salin database ke file backup
    String backupPath = join(backupDirPath, 'cashbook_backup.db');
    File databaseFile = File(databasePath);

    // Memastikan file database utama ada sebelum mencoba menyalinnya
    if (databaseFile.existsSync()) {
      databaseFile.copySync(backupPath);
      return backupPath;
    } else {
      throw FileSystemException("Database file not found");
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Membuat tabel users
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');

    // Membuat tabel transactions
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        amount REAL,
        date TEXT,
        description TEXT
      )
    ''');
  }

  // Menambahkan user baru
  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  // Memeriksa login user
  Future<User?> getUserByUsername(String username) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query('users',
        where: 'username = ?', whereArgs: [username], limit: 1);

    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    } else {
      return null;
    }
  }

  // Mengupdate password user
  Future<int> updateUser(User user) async {
    Database db = await instance.database;
    return await db
        .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // Menambahkan transaksi income
  Future<int> insertIncome(
      String date, double amount, String description) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      'type': 'income',
      'amount': amount,
      'date': date,
      'description': description,
    };
    return await db.insert('transactions', row);
  }

  // Menambahkan transaksi outcome
  Future<int> insertOutcome(
      String date, double amount, String description) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      'type': 'outcome',
      'amount': amount,
      'date': date,
      'description': description,
    };
    return await db.insert('transactions', row);
  }

  // Mendapatkan semua transaksi
  Future<List<Map<String, dynamic>>> queryAllTransactions() async {
    Database db = await instance.database;
    return await db.query('transactions');
  }

  // Mendapatkan total Income
  Future<double?> getTotalIncome() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> amount = await db.query('transactions',
        where: 'type = ?', whereArgs: ['income'], columns: ['amount']);
    if (amount.isNotEmpty) {
      double totalIncome = 0;
      for (int i = 0; i < amount.length; i++) {
        totalIncome += amount[i]['amount'];
      }
      return totalIncome;
    } else {
      return null;
    }
  }

  // Mendapatkan total Outcome
  Future<double?> getTotalOutcome() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> amount = await db.query('transactions',
        where: 'type = ?', whereArgs: ['outcome'], columns: ['amount']);
    if (amount.isNotEmpty) {
      double totalOutcome = 0;
      for (int i = 0; i < amount.length; i++) {
        totalOutcome += amount[i]['amount'];
      }
      return totalOutcome;
    } else {
      return null;
    }
  }
}
