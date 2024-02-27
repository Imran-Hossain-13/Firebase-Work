import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/ui/authentication/verify_code.dart';
import 'package:untitled/widget/round_button.dart';

class NumberLoginScreen extends StatefulWidget {
  static String routeName = "NumberLoginScreen";
  const NumberLoginScreen({super.key});

  @override
  State<NumberLoginScreen> createState() => _NumberLoginScreenState();
}

class _NumberLoginScreenState extends State<NumberLoginScreen> {
  bool loading = false;
  TextEditingController phoneController = TextEditingController();
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
          title: const Text("Phone number sign in screen"),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: size.height/15,),
              Row(
                children: [
                  Container(
                    width: size.width/7,
                    height: 55,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1,color: Colors.black)
                    ),
                    child: const Center(child: Text("+880",style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: size.width/1.5,
                    height: 57,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),),
                          hintText: "1XXXXXXXXXXXX"
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height/25,),
              RoundButton(
                  onTap: (){
                    if(phoneController.text.length == 10){
                      if(!phoneController.text.startsWith("0")){
                        _auth.verifyPhoneNumber(
                            phoneNumber: "+880${phoneController.text}",
                            verificationCompleted: (_){
                              setState(() {
                                loading =false;
                              });
                            },
                            verificationFailed: (error){
                              setState(() {
                                loading =false;
                              });
                              Fluttertoast.showToast(
                                msg: error.toString(),
                                backgroundColor: Colors.green,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            },
                            codeSent: (String verifyId, int? tokenId){
                              setState(() {
                                loading =false;
                              });
                              // Navigator.pushNamed(context, VerifyCodeScreen.routeName,arguments: verifyId);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyCodeScreen(verifyId: verifyId)));
                            },
                            codeAutoRetrievalTimeout: (error){
                              setState(() {
                                loading =false;
                              });
                              Fluttertoast.showToast(
                                msg: error.toString(),
                                backgroundColor: Colors.green,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }
                        );
                      }
                    }
                    setState(() {
                      loading =true;
                    });
                    phoneController.clear();
                  },
                  title: "Get Code",
                dbReport: loading,
              )
            ],
          ),
        ),
      ),
    );
  }
}
