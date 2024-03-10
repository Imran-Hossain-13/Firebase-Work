import 'package:flutter/material.dart';
import 'package:untitled/ui/authentication/login_screen.dart';
import 'package:untitled/ui/authentication/number_login_screen.dart';
import 'package:untitled/ui/authentication/signup_screen.dart';
import 'package:untitled/ui/forgot_password/forgot_pass_screen.dart';
import 'package:untitled/ui/image/upload_imagge.dart';
import 'package:untitled/ui/splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firestore/firestore.dart';
import 'firestore/firestore_services.dart';
// import 'home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SplashScreen(),
    routes: {
      LoginScreen.routeName : (ctx) => const LoginScreen(),
      SignupScreen.routeName : (ctx) => const SignupScreen(),
      // PostScreen.routeName : (ctx) => const PostScreen(),
      NumberLoginScreen.routeName : (ctx) => const NumberLoginScreen(),
      // AddPostScreen.routeName : (ctx) => const AddPostScreen(),
      // HomeScreen.routeName : (ctx) => const HomeScreen(),
      FireStoreScreen.routeName : (ctx) => const FireStoreScreen(),
      FireServiceScreen.routeName : (ctx) => const FireServiceScreen(),
      UploadImageScreen.routeName : (ctx) => const UploadImageScreen(),
      ForgotPassScreen.routeName : (ctx) => const ForgotPassScreen(),
      // VerifyCodeScreen.routeName : (ctx) => const VerifyCodeScreen(),
    },
    theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        )
    ),
  ));
}