import 'package:flutter/material.dart';
import 'package:proxi_job/models/UserModel.dart';
import 'package:proxi_job/services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);
  
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  
  // For additional info fields
  final Map<String, TextEditingController> _additionalInfoControllers = {};
  final TextEditingController _newKeyController = TextEditingController();
  final TextEditingController _newValueController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    
    // Initialize controllers for existing additional info
    if (widget.user.additionalInfo != null) {
      widget.user.additionalInfo!.forEach((key, value) {
        // Skip phone number as it's handled separately
        if (key != 'phoneNumber') {
          _additionalInfoControllers[key] = TextEditingController(text: value.toString());
        }
      });
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _newKeyController.dispose();
    _newValueController.dispose();
    
    // Dispose all additional info controllers
    _additionalInfoControllers.forEach((_, controller) {
      controller.dispose();
    });
    
    super.dispose();
  }
  
  // Add a new field to additional info
  void _addAdditionalField() {
    final key = _newKeyController.text.trim();
    final value = _newValueController.text.trim();
    
    if (key.isNotEmpty && value.isNotEmpty) {
      setState(() {
        _additionalInfoControllers[key] = TextEditingController(text: value);
        _newKeyController.clear();
        _newValueController.clear();
      });
    }
  }
  
  // Remove a field from additional info
  void _removeAdditionalField(String key) {
    setState(() {
      _additionalInfoControllers.remove(key);
    });
  }
  
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Update name
        await _userService.updateUserName(
          widget.user.uid,
          _nameController.text.trim(),
        );
        
        // Update phone number
        await _userService.updateUserPhoneNumber(
          widget.user.uid,
          _phoneController.text.trim(),
        );
        
        // Update additional info
        Map<String, dynamic> additionalInfo = {};
        _additionalInfoControllers.forEach((key, controller) {
          additionalInfo[key] = controller.text.trim();
        });
        
        await _userService.updateUserAdditionalInfo(
          widget.user.uid,
          additionalInfo,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Info Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Basic Information',
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value != null && value.isNotEmpty && value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Additional Info Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Existing additional info fields
                        ..._additionalInfoControllers.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: entry.value,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeAdditionalField(entry.key),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        
                        const Divider(),
                        const SizedBox(height: 8),
                        
                        // Add new field
                        const Text(
                          'Add New Field',
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _newKeyController,
                                decoration: const InputDecoration(
                                  labelText: 'Field Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _newValueController,
                                decoration: const InputDecoration(
                                  labelText: 'Value',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.green),
                              onPressed: _addAdditionalField,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}