import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'flashcard_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE subjects(
                id TEXT PRIMARY KEY , 
                name TEXT  , 
                chapters TEXT
            )''');
        await db.execute('''
            CREATE TABLE flashcards(
              id TEXT,
              chapter TEXT,
              question TEXT,
              type TEXT,
              answer TEXT,
              complex TEXT
            )''');
        await db.execute("""
CREATE TABLE isFirstTime(isFirstTime INTEGER DEFAULT 0)""");
      },
    );
  }
}
