import 'package:flutter/material.dart';
import 'package:recomiendalo/features/jobs/services/job_service.dart';
import 'package:recomiendalo/features/jobs/models/job_model.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';
import 'package:recomiendalo/features/jobs/widgets/job_card_maker.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final _service = JobService();
  late Future<List<JobModel>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = _service.fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: AppDrawer(
        mode: UserMode.employer,
        onToggleMode: () => Navigator.of(context).pop(),
      ),
      appBar: AppBar(
        title: const Text("Trabajos publicados"),
      ),
      body: FutureBuilder<List<JobModel>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay trabajos publicados aún."));
          }

          final jobs = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final job = jobs[i];
              return JobCardMaker(
                job: job,
                messageCount: i == 0 ? 6 : 0, // 👈 el primero con mensajes
              );
            },
          );
        },
      ),
    );
  }
}
