import '../database/database_helper.dart';
import '../database/db_constants.dart';
import '../models/booking.dart';

class BookingService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> createBooking(Booking booking) async {
    return await _dbHelper.insert(DBConstants.bookingTable, booking.toMap());
  }

  Future<List<Booking>> getBookingsByUser(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DBConstants.bookingTable,
      where: '${DBConstants.bookingUserId} = ?',
      whereArgs: [userId],
    );
    return results.map((map) => Booking.fromMap(map)).toList();
  }

  Future<List<Booking>> getBookingsByProperty(int propertyId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DBConstants.bookingTable,
      where: '${DBConstants.bookingPropertyId} = ?',
      whereArgs: [propertyId],
    );
    return results.map((map) => Booking.fromMap(map)).toList();
  }

  Future<bool> isPropertyAvailable(int propertyId, DateTime checkin, DateTime checkout) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery('''
      SELECT * FROM ${DBConstants.bookingTable}
      WHERE ${DBConstants.bookingPropertyId} = ?
      AND (
        (${DBConstants.bookingCheckinDate} <= ? AND ${DBConstants.bookingCheckoutDate} >= ?)
        OR (${DBConstants.bookingCheckinDate} BETWEEN ? AND ?)
      )
    ''', [
      propertyId,
      checkout.toIso8601String(),
      checkin.toIso8601String(),
      checkin.toIso8601String(),
      checkout.toIso8601String()
    ]);

    return results.isEmpty;
  }

  // Método corrigido
  double calculateTotalPrice(DateTime checkin, DateTime checkout, double dailyPrice) {
    final duration = checkout.difference(checkin);
    if (duration.isNegative) throw Exception('Intervalo de datas inválido');
    return dailyPrice * (duration.inDays + 1); // Inclui o dia do check-in
  }

  Future<void> updateBookingRating(int bookingId, double rating) async {
    final db = await _dbHelper.database;
    await db.update(
      DBConstants.bookingTable,
      {DBConstants.bookingRating: rating},
      where: '${DBConstants.bookingId} = ?',
      whereArgs: [bookingId],
    );
  }

  Future<int> updateBooking(Booking booking) async {
    return await _dbHelper.update(
      DBConstants.bookingTable,
      booking.toMap(),
    );
  }

  Future<int> deleteBooking(int bookingId) async {
    return await _dbHelper.delete(
      DBConstants.bookingTable,
      bookingId,
    );
  }
}
