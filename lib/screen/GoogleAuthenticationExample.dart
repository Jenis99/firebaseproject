import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secondfirebaseproject/screen/HomePage.dart';

class GoogleAuthenticationExample extends StatefulWidget {
  @override
  State<GoogleAuthenticationExample> createState() => _GoogleAuthenticationExampleState();
}

class _GoogleAuthenticationExampleState extends State<GoogleAuthenticationExample> {
  final FirebaseAuth auth  = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Google Authentication"),
      ),
      body: Center(
        child:ElevatedButton(
          onPressed: () async{
             final GoogleSignIn? googleSignIn = GoogleSignIn();
            final GoogleSignInAccount? googleSignInAccount = await googleSignIn!.signIn();
            if (googleSignInAccount != null)
            {
              final GoogleSignInAuthentication googleSignInAuthentication =
                  await googleSignInAccount.authentication;
              final AuthCredential authCredential = GoogleAuthProvider.credential(
                  idToken: googleSignInAuthentication.idToken,
                  accessToken: googleSignInAuthentication.accessToken);
              
              // Getting users credential
              UserCredential result = await auth.signInWithCredential(authCredential); 
              User? user = result.user;
              var name = user!.displayName.toString();
              var email = user!.email.toString();
              var photo = user!.photoURL.toString();
              var googleid = user!.uid.toString();

              print("Name : "+name);
              print("Email : "+email);
              print("Photo : "+photo);
              print("Id : "+googleid);

            }
            
          },
          child:Text("LogIn") ,)),
    );
  }
}