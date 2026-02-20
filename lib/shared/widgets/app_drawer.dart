import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recomiendalo/core/theme/theme_mode_provider.dart';
import 'package:recomiendalo/shared/models/user_mode.dart';
import 'package:recomiendalo/shared/providers/user_mode_provider.dart';
import 'package:recomiendalo/core/router/app_routes.dart';
import 'package:recomiendalo/shared/widgets/dialogs/switching_mode_dialog.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final modeState = ref.watch(userModeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final mode = modeState.value ?? UserMode.employer;

    return Drawer(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colors.outline.withValues(
            alpha: Theme.of(context).brightness == Brightness.dark ? 0.45 : 0.2,
          ),
          width: 1.2,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: colors.surface,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.primary.withValues(alpha: 0.15),
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Usuario Demo',
                          style: textTheme.titleMedium?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'demo@correo.com',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: colors.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            mode == UserMode.employer
                                ? 'Modo Empleador'
                                : 'Modo Colaborador',
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ðŸ”¹ Opciones dinÃ¡micas
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (mode == UserMode.employer) ...[
                    _buildTile(
                      context,
                      icon: Icons.add_box_outlined,
                      title: 'Publicar trabajo',
                      route: AppRoutes.jobsCreate,
                    ),
                    _buildTile(
                      context,
                      icon: Icons.work_outline,
                      title: 'Trabajos publicados',
                      route: AppRoutes.jobsList,
                      badgeCount: 2,
                    ),
                    _buildTile(
                      context,
                      icon: Icons.reviews_outlined,
                      title: 'Reseñas como empleador',
                      route: AppRoutes.reviewsEmployer,
                    ),
                    _buildTile(
                      context,
                      icon: Icons.handshake_outlined,
                      title: 'Conectar con trabajadores',
                      route: AppRoutes.connect,
                    ),
                  ] else ...[
                    _buildTile(
                      context,
                      icon: Icons.build_outlined,
                      title: 'Mi Perfil',
                      route: AppRoutes.profile,
                    ),
                    _buildTile(
                      context,
                      icon: Icons.local_offer_outlined,
                      title: 'Mis ofertas',
                      route: AppRoutes.myOffers,
                      badgeCount: 1,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.work_history_outlined,
                        color: colors.onSurface.withValues(alpha: 0.45),
                      ),
                      title: Text(
                        'Trabajos en curso (Próximamente)',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.45),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      enabled: false,
                    ),
                  ],

                  // ListTile(
                  //   leading: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                  //   title: Text(
                  //     'Chat (Próximamente)',
                  //     style: textTheme.bodyMedium?.copyWith(
                  //       color: Colors.grey,
                  //       fontStyle: FontStyle.italic,
                  //     ),
                  //   ),
                  //   enabled: false,
                  // ),
                  const Divider(),

                  ListTile(
                    leading: Icon(
                      Icons.chat_bubble_outline,
                      color: colors.onSurface.withValues(alpha: 0.45),
                    ),
                    title: Text(
                      'Chat (Próximamente)',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.45),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    enabled: false,
                  ),

                  ListTile(
                    leading: Icon(
                      Icons.settings_outlined,
                      color: colors.onSurface.withValues(alpha: 0.45),
                    ),
                    title: Text(
                      'Configuración (Próximamente)',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.45),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    enabled: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.palette_outlined,
                          color: colors.onSurface,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tema',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 36,
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(10),
                            constraints: const BoxConstraints(
                              minHeight: 36,
                              minWidth: 40,
                            ),
                            isSelected: [!isDark, isDark],
                            onPressed: (index) {
                              ref
                                  .read(themeModeProvider.notifier)
                                  .setMode(
                                    index == 0
                                        ? ThemeMode.light
                                        : ThemeMode.dark,
                                  );
                            },
                            children: const [
                              Icon(Icons.light_mode_rounded, size: 16),
                              Icon(Icons.dark_mode_rounded, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildTile(
                    context,
                    icon: Icons.logout,
                    title: 'Cerrar sesión',
                    route: AppRoutes.login,
                  ),
                ],
              ),
            ),

            // Botón cambio de modo
            SafeArea(
              minimum: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: colors.scrim.withValues(alpha: 0.4),
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const Center(child: SwitchingModeDialog());
                      },
                    );

                    await ref.read(userModeProvider.notifier).toggleMode();

                    await Future.delayed(const Duration(milliseconds: 300));

                    if (!context.mounted) return;

                    Navigator.of(context, rootNavigator: true).pop();
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    await Future.delayed(const Duration(milliseconds: 100));
                    if (context.mounted) {
                      final refreshParam =
                          DateTime.now().millisecondsSinceEpoch;
                      context.go('${AppRoutes.home}?refresh=$refreshParam');
                    }
                  },

                  child: Text(
                    mode == UserMode.employer
                        ? 'Cambiar a modo Colaborador'
                        : 'Cambiar a modo Empleador',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    int? badgeCount,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currentLocation = GoRouterState.of(context).uri.toString();
    final bool isSelected =
        currentLocation == route || currentLocation.startsWith(route);

    return ListTile(
      selected: isSelected,
      selectedTileColor: colors.primary.withValues(alpha: 0.08),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: isSelected ? colors.primary : colors.onSurface),
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: textTheme.labelSmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          color: isSelected ? colors.primary : colors.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        final current = GoRouterState.of(context).uri.toString();
        if (current != route) context.go(route);
      },
    );
  }
}
