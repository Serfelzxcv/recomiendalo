import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recomiendalo/shared/providers/user_mode_provider.dart';
import 'package:recomiendalo/core/router/app_routes.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final modeState = ref.watch(userModeProvider);

    final mode = modeState.value ?? UserMode.employer;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // ðŸ”¹ Header
            Container(
              padding: const EdgeInsets.all(16),
              color: colors.surface,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.primary.withOpacity(0.15),
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
                        Text('Usuario Demo',
                            style: textTheme.titleMedium?.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('demo@correo.com',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            )),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      route: AppRoutes.home,
                      badgeCount: 1,
                    ),
                    _buildTile(
                      context,
                      icon: Icons.work_history_outlined,
                      title: 'Trabajos en curso',
                      route: AppRoutes.home,
                    ),
                  ],

                  const Divider(),

                  // ðŸ”¹ Chat deshabilitado (PrÃ³ximamente)
                  ListTile(
                    leading: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                    title: Text(
                      'Chat (Próximamente)',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    enabled: false,
                  ),

                  // ðŸ”¹ Configuración (Próximamente)
                  ListTile(
                    leading: const Icon(Icons.settings_outlined, color: Colors.grey),
                    title: Text(
                      'Configuración (Próximamente)',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    enabled: false,
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
                    await ref.read(userModeProvider.notifier).toggleMode();
                    Navigator.pop(context); // ðŸ‘ˆ cerrar drawer al cambiar modo
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
      selectedTileColor: colors.primary.withOpacity(0.08),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            color: isSelected ? colors.primary : colors.onSurface,
          ),
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











