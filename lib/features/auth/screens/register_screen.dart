import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:recomiendalo/features/auth/data/auth_repository.dart';
import 'package:recomiendalo/features/auth/models/register_model.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/inputs/secondary_button.dart';
import 'package:recomiendalo/shared/widgets/primary_button.dart';
import 'package:recomiendalo/shared/widgets/inputs/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _step = 0;

  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  final _repo = AuthRepository();
  bool _loading = false;

  void _nextStep() {
    final formKey = _step == 0
        ? _formKeyStep1
        : _step == 1
            ? _formKeyStep2
            : _formKeyStep3;

    if (formKey.currentState?.validate() ?? false) {
      setState(() => _step++);
    }
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _onFinish() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      debugPrint('🟢 Entrando a _onFinish() en step $_step');

      // Paso 1 → Enviar OTP
      if (_step == 1) {
        final phone = _phoneController.text.trim();

        if (phone.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ingrese un número válido')),
          );
          return;
        }

        final sent = await _repo.sendOtp(phone);

        if (sent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP enviado correctamente')),
          );
          setState(() => _step = 2);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ No se pudo enviar el OTP')),
          );
        }
      }

      // Paso 2 → Verificar OTP y registrar usuario
      else if (_step == 2) {
        final phone = _phoneController.text.trim();
        final code = _otpController.text.trim();

        final verified = await _repo.verifyOtp(phone, code);

        if (verified) {
          final fullName =
              '${_nameController.text.trim()} ${_lastnameController.text.trim()}';
          final model = RegisterModel(
            fullName: fullName,
            email: _emailController.text.trim(),
            phone: phone,
            password: _passwordController.text.trim(),
          );

          final success = await _repo.register(model);

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuario registrado correctamente')),
            );
            if (mounted) context.go('/login');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Código OTP incorrecto o expirado')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
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
                    duration: const Duration(milliseconds: 400),
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
                  loading: _loading,
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

  Widget _buildStepContent(ColorScheme colors, TextTheme t) {
    switch (_step) {
      case 0:
        return Form(
          key: _formKeyStep1,
          child: ListView(
            key: const ValueKey('step1'),
            children: [
              Text('Datos personales',
                  style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
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

      case 1:
        return Form(
          key: _formKeyStep2,
          child: ListView(
            key: const ValueKey('step2'),
            children: [
              Text('Seguridad y contacto',
                  style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Contraseña',
                controller: _passwordController,
                obscureText: true,
                validator: (v) =>
                    v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Confirmar contraseña',
                controller: _confirmPasswordController,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Repita su contraseña';
                  if (v != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'PE',
                onChanged: (phone) =>
                    _phoneController.text = phone.completeNumber,
              ),
            ],
          ),
        );

      default:
        return Form(
          key: _formKeyStep3,
          child: ListView(
            key: const ValueKey('step3'),
            children: [
              Text('Verifica tu teléfono',
                  style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Código OTP',
                controller: _otpController,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el código' : null,
              ),
            ],
          ),
        );
    }
  }
}

class _StepHeader extends StatelessWidget {
  final int current;
  const _StepHeader({required this.current});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Widget circle(bool active, String text) {
      return Column(children: [
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
        Text(text,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: active ? colors.primary : Colors.grey[600])),
      ]);
    }

    Widget line(bool filled) =>
        Expanded(child: Container(height: 2, color: filled ? colors.primary : Colors.grey[300]));

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

class _BottomActions extends StatelessWidget {
  final int step;
  final bool loading;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final Future<void> Function() onFinish;

  const _BottomActions({
    required this.step,
    required this.onPrev,
    required this.onNext,
    required this.onFinish,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = step == 2;
    final isSendOtpStep = step == 1;

    return Row(children: [
      if (step > 0)
        Expanded(
          child: SecondaryButton(
            text: 'Atrás',
            onPressed: loading ? () {} : onPrev,
          ),
        ),
      if (step > 0) const SizedBox(width: 12),
      Expanded(
        child: PrimaryButton(
          text: isSendOtpStep
              ? 'Enviar código'
              : (isLastStep ? 'Finalizar' : 'Siguiente'),
          onPressed: loading
              ? () {}
              : () {
                  if (isSendOtpStep || isLastStep) {
                    onFinish();
                  } else {
                    onNext();
                  }
                },
        ),
      ),
    ]);
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
