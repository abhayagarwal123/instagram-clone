import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igclone/provider/userprovider.dart';
import 'package:igclone/resources/poststoremethod.dart';
import 'package:igclone/resources/storage.dart';
import 'package:igclone/util/color.dart';
import 'package:igclone/util/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class postscreen extends StatefulWidget {
  @override
  State<postscreen> createState() => _postscreenState();
}

class _postscreenState extends State<postscreen> {
  bool isloading = false;
  final imagelink = "";
  final caption = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    caption.dispose();
  }

  Uint8List? file;
  selectimage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Select Source"),
          children: [
            SimpleDialogOption(
              child: Text("Gallery"),
              padding: EdgeInsets.all(15),
              onPressed: () async {
                Navigator.of(context).pop();

                file = await pickImage(ImageSource.gallery);
                setState(() {});
              },
            ),
            SimpleDialogOption(
              child: Text("Take Photo"),
              padding: EdgeInsets.all(15),
              onPressed: () async {
                Navigator.of(context).pop();
                file = await pickImage(ImageSource.camera);
                setState(() {});
              },
            ),
            SimpleDialogOption(
              child: Center(child: Text("Close")),
              padding: EdgeInsets.all(15),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearimage() {
    setState(() {
      file = null;
    });
  }

  void postimage(BuildContext ctx, String caption, Uint8List file, String uid,
      String imageurl, String username) async {
    try {
      setState(() {
        isloading = true;
      });
      await Firestoremethod().uploadpost(
          ctx: ctx,
          caption: caption,
          file: file,
          uid: uid,
          profileimage: imageurl,
          username: username);
      setState(() {
        isloading = false;
      });
      clearimage();
      snackbaralert(context, "Posted");
    } on FirebaseException catch (error) {
      snackbaralert(context, error.message ?? "failed to post");
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return file == null
        ? Center(
            child: IconButton(
              onPressed: () {
                selectimage(context);
              },
              icon: Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () {
                  clearimage();
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: Text("Share your memories.."),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () {
                    postimage(
                        context,
                        caption.text.toString(),
                        file!,
                        userProvider.getUser.uid,
                        userProvider.getUser.imageurl,
                        userProvider.getUser.username);
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                isloading ? const LinearProgressIndicator() : Container(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(userProvider.getUser.imageurl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: caption,
                        onTap: FocusScope.of(context).unfocus,
                        maxLines: 5,
                        decoration: InputDecoration(
                            hintText: "Describe it..",
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 1.05,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
