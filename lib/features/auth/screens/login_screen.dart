import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String completePhoneNumber = '';
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8FBFF),
              Color(0xFFE0F7FA),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🖋️ Título
                  Text(
                    'Recomiéndalo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 👷 Imagen principal
                  Image.asset(
                    'assets/images/workers_without_background.png',
                    height: 210,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 28),

                  // 🧱 Card principal
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 📱 Campo de teléfono con intl_phone_field
                        IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: 'Número de celular',
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          initialCountryCode: 'PE',
                          dropdownTextStyle: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (phone) {
                            completePhoneNumber = phone.completeNumber;
                          },
                        ),
                        const SizedBox(height: 18),

                        // 🔒 Contraseña
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),

                        // 🔘 Botón Entrar
                        PrimaryButton(
                          text: 'Entrar',
                          onPressed: () {
                            final password = _passwordController.text.trim();
                            debugPrint('📞 $completePhoneNumber / 🔑 $password');
                            context.go('/home');
                          },
                        ),
                        const SizedBox(height: 14),

                        // 🆕 Crear cuenta
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => context.go('/register'),
                            child: const Text('Crear cuenta'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    "Encuentra y conecta con los mejores profesionales cerca de ti",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
