class User {
  final String imagePath;
  final String name;
  final String email;
  final String phoneNumber; // Corrected the data type from 'string' to 'String'
  final String workField;
  final String about;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.workField,
    required this.about,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      workField: json['workField'],
      about: json['about'],
      imagePath: json['imagePath'],
    );
  }
}