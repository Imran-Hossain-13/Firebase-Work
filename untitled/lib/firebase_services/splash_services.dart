import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/home.dart';
import 'package:untitled/ui/authentication/login_screen.dart';

class SplashServices{
  void isLogin(BuildContext context){
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if(user != null){
      Timer(const Duration(seconds: 3), (){
        final val = _auth.currentUser;
        if(val!.email.toString().contains("@gmail.com")){
          final CollectionReference fireStore = FirebaseFirestore.instance.collection(val.email.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(fireStore)));
        }else{
          final fireStore = FirebaseFirestore.instance.collection(val.phoneNumber.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(fireStore)));
        }
      });
        // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    }else{
      Timer(const Duration(seconds: 3), (){
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
      });
    }
  }
}


class GoogleService{
  Future<void> googleLogin(BuildContext context)async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn =  GoogleSignIn();
    try{
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if(googleSignInAccount!=null){
        final GoogleSignInAuthentication googleAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuthentication.idToken,
          accessToken: googleAuthentication.accessToken,
        );
        await _auth.signInWithCredential(credential);
        final val = _auth.currentUser;
        final CollectionReference fireStore = FirebaseFirestore.instance.collection(val!.email.toString());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(fireStore)));
      }
    }catch(error){
      Fluttertoast.showToast(
        msg: error.toString(),
        backgroundColor: Colors.green,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }
}
