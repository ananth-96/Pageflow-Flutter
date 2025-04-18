import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pageflow/services/cloudservice.dart';

class EditBook extends StatefulWidget {
  final String bookId;
  final Map<String,dynamic>bookdata;
  const EditBook({required this.bookId,required this.bookdata,super.key});

  @override
  State<EditBook> createState() => EditBookState();
}

class EditBookState extends State<EditBook> {
final titleController = TextEditingController();
final descriptionController =TextEditingController();
final authorDescriptionController=TextEditingController();
final authorNameController=TextEditingController();
File? newBookCover;
File? newAuthorImage;
File? newPdfFile;
File? newAudioFile;
String? selectedCategory;
List<String> categoryList=[];
bool isLoadingCategories=true;
String? existingBookCoverUrl;
@override
void initState()
{
super.initState();
titleController.text=widget.bookdata['title']??'';
descriptionController.text=widget.bookdata['description']??'';
authorDescriptionController.text=widget.bookdata['authorDescription']??'';
authorNameController.text=widget.bookdata['authorName']??'';
selectedCategory=widget.bookdata['category'];
fetchCategories();
existingBookCoverUrl=widget.bookdata['bookCoverUrl'];
}

Future<void>fetchCategories()async{
  try{
  
  final snapshot=await FirebaseFirestore.instance.collection('categories').get();
  

  if(snapshot.docs.isEmpty){
    print('No Categories found');
  }
setState(() {
  categoryList=snapshot.docs.map((doc)=>doc['category'] as String? ?? '').where((name)=>name.isNotEmpty).toList();
  isLoadingCategories=false;
  
});

} catch(e){
  print('Error loading category:$e');
}
}

Future<void> pickFile(ImageSource source, Function(File) onFilePicked) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      onFilePicked(File(picked.path));
    }
  } Future<void> updateBook() async {
    String? bookCoverUrl = widget.bookdata['bookCoverUrl'];
    String? authorImageUrl = widget.bookdata['authorImageUrl'];
    String? pdfUrl = widget.bookdata['pdfUrl'];
    String? audioUrl = widget.bookdata['audioUrl'];

    if (newBookCover != null) {
      bookCoverUrl = await BookUpload().uploadToCloudinary(newBookCover!) ?? bookCoverUrl;
    }
    if (newAuthorImage != null) {
      authorImageUrl = await BookUpload().uploadToCloudinary(newAuthorImage!) ?? authorImageUrl;
    }
    if (newPdfFile != null) {
      pdfUrl = await BookUpload().uploadToCloudinary(newPdfFile!) ?? pdfUrl;
    }
    if (newAudioFile != null) {
      audioUrl = await BookUpload().uploadToCloudinary(newAudioFile!) ?? audioUrl;
    }

    final updatedData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'authorDescription': authorDescriptionController.text,
      'authorName': authorNameController.text,
      'category': selectedCategory ?? '',
      'bookCoverUrl': bookCoverUrl,
      'authorImageUrl': authorImageUrl,
      'pdfUrl': pdfUrl,
      'audioUrl': audioUrl,
      'timestamp': FieldValue.serverTimestamp(),
    };
     await FirebaseFirestore.instance
        .collection('book')
        .doc(widget.bookId)
        .update(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book updated successfully')));
    Navigator.pop(context);
  }

Widget filePreview({required String? url, required String label, required VoidCallback onChange}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        url != null
            ? Image.network(url, height: 150)
            : Text('No file uploaded'),
        SizedBox(height: 5),
        ElevatedButton(
          onPressed: onChange,
          child: Text('Change $label'),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget textField(TextEditingController controller, String label, {int lines = 1}) {
    return TextField(
      controller: controller,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,shadowColor: Colors.brown.withOpacity(0.5)
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            textField(titleController, 'Book Title'),
            SizedBox(height: 10),
            textField(descriptionController, 'Description', lines: 3),
            SizedBox(height: 10),
            textField(authorNameController, 'Author Name'),
            SizedBox(height: 10),
            textField(authorDescriptionController, 'Author Description', lines: 3),
            SizedBox(height: 20),

            isLoadingCategories
                ? CircularProgressIndicator()
                : DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categoryList.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedCategory = value);
                    },
                  ),

            SizedBox(height: 20),
            filePreview(
              url: widget.bookdata['bookCoverUrl'],
              label: 'Book Cover',
              onChange: () => pickFile(ImageSource.gallery, (file) {
                setState(() => newBookCover = file);
              }),
            ),
            filePreview(
              url: widget.bookdata['authorImageUrl'],
              label: 'Author Image',
              onChange: () => pickFile(ImageSource.gallery, (file) {
                setState(() => newAuthorImage = file);
              }),
            ),

            ElevatedButton(
              onPressed: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() => newPdfFile = File(picked.path));
                }
              },
              child: Text('Change PDF'),
            ),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() => newAudioFile = File(picked.path));
                }
              },
              child: Text('Change Audio'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateBook,style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text('Update Book',style: TextStyle(color: Colors.white,),),
            ),
          ],
        ),
      ),
    );
  }
}
    
 