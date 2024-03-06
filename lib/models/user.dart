import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String imageurl;
  final String username;
  final String bio;
  final List follower;
  final List following;

  const User(
      {required this.username,
        required this.uid,
        required this.imageurl,
        required this.email,
        required this.bio,
        required this.follower,
        required this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      imageurl: snapshot["imageurl"],
      bio: snapshot["bio"],
      follower: snapshot["follower"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "email": email,
    "imageurl": imageurl,
    "bio": bio,
    "follower": follower,
    "following": following,
  };
}