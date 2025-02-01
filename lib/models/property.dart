class Property {
  final int? id; // ID da propriedade (chave primária, pode ser nulo ao criar uma nova propriedade)
  final int userId; // ID do usuário que cadastrou a propriedade (chave estrangeira para a tabela "user")
  final int addressId; // ID do endereço da propriedade (chave estrangeira para a tabela "address")
  final String title; // Título da propriedade
  final String description; // Descrição da propriedade
  final int number; // Número do imóvel
  final String? complement; // Complemento do endereço (opcional)
  final double price; // Preço por diária da propriedade
  final int maxGuest; // Número máximo de hóspedes permitidos
  final String thumbnail; // Caminho para a imagem principal (thumbnail) da propriedade

  Property({
    this.id,
    required this.userId,
    required this.addressId,
    required this.title,
    required this.description,
    required this.number,
    this.complement,
    required this.price,
    required this.maxGuest,
    required this.thumbnail,
  });

  // Converte o objeto Property para um Map<String, dynamic> (usado em operações com o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'address_id': addressId,
      'title': title,
      'description': description,
      'number': number,
      'complement': complement,
      'price': price,
      'max_guest': maxGuest,
      'thumbnail': thumbnail,
    };
  }

  // Cria um objeto Property a partir de um Map<String, dynamic> (usado ao consultar o banco de dados)
  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'],
      userId: map['user_id'],
      addressId: map['address_id'],
      title: map['title'],
      description: map['description'],
      number: map['number'],
      complement: map['complement'],
      price: map['price'].toDouble(),
      maxGuest: map['max_guest'],
      thumbnail: map['thumbnail'],
    );
  }
}
