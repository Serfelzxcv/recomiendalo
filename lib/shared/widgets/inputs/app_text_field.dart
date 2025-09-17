import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300), // 👈 borde visible
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );


  }
}
