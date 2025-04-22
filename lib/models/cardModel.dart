import 'package:cloud_firestore/cloud_firestore.dart';

class Cardmodel {
  final String id;
  final String title;
  final String description;
  final String jobDescription;
  final String image;
  final DateTime timestamp;
  final String userId;

  Cardmodel({
    required this.id,
    required this.title,
    required this.description,
    required this.jobDescription,
    required this.image,
    required this.timestamp,
    required this.userId,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'jobDescription': jobDescription,
      'image': image,
      'timestamp': timestamp,
      'userId': userId,
    };
  }

  // Create from Firestore document
  factory Cardmodel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cardmodel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      jobDescription: data['jobDescription'] ?? '',
      image: data['image'] ?? 'assets/images/civil-engineering.png',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  // Static method to get dummy cards (for testing)
  static List<Cardmodel> getCards() {
    return [
      Cardmodel(
        id: '1',
        title: 'Software Engineer',
        description: 'Full-time position',
        jobDescription: 'Looking for an experienced software engineer...',
        image: 'assets/images/software-development.png',
        timestamp: DateTime.now(),
        userId: '',
      ),
      // Add more dummy cards as needed
    ];
  }
}
