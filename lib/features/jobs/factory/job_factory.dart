import 'package:recomiendalo/features/jobs/models/job_model.dart';

class JobFactory {
  static JobModel fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: (json['id'] ?? '').toString(),
      personId: (json['personId'] ?? json['person_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      budget: (json['budget'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod']?.toString() ?? json['payment_method']?.toString(),
      isRemote: (json['isRemote'] ?? json['is_remote'] ?? false) as bool,
      tags: ((json['tags'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      images: ((json['images'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      createdAt: DateTime.parse(
        (json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String())
            .toString(),
      ),
      updatedAt: DateTime.parse(
        (json['updatedAt'] ?? json['updated_at'] ?? DateTime.now().toIso8601String())
            .toString(),
      ),
    );
  }

  static Map<String, dynamic> toJson(JobModel job) {
    return {
      'id': job.id,
      'person_id': job.personId,
      'title': job.title,
      'description': job.description,
      'category': job.category,
      'location': job.location,
      'budget': job.budget,
      'payment_method': job.paymentMethod,
      'is_remote': job.isRemote,
      'tags': job.tags,
      'images': job.images,
      'created_at': job.createdAt.toIso8601String(),
      'updated_at': job.updatedAt.toIso8601String(),
    };
  }
}
