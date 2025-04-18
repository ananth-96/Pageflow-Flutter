import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pageflow/user/signinPage.dart';
import 'package:pageflow/user/splashScreen.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
// ignore: deprecated_member_use
CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: 'pageflow');
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
    primarySwatch: Colors.blue, // Sets the main color
 // Background for all Scaffold pages
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 5,
    ),
    iconTheme: const IconThemeData(color: Colors.blueAccent),
    // You can add more here like buttonTheme, cardTheme etc.
  ),
      home: Splashscreen());
  }
}
