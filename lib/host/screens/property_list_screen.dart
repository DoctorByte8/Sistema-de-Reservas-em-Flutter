import 'package:flutter/material.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import '../widgets/property_item.dart';

class PropertyListScreen extends StatelessWidget {
  final int userId; // ID do anfitrião logado

  PropertyListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final PropertyService propertyService = PropertyService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Propriedades'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/property-form', arguments: userId);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Property>>(
        future: propertyService.getPropertiesByUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar propriedades.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma propriedade cadastrada.'));
          }

          final properties = snapshot.data!;

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return PropertyItem(
                property: property,
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Confirmar Exclusão'),
                      content:
                          Text('Tem certeza que deseja excluir esta propriedade?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await propertyService.deleteProperty(property.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Propriedade excluída com sucesso.')),
                    );
                    // Atualiza a tela após exclusão
                    (context as Element).reassemble();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
