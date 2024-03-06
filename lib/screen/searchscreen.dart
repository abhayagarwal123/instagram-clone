import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igclone/screen/profilescreen.dart';
import 'package:igclone/util/color.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: controller,
          onFieldSubmitted: (value) {
            setState(() {
              show = true;
            });
          },
          decoration: InputDecoration(labelText: "Search user"),
        ),
      ),
      body: show
          ? FutureBuilder(
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ProfileScreen(
                                    uid: snapshot.data!.docs[index]
                                        .data()['uid']);
                              },
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              snapshot.data!.docs[index].data()['imageurl'],
                            ),
                          ),
                          title: Text(
                            snapshot.data!.docs[index].data()['username'],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  ),
                );
              },
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isGreaterThanOrEqualTo: controller.text)
                  .get(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance.collection('post').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 4,
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                          snapshot.data!.docs[index].data()['postUrl'],
                        ))),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  ),
                );
              },
            ),
    );
  }
}
