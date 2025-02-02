import 'package:flutter/material.dart';
import '../../models/property.dart';
import '../../models/booking.dart';
import '../../services/property_service.dart';
import '../../services/booking_service.dart';
import '../../utils/date_formatter.dart';
import '../../services/auth_service.dart';

class PropertyDetailScreen extends StatefulWidget {
  final int propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});
  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}
class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late Future<Property?> _propertyFuture;
  final BookingService _bookingService = BookingService();
  final AuthService _authService = AuthService();
  DateTime? _checkinDate;
  DateTime? _checkoutDate;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _propertyFuture = PropertyService().getPropertyById(widget.propertyId);
  }
  Future<void> _selectDate(BuildContext context, bool isCheckin) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (pickedDate != null) {
      setState(() {
        if (isCheckin) {
          _checkinDate = pickedDate;
        } else {
          _checkoutDate = pickedDate;
        }
      });
    }
  }
  Future<void> _makeReservation(Property property) async {
    final userId = await _authService.getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para realizar reservas')),
      );
      return;
    }
    if (_checkinDate == null || _checkoutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione as datas de check-in e check-out')),
      );
      return;
    }
    if (!DateFormatter.isValidDateRange(_checkinDate!, _checkoutDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data de check-out deve ser posterior ao check-in')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final isAvailable = await _bookingService.isPropertyAvailable(
        property.id!,
        _checkinDate!,
        _checkoutDate!,
      );
      if (!isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Propriedade indisponível para estas datas')),
        );
        return;
      }
      final totalPrice = _bookingService.calculateTotalPrice(
        _checkinDate!,
        _checkoutDate!,
        property.price,
      );
      final booking = Booking(
        userId: userId,
        propertyId: property.id!,
        checkinDate: DateFormatter.formatDate(_checkinDate!),
        checkoutDate: DateFormatter.formatDate(_checkoutDate!),
        totalDays: DateFormatter.calculateDaysDifference(_checkinDate!, _checkoutDate!),
        totalPrice: totalPrice,
        amountGuest: property.maxGuest,
      );
      await _bookingService.createBooking(booking);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva realizada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Propriedade')),
      body: FutureBuilder<Property?>(
        future: _propertyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Erro ao carregar detalhes'));
          }
          final property = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Image.network(property.thumbnail, height: 200, fit: BoxFit.cover),
                const SizedBox(height: 16),
                Text(
                  property.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(property.description),
                const SizedBox(height: 8),
                Text('Preço diária: R\$${property.price.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('Capacidade: ${property.maxGuest} hóspedes'),
                const SizedBox(height: 20),
                _buildDateSelector('Check-in', true),
                const SizedBox(height: 16),
                _buildDateSelector('Check-out', false),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _makeReservation(property),
                  child: Text(_isLoading ? 'Processando...' : 'Reservar Agora'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildDateSelector(String label, bool isCheckin) {
    return Row(
      children: [
        Expanded(
          child: Text(
            isCheckin
                ? _checkinDate?.toString() ?? 'Selecione Check-in'
                : _checkoutDate?.toString() ?? 'Selecione Check-out',
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context, isCheckin),
        ),
      ],
    );
  }
}