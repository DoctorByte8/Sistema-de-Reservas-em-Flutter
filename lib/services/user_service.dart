import '../database/database_helper.dart';
import '../models/user.dart';

class UserService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Cria um novo usuário no banco de dados
  Future<int> createUser(User user) async {
    return await _dbHelper.insert('user', user.toMap());
  }

  // Autentica um usuário com base no email e senha
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
      return null; // Retorna null se o usuário não for encontrado
    }
  }

  // Recupera todos os usuários cadastrados (apenas para fins administrativos)
  Future<List<User>> getAllUsers() async {
    final db = await _dbHelper.database;
    final results = await db.query('user');
    return results.map((map) => User.fromMap(map)).toList();
  }

  // Recupera um único usuário pelo ID
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
      return null; // Retorna null se o usuário não for encontrado
    }
  }

  // Atualiza os dados de um usuário
  Future<int> updateUser(User user) async {
    return await _dbHelper.update('user', user.toMap());
  }

  // Exclui um usuário pelo ID
  Future<int> deleteUser(int id) async {
    return await _dbHelper.delete('user', id);
  }
}
