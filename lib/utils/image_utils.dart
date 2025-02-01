import 'package:image_picker/image_picker.dart';

class ImageUtils {
  // Seleciona várias imagens da galeria
  static Future<List<XFile>> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile>? images = await picker.pickMultiImage();
      return images ?? []; // Retorna uma lista vazia se nenhuma imagem for selecionada
    } catch (e) {
      throw Exception('Erro ao selecionar imagens: $e');
    }
  }

  // Seleciona uma única imagem (usada para thumbnails)
  static Future<XFile?> pickSingleImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image; // Retorna null se nenhuma imagem for selecionada
    } catch (e) {
      throw Exception('Erro ao selecionar a imagem: $e');
    }
  }

  // Valida o número de imagens selecionadas
  static bool validateImageCount(List<XFile> images, int maxImages) {
    return images.length <= maxImages;
  }
}
