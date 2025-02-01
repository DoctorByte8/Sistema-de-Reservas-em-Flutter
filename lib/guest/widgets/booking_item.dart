import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../utils/date_formatter.dart';

class BookingItem extends StatelessWidget {
  final Booking booking; // Objeto de reserva a ser exibido

  BookingItem({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Datas de check-in e check-out
            Text(
              '${DateFormatter.formatDate(DateTime.parse(booking.checkinDate))} - '
              '${DateFormatter.formatDate(DateTime.parse(booking.checkoutDate))}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Detalhes da reserva
            Text('Dias reservados: ${booking.totalDays}'),
            Text('Número de hóspedes: ${booking.amountGuest}'),
            Text(
              'Valor total: R\$${booking.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Avaliação (se disponível)
            if (booking.rating != null)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 4),
                  Text('Avaliação: ${booking.rating!.toStringAsFixed(1)}'),
                ],
              )
            else
              Text(
                'Sem avaliação',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
