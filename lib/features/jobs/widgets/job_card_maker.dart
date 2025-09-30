import 'package:flutter/material.dart';
import 'package:recomiendalo/features/jobs/models/job_model.dart';
import 'package:recomiendalo/features/jobs/widgets/job_detail_dialog.dart';

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
    final t = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => JobDetailDialog(
              job: job,
              messageCount: messageCount,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Título + Badge mensajes
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (messageCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$messageCount",
                        style: t.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                job.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    job.budget != null ? "S/ ${job.budget}" : "A convenir",
                    style: t.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                  Text(
                    job.location ?? "Sin ubicación",
                    style: t.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
