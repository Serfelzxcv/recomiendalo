import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum UserMode { employer, colaborator }

class AppDrawer extends StatelessWidget {
  final UserMode mode;
  final VoidCallback onToggleMode;

  const AppDrawer({
    super.key,
    required this.mode,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

  return Drawer(
    child: SafeArea(
      child: Column(
        children: [
          // Contenido scrollable
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colors.primary, colors.primary.withOpacity(0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Usuario Demo",
                                style: textTheme.titleMedium?.copyWith(
                                  color: colors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text("demo@correo.com",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.onPrimary.withOpacity(0.9),
                                )),
                            const SizedBox(height: 6),
                            Chip(
                              label: Text(
                                mode == UserMode.employer
                                    ? "Modo Empleador"
                                    : "Modo Colaborador",
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: colors.secondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Opciones dinámicas
                if (mode == UserMode.employer) ...[
                  _buildTile(
                    context,
                    icon: Icons.add_box_outlined,
                    title: 'Publicar trabajo',
                    route: '/jobs/create',
                  ),
                  _buildTile(
                    context,
                    icon: Icons.work_outline,
                    title: 'Trabajos publicados',
                    route: '/home',
                    badgeCount: 2,
                  ),
                  _buildTile(
                    context,
                    icon: Icons.reviews_outlined,
                    title: 'Reseñas como empleador',
                    route: '/reviews/employer',
                  ),
                ] else ...[
                  _buildTile(
                    context,
                    icon: Icons.build_outlined,
                    title: 'Mis servicios',
                    route: '/profile',
                  ),
                  _buildTile(
                    context,
                    icon: Icons.local_offer_outlined,
                    title: 'Mis ofertas',
                    route: '/home',
                    badgeCount: 1,
                  ),
                  _buildTile(
                    context,
                    icon: Icons.work_history_outlined,
                    title: 'Trabajos en curso',
                    route: '/home',
                  ),
                  _buildTile(
                    context,
                    icon: Icons.reviews_outlined,
                    title: 'Reseñas como Colaborador',
                    route: '/reviews/colaborator',
                  ),
                ],

                const Divider(),

                // Comunes
                _buildTile(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: 'Chat',
                  route: '/chat',
                  badgeCount: 3,
                ),
                _buildTile(
                  context,
                  icon: Icons.notifications_none,
                  title: "Notificaciones",
                  route: '/notifications',
                  badgeCount: 5,
                ),
                _buildTile(
                  context,
                  icon: Icons.person_outline,
                  title: "Perfil",
                  route: '/profile',
                ),
                _buildTile(
                  context,
                  icon: Icons.settings_outlined,
                  title: "Configuración",
                  route: '/settings',
                ),
                _buildTile(
                  context,
                  icon: Icons.logout,
                  title: "Cerrar sesión",
                  route: '/login',
                ),
              ],
            ),
          ),

          // Botón fijo abajo
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
                onPressed: onToggleMode,
                child: Text(
                  mode == UserMode.employer
                      ? "Cambiar a modo Colaborador"
                      : "Cambiar a modo Empleador",
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

  /// Construye un ListTile con badge opcional
  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    int? badgeCount,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: colors.primary),
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
      title: Text(title),
      onTap: () => context.go(route),
    );
  }
}
