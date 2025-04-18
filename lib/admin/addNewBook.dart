import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pageflow/Utils/commonWidgets.dart';
import 'package:pageflow/admin/booksList.dart';
import 'package:pageflow/admin/homePage.dart';
import 'package:pageflow/admin/profilePage.dart';
import 'package:pageflow/services/cloudservice.dart';
import 'package:path_provider/path_provider.dart';

class NewbookPage extends StatefulWidget {
  const NewbookPage({super.key});

  @override
  State<NewbookPage> createState() => _NewbookPageState();
}

class _NewbookPageState extends State<NewbookPage> {
  bool isSaved = false;
  File? bookCover;
  File? authorImage;
  File? pdfFile;
  File? audioFile;
  Key? _coverkey;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final authorDescriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final authorNameController = TextEditingController();

  String? selectedCategory;
  List<String> categoryList = [];
  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    final categories =
        snapshot.docs.map((doc) => doc['category'] as String).toList();
    setState(() {
      categoryList = categories;
      isLoadingCategories = false;
    });
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      setState(() {
        audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        pdfFile = File(result.files.single.path!);
      });
    }
  }

  Future<bool> saveBook() async {
    if (bookCover == null || titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book title and cover image are required')),
      );
      return false;
    }

    try {
      await BookUpload().uploadBookDetails(
        bookTitle: titleController.text,
        category: selectedCategory ?? '',
        bookDescription: descriptionController.text,
        authorDescription: authorDescriptionController.text,
        bookCover: bookCover ?? File('bookCover'),
        audioFile: audioFile ?? File('audioFile'),
        pdfFile: pdfFile ?? File('pdfFile'),
        authorImage: authorImage ?? File('authorImage'),
        authorName: authorNameController.text,
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,elevation: 7, // default shadow
  shadowColor: Colors.brown.withOpacity(0.5)
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/nologobackground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 110, right: 110, top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 230,
                      width: 165,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            bookCover == null
                                ? Image.asset(
                                  'assets/book_cover_default.png',
                                  fit: BoxFit.cover,
                                )
                                : Image.file(
                                  bookCover!,
                                  key: _coverkey,
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    SizedBox(height: 20),
                    textField(titleController, 'Book Title', lines: 2),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap:
                          () => Commonwidgets.pickImage((file) {
                            setState(() {
                              bookCover = file;
                              _coverkey = UniqueKey();
                            });
                          }),
                      child: uploadButton(
                        bookCover == null ? 'Choose Image' : 'Change Image',
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        print('Hey');
                        _pickAudio();
                      },
                      child: uploadButton(
                        audioFile == null
                            ? 'Choose Audio File >'
                            : 'Change Audio File >',
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => pickPDF(),
                      child: uploadButton(
                        pdfFile == null
                            ? 'Choose PDF File >'
                            : 'Change PDF File >',
                      ),
                    ),

                    SizedBox(height: 20),
                    textField(descriptionController, 'Description', lines: 4),
                    SizedBox(height: 20),
                    isLoadingCategories
                        ? CircularProgressIndicator()
                        : Container(
                          width: 230,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: DropdownButtonFormField(
                              value: selectedCategory,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              isExpanded: true,
                              hint: Text(
                                'Choose Category',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  {
                                    selectedCategory = value;
                                    categoryController.text = value ?? '';
                                  }
                                });
                              },
                              items:
                                  categoryList.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Center(
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),

                    SizedBox(height: 20),
                    GestureDetector(
                      onTap:
                          () => Commonwidgets.pickImage((file) {
                            setState(() {
                              authorImage = file;
                            });
                          }),
                      child: uploadButton(
                        authorImage == null
                            ? 'Choose Author Image'
                            : 'Change Author Image',
                      ),
                    ),
                    SizedBox(height: 20),
                    textField(authorNameController, 'Author Name', lines: 2),
                    SizedBox(height: 20),
                    textField(
                      authorDescriptionController,
                      'Author Description',
                      lines: 4,
                    ),
                    SizedBox(height: 20),

                    GestureDetector(
                      onTap: () async {
                        final isSaved = await saveBook();
                        if (isSaved) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Book Uploaded Successfully'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BooksList(),
                              ),
                            );
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Text(
                            'Save Book',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          if (isSaved)
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade600,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
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

Widget uploadButton(String text) {
  return Container(
    height: 50,
    width: 230,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Colors.grey.shade200,
      boxShadow: [
        BoxShadow(color: Colors.grey.shade300, spreadRadius: 4, blurRadius: 3),
      ],
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

Widget textField(
  TextEditingController controller,
  String hint, {
  int lines = 1,
}) {
  return Container(
    width: 230,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Colors.grey.shade200,
      boxShadow: [
        BoxShadow(color: Colors.grey.shade300, spreadRadius: 4, blurRadius: 3),
      ],
    ),
    child: TextFormField(
      textAlign: TextAlign.center,
      controller: controller,
      maxLines: lines,
      minLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        border: InputBorder.none, // Removes the default underline
      ),
      style: TextStyle(color: Colors.black),
    ),
  );
}
