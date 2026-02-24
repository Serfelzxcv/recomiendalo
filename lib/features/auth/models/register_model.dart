import 'package:recomiendalo/features/auth/factory/register_factory.dart';

class RegisterModel {
  final String email;
  final String password;

  RegisterModel({
    required this.email,
    required this.password,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return RegisterFactory.toJson(this);
  }
}
