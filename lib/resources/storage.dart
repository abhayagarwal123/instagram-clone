import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class storeimage {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> add_img(
      {required String title, required Uint8List file, required ispost}) async {
    Reference storageref =
        storage.ref().child(title).child('${auth.currentUser!.uid}.jpeg');
    if (ispost) {
      String id = const Uuid().v1();
      storageref = storageref.child(id);
    }
    await storageref.putData(file);
    final imageurl = await storageref.getDownloadURL();
    return imageurl;

    /* usage
    final imageurl = await storeimage().add_img(title: 'profile', file: file);
    */
  }
}
