class ImageModel {
  final int? id; // ID da imagem (chave primária, pode ser nulo ao criar uma nova imagem)
  final int propertyId; // ID da propriedade associada à imagem (chave estrangeira para a tabela "property")
  final String path; // Caminho do arquivo da imagem

  ImageModel({
    this.id,
    required this.propertyId,
    required this.path,
  });

  // Converte o objeto ImageModel para um Map<String, dynamic> (usado em operações com o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'property_id': propertyId,
      'path': path,
    };
  }

  // Cria um objeto ImageModel a partir de um Map<String, dynamic> (usado ao consultar o banco de dados)
  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      propertyId: map['property_id'],
      path: map['path'],
    );
  }
}
