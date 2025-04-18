import 'dart:io';
import 'package:mime/mime.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Userservices {

Future<String> uploadProfilePicture(File profileImage)async{
  final authorImageUrl = profileImage != null ? await uploadToCloudinary(profileImage) ?? '' : '';
  return authorImageUrl;


}






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

}

