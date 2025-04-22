import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proxi_job/models/job_application.dart';

class JobApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Apply for a job
  Future<void> applyForJob(String jobId, String jobTitle) async {
    final user = _auth.currentUser;
    if (user == null)
      throw Exception('User must be logged in to apply for jobs');

    // Check if user has already applied
    final existing = await _firestore
        .collection('job_applications')
        .where('jobId', isEqualTo: jobId)
        .where('userId', isEqualTo: user.uid)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('You have already applied for this job');
    }

    final application = JobApplication(
      id: '', // Will be set by Firestore
      jobId: jobId,
      userId: user.uid,
      jobTitle: jobTitle,
      appliedAt: DateTime.now(),
    );

    await _firestore.collection('job_applications').add(application.toMap());
  }

  // Get user's job applications
  Stream<List<JobApplication>> getUserApplications() {
    final user = _auth.currentUser;
    if (user == null)
      throw Exception('User must be logged in to view applications');

    return _firestore
        .collection('job_applications')
        .where('userId', isEqualTo: user.uid)
        .orderBy('appliedAt',
            descending: true) // Simplified query to only sort by appliedAt
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => JobApplication.fromFirestore(doc))
          .toList();
    });
  }

  // Cancel job application
  Future<void> cancelApplication(String applicationId) async {
    final user = _auth.currentUser;
    if (user == null)
      throw Exception('User must be logged in to cancel applications');

    await _firestore.collection('job_applications').doc(applicationId).delete();
  }
}
