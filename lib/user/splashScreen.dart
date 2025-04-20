import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pageflow/Utils/bottomNavigation.dart';
import 'package:pageflow/admin/homePage.dart';
import 'package:pageflow/user/signinPage.dart';
import 'package:pageflow/user/userHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; 

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future <void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? role = prefs.getString('userrole');

    if (!mounted) return; // to prevent context error

    if (isLoggedIn) {
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/Animation - 1744968019770.json',
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.99,
          fit: BoxFit.fill, // or BoxFit.contain if you prefer
        ),
      ),
    );
  }
}
