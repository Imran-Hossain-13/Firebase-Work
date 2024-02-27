import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widget/round_button.dart';

class ForgotPassScreen extends StatefulWidget {
  static String routeName = "ForgotPassScreen";
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController =  TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password Screen"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios,size: 35,color: Colors.white,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        suffixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter email";
                        }else{
                          return null;
                        }
                      },
                    ),
                  ],
                )
            ),
            const SizedBox(height: 30,),
            RoundButton( onTap: (){
              setState(() {
                loading = true;
              });
              if(_formKey.currentState!.validate()){
                _auth.sendPasswordResetEmail(
                    email: emailController.text.toString()
                ).then((value) {
                  setState(() {
                    loading = false;
                  });
                  // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                }
                ).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Fluttertoast.showToast(
                    msg: error.toString(),
                    backgroundColor: Colors.green,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    toastLength: Toast.LENGTH_SHORT,
                  );
                });
              }
            },title: "Login"),
          ],
        ),
      ),
    );
  }
}
