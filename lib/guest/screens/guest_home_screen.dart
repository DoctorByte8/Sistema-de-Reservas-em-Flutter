// lib/guest/screens/guest_home_screen.dart
import 'package:flutter/material.dart';

class GuestHomeScreen extends StatelessWidget {
  final int? userId; // Pode ser nulo para convidados

  const GuestHomeScreen({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Propriedades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => Navigator.pushNamed(context, '/my-bookings'),
          ),
        ],
      ),
      body: const Center(
        child: Text('Tela principal para hóspedes'),
      ),
    );
  }
}
