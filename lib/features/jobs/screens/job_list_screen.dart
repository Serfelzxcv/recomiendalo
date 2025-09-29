// lib/features/jobs/screens/job_list_screen.dart
import 'package:flutter/material.dart';
import 'package:recomiendalo/features/jobs/services/job_service.dart';
import 'package:recomiendalo/features/jobs/models/job_model.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';

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
        mode: UserMode.employer, // 👈 aquí fijo, luego se puede volver dinámico
        onToggleMode: () {
          Navigator.of(context).pop(); // cierra el drawer
          // opcional: redirigir según el modo
        },
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
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(job.title),
                  subtitle: Text(job.description),
                  trailing: job.budget != null
                      ? Text("S/ ${job.budget}")
                      : const Text("A convenir"),
                  onTap: () {
                    // luego podemos llevar a un detalle
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
