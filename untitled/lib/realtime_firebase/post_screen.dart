import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/ui/authentication/login_screen.dart';
import 'add_post.dart';

class PostScreen extends StatefulWidget {
  static String routeName = "PostScreen";
  final ref;
  const PostScreen(this.ref,{super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _auth = FirebaseAuth.instance;
  // final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Screen"),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder()
              ),
              onChanged: (value){
                setState(() {

                });
              },
            ),
          ),
          // MyStreamBuilder(ref: widget.ref),
          Expanded(
            child: FirebaseAnimatedList(
              query: widget.ref,
              defaultChild:  Center(
                child: Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Center(
                        child: Text("Loading",style: TextStyle(color: Colors.white,fontSize: 20),)
                    )
                ),
              ),
              itemBuilder: (context, snapshot, animation, index){
                final title = snapshot.child('title').value.toString();
                if(searchFilter.text.isEmpty){
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                showMyDialog(title,snapshot.child('id').value.toString());
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
                                widget.ref.child(snapshot.child('id').value.toString()).remove();
                              },
                              leading: const Icon(Icons.delete),
                              title: const Text("Delete"),
                            )
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  );
                }else if(title.toLowerCase().contains(searchFilter.text.toLowerCase())){
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                }else{
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          final val = _auth.currentUser;
          if(val!.email.toString().contains("@gmail.com")){
            final DatabaseReference fireStore = FirebaseDatabase.instance.ref(val.email.toString());
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPostScreen(fireStore,)));
          }else{
            final DatabaseReference fireStore = FirebaseDatabase.instance.ref(val.phoneNumber.toString());
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPostScreen(fireStore,)));
          }
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
                    widget.ref.child(id).update({'title':editController.text});
                  },
                  child: const Text("Update")
              ),
            ],
          );
        }
    );
  }
}

class MyStreamBuilder extends StatelessWidget {
  const MyStreamBuilder({
    super.key,
    required this.ref,
  });

  final DatabaseReference ref;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: StreamBuilder(
      stream: ref.onValue,
      builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
        if(snapshot.hasData){
          Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
          List<dynamic> list =[];
          list.clear();
          list = map.values.toList();
          return ListView.builder(
              itemCount: snapshot.data!.snapshot.children.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(list[index]['title']),
                  subtitle: Text(list[index]['id']),
                );
              }
          );
        }else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
