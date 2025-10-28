import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/primary_button.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 0;

  // Controladores
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() => _step++);
    }
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return AppScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/login'),
        ),
        title: const Text('Registro'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                _StepHeader(current: _step),
                const SizedBox(height: 24),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: _buildStepContent(colors, t),
                  ),
                ),
                const SizedBox(height: 12),
                _BottomActions(
                  step: _step,
                  onPrev: _prevStep,
                  onNext: _nextStep,
                  onFinish: _onFinish,
                ),
                const SizedBox(height: 16),
                _LoginRedirect(onTap: () => context.go('/login')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFinish() {
    final fullName =
      '${_nameController.text.trim()} ${_lastnameController.text.trim()}';

    final payload = {
      'fullName': fullName,
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    debugPrint('📤 Enviando registro: $payload');
    // TODO: POST al backend
    context.go('/home');
  }

  Widget _buildStepContent(ColorScheme colors, TextTheme t) {
    switch (_step) {
      // Paso 1: Datos personales
      case 0:
        return Form(
          key: _formKey,
          child: ListView(
            key: const ValueKey('step1'),
            children: [
              Text(
                'Datos personales',
                style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Cuéntanos quién eres para crear tu cuenta',
                style: t.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Nombres',
                controller: _nameController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese sus nombres' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Apellidos',
                controller: _lastnameController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese sus apellidos' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Correo electrónico',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese su correo';
                  if (!v.contains('@')) return 'Correo inválido';
                  return null;
                },
              ),
            ],
          ),
        );

      // Paso 2: Seguridad y contacto
      case 1:
        return Form(
          key: _formKey,
          child: ListView(
            key: const ValueKey('step2'),
            children: [
              Text(
                'Seguridad y contacto',
                style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Crea una contraseña segura y valida tu número de teléfono',
                style: t.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Contraseña',
                controller: _passwordController,
                obscureText: true, // 👈 con el ojo activo
                validator: (v) =>
                    v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Confirmar contraseña',
                controller: _confirmPasswordController,
                obscureText: true, // 👈 también tiene el ojo
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Repita su contraseña';
                  if (v != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Teléfono',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.length < 9 ? 'Teléfono inválido' : null,
              ),
            ],
          ),
        );

      // Paso 3: OTP
      default:
        return ListView(
          key: const ValueKey('step3'),
          children: [
            Text(
              'Verifica tu teléfono',
              style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Hemos enviado un código OTP a tu número\n${_phoneController.text.isEmpty ? '— — —' : _phoneController.text}',
              style: t.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppTextField(
              label: 'Código OTP',
              controller: _otpController,
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Ingrese el código' : null,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // TODO: reenviar OTP
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OTP reenviado')),
                );
              },
              child: const Text('Reenviar código'),
            ),
          ],
        );
    }
  }
}

/// 🔹 Header de pasos visual
class _StepHeader extends StatelessWidget {
  final int current;

  const _StepHeader({required this.current});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Widget circle(bool active, String text) {
      return Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: active ? colors.primary : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              active ? Icons.check : Icons.circle,
              size: active ? 16 : 10,
              color: active ? colors.onPrimary : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: active ? colors.primary : Colors.grey[600]),
          ),
        ],
      );
    }

    Widget line(bool filled) => Expanded(
          child: Container(
            height: 2,
            color: filled ? colors.primary : Colors.grey[300],
          ),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        circle(current >= 0, 'Datos'),
        line(current >= 1),
        circle(current >= 1, 'Seguridad'),
        line(current >= 2),
        circle(current >= 2, 'OTP'),
      ],
    );
  }
}

/// 🔹 Botones inferiores
class _BottomActions extends StatelessWidget {
  final int step;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const _BottomActions({
    required this.step,
    required this.onPrev,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (step > 0)
          Expanded(
            child: PrimaryButton(
              text: 'Atrás',
              onPressed: onPrev,
            ),
          ),
        if (step > 0) const SizedBox(width: 12),
        Expanded(
          child: PrimaryButton(
            text: step < 2 ? 'Siguiente' : 'Finalizar',
            onPressed: step < 2 ? onNext : onFinish,
          ),
        ),
      ],
    );
  }
}

/// 🔹 Link “¿Ya tienes una cuenta?”
class _LoginRedirect extends StatelessWidget {
  final VoidCallback onTap;

  const _LoginRedirect({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿Ya tienes una cuenta? '),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Entrar',
            style: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
