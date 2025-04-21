import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pageflow/user/booksByCategory.dart';
import 'package:pageflow/user/categories.dart';
import 'package:pageflow/user/editProfilePage.dart';
import 'package:pageflow/user/favouritesPage.dart';
import 'package:pageflow/user/userProfile.dart';
import 'package:pageflow/user/userHomePage.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  
  final Color navigationBarColor = Colors.black;
  int selectedIndex = 0;
  late PageController pageController;
final GlobalKey<UserProfilePageState> profilePageKey = GlobalKey<UserProfilePageState>();
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
          children:  [
            HomePage(),
            UserCategories(),
            FavouritesPage(),
            UserProfilePage(key: profilePageKey),
            UserEditProfile(),
            
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          backgroundColor: navigationBarColor,
          waterDropColor: Colors.white,
          
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
               if (index == 3) { // Assuming profile page is at index 3
      profilePageKey.currentState?.loadUserData();
    }
            });
          },
          selectedIndex: selectedIndex,
          barItems:  [
            BarItem(
              filledIcon: Icons.home_rounded,
              outlinedIcon: Icons.home_outlined,
            ),
            BarItem(
              filledIcon: Icons.category_rounded,
              outlinedIcon: Icons.category_outlined,
            ),
            BarItem(
              filledIcon: Icons.favorite_rounded,
              outlinedIcon: Icons.favorite_border_rounded,
            ),
            BarItem(
              filledIcon: Icons.person_rounded,
              outlinedIcon: Icons.person_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }
}



