// db_helper.dart
import 'package:fingerprint_app/models/finger_print_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'fingerprint_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE fingerprint_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dateCreated TEXT,
        fingerprintPath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE query_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fingerprintPath TEXT,
        result TEXT,
        matchPercentage REAL
      )
    ''');

    print("database tables created");
  }

  Future<int> insertFingerprintRecord(FingerprintModel fingerprint) async {
    Database db = await database;
    return await db.insert('fingerprint_records', fingerprint.toMap());
  }

  Future<List<FingerprintModel>> queryFingerprintRecords() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('fingerprint_records');
    return result.map((map) => FingerprintModel.fromMap(map)).toList();
  }

  Future<int> logFingerprintQuery(
      String fingerprintData, String result, double matchPercentage) async {
    Database db = await database;
    return await db.insert('query_logs', {
      'fingerprint_data': fingerprintData,
      'result': result,
      'match_percentage': matchPercentage,
    });
  }
}

final dbHelper = DatabaseHelper();
