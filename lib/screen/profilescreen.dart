import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igclone/resources/poststoremethod.dart';
import 'package:igclone/screen/loginscreen.dart';
import 'package:igclone/util/color.dart';
import 'package:igclone/util/utils.dart';
import '../widget/profileutil.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userdata = {};
  int postnum = 0;
  int follower = 0;
  int following = 0;
  bool isfollow = false;
  bool isloading = false;
  @override
  void initState() {
    super.initState();

    getdata();
  }

  getdata() async {
    try {
      isloading = true;
      setState(() {});
      var Usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postsnap = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postnum = postsnap.docs.length;
      userdata = Usersnap.data()!;
      follower = Usersnap.data()!['follower'].length;
      following = Usersnap.data()!['following'].length;
      isfollow = Usersnap.data()!['follower']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(
        () {},
      );
    } on FirebaseAuthException catch (error) {
      snackbaralert(context, error.message ?? 'Fail to fetch data');
    }
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userdata['username']),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.redAccent,
                              backgroundImage:
                                  NetworkImage(userdata['imageurl']),
                              radius: 40,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Stat(label: 'Post', num: postnum),
                                      Stat(label: 'Followers', num: follower),
                                      Stat(label: 'Following', num: following),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? Followbutton(
                                              label: 'Sign Out',
                                              backgroundcolor:
                                                  mobileBackgroundColor,
                                              bordercolor: Colors.grey,
                                              textcolor: Colors.white,
                                              Function: () async {
                                                await FirebaseAuth.instance
                                                    .signOut();

                                              },
                                            )
                                          : isfollow
                                              ? Followbutton(
                                                  label: 'UnFollow ' +
                                                      userdata['username']
                                                          .toString(),
                                                  backgroundcolor: blueColor,
                                                  bordercolor:
                                                      Colors.blueAccent,
                                                  textcolor: Colors.white,
                                                  Function: () async {
                                                    await Firestoremethod()
                                                        .followuser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            userdata['uid']);
                                                    setState(() {
                                                      isfollow = false;
                                                      follower--;
                                                    });
                                                  },
                                                )
                                              : Followbutton(
                                                  label: 'Follow ' +
                                                      userdata['username']
                                                          .toString(),
                                                  backgroundcolor: Colors.white,
                                                  bordercolor: Colors.white,
                                                  textcolor: Colors.black,
                                                  Function: () async {
                                                    await Firestoremethod()
                                                        .followuser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            userdata['uid']);
                                                    setState(() {
                                                      isfollow = true;
                                                      follower++;
                                                    });
                                                  },
                                                ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 10),
                          child: Text(userdata['username'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(top: 3),
                          child: Text(
                            userdata['bio'],
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  postnum == 0
                      ? Center(
                          child: Text(
                            'No Post Available',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        )
                      : FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('post')
                              .where('uid', isEqualTo: widget.uid)
                              .get(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.8,
                                      mainAxisSpacing: 4,
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data!.docs[index]
                                            .data()['postUrl'],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.docs.length,
                            );
                          },
                        ),
                ],
              ),
            ),
          );
  }
}
