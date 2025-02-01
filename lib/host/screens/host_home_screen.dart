import 'package:flutter/material.dart';
import '../../services/property_service.dart';
import '../../models/property.dart';
import '../widgets/property_item.dart';

class HostHomeScreen extends StatelessWidget {
  final int userId;

  const HostHomeScreen({required this.userId});
  
  @override
  Widget build(BuildContext context) {
    // Obtém o ID do usuário logado passado como argumento
    final int userId = ModalRoute.of(context)!.settings.arguments as int;
    final PropertyService propertyService = PropertyService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Propriedades'),
        actions: [
          // No botão "Adicionar Propriedade":
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(
              context,
              '/property-form', // Nome correto da rota
              arguments: userId,
            ),
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
