import 'package:flutter/material.dart';
import 'package:recomiendalo/features/jobs/models/job_model.dart';

class JobDetailDialog extends StatelessWidget {
  final JobModel job;
  final int messageCount;

  const JobDetailDialog({
    super.key,
    required this.job,
    this.messageCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Header tipo AppBar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    "Detalle de trabajo",
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Título del trabajo
                Text(
                  job.title,
                  style: t.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // 🔹 Descripción
                Container(
                  constraints: const BoxConstraints(maxHeight: 140),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: colors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            job.description,
                            style: t.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 Botones de acción
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _outlinedAction("Ver", Icons.remove_red_eye, () {}),
                    _outlinedAction("Impulsar", Icons.trending_up, () {}),
                    _messageButton(t, colors),
                    _outlinedAction("Compartir", Icons.share, () {}),
                    _outlinedAction("Editar", Icons.edit, () {}),
                    _dangerAction("Eliminar", Icons.delete, () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Botón estilo outlined
  Widget _outlinedAction(String label, IconData icon, VoidCallback onTap) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  /// 🔹 Botón estilo peligro (fill rojo sólido)
  Widget _dangerAction(String label, IconData icon, VoidCallback onTap) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  /// 🔹 Botón de mensajes con badge
  Widget _messageButton(TextTheme t, ColorScheme colors) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _outlinedAction("Mensajes", Icons.message, () {}),
        if (messageCount > 0)
          Positioned(
            right: -6,
            top: -6,
            child: CircleAvatar(
              radius: 11,
              backgroundColor: colors.error,
              child: Text(
                "$messageCount",
                style: t.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
