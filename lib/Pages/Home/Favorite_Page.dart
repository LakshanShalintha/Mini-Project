import 'package:flutter/material.dart';
import '../../CommonParts/AppBar.dart';
import '../../CommonParts/Nav_Menu.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

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
            icon: Icon(
              Icons.add,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              // Add your functionality here
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Add your favorite items grid here
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(6, (index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle item tap
                    },
                    child: Card(
                      child: Stack(
                        children: [
                          // Your content here
                          Center(
                            child: Icon(
                              Icons.favorite,
                              color: isFavorited[index]
                                  ? Colors.red
                                  : Colors.grey, // Change color based on isFavorited value
                              size: 50,
                            ),
                          ),
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
                                isFavorited[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorited[index]
                                    ? Colors.red
                                    : Colors.grey, // Change color based on isFavorited value
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
      bottomNavigationBar: NavMenu(),
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
    this.backgroundColor = Colors.blue, // Default color is blue
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
