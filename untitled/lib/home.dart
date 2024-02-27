import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled/firestore/firestore.dart';
import 'package:untitled/ui/image/upload_imagge.dart';

import 'realtime_firebase/post_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "HomeScreen";
  final CollectionReference fireStore;
  const HomeScreen(this.fireStore, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height/2.5,
          width: size.width/1.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: widget.fireStore.snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }else if(snapshot.hasError){
                    return const Center(child: Text("Something is wrong..."),);
                  }else{
                    if(snapshot.data!.docs.isEmpty || snapshot.data!.docs[0]['id'].toString() != '1'){
                      return const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color.fromARGB(255, 187, 186, 186),
                        child: Center(child: Icon(Icons.person_outline,size: 60,color: Colors.white,)),
                      );
                    }else{
                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(snapshot.data!.docs[0]['profile'].toString()),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 15,),
              InkWell(
                onTap: (){
                  final auth = FirebaseAuth.instance;
                  final val = auth.currentUser;
                  if(val!.email.toString().contains("@gmail.com")){
                    final DatabaseReference fireStore = FirebaseDatabase.instance.ref(val.email.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(fireStore,)));
                  }else{
                    final DatabaseReference fireStore = FirebaseDatabase.instance.ref(val.phoneNumber.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(fireStore,)));
                  }
                },
                child: Container(
                  width: size.width/2,
                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(child: Text("Go to Firebase",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
              ),
              const SizedBox(height: 15,),
              InkWell(
                onTap: (){
                  final auth = FirebaseAuth.instance;
                  final val = auth.currentUser;
                  if(val!.email.toString().contains("@gmail.com")){
                    final fireStore = FirebaseFirestore.instance.collection(val.email.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FireStoreScreen(ref: fireStore,)));
                  }else{
                    final fireStore = FirebaseFirestore.instance.collection(val.phoneNumber.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FireStoreScreen(ref: fireStore,)));
                  }
                  // Navigator.pushNamed(context, FireStoreScreen.routeName,arguments: [fireStore]);
                },
                child: Container(
                  width: size.width/2,
                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(child: Text("Go to Firestore",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
              ),
              const SizedBox(height: 15,),
              InkWell(
                onTap: (){
                  final auth = FirebaseAuth.instance;
                  final val = auth.currentUser;
                  if(val!.email.toString().contains("@gmail.com")){
                    final fireStore = FirebaseFirestore.instance.collection(val.email.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadImageScreen(databaseRef: fireStore,userDetail: val.email.toString(),)));
                  }else{
                    final fireStore = FirebaseFirestore.instance.collection(val.phoneNumber.toString());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadImageScreen(databaseRef: fireStore,userDetail: val.phoneNumber.toString(),)));
                  }
                  // Navigator.pushNamed(context, UploadImageScreen.routeName);
                },
                child: Container(
                  width: size.width/2,
                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(child: Text("Profile picture",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white60,
    );
  }
}
