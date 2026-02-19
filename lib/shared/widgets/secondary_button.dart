import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fullWidth = true,
    this.loading = false,
    this.icon,
    this.style, // opcional: overrides puntuales
  });

  final String text;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final bool loading;
  final IconData? icon;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : (icon == null)
            ? Text(text, maxLines: 1, overflow: TextOverflow.ellipsis)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: style, // si es null, usa 100% el theme
        child: child,
      ),
    );
  }
}
