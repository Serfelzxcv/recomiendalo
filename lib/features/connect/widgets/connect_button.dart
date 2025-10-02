import 'package:flutter/material.dart';

class ConnectButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ConnectButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity, // ✅ asegura que ocupe todo el ancho disponible
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
