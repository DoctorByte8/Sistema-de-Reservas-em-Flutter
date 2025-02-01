import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class HostAuthScreen extends StatefulWidget {
  @override
  _HostAuthScreenState createState() => _HostAuthScreenState();
}

class _HostAuthScreenState extends State<HostAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // Apenas para registro
  bool _isLoginMode = true; // Alterna entre login e registro
  bool _isLoading = false; // Indica se uma operação está em andamento

  final AuthService _authService = AuthService();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLoginMode) {
        // Login
        final user = await _authService.login(
          _emailController.text,
          _passwordController.text,
        );

        if (user != null) {
          Navigator.pushReplacementNamed(context, '/host-home', arguments: user.id);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Credenciais inválidas. Tente novamente.')),
          );
        }
      } else {
        // Registro
        final userId = await _authService.register(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário registrado com sucesso!')),
        );

        Navigator.pushReplacementNamed(context, '/host-home', arguments: userId);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Login de Anfitrião' : 'Registro de Anfitrião'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (!_isLoginMode)
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Por favor, insira seu nome.';
                    return null;
                  },
                ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, insira seu email.';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Por favor, insira um email válido.';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, insira sua senha.';
                  if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_isLoginMode ? 'Entrar' : 'Registrar'),
                ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoginMode = !_isLoginMode;
                  });
                },
                child: Text(_isLoginMode
                    ? 'Não tem uma conta? Registre-se'
                    : 'Já tem uma conta? Faça login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
