class DBConstants {
  // Nome das tabelas
  static const String userTable = 'user';
  static const String addressTable = 'address';
  static const String propertyTable = 'property';
  static const String imagesTable = 'images';
  static const String bookingTable = 'booking';

  // Colunas da tabela "user"
  static const String userId = 'id';
  static const String userName = 'name';
  static const String userEmail = 'email';
  static const String userPassword = 'password';

  // Colunas da tabela "address"
  static const String addressId = 'id';
  static const String addressCep = 'cep';
  static const String addressLogradouro = 'logradouro';
  static const String addressBairro = 'bairro';
  static const String addressLocalidade = 'localidade';
  static const String addressUf = 'uf';
  static const String addressEstado = 'estado';

  // Colunas da tabela "property"
  static const String propertyId = 'id';
  static const String propertyUserId = 'user_id';
  static const String propertyAddressId = 'address_id';
  static const String propertyTitle = 'title';
  static const String propertyDescription = 'description';
  static const String propertyNumber = 'number';
  static const String propertyComplement = 'complement';
  static const String propertyPrice = 'price';
  static const String propertyMaxGuest = 'max_guest';
  static const String propertyThumbnail = 'thumbnail';

  // Colunas da tabela "images"
  static const String imagesId = 'id';
  static const String imagesPropertyId = 'property_id';
  static const String imagesPath = 'path';

  // Colunas da tabela "booking"
  static const String bookingId = 'id';
  static const String bookingUserId = 'user_id';
  static const String bookingPropertyId = 'property_id';
  static const String bookingCheckinDate = 'checkin_date';
  static const String bookingCheckoutDate = 'checkout_date';
  static const String bookingTotalDays = 'total_days';
  static const String bookingTotalPrice = 'total_price';
  static const String bookingAmountGuest = 'amount_guest';
  static const String bookingRating = 'rating';
}
