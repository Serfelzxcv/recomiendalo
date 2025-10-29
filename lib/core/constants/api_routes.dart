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

// lib/core/constants/api_routes.dart
class API {
  static String get register  => URL.http("/auth/register");
  static String get sendOtp   => URL.http("/auth/send_otp");
  static String get verifyOtp => URL.http("/auth/verify_otp");
  static String get login     => URL.http("/auth/login");
}
