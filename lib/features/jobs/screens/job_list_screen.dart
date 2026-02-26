import 'package:flutter/material.dart';
import 'dart:async';
import 'package:recomiendalo/features/jobs/services/job_service.dart';
import 'package:recomiendalo/features/jobs/models/job_model.dart';
import 'package:recomiendalo/shared/widgets/app_scaffold.dart';
import 'package:recomiendalo/shared/widgets/app_drawer.dart';
import 'package:recomiendalo/features/jobs/widgets/job_card_maker.dart';
import 'package:recomiendalo/features/jobs/screens/job_create_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final _service = JobService();
  late Future<List<JobModel>> _jobsFuture;
  StreamSubscription<AuthState>? _authSubscription;
  String? _lastUserId;
  bool _isDeleting = false;

  void _refreshJobs() {
    setState(() => _jobsFuture = _service.fetchJobs());
  }

  Future<void> _editJob(JobModel job) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JobCreateScreen(jobToEdit: job),
      ),
    );
    if (!mounted) return;
    _refreshJobs();
  }

  Future<void> _deleteJob(JobModel job) async {
    if (_isDeleting) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar trabajo'),
          content: Text('¿Seguro que deseas eliminar "${job.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isDeleting = true);
    try {
      await _service.deleteJob(jobId: job.id, personId: user.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trabajo eliminado correctamente')),
      );
      _refreshJobs();
    } on PostgrestException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar el trabajo')),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _lastUserId = Supabase.instance.client.auth.currentUser?.id;
    _jobsFuture = _service.fetchJobs();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      _,
    ) {
      if (!mounted) return;
      final currentUserId = Supabase.instance.client.auth.currentUser?.id;
      if (currentUserId == _lastUserId) return;
      _lastUserId = currentUserId;
      _refreshJobs();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: const AppDrawer(), // 👈 ahora es global con Riverpod
      appBar: AppBar(
        title: const Text('Mis trabajos publicados'),
      ),
      body: FutureBuilder<List<JobModel>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('No se pudieron cargar los trabajos publicados.'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay trabajos publicados aún.'));
          }

          final jobs = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final job = jobs[i];
              return JobCardMaker(
                job: job,
                messageCount: i == 0 ? 6 : 0, // 👈 solo ejemplo: primer job con mensajes
                onEdit: () => _editJob(job),
                onDelete: _isDeleting ? null : () => _deleteJob(job),
              );
            },
          );
        },
      ),
    );
  }
}
