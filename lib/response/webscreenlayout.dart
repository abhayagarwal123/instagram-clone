import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:igclone/util/color.dart';
import '../screen/favouritescreen.dart';
import '../screen/feedscreen.dart';
import '../screen/postscreen.dart';
import '../screen/profilescreen.dart';
import '../screen/searchscreen.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      page = page;
    });
  }

  void navjump(int page) {
    pageController.jumpToPage(page);
    setState(() {
      page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: page == 0 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navjump(0),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: page == 1 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navjump(1),
          ),
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              color: page == 2 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navjump(2),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: page == 3 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navjump(3),
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: page == 4 ? primaryColor : secondaryColor,
            ),
            onPressed: () => navjump(4),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          feedscreen(),
          SearchScreen(),
          postscreen(),
          FavouriteScreen(),
          ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
        ],
      ),
    );
  }
}
