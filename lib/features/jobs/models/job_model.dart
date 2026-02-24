class JobModel {
  final String id;
  final String personId;

  final String title;
  final String description;
  final String category;

  /// Si es remoto puede ser '' o null; igual lo dejo como String para tu UI actual
  final String location;

  final double? budget;
  final String? paymentMethod;
  final bool isRemote;

  /// Extras según tu formulario
  final List<String> tags; // etiquetas
  final List<String> images; // URLs de imágenes (luego de subir a Storage)

  /// Recomendado para orden y auditoría
  final DateTime createdAt;
  final DateTime updatedAt;

  const JobModel({
    required this.id,
    required this.personId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.budget,
    this.paymentMethod,
    this.isRemote = false,
    this.tags = const [],
    this.images = const [],
    required this.createdAt,
    required this.updatedAt,
  });
}
