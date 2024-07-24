import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mini_project/Pages/Home/Gallery.dart';
import 'package:mini_project/Pages/Home/Home_Screen.dart';
import 'package:mini_project/Pages/Home/New_Story.dart';
import 'package:mini_project/Pages/Home/StoryDisplay.dart';
import '../Pages/Home/Favorite_Page.dart';
import '../Pages/Home/speech.dart';
import 'Setting.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 60,
      color: Colors.black26,
      backgroundColor: Colors.black26,
      items: const [
        CurvedNavigationBarItem(
          child: Icon(Icons.home_outlined,
            color: Colors.black,
          ),
          label: 'Home',
        ),
        CurvedNavigationBarItem(
          child: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 40,
          ),
          label: 'Favorite',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.add_box_rounded,
              color: Colors.black,
              size: 40,
          ),
          label: 'Create',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.add_business_sharp,
            color: Colors.black,
          ),
          label: 'Gallery',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.account_circle_outlined,
            color: Colors.black,
          ),
          label: 'Account',
        ),
      ],
      onTap: (index) {
        // Handle button tap
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            break; // Add break statement
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritePage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewStory()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Gallery(searchQuery: '',)),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingScreen()),
            );
            break;
        }
      },
    );
  }
}
