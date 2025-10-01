
import 'package:flutter/material.dart';
import 'package:recomiendalo/features/references/screens/reference_list_screen.dart';

class ReferenceCardMaker extends StatelessWidget {
  final Reference reference;

  const ReferenceCardMaker({super.key, required this.reference});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade300
              : Colors.grey.shade700,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10), // 👈 menos padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Avatar + Nombre + Estrellas
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18, // 👈 más pequeño
                  backgroundImage: reference.avatarUrl != null
                      ? NetworkImage(reference.avatarUrl!)
                      : null,
                  backgroundColor: colors.primary.withOpacity(0.2),
                  child: reference.avatarUrl == null
                      ? Text(
                          reference.name.isNotEmpty
                              ? reference.name[0].toUpperCase()
                              : "?",
                          style: t.bodySmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reference.name,
                          style: t.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < reference.stars
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16, // 👈 más compacto
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6), // 👈 menos espacio

            // 🔹 Comentario
            Text(
              reference.comment,
              style: t.bodySmall?.copyWith(
                color: colors.onSurface.withOpacity(0.75),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
