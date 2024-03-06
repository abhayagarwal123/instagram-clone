import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igclone/provider/userprovider.dart';
import 'package:igclone/screen/favouritescreen.dart';
import 'package:igclone/screen/feedscreen.dart';
import 'package:igclone/screen/postscreen.dart';
import 'package:igclone/screen/profilescreen.dart';
import 'package:igclone/screen/searchscreen.dart';
import 'package:igclone/util/color.dart';
import 'package:provider/provider.dart';
import 'package:igclone/models/user.dart' as model;

class mobilescreenlayout extends StatefulWidget {
  const mobilescreenlayout({super.key});

  @override
  State<mobilescreenlayout> createState() => _mobilescreenlayoutState();
}

class _mobilescreenlayoutState extends State<mobilescreenlayout> {
  late PageController pagecontroller = PageController();
  int page = 0;
  @override
  void initState() {
    super.initState();
    pagecontroller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pagecontroller.dispose();
  }

  void bottomnavigation(int page) {
    pagecontroller.jumpToPage(page);
  }

  void onpagechange(int changedpage) {
    setState(() {
      page = changedpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          onpagechange(value);
        },
        controller: pagecontroller,
        children: [
          feedscreen(),
          SearchScreen(),
          postscreen(),
          FavouriteScreen(),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        ],
        //onPageChanged: ,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mobileBackgroundColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: page == 0 ? primaryColor : secondaryColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: page == 1 ? primaryColor : secondaryColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: page == 2 ? primaryColor : secondaryColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: page == 3 ? primaryColor : secondaryColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: page == 4 ? blueColor : secondaryColor,
            ),
            label: '',
          ),
        ],
        onTap: (value) {
          bottomnavigation(value);
        },
      ),
    );
  }
}
