class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? phoneNumber;
  final Map<String, dynamic>? additionalInfo;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.photoUrl,
    this.phoneNumber,
    this.additionalInfo,
  });

  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      // We'll initialize name as null when creating from Firebase User
      photoUrl: firebaseUser.photoURL,
      phoneNumber: firebaseUser.phoneNumber,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      name: map['name'],
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
      additionalInfo: map['additionalInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'additionalInfo': additionalInfo,
    };
  }
}
