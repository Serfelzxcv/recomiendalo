import 'package:flutter/material.dart';
import 'package:recomiendalo/features/jobs/models/job_model.dart';

class JobCardMaker extends StatelessWidget {
  final JobModel job;
  final int messageCount;

  const JobCardMaker({
    super.key,
    required this.job,
    this.messageCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 👇 Mostrar presupuesto o "A convenir"
    String budgetText;
    if (job.budget != null && job.budget! > 0) {
      budgetText = "S/ ${job.budget!.toStringAsFixed(1)}";
    } else {
      budgetText = "A convenir";
    }

    // 👇 Mostrar ubicación o remoto
    final locationText = job.isRemote ? "Remoto" : job.location;

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
        padding: const EdgeInsets.all(12), // 👈 menos padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Título y badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (messageCount > 0)
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: Colors.red,
                    child: Text(
                      messageCount.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4), // 👈 menos espacio

            /// --- Descripción
            Text(
              job.description,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8), // 👈 menos espacio

            /// --- Presupuesto y ubicación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budgetText,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  locationText,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
