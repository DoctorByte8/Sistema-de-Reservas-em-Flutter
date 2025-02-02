import 'package:flutter/material.dart';
import '../../services/property_service.dart';
import '../../models/property.dart';
import '../../utils/date_formatter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  DateTime? _checkinDate;
  DateTime? _checkoutDate;
  int? _guestCount;
  List<Property> _searchResults = [];
  bool _isLoading = false;
  final PropertyService _propertyService = PropertyService();
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
  Future<void> _searchProperties() async {
    if (!_formKey.currentState!.validate()) return;
    if (_checkinDate == null || _checkoutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione as datas de check-in e check-out.')),
      );
      return;
    }
    if (!DateFormatter.isValidDateRange(_checkinDate!, _checkoutDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A data de check-out deve ser posterior ao check-in.')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final results = await _propertyService.searchProperties(
        state: _stateController.text,
        city: _cityController.text,
        neighborhood: _neighborhoodController.text,
        checkin: _checkinDate!,
        checkout: _checkoutDate!,
        guestCount: _guestCount ?? 1,
      );
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar propriedades: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Propriedades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/guest-auth'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => Navigator.pushNamed(context, '/my-bookings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o estado' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cityController,
                decoration:
                    const InputDecoration(labelText: 'Cidade', border: OutlineInputBorder()),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a cidade' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _neighborhoodController,
                decoration:
                    const InputDecoration(labelText: 'Bairro', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(_checkinDate == null
                        ? 'Selecione Check-in'
                        : 'Check-in: ${DateFormatter.formatDate(_checkinDate!)}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, true),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_checkoutDate == null
                        ? 'Selecione Check-out'
                        : 'Check-out: ${DateFormatter.formatDate(_checkoutDate!)}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, false),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Número de Hóspedes', border: OutlineInputBorder()),
                keyboardType:
                    TextInputType.number,
                onChanged: (value) => setState(() {
                  if (value.isNotEmpty) {
                    _guestCount = int.tryParse(value);
                  }
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _searchProperties,
                child:
                    Text(_isLoading ? 'Buscando...' : 'Buscar Propriedades'),
              ),
              const SizedBox(height: 20),
              if (_searchResults.isNotEmpty)
                ..._searchResults.map((property) => ListTile(
                      leading:
                          Image.network(property.thumbnail, width: 60, height: 60, fit: BoxFit.cover),
                      title:
                          Text(property.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle:
                          Text('Preço R\$${property.price.toStringAsFixed(2)}\nRating médio'),
                      onTap:
                          () => Navigator.pushNamed(context, '/property-details', arguments: property.id),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}