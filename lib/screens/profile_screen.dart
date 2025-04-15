import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proxi_job/models/UserModel.dart';
import 'package:proxi_job/screens/edit_profile_screen.dart';
import 'package:proxi_job/screens/welcome_screen.dart';
import 'package:proxi_job/services/user_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserService _userService = UserService();
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserModel? user = await _userService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(
          child: Text('No user logged in. Please sign in.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            color: Colors.red,
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Navigate to login page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (e) => const WelcomeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: _userService.userStream(),
        initialData: _currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          UserModel? user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? Text(
                            user.name?.substring(0, 1).toUpperCase() ??
                                user.email.substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontSize: 36),
                          )
                        : null,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Edit profile button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(user: user),
                        ),
                      ).then((_) => _loadUser()); // Refresh after editing
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // All user information in a single card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name section
                          Row(
                            children: [
                              const Icon(Icons.person, size: 28, color: Colors.blue),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  user.name ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const Divider(height: 32),
                          
                          // Contact information section
                          const Text(
                            'Contact Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Email
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.grey),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  user.email,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Phone number
                          if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.grey),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    user.phoneNumber!,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          
                          if (user.name == null) ...[
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _showNameInputDialog(context);
                              },
                              child: const Text('Add Your Name'),
                            ),
                          ],
                          
                          // Additional information section
                          if (user.additionalInfo != null &&
                              user.additionalInfo!.isNotEmpty) ...[
                            const Divider(height: 32),
                            const Text(
                              'Additional Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...user.additionalInfo!.entries.map((entry) {
                              // Skip phone number as it's displayed separately
                              if (entry.key == 'phoneNumber') return const SizedBox.shrink();
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.info_outline, color: Colors.grey),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.key,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            entry.value.toString(),
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Dialog to add name if not already set
  void _showNameInputDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Your Name'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Enter your name'),
            textCapitalization: TextCapitalization.words,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (_nameController.text.trim().isNotEmpty &&
                    _currentUser != null) {
                  try {
                    await _userService.updateUserName(
                        _currentUser!.uid, _nameController.text.trim());
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error updating name: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Failed to update name. Please try again.')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}