

import 'package:recomiendalo/features/jobs/models/job_model.dart';

class JobFactory {
  static JobModel fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      location: json['location'],
      budget: (json['budget'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'],
      isRemote: json['isRemote'] ?? false,
    );
  }

  static Map<String, dynamic> toJson(JobModel job) {
    return {
      'id': job.id,
      'title': job.title,
      'description': job.description,
      'category': job.category,
      'location': job.location,
      'budget': job.budget,
      'paymentMethod': job.paymentMethod,
      'isRemote': job.isRemote,
    };
  }
}
