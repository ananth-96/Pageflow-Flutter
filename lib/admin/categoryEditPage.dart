import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pageflow/Utils/commonWidgets.dart';
import 'package:pageflow/services/cloudservice.dart';

class CategoryEditPage extends StatefulWidget {
  final String categoryId;
  final String currentName;
  final String currentImageUrl;
  const CategoryEditPage({super.key,required this.categoryId,required this.currentName,required this.currentImageUrl});

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  late TextEditingController newCategoryNameController;
  File? newImage;
  bool isSaving = false;
  @override

  void initState(){super.initState();
  newCategoryNameController=TextEditingController(text: widget.currentName);}
  
  Future<void> pickNewImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        newImage = File(picked.path);
      });
    }
  }

   Future<void> saveChanges() async {
    setState(() => isSaving = true);

    try {
      String imageUrl = widget.currentImageUrl;

      // If new image is selected, upload it
      if (newImage != null) {
        final uploaded = await BookUpload().uploadToCloudinary(newImage!);
        if (uploaded != null) imageUrl = uploaded;
      }
       await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .update({
        'category': newCategoryNameController.text.trim(),
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category updated successfully')),
      );

      Navigator.pop(context); // Go back to CategoryList
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update category')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  Widget build(BuildContext context) {
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,automaticallyImplyLeading: false,shadowColor: Colors.brown.withOpacity(0.5)
      ),
      body: isSaving
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickNewImage,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        image: DecorationImage(
                          image: newImage != null
                              ? FileImage(newImage!)
                              : NetworkImage(widget.currentImageUrl)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: newCategoryNameController,
                    decoration: InputDecoration(
                      labelText: 'Category Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: saveChanges,
                    icon: Icon(Icons.save),
                    label: Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
    
  }

