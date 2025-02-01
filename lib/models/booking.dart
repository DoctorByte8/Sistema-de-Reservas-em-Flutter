class Booking {
  final int? id; // ID da reserva (chave primária, pode ser nulo ao criar uma nova reserva)
  final int userId; // ID do usuário que fez a reserva (chave estrangeira para a tabela "user")
  final int propertyId; // ID da propriedade reservada (chave estrangeira para a tabela "property")
  final String checkinDate; // Data de check-in
  final String checkoutDate; // Data de check-out
  final int totalDays; // Total de dias da reserva
  final double totalPrice; // Preço total da reserva
  final int amountGuest; // Número de hóspedes
  final double? rating; // Avaliação da propriedade (opcional)

  Booking({
    this.id,
    required this.userId,
    required this.propertyId,
    required this.checkinDate,
    required this.checkoutDate,
    required this.totalDays,
    required this.totalPrice,
    required this.amountGuest,
    this.rating,
  });

  // Converte o objeto Booking para um Map<String, dynamic> (usado em operações com o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'property_id': propertyId,
      'checkin_date': checkinDate,
      'checkout_date': checkoutDate,
      'total_days': totalDays,
      'total_price': totalPrice,
      'amount_guest': amountGuest,
      'rating': rating,
    };
  }

  // Cria um objeto Booking a partir de um Map<String, dynamic> (usado ao consultar o banco de dados)
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      userId: map['user_id'],
      propertyId: map['property_id'],
      checkinDate: map['checkin_date'],
      checkoutDate: map['checkout_date'],
      totalDays: map['total_days'],
      totalPrice: map['total_price'].toDouble(),
      amountGuest: map['amount_guest'],
      rating: map['rating'] != null ? map['rating'].toDouble() : null,
    );
  }
}
