
  import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pageflow/admin/admin_home_page.dart';
import 'package:pageflow/admin/admin_profile_page.dart';
  import 'package:path_provider/path_provider.dart';

class AdminEditProfile extends StatefulWidget {
  const AdminEditProfile({super.key});

  @override
  State<AdminEditProfile> createState() => _AdminEditProfileState();
}

class _AdminEditProfileState extends State<AdminEditProfile> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = File('${directory.path}/profile_pic.png');
      setState(() {
        _image = imagePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              ClipOval(
                child:
                    _image == null
                        ? Image.asset(
                          'assets/pngwing.com.png', // Default image
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                        : Image.file(
                          _image!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
              ),
              Positioned(
                bottom: 5,
                right: 5,

                child: InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 20,
                    child: Icon(Icons.camera_alt),
                  ),
                ),
              ),
            ],
          ),
          Text("Username"),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text("Password"),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text('Phone Number'),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminHomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminProfilePage()),
            );
          }
        },
      ),
    );
  }
}
