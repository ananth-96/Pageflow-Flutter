import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pageflow/Utils/bottomNavigation.dart';
import 'package:pageflow/admin/homePage.dart';
import 'package:pageflow/services/database.dart';
import 'package:pageflow/user/signupPage.dart';
import 'package:pageflow/user/userHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  

  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
 

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned.fill(
          child: Image.asset(
            'assets/pageflow signin background.png',
            fit: BoxFit.cover,
          ),
        ),
            
            
            SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
               SizedBox(height: 450),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: usernameController,
                  ),
                  SizedBox(height: 14),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      hintText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 14),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      onPressed: () {
                        _login(context);
                      },
                      child: Text('Login'),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont have an account?',
                        style: TextStyle(color: Colors.black,fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupPage()),
                          );
                        },
                        child: Text(
                          ' Sign Up',
                          style: TextStyle(color: Colors.white,fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                        ),
            ),]
        ),
    );
  }

  void _login(BuildContext context) async{
    String adminUsername = 'admin@email.com';
    String adminPassword = 'admin';
    String emailController = usernameController.text;
    String passController=passwordController.text;
    bool isSubmitted=await DatabaseServices.logInFirebase(emailController, passController);
    SharedPreferences prefs =await SharedPreferences.getInstance();
    if (emailController == adminUsername &&
        passController == adminPassword) {
          await prefs.setBool('isLoggedIn',true);
          await prefs.setString('userrole','admin');
      print('Login Successfull');

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      });
    } 
    else if(isSubmitted){
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userrole', 'user');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
    }
    
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username or password is incorrect!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
