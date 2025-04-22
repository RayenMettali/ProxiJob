import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proxi_job/models/cardModel.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new job
  Future<void> addJob(Cardmodel job) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User must be logged in to post a job');

    final jobData = job.toMap();
    jobData['userId'] = user.uid; // Set the current user's ID

    await _firestore.collection('jobs').add(jobData);
  }

  // Get all jobs
  Stream<List<Cardmodel>> getJobs() {
    return _firestore
        .collection('jobs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Cardmodel.fromFirestore(doc)).toList();
    });
  }

  // Get jobs by user ID
  Stream<List<Cardmodel>> getUserJobs(String userId) {
    return _firestore
        .collection('jobs')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Cardmodel.fromFirestore(doc)).toList();
    });
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    await _firestore.collection('jobs').doc(jobId).delete();
  }

  // Update a job
  Future<void> updateJob(String jobId, Map<String, dynamic> updates) async {
    await _firestore.collection('jobs').doc(jobId).update(updates);
  }
}
