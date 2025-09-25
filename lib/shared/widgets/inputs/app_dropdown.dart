import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;
  final String? hint;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: t.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            value: value,
            hint: Text(
              hint ?? 'Selecciona una opción',
              style: t.bodyMedium?.copyWith(color: Colors.grey.shade500),
            ),
            items: items,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black, // 👈 igual al borde del TextField
                  width: 1,                  // 👈 grosor consistente
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 280,
              width: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black, // 👈 mismo borde también en menú
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 44,
              padding: EdgeInsets.symmetric(horizontal: 14),
            ),
          ),
        ),
      ],
    );
  }
}
