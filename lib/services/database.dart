import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseServices {
  static Future<bool> signUpuserFirebase(
    String emailAddress,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      String uid = credential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': emailAddress,
        'firstName': firstName,
        'lastName': lastName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> logInFirebase(
    String emailAddress,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> recentlyViewed(
    Map<String, dynamic> bookData,
    String userId,
  ) async {
    try {
      bookData['timeStamp'] = FieldValue.serverTimestamp();
      final bookId = bookData['id'];

      if (bookId == null) {
        throw Exception("Book ID is missing");
      }
      await FirebaseFirestore.instance
          .collection('User recently viewed')
          .doc(userId)
          .collection('books')
          .doc(bookId)
          .set(bookData, SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  Stream <List<Map<String,dynamic>>> getbooks(String userId) {
   
   return FirebaseFirestore.instance.collection('User recently viewed').doc(userId)
          .collection('books').orderBy('timeStamp',descending: true).limit(5).snapshots().map((snapshot)=>snapshot.docs.map((doc)=>doc.data()).toList());

  }
  
}
