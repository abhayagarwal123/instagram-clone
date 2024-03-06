import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:igclone/util/color.dart';
import 'package:igclone/util/dimension.dart';
import 'package:igclone/widget/postcard.dart';

class feedscreen extends StatefulWidget {
  @override
  State<feedscreen> createState() => _feedscreenState();
}

class _feedscreenState extends State<feedscreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MediaQuery.of(context).size.width>websize?null:AppBar(
          backgroundColor:MediaQuery.of(context).size.width>websize?webBackgroundColor: mobileBackgroundColor,
          title: SvgPicture.asset('assets/images/logo.svg',
              color: Colors.white, height: 35),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chat_rounded,
                color: Colors.white,
              ),
            )
          ],
        ),
        //streambuilder to get real time update
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('post').snapshots(),
          //.snapshot because get return a future and also we can get snapshot.data.doc.length
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return Postcard(snap: snapshot.data!.docs[index].data(),);
              },
              itemCount: snapshot.data!.docs.length,
            );
          },
        ),);
  }
}
