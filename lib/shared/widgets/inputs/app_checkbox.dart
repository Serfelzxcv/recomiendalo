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
return Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(12),
    color: Colors.white,
  ),
  child: CheckboxListTile(
    value: value,
    onChanged: onChanged,
    title: Text(label),
    controlAffinity: ListTileControlAffinity.leading,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
  ),
);

  }
}
