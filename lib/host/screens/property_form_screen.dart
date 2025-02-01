import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/via_cep_service.dart';
import '../../services/property_service.dart';
import '../../utils/image_utils.dart';
import '../../models/address.dart';
import '../../models/property.dart';
import '../../database/database_helper.dart';

class PropertyFormScreen extends StatefulWidget {
  final int userId; // ID do usuário logado

  PropertyFormScreen({required this.userId});

  @override
  _PropertyFormScreenState createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _numberController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxGuestController = TextEditingController();

  Address? _address; // Endereço obtido via API ViaCEP
  List<XFile> _images = []; // Lista de imagens selecionadas
  XFile? _thumbnail; // Imagem principal (thumbnail)

  final PropertyService _propertyService = PropertyService();

  // Busca o endereço usando o CEP fornecido
  Future<void> _searchAddress() async {
    if (_cepController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira um CEP válido.')),
      );
      return;
    }

    try {
      final data = await ViaCepService.fetchAddress(_cepController.text);
      setState(() {
        _address = Address(
          cep: data['cep'],
          logradouro: data['logradouro'] ?? '',
          bairro: data['bairro'] ?? '',
          localidade: data['localidade'] ?? '',
          uf: data['uf'] ?? '',
          estado: data['uf'], // Estado é igual à UF
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar o endereço: $e')),
      );
    }
  }

  // Seleciona imagens para a propriedade
  Future<void> _pickImages() async {
    try {
      final images = await ImageUtils.pickMultipleImages();
      setState(() {
        _images.addAll(images);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagens: $e')),
      );
    }
  }

  // Seleciona a imagem principal (thumbnail)
  Future<void> _pickThumbnail() async {
    try {
      final thumbnail = await ImageUtils.pickSingleImage();
      setState(() {
        _thumbnail = thumbnail;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar a thumbnail: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  if (_address == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor, busque um endereço válido.')),
    );
    return;
  }

  if (_thumbnail == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor, selecione uma imagem principal.')),
    );
    return;
  }

  try {
    final db = DatabaseHelper.instance;

    // Verifica se o CEP já existe
    final existingAddress = await db.query(
      'address',
      where: 'cep = ?',
      whereArgs: [_address!.cep],
    );

    int addressId;
    if (existingAddress.isNotEmpty) {
      // Reutiliza o endereço existente
      addressId = existingAddress.first['id'];
    } else {
      // Insere um novo endereço
      addressId = await db.insert('address', _address!.toMap());
    }

    // Cria a propriedade no banco de dados
    final property = Property(
      userId: widget.userId,
      addressId: addressId,
      title: _titleController.text,
      description: _descriptionController.text,
      number: int.parse(_numberController.text),
      complement: null,
      price: double.parse(_priceController.text),
      maxGuest: int.parse(_maxGuestController.text),
      thumbnail: _thumbnail!.path,
    );

    final propertyId = await db.insert('property', property.toMap());

    // Salva as imagens da propriedade no banco de dados
    for (var image in _images) {
      await db.insert('images', {'property_id': propertyId, 'path': image.path});
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Propriedade cadastrada com sucesso!')),
    );

    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao cadastrar a propriedade: $e')),
    );
  }
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Cadastrar Propriedade'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Campo para o CEP
            TextFormField(
              controller: _cepController,
              decoration: InputDecoration(
                labelText: 'CEP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Informe um CEP válido' : null,
            ),
            ElevatedButton(
              onPressed: _searchAddress,
              child: Text('Buscar Endereço'),
            ),
            if (_address != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text('Logradouro: ${_address!.logradouro}'),
                  Text('Bairro: ${_address!.bairro}'),
                  Text('Cidade/UF: ${_address!.localidade}/${_address!.uf}'),
                ],
              ),
            SizedBox(height: 20),

            // Campo para o título da propriedade
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) => value == null || value.isEmpty ? 'Informe o título' : null,
            ),
            SizedBox(height: 10),

            // Campo para a descrição da propriedade
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator:
                  (value) => value == null || value.isEmpty ? 'Informe a descrição' : null,
            ),
            SizedBox(height: 10),

            // Campo para o número do imóvel
            TextFormField(
              controller: _numberController,
              decoration: InputDecoration(
                labelText: 'Número',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  TextInputType.number, // Apenas números são permitidos
              validator:
                  (value) => value == null || value.isEmpty ? 'Informe o número' : null,
            ),
            SizedBox(height: 10),

            // Campo para o preço da propriedade
            TextFormField(
              controller: _priceController,
              decoration:
                  InputDecoration(labelText: 'Preço', border: OutlineInputBorder()),
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true), // Permite números decimais
              validator:
                  (value) => value == null || value.isEmpty ? 'Informe o preço' : null,
            ),
            SizedBox(height: 10),

            // Campo para a quantidade máxima de hóspedes
            TextFormField(
              controller: _maxGuestController,
              decoration:
                  InputDecoration(labelText: 'Máximo de Hóspedes', border: OutlineInputBorder()),
              keyboardType:
                  TextInputType.number, // Apenas números são permitidos
              validator:
                  (value) => value == null || value.isEmpty ? 'Informe a capacidade máxima' : null,
            ),
            SizedBox(height: 20),

            // Botão para selecionar a imagem principal (thumbnail)
            ElevatedButton(
              onPressed: _pickThumbnail,
              child:
                  Text(_thumbnail == null ? 'Selecionar Thumbnail' : 'Thumbnail Selecionada'),
            ),
            if (_thumbnail != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child:
                    Text('Thumbnail selecionada com sucesso!', style: TextStyle(color: Colors.green)),
              ),

            SizedBox(height: 20),

            // Botão para selecionar múltiplas imagens
            ElevatedButton(
              onPressed: _pickImages,
              child:
                  Text(_images.isEmpty ? 'Adicionar Imagens' : '${_images.length} Imagens Selecionadas'),
            ),

            SizedBox(height: 30),

            // Botão para salvar a propriedade
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Salvar Propriedade'),
            ),
          ],
        ),
      ),
    ),
  );
}
}