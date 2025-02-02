import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../utils/date_formatter.dart';

class BookingItem extends StatelessWidget {
  final Booking booking;
  const BookingItem({super.key, required this.booking});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormatter.formatDate(DateTime.parse(booking.checkinDate))} - '
              '${DateFormatter.formatDate(DateTime.parse(booking.checkoutDate))}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Dias reservados: ${booking.totalDays}'),
            Text('Número de hóspedes: ${booking.amountGuest}'),
            Text(
              'Valor total: R\$${booking.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (booking.rating != null)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('Avaliação: ${booking.rating!.toStringAsFixed(1)}'),
                ],
              )
            else
              const Text(
                'Sem avaliação',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}