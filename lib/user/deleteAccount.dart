import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Deleteaccount {
  

static Future<void> deleteUserAccount()async{
  try {
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null) {
      final userId=user.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      await user.delete();
      print('User ccount has been deleted');
    }else{
      print('No user signed in');
    }
  } catch (e) {
    print('Error deleting user : $e');
    
  }
}
}