class ProfileModel {
  final String id;
  final String userId;        // Relación con el dueño
  final String name;          // Ej: "José Albañil", "Ferretería San Juan"
  final String role;          // Ej: "Albañil", "Ferretería"
  final String description;   // Breve descripción
  final String? avatarUrl;    // Foto de perfil
  final List<String> gallery; // URLs de imágenes (inventario, trabajos, etc.)
  final double rating;        // Promedio de estrellas (de referencias)

  ProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.description,
    this.avatarUrl,
    this.gallery = const [],
    this.rating = 0,
  });
}
