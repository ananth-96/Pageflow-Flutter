import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Commonwidgets {

  static  Future<void> pickImage(Function(File) onSelected) async {
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
}