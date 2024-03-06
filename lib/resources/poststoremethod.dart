import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:igclone/models/post.dart';
import 'package:igclone/resources/storage.dart';
import 'package:igclone/util/utils.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Firestoremethod {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  uploadpost(
      {required Uint8List file,
      required String caption,
      required String uid,
      required BuildContext ctx,
      required String username,
      required String profileimage}) async {
    try {
      String posturl =
          await storeimage().add_img(title: "post", file: file, ispost: true);

      String postid = Uuid().v1();
      Post post = Post(
          description: caption,
          uid: uid,
          username: username,
          likes: [],
          postId: postid,
          datePublished: DateTime.now(),
          postUrl: posturl,
          profImage: profileimage);
      await firestore.collection('post').doc(postid).set(post.toJson());
    } on FirebaseException catch (error) {
      snackbaralert(ctx, error.message ?? "upload fail");
    }
  }

  Future<void> likePost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        //if already liked by user then remove from array
        await firestore.collection('post').doc(postid).update(
          {
            'likes': FieldValue.arrayRemove([uid])
          },
        );
      } else {
        //if not liked by user then add from array
        await firestore.collection('post').doc(postid).update(
          {
            'likes': FieldValue.arrayUnion([uid])
          },
        );
      }
    } catch (error) {}
  }

  Future<void> Postcomment(String postId, String uid, String username,
      String comment, String profilepic, BuildContext ctx) async {
    try {
      if (comment.trim().length == 0) {
        return;
      }
      String commentid = Uuid().v1();
      await firestore
          .collection('post')
          .doc(postId)
          .collection('comment')
          .doc(commentid)
          .set({
        'profilephoto': profilepic,
        'username': username,
        'comment': comment,
        'uid': uid,
        'datePublished': DateTime.now()
      });
    } on FirebaseException catch (error) {
      snackbaralert(ctx, error.message ?? "upload fail");
    }
  }

  Future<void> followuser(String uid, String followid) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followid)) {
        await firestore.collection('users').doc(followid).update({
          'follower': FieldValue.arrayRemove([uid])
        });
        await firestore.collection('users').doc(followid).update({
          'following': FieldValue.arrayRemove([followid])
        });
      } else {
        await firestore.collection('users').doc(followid).update({
          'follower': FieldValue.arrayUnion([uid])
        });
        await firestore.collection('users').doc(followid).update({
          'following': FieldValue.arrayUnion([followid])
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
