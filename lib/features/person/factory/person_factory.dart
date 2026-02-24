import 'package:recomiendalo/features/person/models/person_model.dart';

class PersonFactory {
  static PersonModel fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: (json['id'] ?? '').toString(),
      dni: json['dni']?.toString(),
      role: (json['role'] ?? '').toString(),
      isActive: (json['is_active'] ?? json['isActive'] ?? false) as bool,
      avatarUrl: (json['avatar_url'] ?? json['avatarUrl'])?.toString(),
      dniFrontUrl: (json['dni_front_url'] ?? json['dniFrontUrl'])?.toString(),
      dniBackUrl: (json['dni_back_url'] ?? json['dniBackUrl'])?.toString(),
      createdAt: DateTime.parse(
        (json['created_at'] ?? json['createdAt'] ?? '').toString(),
      ),
      updatedAt: DateTime.parse(
        (json['updated_at'] ?? json['updatedAt'] ?? '').toString(),
      ),
      fullName: (json['full_name'] ?? json['fullName'])?.toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }

  static Map<String, dynamic> toJson(PersonModel model) {
    return {
      'id': model.id,
      'dni': model.dni,
      'role': model.role,
      'is_active': model.isActive,
      'avatar_url': model.avatarUrl,
      'dni_front_url': model.dniFrontUrl,
      'dni_back_url': model.dniBackUrl,
      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
      'full_name': model.fullName,
      'phone': model.phone,
    };
  }
}
