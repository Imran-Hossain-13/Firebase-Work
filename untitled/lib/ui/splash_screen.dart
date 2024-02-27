import 'package:flutter/material.dart';
import '../firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "LoginScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    splashServices.isLogin(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Firebase Tutorial",style: TextStyle(fontSize: 28),),
      ),
    );
  }
}
