import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igclone/util/color.dart';

import '../util/dimension.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite posts"),
        backgroundColor: MediaQuery.of(context).size.width > websize
            ? webBackgroundColor
            : mobileBackgroundColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('post')
            .where('likes',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

          if(snapshot.data!.size==0 ){
            return Center(child: Text('No Favourite post...Try adding some',),);
          }
          else{
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else{

              return GridView.builder(

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.8, mainAxisSpacing: 4, crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            snapshot.data!.docs[index].data()['postUrl']),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            }
          }


        },
      ),
    );
  }
}
