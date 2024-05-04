import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Import your home page here
import '../Pages/Home/Home_Screen.dart';
import '../Pages/Home_Page.dart';
import 'AppBar.dart'; // Import the file where CurvedBackground is defined

// Explicitly import VoidCallback from dart:ui
import 'dart:ui' show VoidCallback;

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Account',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            CurvedBackground(
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: const Icon(
                            Icons.account_circle_sharp,
                            size: 66,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Your Text Here',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Account setting
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Account Setting',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SettingMenuTitle(
                    icon: Icons.account_circle,
                    title: 'Account',
                    subtitle: 'Manage your account',
                    onTap: () {},
                  ),
                  SettingMenuTitle(
                    icon: Icons.account_circle,
                    title: 'Account',
                    subtitle: 'Manage your account',
                    onTap: () {},
                  ),
                  SettingMenuTitle(
                    icon: Icons.account_circle,
                    title: 'Account',
                    subtitle: 'Manage your account',
                    onTap: () {},
                  ),

                  /// App Setting
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'App Setting',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SettingMenuTitle(
                    icon: Icons.account_circle,
                    title: 'App',
                    subtitle: 'Manage your account',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Log Out button at the bottom of the SingleChildScrollView
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // Show log out confirmation dialog
                    _showLogoutConfirmation(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Log Out"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform log out action here
                // For example, you can navigate to the home page
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the HomePage
                Navigator.of(context).popUntil((route) => route.isFirst); // Pop all existing routes
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(), // Replace HomePage with the actual class name of your home page
                  ),
                );
              },
              child: Text("Log Out",
              style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SettingMenuTitle extends StatelessWidget {
  const SettingMenuTitle({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title, subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 28,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6!,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.subtitle1!,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class CurvedBackground extends StatelessWidget {
  final Widget child;

  const CurvedBackground({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomCurvedEdges(),
      child: Container(
        color: Colors.purpleAccent,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 100,
          child: Stack(
            children: [
              Positioned(
                top: -150,
                right: -250,
                child: CircularContainer(
                  backgroundColor: Colors.white70.withOpacity(0.1),
                ),
              ),
              Positioned(
                top: 100,
                right: -300,
                child: CircularContainer(
                  backgroundColor: Colors.white70.withOpacity(0.1),
                ),
              ),
              // Aligning child column to the center of the page
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    Key? key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.backgroundColor = Colors.blueAccent,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
