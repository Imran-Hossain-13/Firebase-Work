import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../home.dart';
import '../../widget/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  static String routeName = "NumberLoginScreen";
  final String verifyId;
  const VerifyCodeScreen({super.key, required this.verifyId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  TextEditingController userCode = TextEditingController();
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
          title: const Text("Verify screen"),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: size.height/15,),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: userCode,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),),
                    hintText: "6 digits code"
                ),
              ),
              SizedBox(height: size.height/25,),
              RoundButton(
                onTap: ()async{
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verifyId,
                      smsCode: userCode.text.toString(),
                  );
                  try{
                    await _auth.signInWithCredential(credential);
                    final val = _auth.currentUser;
                    final CollectionReference fireStore = FirebaseFirestore.instance.collection(val!.email.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(fireStore)));
                  }catch(error){
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
                  }
                },
                title: "Verify",
                dbReport: loading,
              )
            ],
          ),
        ),
      ),
    );
  }
}
