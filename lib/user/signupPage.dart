import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pageflow/services/database.dart';
import 'package:pageflow/user/signinPage.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey();

    return Scaffold(
      body: Container(width: double.infinity,
  height: double.infinity,  
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pageflow signin background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                 
                  
                  SizedBox(height: 300),

                  // First Name
                  TextFormField(
                    controller: firstNameController,
                    decoration: _inputDecoration("First Name", Icons.person),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required field' : null,
                  ),
                  SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: lastNameController,
                    decoration: _inputDecoration("Last Name", Icons.person),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required field' : null,
                  ),
                  SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration("Email", Icons.email),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field';
                      } else if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("Password", Icons.lock),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: _inputDecoration("Confirm Password", Icons.lock),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field';
                      } else if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          bool isSubmitted = await DatabaseServices.signUpuserFirebase(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            firstNameController.text.trim(),
                            lastNameController.text.trim(),
                          );

                          if (isSubmitted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('User created Successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error - User not created'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Sign Up'),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Already have an account?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
