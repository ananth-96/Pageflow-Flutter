import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:pageflow/user/userProfile.dart';

class BookUpload {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Replace with your actual Cloudinary details
  final String cloudName = 'pageflow'; // e.g. 'mycloud123'
  final String uploadPreset = 'pageflow_upload_preset'; // set this in Cloudinary dashboard

  // Function to upload a file to Cloudinary and return its URL
      Future<String?> uploadToCloudinary(File file,{bool isRaw=false}) async {
         final resourceType = isRaw ? 'raw' : 'auto';
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload');

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final fileName = file.path.split('/').last;

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final secureUrl = RegExp('"secure_url":"(.*?)"').firstMatch(respStr)?.group(1);
      return secureUrl?.replaceAll(r'\/', '/');
    } else {
      print('Cloudinary upload failed: ${response.statusCode}');
      return null;
    }
  }

  // Upload book details to Firestore with Cloudinary-hosted file URLs
  Future<void> uploadBookDetails({
    String? bookTitle,
     String? category,
     String? bookDescription,
     String? authorDescription,
     String? authorName,
     File? bookCover,
    File? authorImage,
    File? audioFile,
    File? pdfFile,
    File? categoryImage,
    
  }) async {
    final bookCoverUrl = await uploadToCloudinary(bookCover!) ?? '';
    final authorImageUrl = authorImage != null ? await uploadToCloudinary(authorImage) ?? '' : '';
    final pdfUrl = pdfFile != null ? await uploadToCloudinary(pdfFile,isRaw: true) ?? '' : '';
    final audioUrl = audioFile != null ? await uploadToCloudinary(audioFile) ?? '' : '';
    final docRef = _firestore.collection('book').doc();
  final bookId = docRef.id;
 
    final data = {
      'id': bookId,
      'title': bookTitle,
      'category': category,
      'description': bookDescription,
      'authorDescription': authorDescription, 
      'bookCoverUrl': bookCoverUrl,
      'authorImageUrl': authorImageUrl,
      'authorName':authorName,
      'pdfUrl': pdfUrl,
      'audioUrl': audioUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'categoryImage':categoryImage,
     
    };

    await docRef.set(data);
    print('Book uploaded successfully with Cloudinary URLs');
  }
}

