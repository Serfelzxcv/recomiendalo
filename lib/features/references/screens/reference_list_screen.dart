import 'package:flutter/material.dart';
import 'package:recomiendalo/features/references/widgets/reference_card_maker.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';

class Reference {
  final String name;
  final String? avatarUrl;
  final int stars;
  final String comment;

  Reference({
    required this.name,
    this.avatarUrl,
    required this.stars,
    required this.comment,
  });
}

class ReferenceListScreen extends StatelessWidget {
  const ReferenceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final references = [
      Reference(
        name: 'Juan Pérez',
        stars: 5,
        comment: 'Puntualidad de pago, muy responsable.',
      ),
      Reference(
        name: 'María López',
        stars: 4,
        comment: 'Buena recepción y comunicación fluida.',
      ),
      Reference(
        name: 'Carlos Ramírez',
        stars: 5,
        comment: 'Siempre dispuesto a ayudar al trabajador.',
      ),
      Reference(
        name: 'Ana Torres',
        stars: 5,
        comment: 'Excelente experiencia, trato respetuoso.',
      ),
    ];

    return AppScaffold(
      drawer: const AppDrawer(), // 👈 ya no recibe mode ni onToggleMode
      appBar: AppBar(
        title: const Text('Tus Referencias'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: references.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final ref = references[index];
          return ReferenceCardMaker(reference: ref);
        },
      ),
    );
  }
}
