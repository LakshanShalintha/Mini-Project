import 'package:flutter/material.dart';
import '../../CommonParts/AppBar.dart';
import '../../CommonParts/Nav_Menu.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(
          title: 'Favorite',
        ),

      bottomNavigationBar: NavMenu(),
    );
  }
}
