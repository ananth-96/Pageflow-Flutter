import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookUpload{
   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
    Future<String>uploadFile(File file, String folderName)async{
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final ref=_storage.ref().child('$folderName/file_$timeStamp');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    }

      Future<void> uploadBookDetails({required String bookTitle, required String category,required String bookDescription,required String authorDescription, required File bookCover, required File authorImage, required File audioFile, required File pdfFile})async{
      final bookCoverUrl = await uploadFile(bookCover,'Book Covers');
      final authorImageUrl = authorImage !=null? await uploadFile(authorImage, 'Author Images'):'';
      final pdfUrl = pdfFile!=null? await uploadFile(pdfFile, 'PDF Files'):'';
      final audioUrl=audioFile!=null? await uploadFile(audioFile, 'Audio Files'):'';

      await _firestore.collection('book').add({
        'title':bookTitle,
        'category':category,
        'description':bookDescription,
        'author Description':authorDescription,
        'bookCoverUrl':bookCoverUrl,
        'authorImageURl':authorImageUrl,
        'pdfUrl':pdfUrl,
        'audoUrl':audioUrl,
        'timestamp':FieldValue.serverTimestamp(),
      });
      
    }
  }
  