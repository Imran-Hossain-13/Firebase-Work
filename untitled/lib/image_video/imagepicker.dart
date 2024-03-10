import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../ui/authentication/login_screen.dart';
import '../widget/round_button.dart';

class MyImagePicker extends StatefulWidget {
  final CollectionReference databaseRef;
  final userDetail;
  const MyImagePicker({super.key, required this.databaseRef, this.userDetail});
  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  XFile? file;
  final imagePicker = ImagePicker();
  UploadTask? uploadTask;
  bool upLoaderProgress = true;

  Future getImageGallery() async {
    //Get any File

    /*FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result!=null && result.files.single.path != null){
      PlatformFile myFile = result.files.first;
      print(myFile.name);
      setState(() {
        file = XFile(result.files.single.path!);
      });
    } */

    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        file = pickedFile;
      });
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
                    _auth.signOut().then((value) {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 180,
            ),
            InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 3),
                ),
                child: file != null
                    ? Image.file(
                  File(file!.path),
                  fit: BoxFit.cover,
                )
                    : const Icon(
                  Icons.camera_alt_outlined,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
              onTap: () async {
                if (file != null) {
                  // final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
                  final path = "images2/${widget.userDetail}.${file!.name.split('.').last}";
                  final myFile = File(file!.path);
                  Reference ref = FirebaseStorage.instance.ref().child(path);
                  setState(() {
                    uploadTask = ref.putFile(myFile);
                    upLoaderProgress = false;
                  });
                  await uploadTask!.whenComplete(() async {
                    Timer(const Duration(seconds: 2), () {
                      setState(() {
                        upLoaderProgress = true;
                      });
                    });
                    final urlLink = await ref.getDownloadURL();
                    final uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
                    widget.databaseRef.doc(uniqueId).set({
                      'id':uniqueId,
                      'imgUrl':urlLink
                    });
                  });
                  setState(() {
                    uploadTask = null;
                  });
                } else {
                  return;
                }
              },
              title: "Upload",
            ),
            StreamBuilder(
                stream: uploadTask?.snapshotEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    if(upLoaderProgress == false){
                      double progress = data!.bytesTransferred / data.totalBytes;
                      return SizedBox(
                        height: 40,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.blueAccent.withOpacity(.3),
                              color: Colors.blueAccent.withOpacity(.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            Center(
                              child: Text(
                                "${(100 * progress).roundToDouble()}%",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      );
                    }else{
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
