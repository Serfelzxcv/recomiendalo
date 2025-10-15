import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomiendalo/shared/models/user_mode.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/loading_overlay.dart';
import 'package:recomiendalo/features/home/screens/maker_home_screen.dart';
import 'package:recomiendalo/features/home/screens/taker_home_screen.dart';
import 'package:recomiendalo/shared/providers/user_mode_provider.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeState = ref.watch(userModeProvider);

    return Stack(
      children: [
        AppScaffold(
          appBar: AppBar(
            title: Text(
              modeState.value == UserMode.employer
                  ? "Modo Empleador"
                  : "Modo Colaborador",
            ),
          ),
          drawer: const AppDrawer(),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: modeState.value == UserMode.employer
                ? const MakerHomeScreen(key: ValueKey("employer"))
                : const TakerHomeScreen(key: ValueKey("colaborator")),
          ),
        ),
        if (modeState.isLoading) const LoadingOverlay(),
      ],
    );
  }
}
