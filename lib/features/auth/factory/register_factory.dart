import 'package:recomiendalo/features/auth/models/register_model.dart';

class RegisterFactory {
  static RegisterModel fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      email     : (json['email'] ?? '').toString(),
      password  : (json['password'] ?? '').toString(),
    );
  }

  static Map<String, dynamic> toJson(RegisterModel model) {
    return {
      'email'   : model.email,
      'password': model.password,
    };
  }
}
