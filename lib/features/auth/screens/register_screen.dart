import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/secondary_button.dart';
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
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  bool _loading = false;

  Future<void> _nextStep() async {
    if (_loading) return;

    final formKey = _step == 0
        ? _formKeyStep1
        : _step == 1
        ? _formKeyStep2
        : _formKeyStep3;

    if (!(formKey.currentState?.validate() ?? false)) return;

    if (_step != 1) {
      setState(() => _step++);
      return;
    }

    setState(() => _loading = true);
    try {
      final fullName = '${_nameController.text.trim()} ${_lastnameController.text.trim()}';
      await Supabase.instance.client.auth.signUp(
        email    : _emailController.text.trim(),
        password : _passwordController.text.trim(),
        data: {
          'full_name': fullName,
          'phone': _phoneController.text.trim(),
        },
      );

      if (!mounted) return;
      setState(() => _step++);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Te enviamos un código de verificación a tu correo'),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al registrarse: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _onFinish() async {
    if (_loading) return;
    if (!(_formKeyStep3.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);

    try {
      if (_step == 2) {
        await Supabase.instance.client.auth.verifyOTP(
          email: _emailController.text.trim(),
          token: _otpController.text.trim(),
          type: OtpType.email,
        );
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado correctamente')),
        );
        context.go('/login');
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
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
                  onBackToLogin: () => context.go('/login'),
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
      // Paso 1 - Datos personales
      case 0:
        return Form(
          key: _formKeyStep1,
          child: ListView(
            key: const ValueKey('step1'),
            children: [
              Text(
                'Datos personales',
                style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
                label: 'Celular',
                hint: 'Ej: 987654321',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digitsOnly != value) {
                    _phoneController.value = TextEditingValue(
                      text: digitsOnly,
                      selection: TextSelection.collapsed(
                        offset: digitsOnly.length,
                      ),
                    );
                  }
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese su celular';
                  if (!RegExp(r'^[0-9]{9,15}$').hasMatch(v)) {
                    return 'Ingrese un celular válido';
                  }
                  return null;
                },
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxHeight = constraints.maxHeight * 0.35;
                      return Image.asset(
                        'assets/images/register.png',
                        height: maxHeight.clamp(140, 240),
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );

      // Paso 2 - Seguridad
      case 1:
        return Form(
          key: _formKeyStep2,
          child: ListView(
            key: const ValueKey('step2'),
            children: [
              Text(
                'Seguridad',
                style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxHeight = constraints.maxHeight * 0.35;
                      return Image.asset(
                        'assets/images/security.png',
                        height: maxHeight.clamp(140, 240),
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );

      // Paso 3 - Validación
      default:
        return Form(
          key: _formKeyStep3,
          child: ListView(
            key: const ValueKey('step3'),
            children: [
              Text(
                'Validación',
                style: t.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Código de validación',
                hint: 'Ingrese 6 dígitos',
                controller: _otpController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
                  final normalized = digitsOnly.length > 6
                      ? digitsOnly.substring(0, 6)
                      : digitsOnly;

                  if (normalized != value) {
                    _otpController.value = TextEditingValue(
                      text: normalized,
                      selection: TextSelection.collapsed(
                        offset: normalized.length,
                      ),
                    );
                  }
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el código';
                  if (!RegExp(r'^[0-9]{6}$').hasMatch(v)) {
                    return 'El código debe tener 6 dígitos';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxHeight = constraints.maxHeight * 0.35;
                      return Image.asset(
                        'assets/images/otp.png',
                        height: maxHeight.clamp(140, 240),
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
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
      final inactive = colors.onSurface.withValues(alpha: 0.25);
      final inactiveText = colors.onSurface.withValues(alpha: 0.6);
      return Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: active ? colors.primary : inactive,
              shape: BoxShape.circle,
            ),
            child: Icon(
              active ? Icons.check : Icons.circle,
              size: active ? 16 : 10,
              color: active ? colors.onPrimary : inactiveText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: active ? colors.primary : inactiveText,
            ),
          ),
        ],
      );
    }

    Widget line(bool filled) => Expanded(
      child: Container(
        height: 2,
        color: filled ? colors.primary : colors.outline.withValues(alpha: 0.35),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        circle(current >= 0, 'Datos'),
        line(current >= 1),
        circle(current >= 1, 'Seguridad'),
        line(current >= 2),
        circle(current >= 2, 'Validación'),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  final int step;
  final bool loading;
  final VoidCallback onPrev;
  final VoidCallback onBackToLogin;
  final Future<void> Function() onNext;
  final Future<void> Function() onFinish;

  const _BottomActions({
    required this.step,
    required this.onPrev,
    required this.onBackToLogin,
    required this.onNext,
    required this.onFinish,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = step == 2;

    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            text: 'Atrás',
            onPressed: loading ? () {} : (step == 0 ? onBackToLogin : onPrev),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButton(
            text: isLastStep ? 'Finalizar' : 'Siguiente',
            onPressed: loading
                ? () {}
                : () async {
                    if (isLastStep) {
                      await onFinish();
                    } else {
                      await onNext();
                    }
                  },
          ),
        ),
      ],
    );
  }
}

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
