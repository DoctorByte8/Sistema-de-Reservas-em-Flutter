import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'host/screens/host_auth_screen.dart';
import 'guest/screens/guest_auth_screen.dart';
import 'host/screens/host_home_screen.dart';
import 'guest/screens/guest_home_screen.dart';
import 'host/screens/property_form_screen.dart';
import 'dart:io';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RéServè',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => MainGatewayScreen(),
        '/host': (context) => HostAuthScreen(),
        '/guest': (context) => GuestAuthScreen(),
        '/host-home': (context) => HostHomeScreen(
              userId: ModalRoute.of(context)!.settings.arguments as int,
            ),
        '/guest-home': (context) => const GuestHomeScreen(),
        '/property-form': (context) => PropertyFormScreen(
          userId: ModalRoute.of(context)!.settings.arguments as int,
        ),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(child: Text('Rota não encontrada: ${settings.name}')),
        ),
      ),
    );
  }
}

class MainGatewayScreen extends StatelessWidget {
  const MainGatewayScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem-vindo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/host'),
              child: const Text('Sou Anfitrião'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/guest'),
              child: const Text('Quero Reservar'),
            ),
          ],
        ),
      ),
    );
  }
}