import 'package:dio/dio.dart';
import 'package:recomiendalo/core/network/dio_client.dart';
import 'package:recomiendalo/core/constants/api_routes.dart';
import 'package:recomiendalo/features/auth/models/register_model.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<Response> registerUser(RegisterModel model) async {
    try {
      final response = await _dio.post(API.register, data: model.toJson());
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al registrar usuario');
    }
  }
}
