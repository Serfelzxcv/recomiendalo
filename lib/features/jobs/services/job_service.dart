import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recomiendalo/features/jobs/factory/job_factory.dart';
import 'package:recomiendalo/features/jobs/models/job_model.dart';

class JobService {
  Future<List<JobModel>> fetchJobs() async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) {
        debugPrint('[JobService.fetchJobs] Usuario no autenticado');
        return const [];
      }

      final rows = await client
          .from('jobs')
          .select()
          .eq('person_id', user.id)
          .order('created_at', ascending: false);

      final rawList = (rows as List)
          .map((json) => json as Map<String, dynamic>)
          .toList();

      debugPrint(
        '[JobService.fetchJobs] user=${user.id} rows_backend=${rawList.length}',
      );

      return rawList.map(JobFactory.fromJson).toList();
    } on PostgrestException catch (e, st) {
      debugPrint(
        '[JobService.fetchJobs][PostgrestException] message=${e.message} code=${e.code} details=${e.details} hint=${e.hint}',
      );
      debugPrintStack(stackTrace: st);
      rethrow;
    } catch (e, st) {
      debugPrint('[JobService.fetchJobs][Exception] $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<void> deleteJob({
    required String jobId,
    required String personId,
  }) async {
    try {
      await Supabase.instance.client
          .from('jobs')
          .delete()
          .eq('id', jobId)
          .eq('person_id', personId);
    } on PostgrestException catch (e, st) {
      debugPrint(
        '[JobService.deleteJob][PostgrestException] message=${e.message} code=${e.code} details=${e.details} hint=${e.hint}',
      );
      debugPrintStack(stackTrace: st);
      rethrow;
    } catch (e, st) {
      debugPrint('[JobService.deleteJob][Exception] $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }
}
