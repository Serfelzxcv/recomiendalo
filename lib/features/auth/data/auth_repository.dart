import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recomiendalo/features/auth/data/auth_service.dart';
import 'package:recomiendalo/features/auth/models/register_model.dart';

class AuthRepository {
  final _service = AuthService();

  /// 📤 Enviar OTP
  Future<bool> sendOtp(String phone) async {
    try {
      final Response res = await _service.sendOtp(phone);

      final data = res.data is Map ? res.data : {};
      debugPrint('📩 Respuesta de sendOtp: $data');

      final status = data['status']?.toString().toLowerCase();
      final message = data['message']?.toString().toLowerCase();

      // ✅ Aceptar 200 o 201 como éxito
      if ((res.statusCode == 200 || res.statusCode == 201) &&
          (status == 'pending' ||
              status == 'sent' ||
              status == 'approved' ||
              (message?.contains('enviado correctamente') ?? false))) {
        debugPrint('✅ OTP enviado correctamente');
        return true;
      }

      debugPrint('⚠️ OTP no confirmado -> status: $status');
      return false;
    } on DioException catch (e) {
      debugPrint('❌ DioException sendOtp: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      debugPrint('❌ Error inesperado en sendOtp: $e');
      return false;
    }
  }

  /// ✅ Verificar OTP
  Future<bool> verifyOtp(String phone, String code) async {
    try {
      final Response res = await _service.verifyOtp(phone, code);
      final data = res.data is Map ? res.data : {};

      debugPrint('📩 Respuesta de verifyOtp: $data');

      final status = data['status']?.toString().toLowerCase();
      final message = data['message']?.toString().toLowerCase();

      if ((res.statusCode == 200 || res.statusCode == 201) &&
          (status == 'approved' ||
              (message?.contains('verificado correctamente') ?? false))) {
        debugPrint('✅ OTP verificado correctamente');
        return true;
      }

      debugPrint('⚠️ OTP incorrecto o expirado -> status: $status');
      return false;
    } on DioException catch (e) {
      debugPrint('❌ DioException verifyOtp: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      debugPrint('❌ Error inesperado verifyOtp: $e');
      return false;
    }
  }

  /// 🧾 Registrar usuario
  Future<bool> register(RegisterModel model) async {
    print(model);
    try {
      final Response res = await _service.registerUser(model);

      debugPrint('📩 Respuesta de register: ${res.data}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      debugPrint('❌ DioException register: ${e.response?.data ?? e.message}');
      return false;
    } catch (e) {
      debugPrint('❌ Error inesperado register: $e');
      return false;
    }
  }
}
