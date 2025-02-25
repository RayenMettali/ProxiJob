import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proxi_job/screens/welcome_screen.dart';
import 'package:proxi_job/screens/edit_profile_page.dart'; // Ensure this file exists
import 'firebase_options.dart'; // Ensure this file exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Proxi Job';
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proxi Job',
      home: const WelcomeScreen(), // Ensure this file exists
    );
  }
}
