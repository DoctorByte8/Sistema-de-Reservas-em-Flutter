import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class AuthService {
  final UserService _userService = UserService();
  Future<User?> login(String email, String password) async {
    final user = await _userService.authenticateUser(email, password);
    if (user != null) {
      await _saveUserSession(user.id!);
    }
    return user;
  }
  Future<int> register(String name, String email, String password) async {
    final newUser = User(name: name, email: email, password: password);
    final userId = await _userService.createUser(newUser);
    await _saveUserSession(userId);
    return userId;
  }
  Future<void> _saveUserSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }
  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }
  Future<bool> isLoggedIn() async {
    final userId = await getCurrentUserId();
    return userId != null;
  }
}