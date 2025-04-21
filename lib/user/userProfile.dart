import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pageflow/user/deleteAccount.dart';
import 'package:pageflow/user/editProfilePage.dart';
import 'package:pageflow/user/privacyPolicy.dart';
import 'package:pageflow/user/signinPage.dart';
import 'package:pageflow/user/termsOfUse.dart';
import 'package:pageflow/user/tipsPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}):super(key:key);

  @override
  State<UserProfilePage> createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  File? _image;
  String? fullName;
  String imageUrl =
      'https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2247726673.jpg';
      bool isLoading=true;
  @override
  void initState() {
    super.initState();
    loadUserData();
  }


  Future<void> loadUserData() async {
    final userData = await getUserProfile();
    if (userData != null) {
      setState(() {
        print(userData);
        fullName = "${userData['firstName']}";
        imageUrl = userData['userImageUrl']??imageUrl;
        isLoading=false;
        print('This is user : $fullName');
        print(imageUrl);
      });
    }
    else{
      setState(() {
        isLoading=false;
      });
    }
  }
  @override
  void didChangeDependencies() {
  super.didChangeDependencies();
  loadUserData(); // reload user data when the widget is rebuilt
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffA1C4FD), Color(0xffC2E9FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
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
        body: Padding(
          padding: const EdgeInsets.only(left: 40, top: 50, right: 40),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                Text(
                  fullName??'',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 95),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserEditProfile(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.shade900,
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserEditProfile(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade900,
                  ),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TipsPage()),
                        );
                      },
                      child: Text(
                        'Tips',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade900,
                  ),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TermsOfUsePage(),
                          ),
                        );
                      },
                      child: Text(
                        'Terms of use',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade900,
                  ),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade900,
                  ),
                  width: double.infinity,
                  height: 50,
                  child: GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Are you sure you want to logout',
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _clearLoginState(context);
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'No',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.shade900,
                  ),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        await showDialog(context: context, builder: (BuildContext context)
                        {
                          return AlertDialog(title: Text('Are you sure you want to delete the account permanently ?'),actions: [TextButton(onPressed: (){
                              Deleteaccount.deleteUserAccount();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                          }, child: Text('Yes',style: TextStyle(color: Colors.red),)),TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text('No'))],);
                        });
                        
                      },
                      child: Text(
                        'Delete User Account',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

void _clearLoginState(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
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
      final doc =
          await FirebaseFirestore.instance
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
