import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?) onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        width: MediaQuery.of(context).size.width * 0.7, // 👈 más estrecho
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
