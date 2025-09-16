import 'package:flutter/material.dart';

/// Wrapper que asegura que todas las pantallas
/// estén dentro de un Scaffold + SafeArea.
/// 
/// Así evitamos repetir código en cada pantalla.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.drawer,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.background,
      body: SafeArea(child: body),
    );
  }
}
