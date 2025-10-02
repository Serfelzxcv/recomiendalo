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
            // 🔹 Encabezado de usuario
            Container(
              padding: const EdgeInsets.all(16),
              color: colors.surface,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.primary.withOpacity(0.15),
                    child: const Icon(Icons.person, size: 32, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Usuario Demo",
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        Text("demo@correo.com",
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            )),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: colors.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            mode == UserMode.employer
                                ? "Modo Empleador"
                                : "Modo Colaborador",
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

            // 🔹 Opciones dinámicas
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
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
                      route: '/jobs/list',
                      badgeCount: 2,
                    ),
                    _buildTile(
                      context,
                      icon: Icons.reviews_outlined,
                      title: 'Reseñas como empleador',
                      route: '/reviews/employer',
                    ),
                    _buildTile(
                      context,
                      icon: Icons.handshake_outlined,
                      title: 'Conectar con trabajadores',
                      route: '/connect',
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
                  ],

                  const Divider(),

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

            // 🔹 Botón de cambio de modo
            SafeArea(
              minimum: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
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
          Icon(icon, color: Colors.black87),
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
      title: Text(title,
          style: textTheme.bodyMedium?.copyWith(color: Colors.black87)),
      onTap: () => context.go(route),
    );
  }
}
