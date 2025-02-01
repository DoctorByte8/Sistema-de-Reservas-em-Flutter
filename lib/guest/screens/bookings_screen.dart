import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../services/auth_service.dart';
import '../../services/booking_service.dart';
import '../../utils/date_formatter.dart';

class BookingsScreen extends StatefulWidget {
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late Future<List<Booking>> _bookingsFuture;
  final BookingService _bookingService = BookingService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() async {
    final userId = await _authService.getCurrentUserId();
    if (userId != null) {
      _bookingsFuture = _bookingService.getBookingsByUser(userId);
    } else {
      _bookingsFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Reservas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar reservas'));
          }

          final bookings = snapshot.data ?? [];

          if (bookings.isEmpty) {
            return Center(child: Text('Nenhuma reserva encontrada'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text(
                    '${DateFormatter.formatDate(DateTime.parse(booking.checkinDate))} - '
                    '${DateFormatter.formatDate(DateTime.parse(booking.checkoutDate))}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text('Dias: ${booking.totalDays}'),
                      Text('Hóspedes: ${booking.amountGuest}'),
                      Text(
                        'Total: R\$${booking.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  trailing: booking.rating != null 
                      ? Icon(Icons.star, color: Colors.amber)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
