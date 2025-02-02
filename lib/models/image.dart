class ImageModel {
  final int? id;
  final int propertyId;
  final String path;
  ImageModel({
    this.id,
    required this.propertyId,
    required this.path,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'property_id': propertyId,
      'path': path,
    };
  }
  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      propertyId: map['property_id'],
      path: map['path'],
    );
  }
}