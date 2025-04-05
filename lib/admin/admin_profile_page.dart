import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pageflow/admin/admin_edit_profile.dart';
import 'package:pageflow/admin/admin_home_page.dart';
import 'package:pageflow/user/signin_page.dart';
import 'package:path_provider/path_provider.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
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
      body: Padding(
        padding: const EdgeInsets.only(left: 135, top: 50),
        child: Column(
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
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Text('Nandakrishnan'),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminEditProfile()),
                );
              },
              child: Container(
                height: 30,
                width: 40,
                child: Text('EDIT PROFILE', style: TextStyle(fontSize: 17)),
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },

              child: Container(
                height: 30,
                width: 40,
                child: Text('LOG OUT', style: TextStyle(fontSize: 17)),
              ),
            ),
          ],
        ),
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
