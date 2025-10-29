import 'package:dio/dio.dart';
import 'package:recomiendalo/core/constants/api_routes.dart';
import 'package:recomiendalo/core/network/dio_client.dart';
import 'package:recomiendalo/features/auth/models/register_model.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  // 📤 Registro
  Future<Response> registerUser(RegisterModel model) async {
    try {
      final res = await _dio.post(API.register, data: model.toJson());
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al registrar');
    }
  }

  // 📤 Enviar OTP
  Future<Response> sendOtp(String phone) async {
    try {
      final res = await _dio.post(API.sendOtp, data: {"phone": phone});
      print(API.sendOtp);
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al enviar OTP');
    }
  }

  // ✅ Verificar OTP
  Future<Response> verifyOtp(String phone, String code) async {
    try {
      print(API.verifyOtp);
      final res = await _dio.post(API.verifyOtp, data: {
        "phone": phone,
        "code": code,
      });
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al verificar OTP');
    }
  }
}
