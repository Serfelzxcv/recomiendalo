import 'package:flutter/material.dart';

/// Overlay simple para simular una carga al cambiar de modo.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.scrim.withValues(alpha: 0.45),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
