import 'package:flutter/material.dart';
import 'package:untitled/widget/round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireServiceScreen extends StatefulWidget {
  static String routeName = "FireServiceScreen";
  final fireStore;
  const FireServiceScreen({super.key, this.fireStore});

  @override
  State<FireServiceScreen> createState() => _FireServiceScreenState();
}

class _FireServiceScreenState extends State<FireServiceScreen> {
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection("users");
  final postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add firestore data"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: "What is in your mind?",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              onTap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                widget.fireStore.doc(id).set({
                  'id' : id,
                  'title' : postController.text.toString(),
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  SnackBar sc = const SnackBar(content: Text("Data add success.."));
                  ScaffoldMessenger.of(context).showSnackBar(sc);
                });
              },
              title: "Submit",
              dbReport: loading,
            )
          ],
        ),
      ),
    );
  }
}
