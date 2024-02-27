import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/ui/authentication/signup_screen.dart';
import 'package:untitled/ui/forgot_password/forgot_pass_screen.dart';
import '../../firebase_services/splash_services.dart';
import '../../home.dart';
import '../../widget/round_button.dart';
import 'number_login_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
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
        backgroundColor: Colors.white54,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height / 3.8,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 60),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
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
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, ForgotPassScreen.routeName);
                            },child: const Text("Forgot Password?",style: TextStyle(color: Colors.blue),),
                          )
                        ],
                      ),
                      const SizedBox(height: 20,),
                      RoundButton( onTap: (){
                        setState(() {
                          loading = true;
                        });
                        if(_formKey.currentState!.validate()){
                          _auth.signInWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passController.text.toString()
                          ).then((value) {
                            setState(() {
                              loading = false;
                            });
                            final val = _auth.currentUser;
                            if(val!.email.toString().contains("@gmail.com")){
                              final fireStore = FirebaseFirestore.instance.collection(val.email.toString());
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(fireStore,)));
                            }else{
                              final fireStore = FirebaseFirestore.instance.collection(val.phoneNumber.toString());
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(fireStore,)));
                            }
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
                      },title: "Login",dbReport: loading,),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          const SizedBox(width: 5,),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, SignupScreen.routeName);
                            },child: const Text("Sign up",style: TextStyle(color: Colors.blue),),
                          )
                        ],
                      ),
                      const SizedBox(height: 25,),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1,color: Colors.black))
                        ),
                        child: const Text("Others login method",style: TextStyle(fontSize: 16),),
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, NumberLoginScreen.routeName);
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.blue)
                                ),
                                child: const Center(child: Icon(Icons.phone,size: 33,color: Colors.blue,),)
                            ),
                          ),
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: (){
                              GoogleService gs = GoogleService();
                              gs.googleLogin(context);
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.blue)
                                ),
                                child: Center(child: Image.asset("assets/google-logo.png",width: 31),)
                            ),
                          ),
                          const SizedBox(width: 15,),
                          InkWell(
                            onTap: (){
                              var sc = SnackBar(
                                  content: const Text("Sorry..This feature isn't available yet",style: TextStyle(color: Colors.white),),
                                backgroundColor: Colors.blue.shade900,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(sc);
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.blue)
                                ),
                                child: const Center(child: Icon(Icons.facebook,color: Colors.blue,size: 38),)
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
