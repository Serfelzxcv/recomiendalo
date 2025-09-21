import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final int maxLines;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: t.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true, // 🔹 altura intermedia
            filled: true,  // 🔹 activa fondo
            fillColor: Colors.white, // 🔹 fondo blanco
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
