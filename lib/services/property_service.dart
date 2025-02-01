import '../database/database_helper.dart';
import '../models/property.dart';
import '../models/address.dart'; // Para a classe Address
import '../database/db_constants.dart'; // Para a classe DBConstants

class PropertyService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Método para criar um endereço (NEW)
  Future<int> createAddress(Address address) async {
    return await _dbHelper.insert(DBConstants.addressTable, address.toMap());
  }

  // Método para adicionar uma imagem (NEW)
  Future<void> addImage(int propertyId, String imagePath) async {
    await _dbHelper.insert(DBConstants.imagesTable, {
      'property_id': propertyId,
      'path': imagePath,
    });
  }

  // Cria uma nova propriedade no banco de dados
  Future<int> createProperty(Property property) async {
    return await _dbHelper.insert(DBConstants.propertyTable, property.toMap());
  }


  // Recupera todas as propriedades cadastradas por um usuário específico
  Future<List<Property>> getPropertiesByUser(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DBConstants.propertyTable, // Alterado para usar a constante
      where: '${DBConstants.propertyUserId} = ?',
      whereArgs: [userId],
    );
    return results.map((map) => Property.fromMap(map)).toList();
  }


  // Recupera todas as propriedades disponíveis (sem filtro de usuário)
  Future<List<Property>> getAllProperties() async {
    final db = await _dbHelper.database;
    final results = await db.query(DBConstants.propertyTable); // Usando a constante
    return results.map((map) => Property.fromMap(map)).toList();
  }


  // Recupera uma única propriedade pelo ID
  Future<Property?> getPropertyById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'property',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Property.fromMap(results.first);
    } else {
      return null; // Retorna null se a propriedade não for encontrada
    }
  }

  // Atualiza os dados de uma propriedade
  Future<int> updateProperty(Property property) async {
    return await _dbHelper.update('property', property.toMap());
  }

  // Exclui uma propriedade pelo ID e remove todas as reservas associadas a ela
  Future<void> deleteProperty(int propertyId) async {
    final db = await _dbHelper.database;

    // Exclui todas as reservas associadas à propriedade
    await db.delete(
      'booking',
      where: 'property_id = ?',
      whereArgs: [propertyId],
    );

    // Exclui as imagens associadas à propriedade
    await db.delete(
      'images',
      where: 'property_id = ?',
      whereArgs: [propertyId],
    );

    // Exclui a propriedade
    await db.delete(
      'property',
      where: 'id = ?',
      whereArgs: [propertyId],
    );
  }

  Future<List<Property>> searchProperties({
    required String state,
    required String city,
    required String neighborhood,
    required DateTime checkin,
    required DateTime checkout,
    required int guestCount
  }) async {
    final db = await _dbHelper.database;
    
    final results = await db.query(
      DBConstants.propertyTable,
      where: '''
        uf = ? AND 
        localidade = ? AND 
        bairro LIKE ? AND 
        max_guest >= ?
      ''',
      whereArgs: [
        state,
        city,
        '%$neighborhood%',
        guestCount
      ],
    );

    return results.map((map) => Property.fromMap(map)).toList();
  }

}
