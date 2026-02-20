import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const AppCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(12),
        color: colors.surface,
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(label),
        activeColor: colors.primary,
        checkColor: colors.onPrimary,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
