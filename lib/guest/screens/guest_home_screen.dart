import 'package:flutter/material.dart';

class GuestHomeScreen extends StatelessWidget {
  final int? userId;
  const GuestHomeScreen({super.key, this.userId});
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