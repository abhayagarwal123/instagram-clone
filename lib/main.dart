import 'package:flutter/material.dart';
import 'package:igclone/provider/userprovider.dart';
import 'package:igclone/response/mobilescreenlayout.dart';
import 'package:igclone/response/responsive_layout.dart';
import 'package:igclone/response/webscreenlayout.dart';
import 'package:igclone/screen/feedscreen.dart';
import 'package:igclone/screen/loginscreen.dart';
import 'package:igclone/util/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'IG clone',
        theme: ThemeData.dark().copyWith(

          scaffoldBackgroundColor: mobileBackgroundColor,
          brightness: Brightness.dark,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Responsivelayout(
                  mobilelayout: mobilescreenlayout(),
                  weblayout: WebScreenLayout());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return loginscreen();
          },
        ),
      ),
    );
  }
}
