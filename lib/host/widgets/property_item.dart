import 'package:flutter/material.dart';
import '../../models/property.dart';

class PropertyItem extends StatelessWidget {
  final Property property; // Propriedade a ser exibida
  final VoidCallback onDelete; // Callback para exclusão da propriedade

  PropertyItem({
    required this.property,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: property.thumbnail.isNotEmpty
            ? Image.network(
                property.thumbnail,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            : Icon(Icons.home, size: 60, color: Colors.grey),
        title: Text(
          property.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Preço: R\$${property.price.toStringAsFixed(2)}\nMáx. Hóspedes: ${property.maxGuest}',
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Chama o callback de exclusão ao clicar no botão
            onDelete();
          },
        ),
        onTap: () {
          // Ao clicar na propriedade, navega para os detalhes
          Navigator.pushNamed(
            context,
            '/property-details',
            arguments: property.id,
          );
        },
      ),
    );
  }
}
