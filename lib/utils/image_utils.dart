import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<List<XFile>> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> images = await picker.pickMultiImage();
      return images ?? [];
    } catch (e) {
      throw Exception('Erro ao selecionar imagens: $e');
    }
  }
  static Future<XFile?> pickSingleImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e) {
      throw Exception('Erro ao selecionar a imagem: $e');
    }
  }
  static bool validateImageCount(List<XFile> images, int maxImages) {
    return images.length <= maxImages;
  }
}