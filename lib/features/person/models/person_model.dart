import 'package:recomiendalo/features/person/factory/person_factory.dart';

class PersonModel {
  final String id;
  final String? dni;
  final String role;
  final bool isActive;
  final String? avatarUrl;
  final String? dniFrontUrl;
  final String? dniBackUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? fullName;
  final String? phone;

  const PersonModel({
    required this.id,
    this.dni,
    required this.role,
    required this.isActive,
    this.avatarUrl,
    this.dniFrontUrl,
    this.dniBackUrl,
    required this.createdAt,
    required this.updatedAt,
    this.fullName,
    this.phone,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return PersonFactory.toJson(this);
  }
}
