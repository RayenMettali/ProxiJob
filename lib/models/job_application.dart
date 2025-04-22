import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplication {
  final String id;
  final String jobId;
  final String userId;
  final String jobTitle;
  final DateTime appliedAt;
  final String status; // 'pending', 'accepted', 'rejected'

  JobApplication({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.jobTitle,
    required this.appliedAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'userId': userId,
      'jobTitle': jobTitle,
      'appliedAt': appliedAt,
      'status': status,
    };
  }

  factory JobApplication.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return JobApplication(
      id: doc.id,
      jobId: data['jobId'] ?? '',
      userId: data['userId'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      appliedAt: (data['appliedAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
    );
  }
}
