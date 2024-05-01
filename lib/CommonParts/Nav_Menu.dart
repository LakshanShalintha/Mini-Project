import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

import 'Setting.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 60,
      color: Colors.white70,
      backgroundColor: Colors.blueAccent,
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
          child: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.add),
          label: 'Add',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.perm_identity),
          label: 'Personal',
        ),
      ],
      onTap: (index) {
        // Handle button tap
        if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingScreen()),
          );
        }
      },
    );
  }
}

