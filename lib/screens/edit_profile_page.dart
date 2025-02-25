/*import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:proxi_job/models/user.dart';
import 'package:proxi_job/utils/user_preferences.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = UserPreferences.myUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineAwesomeIcons.arrow_left_solid, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                imagePath:User.imagePath,
                onClicked: () async {},
             
              ),
              const SizedBox(height: 10),
              Text(
                user.name,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 10),
              // Add more widgets here for editing profile details
            ],
          ),
        ),
      ),
    );
  }
}
*/