import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igclone/resources/poststoremethod.dart';
import 'package:igclone/util/color.dart';
import 'package:igclone/widget/commentcard.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/userprovider.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({super.key, required this.snap});
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool posted = true;
  final controller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Comment'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .doc(widget.snap['postId'])
            .collection('comment')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return CommentCard(
                snap: snapshot.data!.docs[index].data(),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 15, right: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.imageurl),
              radius: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: "Add Comments", border: InputBorder.none),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: InkWell(
                onTap: () async {
                  setState(() {
                    posted = false;
                  });
                  await Firestoremethod().Postcomment(
                      widget.snap['postId'],
                      user.uid,
                      user.username,
                      controller.text.toString(),
                      user.imageurl,
                      context);
                  setState(() {
                    posted = true;
                    controller.clear();
                  });
                },
                child: posted
                    ? Text(
                        'Post',
                        style: TextStyle(color: blueColor, fontSize: 20),
                      )
                    : CircularProgressIndicator(),
              ),
            )
          ],
        ),
      )),
    );
  }
}
