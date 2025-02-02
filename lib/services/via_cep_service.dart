import 'dart:convert';
import 'package:http/http.dart' as http;

class ViaCepService {
  static const String _baseUrl = 'https://viacep.com.br/ws';
  static Future<Map<String, dynamic>> fetchAddress(String cep) async {
    final url = Uri.parse('$_baseUrl/$cep/json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('erro') && data['erro'] == true) {
          throw Exception('CEP inválido ou não encontrado.');
        }
        return data;
      } else {
        throw Exception('Falha ao buscar o CEP. Código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar o CEP: $e');
    }
  }
}