// lib/features/jobs/models/job_model.dart
class JobModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final double? budget;
  final String? paymentMethod;
  final bool isRemote;

  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.budget,
    this.paymentMethod,
    this.isRemote = false,
  });
}
