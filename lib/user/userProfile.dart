import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pageflow/user/editProfilePage.dart';
import 'package:pageflow/user/signinPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  File? _image;
  String fullName= 'User Name';
  String imageUrl='';
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

    Future<void> loadUserData() async{
      final userData=await getUserProfile();
      if(userData!=null){
        setState(() {
          fullName="${userData['firstName']}${userData['lastName']}";
          imageUrl=userData['userImageUrl'];
        });
      }
    }

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
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors:  [Color(0xffA1C4FD), Color(0xffC2E9FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)),
      child: Scaffold(backgroundColor: Colors.black,
        appBar: AppBar(automaticallyImplyLeading: false,backgroundColor: Colors.black,
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
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(100),
      ),
        ),
        shadowColor: Colors.grey,
      ),
        body: Padding(
          padding: const EdgeInsets.only(left: 1, top: 50),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: [
                CircleAvatar(radius: 60,backgroundImage:NetworkImage(imageUrl,),
                
                      
                      
                ),
                Text(fullName, style: TextStyle(fontSize: 23,fontWeight: FontWeight.w600,color: Colors.white)),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserEditProfile()),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                  
                    decoration: BoxDecoration(color: Colors.grey.shade200,boxShadow: [BoxShadow(spreadRadius: 2,blurRadius: 3,color: Colors.grey.withOpacity(0.6))]
                      ,borderRadius: BorderRadius.circular(10),
                      
                    ),
                    child: Center(child: IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserEditProfile()));
                    }, icon: Icon(Icons.edit),)),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                   _clearLoginState(context);
                  },
                  
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.shade200,boxShadow: [BoxShadow(spreadRadius: 2,blurRadius: 3,color: Colors.grey.withOpacity(0.6))]),
                    
                    height: 50,
                    width: 150,
                    child: Center(child: Text('LOG OUT', style: TextStyle(fontSize: 17))),
                  ),
                ),
              ],
            ),
          ),
        )),
    );}}


    void _clearLoginState(context) async{
      SharedPreferences prefs= await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );

    }


   Future<Map<String, dynamic>?> getUserProfile() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      return doc.data() as Map<String, dynamic>?;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}
