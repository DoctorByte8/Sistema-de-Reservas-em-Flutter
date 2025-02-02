import '../database/database_helper.dart';
import '../models/user.dart';

class UserService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Future<int> createUser(User user) async {
    return await _dbHelper.insert('user', user.toMap());
  }
  Future<User?> authenticateUser(String email, String password) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    } else {
      return null;
    }
  }
  Future<List<User>> getAllUsers() async {
    final db = await _dbHelper.database;
    final results = await db.query('user');
    return results.map((map) => User.fromMap(map)).toList();
  }
  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    } else {
      return null;
    }
  }
  Future<int> updateUser(User user) async {
    return await _dbHelper.update('user', user.toMap());
  }
  Future<int> deleteUser(int id) async {
    return await _dbHelper.delete('user', id);
  }
}