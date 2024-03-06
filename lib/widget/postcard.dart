import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igclone/provider/userprovider.dart';
import 'package:igclone/resources/poststoremethod.dart';
import 'package:igclone/screen/commentscreen.dart';
import 'package:igclone/util/color.dart';
import 'package:igclone/widget/likeanimation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../util/dimension.dart';

class Postcard extends StatefulWidget {
  final snap;
  Postcard({super.key, required this.snap});

  @override
  State<Postcard> createState() => _PostcardState();
}

class _PostcardState extends State<Postcard> {
  int commentcount = 0;
  void getcomment() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.snap['postId'])
        .collection('comment')
        .get();

    setState(() {
      commentcount = snap.docs.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcomment();
  }

  bool likeanimating = false;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > websize
              ? MediaQuery.of(context).size.width / 3
              : 0,
      vertical:MediaQuery.of(context).size.width > websize
          ? 15
          : 0
      ),
      color: mobileBackgroundColor,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 2, top: 4, left: 3, bottom: 5),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                  radius: 15,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(widget.snap['username']),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: mobileBackgroundColor,
                          title: Text("Delete post?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('post')
                                    .doc(widget.snap['postId'])
                                    .delete();
                                Navigator.pop(context);
                              },
                              child: Text("Delete"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await Firestoremethod().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                likeanimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.snap['postUrl'],
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: likeanimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 140,
                    ),
                    isanimating: likeanimating,
                    duration: Duration(milliseconds: 400),
                    onend: () {
                      setState(() {
                        likeanimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isanimating: widget.snap['likes'].contains(user.uid),
                likes: true,
                child: IconButton(
                  onPressed: () async {
                    await Firestoremethod().likePost(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: widget.snap['likes'].contains(user.uid)
                        ? Colors.redAccent
                        : null,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CommentScreen(
                          snap: widget.snap,
                        );
                      },
                    ),
                  );
                },
                icon: Icon(Icons.comment_sharp),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send),
              ),
              Expanded(
                  child: Align(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.bookmark),
                ),
                alignment: Alignment.bottomRight,
              ))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' ${widget.snap['likes'].length} likes :)',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap["username"] + " ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: widget.snap["description"]),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      " View all $commentcount comments",
                      style: TextStyle(fontSize: 15, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    DateFormat('yMMMd')
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(fontSize: 15, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
