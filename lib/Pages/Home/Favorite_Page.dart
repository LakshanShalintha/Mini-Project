import 'package:flutter/material.dart';
import '../../CommonParts/Nav_Menu.dart';
import 'Gallery.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // Boolean list to track whether each grid item is favorited or not
  List<bool> isFavorited = List.generate(6, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: 'Favorite',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Gallery()),
              );// Add your functionality here
            },
          ),
        ],
        backgroundColor: Colors.purpleAccent,
      ),
      backgroundColor: Colors.purple,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(12, (index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle item tap
                    },
                    child: Card(
                      child: Stack(
                        children: [
                          // Your content here

                          // Heart button in top-right corner
                          Positioned(
                            top: 8,
                            right: 8,
                            child: InkWell(
                              onTap: () {
                                // Toggle isFavorited value when heart button is tapped
                                setState(() {
                                  isFavorited[index] = !isFavorited[index];
                                });
                              },
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red, // Always show as red
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavMenu(),
    );
  }
}

class FAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;

  const FAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.backgroundColor = Colors.purpleAccent, // Default color is purpleAccent
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      backgroundColor: backgroundColor, // Set the background color
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
