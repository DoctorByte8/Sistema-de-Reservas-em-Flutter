class User {
  final int? id; // ID do usuário (chave primária, pode ser nulo ao criar um novo usuário)
  final String name; // Nome do usuário
  final String email; // Email do usuário
  final String password; // Senha do usuário

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  // Converte o objeto User para um Map<String, dynamic> (usado em operações com o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Cria um objeto User a partir de um Map<String, dynamic> (usado ao consultar o banco de dados)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
}
