import 'package:recomiendalo/features/auth/data/auth_service.dart';
import 'package:recomiendalo/features/auth/models/register_model.dart';

class AuthRepository {
  final _service = AuthService();

  Future<bool> register(RegisterModel model) async {
    final response = await _service.registerUser(model);
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
