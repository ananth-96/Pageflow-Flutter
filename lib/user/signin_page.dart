import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pageflow/admin/admin_home_page.dart';
import 'package:pageflow/services/database.dart';
import 'package:pageflow/user/signup_page.dart';
import 'package:pageflow/user/user_home_page.dart';

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
      return Scaffold(
        body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pageflow signin background.png'),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
        ),
    );
  }

  void _login(BuildContext context) async{
    String username = 'admin@email.com';
    String password = 'admin';
    String adminEmail = usernameController.text;
    String pass=passwordController.text;
    bool isSubmitted=await DatabaseServices.logInFirebase(adminEmail, pass);
    if (usernameController.text == username &&
        passwordController.text == password) {
      print('Login Successfull');

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      });
    } 
    else if(isSubmitted){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
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
