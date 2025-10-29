import 'package:recomiendalo/features/auth/data/auth_service.dart';
import 'package:recomiendalo/features/auth/models/register_model.dart';

class AuthRepository {
  final _service = AuthService();

  Future<bool> sendOtp(String phone) async {
    final res = await _service.sendOtp(phone);
    return res.statusCode == 200;
  }

  Future<bool> verifyOtp(String phone, String code) async {
    final res = await _service.verifyOtp(phone, code);
    return res.data['status'] == 'approved';
  }

  Future<bool> register(RegisterModel model) async {
    final res = await _service.registerUser(model);
    return res.statusCode == 200 || res.statusCode == 201;
  }
}
