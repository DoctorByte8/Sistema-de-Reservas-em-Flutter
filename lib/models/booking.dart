class Booking {
  final int? id;
  final int userId;
  final int propertyId;
  final String checkinDate;
  final String checkoutDate;
  final int totalDays;
  final double totalPrice;
  final int amountGuest;
  final double? rating;
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
      rating: map['rating']?.toDouble(),
    );
  }
}