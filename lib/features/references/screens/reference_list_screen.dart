import 'package:flutter/material.dart';
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
        name: "Juan Pérez",
        stars: 5,
        comment: "Puntualidad de pago, muy responsable.",
      ),
      Reference(
        name: "María López",
        stars: 4,
        comment: "Buena recepción y comunicación fluida.",
      ),
      Reference(
        name: "Carlos Ramírez",
        stars: 5,
        comment: "Siempre dispuesto a ayudar al trabajador.",
      ),
      Reference(
        name: "Ana Torres",
        stars: 5,
        comment: "Excelente experiencia, trato respetuoso.",
      ),
    ];

    return AppScaffold(
      drawer: AppDrawer(
        mode: UserMode.employer, // 👈 puedes cambiarlo dinámico después
        onToggleMode: () => Navigator.of(context).pop(),
      ),
      appBar: AppBar(
        title: const Text("Referencias"),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: references.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final ref = references[index];
          return _ReferenceCard(reference: ref);
        },
      ),
    );
  }
}

class _ReferenceCard extends StatelessWidget {
  final Reference reference;

  const _ReferenceCard({required this.reference});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Avatar + Nombre + Estrellas
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: reference.avatarUrl != null
                      ? NetworkImage(reference.avatarUrl!)
                      : null,
                  backgroundColor: colors.primary.withOpacity(0.2),
                  child: reference.avatarUrl == null
                      ? Text(
                          reference.name.isNotEmpty
                              ? reference.name[0].toUpperCase()
                              : "?",
                          style: t.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reference.name,
                          style: t.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < reference.stars
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🔹 Comentario
            Text(
              reference.comment,
              style: t.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
