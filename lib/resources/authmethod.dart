import 'dart:typed_data';
import 'package:igclone/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:igclone/resources/storage.dart';
import 'package:igclone/util/utils.dart';

class AuthMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }
  signupuser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file,
      required BuildContext ctx}) async {
    try {
      UserCredential usercredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final imageurl = await storeimage()
          .add_img(title: 'profile', file: file, ispost: false);


      model.User user = model.User(
          username: username,
          uid: usercredential.user!.uid,
          imageurl: imageurl,
          email: email,
          bio: bio,
          follower: [],
          following: []);

      await firestore
          .collection('users')
          .doc(usercredential.user!.uid)
          .set(user.toJson());
      //firestore require data in json format so we convert user to json

    } on FirebaseAuthException catch (error) {
      snackbaralert(ctx, error.message ?? 'Authentication failed');
    }
  }

  loginuser(
      {required String email,
      required String password,
      required BuildContext ctx}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      snackbaralert(ctx, error.message ?? 'Authentication failed');
    }
  }
}
