import 'package:flutter/material.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/loading_overlay.dart';
import 'package:recomiendalo/features/home/screens/maker_home_screen.dart';
import 'package:recomiendalo/features/home/screens/taker_home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserMode _mode = UserMode.employer;
  bool _isLoading = false;

  void _toggleMode() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 450));
    setState(() {
      _mode = _mode == UserMode.employer
          ? UserMode.colaborator
          : UserMode.employer;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppScaffold(
          appBar: AppBar(
            title: Text(
              _mode == UserMode.employer
                  ? "Modo Empleador"
                  : "Modo Colaborador",
            ),
          ),
          drawer: AppDrawer(
            mode: _mode,
            onToggleMode: _toggleMode,
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _mode == UserMode.employer
                ? const MakerHomeScreen(key: ValueKey("employer"))
                : const TakerHomeScreen(key: ValueKey("colaborator")),
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }
}
