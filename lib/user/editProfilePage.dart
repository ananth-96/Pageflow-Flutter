import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pageflow/admin/homePage.dart';
import 'package:pageflow/admin/profilePage.dart';
import 'package:pageflow/services/userServices.dart';
import 'package:path_provider/path_provider.dart';

class UserEditProfile extends StatefulWidget {
  const UserEditProfile({super.key});

  @override
  State<UserEditProfile> createState() => UserEditProfileState();
}

class UserEditProfileState extends State<UserEditProfile> {
  File? _image;
  String? imageUrl='https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2247726673.jpg';
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final userId=FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          nameController.text = "${data['firstName']} ${data['lastName']}";
          imageUrl=data['userImageUrl'];
          
        });
      }
    }
  }

  Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );

  if (pickedFile != null) {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile_pic.png';
    final imageFile = await File(pickedFile.path).copy(imagePath);

    setState(() {
      _image = imageFile;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'PageFlow',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
        ),
        shadowColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Stack(
              children: [
                ClipOval(
                  child:
                      _image == null
                          ? Image.network(imageUrl??'https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2247726673.jpg',height: 150,width: 150,fit: BoxFit.cover,)
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
            SizedBox(height: 80),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade400,
              ),
              child: TextFormField(
                controller: nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(fontSize: 18),
                  border: InputBorder.none,
                ),
              ),
            ),
        
            SizedBox(height: 40),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade400,
              ),
              child: TextFormField(controller: phoneController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(fontSize: 18),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 40,),
            Container(width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange,
              ),
              child: TextButton(
                onPressed: () async{
                  final imageUrl=await Userservices().uploadProfilePicture(_image!);
                  print(imageUrl);
                  Map<String,dynamic> newData={
                    'firstName':nameController.text,
                    'phoneNumber':phoneController.text,
                    'userImageUrl':imageUrl
                  };
                  print(newData);
                  final result =
                  await  updateUser(newData,userId);
                  if(result==true){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Userdetails updated',),backgroundColor: Colors.green,));
                    Navigator.pop(context);
                    loadUserData();
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Userdetails not updated',),backgroundColor: Colors.red,));
                  }
                  setState(() {
                    
                  });
        
                },
                child: Text(
                  'Update',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> updateUser(Map<String,dynamic> userData, String userid) async{
  try {
    await FirebaseFirestore.instance.collection('users').doc(userid).update(userData);
    return true;
  } catch (e) {
    print(e);
    return false;
    
  }

}
