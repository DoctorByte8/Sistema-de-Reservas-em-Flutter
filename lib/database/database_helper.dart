import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Private constructor
  DatabaseHelper._init();

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('booking.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the database schema
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR NOT NULL,
        email VARCHAR NOT NULL,
        password VARCHAR NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE address(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cep VARCHAR NOT NULL UNIQUE,
        logradouro VARCHAR NOT NULL,
        bairro VARCHAR NOT NULL,
        localidade VARCHAR NOT NULL,
        uf VARCHAR NOT NULL,
        estado VARCHAR NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE property(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        address_id INTEGER NOT NULL,
        title VARCHAR NOT NULL,
        description VARCHAR NOT NULL,
        number INTEGER NOT NULL,
        complement VARCHAR,
        price REAL NOT NULL,
        max_guest INTEGER NOT NULL,
        thumbnail VARCHAR NOT NULL,
        FOREIGN KEY(user_id) REFERENCES user(id),
        FOREIGN KEY(address_id) REFERENCES address(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE images(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        property_id INTEGER NOT NULL,
        path VARCHAR NOT NULL,    
        FOREIGN KEY(property_id) REFERENCES property(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE booking(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        property_id INTEGER NOT NULL,
        checkin_date VARCHAR NOT NULL,
        checkout_date VARCHAR NOT NULL,
        total_days INTEGER NOT NULL,
        total_price REAL NOT NULL,
        amount_guest INTEGER NOT NULL,
        rating REAL,
        FOREIGN KEY(user_id) REFERENCES user(id),
        FOREIGN KEY(property_id) REFERENCES property(id)
      );
    ''');
  }

  // Método query genérico adicionado
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await instance.database;
    return db.query(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  // Insert data into a table
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert(table, data);
  }

  // Query all rows from a table
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  // Query a single row by ID
  Future<Map<String, dynamic>?> queryById(String table, int id) async {
    final db = await instance.database;
    final results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Update a row in a table
  Future<int> update(String table, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  // Delete a row from a table by ID
  Future<int> delete(String table, int id) async {
    final db = await instance.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database connection
  Future<void> close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
