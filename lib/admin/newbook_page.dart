import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pageflow/admin/admin_home_page.dart';
import 'package:pageflow/admin/admin_profile_page.dart';
import 'package:pageflow/services/bookcrud.dart';
import 'package:pageflow/services/database.dart';
import 'package:path_provider/path_provider.dart';

class NewbookPage extends StatefulWidget {
  const NewbookPage({super.key});

  @override
  State<NewbookPage> createState() => _NewbookPageState();
}

class _NewbookPageState extends State<NewbookPage> {
  File? bookCover;
  File? authorImage;
  File? pdfFile;
  File? audioFile;
  Key? _coverkey;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final authordescriptionController = TextEditingController();
  final categoryController = TextEditingController();

  Future<void> _pickImage(Function(File) onSelected) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final savedImage = await File(
        pickedFile.path,
      ).copy('${directory.path}/img_$timeStamp.png');
      onSelected(savedImage);
    }
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

  Future<void> saveBook() async {
    if (bookCover == null || titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book title and cover image are required')),
      );
      return;
    }

    await BookUpload().uploadBookDetails(
      bookTitle: titleController.text,
      category: categoryController.text,
      bookDescription: descriptionController.text,
      authorDescription: authordescriptionController.text,
      bookCover: bookCover!,
      audioFile: audioFile!,
      pdfFile: pdfFile!,
      authorImage: authorImage!,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Book Uploaded Successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                  color: Colors.green,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                      bookCover == null
                          ? Image.asset(
                            'assets\book_cover_default.png',
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
              GestureDetector(
                onTap:
                    () => _pickImage((file) {
                      setState(() {
                        bookCover = file;
                        _coverkey = UniqueKey();
                      });
                    }),
                child: uploadButton(
                  bookCover == null ? 'Choose Image' : 'Change Image',
                ),
              ),
              GestureDetector(
                onTap: () => _pickAudio,
                child: uploadButton(
                  audioFile == null
                      ? 'Choose Audio File >'
                      : 'Change Audio File >',
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => pickPDF,
                child: uploadButton(
                  pdfFile == null ? 'Choose PDF File >' : 'Change PDF File >',
                ),
              ),

              SizedBox(height: 20),
              textField(descriptionController, 'Description',lines: 4),
              SizedBox(height: 20),
              GestureDetector(onTap: () => _pickImage((file){setState(() {
                authorImage=file;
              });}),
              child: uploadButton(authorImage==null?'Choose Image':'Change Image'),),
              SizedBox(height: 20),
              textField(authordescriptionController,'Author Description',lines: 4),
              SizedBox(height: 20),

              GestureDetector(
                onTap: saveBook,
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

Widget uploadButton(String text) {
  return Container(
    height: 50,
    width: 230,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.green,
    ),
    child: Center(child: Text(text)),
  );
}

Widget textField(
  TextEditingController controller,
  String hint, {
  int lines = 1,
}) {
  return Container(
    height: 50,
    width: 230,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.green,
    ),
    child: TextFormField(
      maxLines: lines,
      minLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        hintText: hint,
        border: InputBorder.none, // Removes the default underline
      ),
      style: TextStyle(color: Colors.black),
    ),
  );
}
