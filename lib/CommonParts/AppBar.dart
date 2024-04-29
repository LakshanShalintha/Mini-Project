import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor; // Add a new property for background color

  const CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = Colors.brown, // Default color is blue
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: backgroundColor, // Set the background color here
      // You can add more customization options here
    );
  }
}
