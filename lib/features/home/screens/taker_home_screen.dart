import 'package:flutter/material.dart';
import 'package:recomiendalo/shared/widgets/app_card.dart';

class TakerHomeScreen extends StatelessWidget {
  const TakerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      children: const [
        AppCard(title: 'Mis servicios', icon: Icons.build_outlined),
        AppCard(title: 'Mis propuestas', icon: Icons.local_offer_outlined),
      ],
    );
  }
}
