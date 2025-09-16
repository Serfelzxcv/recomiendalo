import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recomiendalo/features/auth/screens/secondary_button.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/primary_button.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Contraseña",
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: "Entrar",
              onPressed: () => context.go('/home'),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: "Crear cuenta",
              onPressed: () => context.go('/register'),
            ),
          ],
        ),
      ),
    );
  }
}
