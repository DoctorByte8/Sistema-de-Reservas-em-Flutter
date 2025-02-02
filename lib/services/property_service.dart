import '../database/database_helper.dart';
import '../models/property.dart';
import '../models/address.dart';
import '../database/db_constants.dart';

class PropertyService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Future<int> createAddress(Address address) async {
    return await _dbHelper.insert(DBConstants.addressTable, address.toMap());
  }
  Future<void> addImage(int propertyId, String imagePath) async {
    await _dbHelper.insert(DBConstants.imagesTable, {
      'property_id': propertyId,
      'path': imagePath,
    });
  }
  Future<int> createProperty(Property property) async {
    return await _dbHelper.insert(DBConstants.propertyTable, property.toMap());
  }
  Future<List<Property>> getPropertiesByUser(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DBConstants.propertyTable,
      where: '${DBConstants.propertyUserId} = ?',
      whereArgs: [userId],
    );
    return results.map((map) => Property.fromMap(map)).toList();
  }
  Future<List<Property>> getAllProperties() async {
    final db = await _dbHelper.database;
    final results = await db.query(DBConstants.propertyTable);
    return results.map((map) => Property.fromMap(map)).toList();
  }
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
      return null;
    }
  }
  Future<int> updateProperty(Property property) async {
    return await _dbHelper.update('property', property.toMap());
  }
  Future<void> deleteProperty(int propertyId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'booking',
      where: 'property_id = ?',
      whereArgs: [propertyId],
    );
    await db.delete(
      'images',
      where: 'property_id = ?',
      whereArgs: [propertyId],
    );
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