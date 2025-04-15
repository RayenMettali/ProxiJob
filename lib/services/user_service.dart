import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proxi_job/models/UserModel.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  final CollectionReference _usersCollection = 
      FirebaseFirestore.instance.collection('users');

  // Get current user
  User? getCurrentFirebaseUser() {
    return _auth.currentUser;
  }

  // Get current user model
  Future<UserModel?> getCurrentUser() async {
    User? firebaseUser = getCurrentFirebaseUser();
    if (firebaseUser != null) {
      // Check if user exists in Firestore
      DocumentSnapshot userDoc = await _usersCollection.doc(firebaseUser.uid).get();
      
      if (userDoc.exists) {
        // User exists in Firestore, return data from there
        return UserModel.fromMap(
          userDoc.data() as Map<String, dynamic>, 
          firebaseUser.uid
        );
      } else {
        // User not in Firestore yet, create from Firebase Auth data
        UserModel newUser = UserModel.fromFirebaseUser(firebaseUser);
        // Save to Firestore
        await createOrUpdateUser(newUser);
        return newUser;
      }
    }
    return null;
  }

  // Create or update user in Firestore
  Future<void> createOrUpdateUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  // Update user name
  Future<void> updateUserName(String userId, String name) async {
    await _usersCollection.doc(userId).update({
      'name': name,
    });
  }

  // Update user additional info
  Future<void> updateUserAdditionalInfo(String userId, Map<String, dynamic> additionalInfo) async {
    await _usersCollection.doc(userId).update({
      'additionalInfo': additionalInfo,
    });
  }

  // Stream of current user data (real-time updates)
  Stream<UserModel?> userStream() {
    User? firebaseUser = getCurrentFirebaseUser();
    if (firebaseUser != null) {
      return _usersCollection.doc(firebaseUser.uid).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return UserModel.fromMap(
            snapshot.data() as Map<String, dynamic>, 
            firebaseUser.uid
          );
        }
        return null;
      });
    }
    return Stream.value(null);
  }

  Future<void> updateUserPhoneNumber(String uid, String phoneNumber) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'phoneNumber': phoneNumber,
    });
  } catch (e) {
    print('Error updating phone number: $e');
    throw e;
  }
}

}