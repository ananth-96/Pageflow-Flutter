import 'package:firebase_auth/firebase_auth.dart';



class DatabaseServices{
 static Future<bool>signUpuserFirebase(String emailAddress,String password)async{
    try  {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailAddress, password: password);
      return true;
      
    } catch (e) {
      print(e);
      return false;
      
    }
  }

  static Future<bool>logInFirebase(String emailAddress, String password)async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailAddress, password: password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
    }
}


