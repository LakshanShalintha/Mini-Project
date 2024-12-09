import 'package:flutter/material.dart';
import 'package:mini_project/CommonParts/Account_Page/AccountPage.dart';
import 'package:mini_project/Pages/Home/Favorite_Page.dart';
import 'package:mini_project/Pages/Home/Gallery.dart';
import 'package:mini_project/Pages/Home/Home_Screen.dart';
import 'package:mini_project/Pages/Home/New_Story.dart';

class NavMenu extends StatefulWidget {
  const NavMenu({super.key});

  @override
  State<NavMenu> createState() => _NavBarState();
}

int _selectedIndex = 0;

class _NavBarState extends State<NavMenu> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavoritePage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NewStory()),
        );
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Gallery(searchQuery: '',)),
        );
        break;
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // Green shadow color
            blurRadius: 8, // Spread of the shadow
            offset: Offset(0, -2), // Shadow offset (negative y-axis to show above the bar)
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black54,
        type: BottomNavigationBarType.fixed,  // Always show the labels
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
              size: 30.0,
            ),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create_new_folder_outlined),
            label: 'New',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_sharp),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}