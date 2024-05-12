import 'package:flutter/material.dart';

import '../../CommonParts/Nav_Menu.dart';
import 'Favorite_Page.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<bool> isFavorited = List.generate(6, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: 'Gallery',
      ),
      backgroundColor: Colors.purple,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                children: [
                  Text('Grid 1'),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                                child: Text('Item $index'),
                              ),

                              // Heart button in top-right corner
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () {
                                    // Toggle isFavorited value when heart button is tapped
                                    setState(() {
                                      isFavorited[index] =
                                      !isFavorited[index];
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
              Column(
                children: [
                  Text('Grid 2'),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                                child: Text('Item $index'),
                              ),

                              // Heart button in top-right corner
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () {
                                    // Toggle isFavorited value when heart button is tapped
                                    setState(() {
                                      isFavorited[index] =
                                      !isFavorited[index];
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
              Column(
                children: [
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                                child: Text('Item $index'),
                              ),

                              // Heart button in top-right corner
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () {
                                    // Toggle isFavorited value when heart button is tapped
                                    setState(() {
                                      isFavorited[index] =
                                      !isFavorited[index];
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
            ], // Close the children list of the main Column here
          ), // Close the main Column here
        ),
      ),
      bottomNavigationBar: const NavMenu(),
    );
  }
}
