import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        color: Colors.white70,
        backgroundColor: Colors.blueAccent,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.search,
              color: Colors.red,
              size: 40,
            ),
            label: 'Search',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.newspaper),
            label: 'Feed',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity),
            label: 'Personal',
          ),
        ],// Set text style for all labels
        onTap: (index) {
          // Handle button tap
        },
      ),
      // Add other Scaffold content like appBar, body, etc.
    );
  }
}