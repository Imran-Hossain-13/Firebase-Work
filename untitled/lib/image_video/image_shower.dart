import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:untitled/image_video/imagepicker.dart';

import '../ui/authentication/login_screen.dart';

class ImageShower extends StatefulWidget {
  final CollectionReference ref;
  const ImageShower({super.key,required this.ref});

  @override
  State<ImageShower> createState() => _ImageShowerState();
}

class _ImageShowerState extends State<ImageShower> {
  final auth = FirebaseAuth.instance;
  void test() {
    final val = auth.currentUser;
    if(val!.email.toString().contains("@gmail.com")){
      final fireStore = FirebaseFirestore.instance.collection("${val.email}Images");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyImagePicker(databaseRef: fireStore,userDetail: val.email.toString())));
    }else{
      final fireStore = FirebaseFirestore.instance.collection(val.phoneNumber.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyImagePicker(databaseRef: fireStore,userDetail: val.email.toString())));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Image"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 35,
            color: Colors.white,
          ),
        ),
        actions: [
          Row(
            children: [
              const Text(
                "Log out",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              IconButton(
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.routeName, (route) => false);
                    }).onError((error, stackTrace) {
                      Fluttertoast.showToast(
                        msg: error.toString(),
                        backgroundColor: Colors.green,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 28,
                  )),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: widget.ref.snapshots(),
            // stream: ref.snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }else if(snapshot.hasError){
                return const Center(child: Text("Something is wrong..."),);
              }else{
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        if(index==0){
                          return Container();
                        }else if(snapshot.data!.docs.isEmpty){
                          return Container(height: 10,width: 10,color: Colors.red,);
                        }else{
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10,),
                                Image.network(snapshot.data!.docs[index]['imgUrl'].toString(),width: 70,height: 70,),
                                const SizedBox(width: 30,),
                                Text("Image $index"),
                                const SizedBox(width: 120,),
                                IconButton(
                                  onPressed: (){
                                    FileDownloader.downloadFile(
                                      url: snapshot.data!.docs[index]['imgUrl'].toString(),
                                      onProgress: (name,progress){
                                      },
                                      onDownloadCompleted: (path){
                                        SnackBar sc = const SnackBar(content: Text("Download Completed..."));
                                        ScaffoldMessenger.of(context).showSnackBar(sc);
                                      },
                                      onDownloadError: (String error){
                                        print("Error is : $error");
                                      }
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_circle_down,size: 35,color: Colors.blueGrey,),
                                ),
                                IconButton(
                                  onPressed: (){
                                    showDialog(context: context, builder: (context){
                                      return AlertDialog(
                                        title: const Text("Are you confirm?"),
                                        actions: [
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: const Text("No")),
                                          TextButton(onPressed: (){
                                            widget.ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                            Navigator.pop(context);
                                          },
                                              child: const Text("Yes")),
                                        ],
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.delete,size: 35,color: Colors.blueGrey,),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          test();
        },
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.add,size: 34,color: Colors.white,),
      ),
    );
  }
}
