// lib/features/jobs/services/job_service.dart
import 'package:recomiendalo/features/hard_code/jobs_hardcode.dart';
import 'package:recomiendalo/features/jobs/models/job_factory.dart';
import 'package:recomiendalo/features/jobs/models/job_model.dart';

class JobService {
  Future<List<JobModel>> fetchJobs() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simula delay
    return jobsHardcode.map((json) => JobFactory.fromJson(json)).toList();
  }
}
