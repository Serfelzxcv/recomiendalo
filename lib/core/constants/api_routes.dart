import 'package:flutter_dotenv/flutter_dotenv.dart';

/// ✅ Controla los protocolos y el dominio dinámicamente desde `.env`
class URL {
  static bool get sslActive => bool.parse(dotenv.env['SSL'] ?? 'false');

  static String get domain {
    final protocol = sslActive ? 'https' : 'http';
    final host = dotenv.env['DOMAIN'] ?? '192.168.4.136:3000';
    return '$protocol://$host';
  }

  static String http(String uri) => '$domain$uri';
  static String ws(String uri) => "${sslActive ? 'wss' : 'ws'}://$domain$uri";
}

class API {
  static String get domain => URL.domain;

  // 🔹 Auth
  static String get register => URL.http('/auth/register');
  static String get login    => URL.http('/auth/login');

  // 🔹 Usuarios (cuando los agregues)
  static String get userProfile => URL.http('/users/profile');
  static String get resendOtp => URL.http('/auth/resend-otp');

  // 🔹 Ejemplo adicional (luego puedes ir agregando)
  static String get home => URL.http('/home');
}
