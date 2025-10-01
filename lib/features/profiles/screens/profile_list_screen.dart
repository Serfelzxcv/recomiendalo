import 'package:flutter/material.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';

class ProfileListScreen extends StatelessWidget {
  const ProfileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: AppDrawer(
        mode: UserMode.colaborator, // 👈 puedes hacerlo dinámico luego
        onToggleMode: () => Navigator.of(context).pop(),
      ),
      appBar: AppBar(title: const Text("Mis Perfiles")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text("Aquí se mostrarán los perfiles del usuario"),
        ],
      ),
    );
  }
}
