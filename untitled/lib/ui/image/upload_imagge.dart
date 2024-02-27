import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/widget/round_button.dart';
import '../authentication/login_screen.dart';

class UploadImageScreen extends StatefulWidget {
  static String routeName = "UploadImageScreen";
  final databaseRef;
  final userDetail;
  const UploadImageScreen({super.key, this.databaseRef, this.userDetail});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  XFile? file;
  final imagePicker = ImagePicker();
  // DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  UploadTask? uploadTask;
  bool upLoaderProgress = true;

  Future getImageGallery() async {
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
              height: 250,
            ),
            InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 3),
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
              height: 20,
            ),
            RoundButton(
              onTap: () async {
                if (file != null) {
                  final path = "images/${widget.userDetail}.${file!.name.split('.').last}";
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
                    widget.databaseRef.doc('1').set({
                      'id': '1',
                      'profile': urlLink,
                    }).then((value) {
                      SnackBar sc = const SnackBar(content: Text("Data add success.."));
                      ScaffoldMessenger.of(context).showSnackBar(sc);
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
              dbReport: loading,
            ),
            // const SizedBox(height: 270,),
            StreamBuilder(
                stream: uploadTask?.snapshotEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    double progress = data!.bytesTransferred / data.totalBytes;
                    return upLoaderProgress == true
                        ? Container()
                        : SizedBox(
                            height: 40,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor:
                                      Colors.blueAccent.withOpacity(.3),
                                  color: Colors.blueAccent.withOpacity(.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                Center(
                                  child: Text(
                                    "${(100 * progress).roundToDouble()}%",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          );
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
