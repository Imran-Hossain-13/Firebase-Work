import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../ui/authentication/login_screen.dart';
import 'firestore_services.dart';

class FireStoreScreen extends StatefulWidget {
  static String routeName = "FireStoreScreen";
  final ref;
  const FireStoreScreen({super.key,this.ref});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final _auth = FirebaseAuth.instance;
  // final ref = FirebaseFirestore.instance.collection('+8801736753991');
  final editController = TextEditingController();
  void test() {
    final val = _auth.currentUser;
    if(val!.email.toString().contains("@gmail.com")){
      final fireStore = FirebaseFirestore.instance.collection(val.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>FireServiceScreen(fireStore: fireStore,)));
    }else{
      final fireStore = FirebaseFirestore.instance.collection(val.phoneNumber.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>FireServiceScreen(fireStore: fireStore,)));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireStore Screen"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios,size: 35,color: Colors.white,),
        ),
        actions: [
          Row(
            children: [
              const Text("Log out",style: TextStyle(color: Colors.white,fontSize: 18),),
              IconButton(
                  onPressed: (){
                    _auth.signOut().then((value){
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
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
                  icon: const Icon(Icons.logout,color: Colors.white,size: 28,)
              ),
              const SizedBox(width: 10,),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20,),
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
                          if(index == 0){
                            return Container();
                          }else{
                            return ListTile(
                              title: Text(snapshot.data!.docs[index]['title'].toString()),
                              subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.pop(context);
                                          showMyDialog(snapshot.data!.docs[index]['title'].toString(),snapshot.data!.docs[index]['id'].toString());
                                        },
                                        leading: const Icon(Icons.edit),
                                        title: const Text("Edit"),
                                      )
                                  ),
                                  PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.pop(context);
                                          widget.ref.doc(snapshot.data!.docs[index]['id']).delete();
                                        },
                                        leading: const Icon(Icons.delete),
                                        title: const Text("Delete"),
                                      )
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert),
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

  Future<void> showMyDialog(String title, String id)async{
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Center(child: Text("Update")),
            content: TextFormField(
              controller: editController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder()
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    widget.ref.doc(id).update({
                      'title':editController.text,
                    });
                  },
                  child: const Text("Update")
              ),
            ],
          );
        }
    );
  }
}
