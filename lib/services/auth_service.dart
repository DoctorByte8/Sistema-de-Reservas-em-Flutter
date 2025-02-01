import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../../services/auth_service.dart';

class AuthService {
  final UserService _userService = UserService(); // Instância do serviço de usuários

  // Faz login de um usuário com email e senha
  Future<User?> login(String email, String password) async {
    final user = await _userService.authenticateUser(email, password);
    if (user != null) {
      await _saveUserSession(user.id!); // Salva a sessão do usuário
    }
    return user;
  }

  // Registra um novo usuário no sistema
  Future<int> register(String name, String email, String password) async {
    final newUser = User(name: name, email: email, password: password);
    final userId = await _userService.createUser(newUser);
    await _saveUserSession(userId); // Salva a sessão do usuário após o registro
    return userId;
  }

  // Salva a sessão do usuário (ID) usando SharedPreferences
  Future<void> _saveUserSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Faz logout do usuário e limpa a sessão
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  // Verifica se há um usuário logado atualmente
  Future<bool> isLoggedIn() async {
    final userId = await getCurrentUserId();
    return userId != null;
  }
}
