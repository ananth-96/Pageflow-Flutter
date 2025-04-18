import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pageflow/Utils/commonWidgets.dart';
import 'package:pageflow/admin/homePage.dart';
import 'package:pageflow/admin/profilePage.dart';
import 'package:pageflow/services/cloudservice.dart';
import 'package:pageflow/user/userHomePage.dart';

class Addnewcategorypage extends StatefulWidget {
  const Addnewcategorypage({super.key});

  @override
  State<Addnewcategorypage> createState() => _AddnewcategorypageState();
}

class _AddnewcategorypageState extends State<Addnewcategorypage> {
  final categoryController = TextEditingController();
  File? categoryImage;
  Key? categoryKey;
  bool isSaved = false;

  Future<bool> saveCategory() async {
    if (categoryImage == null || categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category Image and Category name are required'),
        ),
      );
      return false;
    }
    try {
      final imageUrl = await BookUpload().uploadToCloudinary(categoryImage!);
      await FirebaseFirestore.instance.collection('categories').add({
        'category': categoryController.text,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Category',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,automaticallyImplyLeading: false,
        shadowColor: Colors.brown.withOpacity(0.5)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 50),
          child: Column(
            children: [
              Container(
                height: 250,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                      categoryImage == null
                          ? Image.asset(
                            'assets/book_cover_default.png',
                            fit: BoxFit.cover,
                          )
                          : Image.file(categoryImage!, key: categoryKey),
                ),
              ),
              SizedBox(height: 40),
              Container(
                height: 50,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow,
                ),

                child: GestureDetector(
                  onTap: () {
                    Commonwidgets.pickImage((file) {
                      setState(() {
                        categoryImage = file;
                        categoryKey = UniqueKey();
                      });
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.shade200,
                    ),
                    child: Center(
                      child: Text(
                        categoryImage == null ? 'Choose Image' : 'Change Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.shade200,
                ),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Category',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                  ),
                  controller: categoryController,
                ),
              ),
              SizedBox(height: 60),
              GestureDetector(
                onTap: () async {
                  final isSaved = await saveCategory();
                  if (isSaved) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added new Category ${categoryController.text}',
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminHomePage(),
                        ),
                      );
                    });
                  }
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),

                  child: Center(
                    child: Text(
                      'Save Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
