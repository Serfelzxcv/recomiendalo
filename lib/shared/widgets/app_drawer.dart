import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Enum para definir los modos de usuario
enum UserMode { maker, taker }

/// Drawer principal de la aplicación.
/// Cambia opciones según el modo actual.
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header con gradiente
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary, colors.primary.withOpacity(0.8)],
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
                          mode == UserMode.maker ? "Maker" : "Taker",
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
          if (mode == UserMode.maker) ...[
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text("Publicar trabajo"),
              onTap: () => context.go('/jobs/create'),
            ),
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text("Trabajos publicados"),
              onTap: () => _showWip(context),
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.build_outlined),
              title: const Text("Mis servicios"),
              onTap: () => context.go('/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.local_offer_outlined),
              title: const Text("Mis ofertas"),
              onTap: () => _showWip(context),
            ),
          ],

          const Divider(),

          // Opciones comunes
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text("Chat"),
            onTap: () => _showWip(context),
          ),
          ListTile(
            leading: const Icon(Icons.reviews_outlined),
            title: const Text("Reseñas"),
            onTap: () => _showWip(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Cerrar sesión"),
            onTap: () => context.go('/login'),
          ),

          const Spacer(),

          // Cambio de modo
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(
              mode == UserMode.maker
                  ? "Cambiar a modo Taker"
                  : "Cambiar a modo Maker",
            ),
            onTap: onToggleMode,
          ),
        ],
      ),
    );
  }

  void _showWip(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("En construcción (demo)")),
    );
  }
}
