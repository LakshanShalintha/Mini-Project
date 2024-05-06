import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:mini_project/Pages/Home/Home_Screen.dart';
import 'package:mini_project/Pages/Home/New_Story.dart';

import '../Pages/Home/Favorite_Page.dart';
import 'Setting.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 60,
      color: Colors.white70,
      backgroundColor: Colors.purpleAccent,
      items: const [
        CurvedNavigationBarItem(
          child: Icon(Icons.home_outlined),
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
          child: Icon(Icons.add,
            size: 40,
          ),
          label: 'New',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.perm_identity),
          label: 'Personal',
        ),
      ],
      onTap: (index) {
        // Handle button tap
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );// Home
          // Handle navigation to Home
            break;
          case 1: // Favorite
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritePage()),
            );
            break;
          case 2: // Chat
          // Handle navigation to Chat
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewStory()),
            );
            break;
          case 3: // Add
          // Handle navigation to Add
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingScreen()),
            );// Personal
          // Handle navigation to Personal
            break;
        }
      },

    );
  }
}

