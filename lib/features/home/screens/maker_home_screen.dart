import 'package:flutter/material.dart';
import 'package:recomiendalo/shared/widgets/app_card.dart';

class MakerHomeScreen extends StatelessWidget {
  const MakerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      children: const [
        AppCard(title: 'Publicar trabajo', icon: Icons.add_box_outlined),
        AppCard(title: 'Trabajos publicados', icon: Icons.work_outline),
      ],
    );
  }
}
