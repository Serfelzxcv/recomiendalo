import 'package:flutter/material.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';
import 'package:recomiendalo/features/home/screens/maker_home_screen.dart';
import 'package:recomiendalo/features/home/screens/taker_home_screen.dart';
import 'package:recomiendalo/shared/widgets/loading_overlay.dart';

/// Pantalla principal con Drawer y contenido dinámico
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserMode _mode = UserMode.maker; // valor inicial
  bool _isLoading = false;

  void _toggleMode() async {
    setState(() => _isLoading = true);

    // Pequeña simulación de carga con overlay
    await Future.delayed(const Duration(milliseconds: 450));

    setState(() {
      _mode = _mode == UserMode.maker ? UserMode.taker : UserMode.maker;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(_mode == UserMode.maker ? "Maker" : "Taker"),
          ),
          drawer: AppDrawer(
            mode: _mode,
            onToggleMode: _toggleMode,
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _mode == UserMode.maker
                ? const MakerHomeScreen(key: ValueKey("maker"))
                : const TakerHomeScreen(key: ValueKey("taker")),
          ),
        ),

        // Overlay de carga
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }
}
