import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:proxi_job/models/user.dart';
import 'package:proxi_job/utils/user_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Scaffold(
      backgroundColor: Colors.white,
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
          'Profile',
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
              Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/profile_picture.png"),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Icon(LineAwesomeIcons.edit, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildInfoCard('Email', user.email),
              buildInfoCard('Phone Number', user.phoneNumber),
              buildInfoCard('Work Field', user.workField),
              buildInfoCard('About', user.about),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity, // Ensures full width
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16), // Adds padding inside the box
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1.5), // Blue border
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 15), // Space between sections
      ],
    );
  }
}