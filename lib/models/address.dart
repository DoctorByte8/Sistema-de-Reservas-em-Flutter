class Address {
  final int? id; // ID do endereço (chave primária, pode ser nulo ao criar um novo endereço)
  final String cep; // CEP do endereço (único)
  final String logradouro; // Logradouro (rua/avenida)
  final String bairro; // Bairro
  final String localidade; // Cidade
  final String uf; // Unidade Federativa (estado, abreviação)
  final String estado; // Nome completo do estado

  Address({
    this.id,
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.estado,
  });

  // Converte o objeto Address para um Map<String, dynamic> (usado em operações com o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'estado': estado,
    };
  }

  // Cria um objeto Address a partir de um Map<String, dynamic> (usado ao consultar o banco de dados)
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      cep: map['cep'],
      logradouro: map['logradouro'],
      bairro: map['bairro'],
      localidade: map['localidade'],
      uf: map['uf'],
      estado: map['estado'],
    );
  }
}
