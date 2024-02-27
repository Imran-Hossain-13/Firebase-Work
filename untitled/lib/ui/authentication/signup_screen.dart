import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widget/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = "SignupScreen";
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool dbReport = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScopeNode focus = FocusScope.of(context);
        if(!focus.hasPrimaryFocus){
          focus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign up screen"),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height/3.3,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            const SizedBox(height: 10,),
                            TextFormField(
                              controller: passController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                suffixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter password";
                                }else{
                                  return null;
                                }
                              },
                            ),
                          ],
                        )
                    ),
                    const SizedBox(height: 20,),
                    RoundButton( onTap: (){
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          dbReport =true;
                        });
                        _auth.createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passController.text.toString()
                        ).then((value) {
                          setState(() {
                            dbReport =true;
                          });
                          final val = _auth.currentUser;
                          final fireStore = FirebaseFirestore.instance.collection(val!.email.toString());
                          String id = DateTime.now().millisecondsSinceEpoch.toString();
                          fireStore.doc(id).set({
                            'id':id,
                          });
                          SnackBar sc = const SnackBar(content:  Text("Sign up success"));
                          ScaffoldMessenger.of(context).showSnackBar(sc);
                        }
                        ).onError((error, stackTrace) {
                          Fluttertoast.showToast(
                            msg: error.toString(),
                            backgroundColor: Colors.green,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        });
                      }
                      emailController.clear();
                      passController.clear();
                    },title: "Signup",dbReport: dbReport,),
                    const SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already registered?"),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },child: const Text("Login",style: TextStyle(color: Colors.blue),),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
