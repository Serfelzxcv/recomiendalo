import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recomiendalo/core/theme/theme_mode_provider.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/primary_button.dart';
import 'package:recomiendalo/shared/widgets/secondary_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    final passwordOk = _passwordController.text.trim().length >= 6;
    final emailOk = _emailController.text.trim().contains('@');
    return emailOk && passwordOk && !_isSubmitting;
  }

  Future<void> _submit() async {
    // Cierra teclado
    FocusScope.of(context).unfocus();

    final formOk = _formKey.currentState?.validate() ?? false;
    if (!formOk) return;

    setState(() => _isSubmitting = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      context.go('/home');
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo iniciar sesión')),
      );
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
                              TextFormField(
                                controller: _emailController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  labelText: 'Correo electrónico',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  filled: true,
                                  fillColor: colors.primary.withValues(
                                    alpha: 0.04,
                                  ),
                                ),
                                validator: (value) {
                                  final v = (value ?? '').trim();
                                  if (v.isEmpty) {
                                    return 'Ingresa tu correo electrónico';
                                  }
                                  if (!v.contains('@')) return 'Correo inválido';
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
                                text: _isSubmitting
                                    ? 'Ingresando...'
                                    : 'Ingresar',
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
