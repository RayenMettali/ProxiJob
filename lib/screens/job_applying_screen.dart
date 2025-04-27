import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class ApplyJobScreen extends StatefulWidget {
  @override
  _ApplyJobScreenState createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  String? cvFileName;
  String? cvFileSize;
  bool isUploadingCV = false;

  String? portfolioFileName;
  String? portfolioFileSize;
  bool isUploadingPortfolio = false;

  Future<void> uploadFile({required bool isCV}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;

        setState(() {
          if (isCV) {
            isUploadingCV = true;
          } else {
            isUploadingPortfolio = true;
          }
        });

        final storageRef = FirebaseStorage.instance.ref().child('uploads/${file.name}');
        await storageRef.putData(file.bytes!);

        final fileSize = (file.size / 1024).toStringAsFixed(2); // Size in KB

        setState(() {
          if (isCV) {
            cvFileName = file.name;
            cvFileSize = '${fileSize}KB';
            isUploadingCV = false;
          } else {
            portfolioFileName = file.name;
            portfolioFileSize = '${fileSize}KB';
            isUploadingPortfolio = false;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully!')),
        );
      }
    } catch (e) {
      setState(() {
        if (isCV) {
          isUploadingCV = false;
        } else {
          isUploadingPortfolio = false;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        title: Text('Apply Job', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // CV Upload Section
            Text('Curiculum Vitae', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => uploadFile(isCV: true),
              icon: Icon(Icons.upload_file, color: Colors.grey),
              label: Text(
                cvFileName ?? 'Upload your CV Here',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            if (isUploadingCV)
              Center(child: CircularProgressIndicator()),
            if (cvFileName != null && cvFileSize != null)
              UploadedFile(name: cvFileName!, size: cvFileSize!),

            SizedBox(height: 20),

            // Portfolio Upload Section
            Text('Portofolio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => uploadFile(isCV: false),
              icon: Icon(Icons.upload_file, color: Colors.grey),
              label: Text(
                portfolioFileName ?? 'Upload your Portofolio',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            if (isUploadingPortfolio)
              Center(child: CircularProgressIndicator()),
            if (portfolioFileName != null && portfolioFileSize != null)
              UploadedFile(name: portfolioFileName!, size: portfolioFileSize!),

            SizedBox(height: 10),
            Center(child: Text('or use link portofolio')),

            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'https://',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 30),

            // Send Apply Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Send Apply logic here
                },
                child: Text('Send Apply', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Uploaded File Widget
class UploadedFile extends StatelessWidget {
  final String name;
  final String size;
  UploadedFile({required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.insert_drive_file, color: Colors.grey),
      title: Text(name),
      subtitle: Text(size),
      trailing: Icon(Icons.delete, color: Colors.red),
    );
  }
}
