import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:recomiendalo/core/theme/theme_mode_provider.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/primary_button.dart';
import 'package:recomiendalo/shared/widgets/secondary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _completePhoneNumber = '';
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    final passwordOk = _passwordController.text.trim().length >= 6;
    final phoneOk = _completePhoneNumber.trim().isNotEmpty;
    return phoneOk && passwordOk && !_isSubmitting;
  }

  Future<void> _submit() async {
    // Cierra teclado
    FocusScope.of(context).unfocus();

    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;

    setState(() => _isSubmitting = true);
    try {
      // TODO: llama tu login real aquí.
      // Evita imprimir contraseñas en logs.
      // debugPrint('📞 $_completePhoneNumber');

      if (!mounted) return;
      context.go('/home');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return AppScaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.alphaBlend(
                colors.primary.withValues(alpha: 0.12),
                colors.surface,
              ),
              colors.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 40,
                        child: ToggleButtons(
                          borderRadius: BorderRadius.circular(10),
                          constraints: const BoxConstraints(
                            minHeight: 40,
                            minWidth: 44,
                          ),
                          isSelected: [!isDark, isDark],
                          onPressed: (index) {
                            ref
                                .read(themeModeProvider.notifier)
                                .setMode(
                                  index == 0 ? ThemeMode.light : ThemeMode.dark,
                                );
                          },
                          children: const [
                            Icon(Icons.light_mode_rounded, size: 18),
                            Icon(Icons.dark_mode_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Recomiéndalo',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Image.asset(
                      'assets/images/workers_without_background.png',
                      height: 185,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),

                    // Card de formulario
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.14),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow.withValues(alpha: 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              IntlPhoneField(
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                                cursorColor: colors.primary,
                                decoration: InputDecoration(
                                  labelText: 'Número de celular',
                                  prefixIcon: const Icon(
                                    Icons.phone_android_rounded,
                                  ),
                                  filled: true,
                                  fillColor: colors.primary.withValues(
                                    alpha: 0.04,
                                  ),
                                ),
                                initialCountryCode: 'PE',
                                dropdownTextStyle: TextStyle(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (phone) {
                                  setState(() {
                                    _completePhoneNumber = phone.completeNumber;
                                  });
                                },
                                validator: (phone) {
                                  // IntlPhoneField puede pasar valores null
                                  final value = phone?.completeNumber ?? '';
                                  if (value.trim().isEmpty) {
                                    return 'Ingresa tu número de celular';
                                  }
                                  // validación ligera (no perfecta, pero útil)
                                  if (value
                                          .replaceAll(RegExp(r'\D'), '')
                                          .length <
                                      9) {
                                    return 'Número inválido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                onChanged: (_) => setState(() {}),
                                onFieldSubmitted: (_) =>
                                    _canSubmit ? _submit() : null,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  filled: true,
                                  fillColor: colors.primary.withValues(
                                    alpha: 0.04,
                                  ),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      );
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  final v = (value ?? '').trim();
                                  if (v.isEmpty) return 'Ingresa tu contraseña';
                                  if (v.length < 6) {
                                    return 'Mínimo 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              PrimaryButton(
                                text: _isSubmitting ? 'Entrando...' : 'Entrar',
                                onPressed: _canSubmit ? _submit : null,
                                loading: _isSubmitting,
                              ),
                              const SizedBox(height: 12),
                              SecondaryButton(
                                text: 'Crear cuenta',
                                onPressed: _isSubmitting
                                    ? null
                                    : () => context.go('/register'),
                                fullWidth: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),
                    Text(
                      'Encuentra y conecta con los mejores profesionales cerca de ti',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.65),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
