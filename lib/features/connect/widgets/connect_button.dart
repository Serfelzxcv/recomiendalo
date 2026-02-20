import 'package:flutter/material.dart';

class ConnectButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ConnectButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: FilledButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
