import 'package:flutter/material.dart';
import 'package:recomiendalo/features/references/widgets/reference_card_maker.dart';
import 'package:recomiendalo/features/references/screens/reference_list_screen.dart'; 
// 👆 Aquí está la clase Reference original

class ProfileReferencesSection extends StatelessWidget {
  final String profileId;

  const ProfileReferencesSection({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    // 🔹 Mock de referencias (más adelante se filtra por profileId desde backend)
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

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: references.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ref = references[index];
        return ReferenceCardMaker(reference: ref);
      },
    );
  }
}
