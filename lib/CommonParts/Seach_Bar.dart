import 'package:flutter/material.dart';

class Search_Bar extends StatelessWidget {
  const Search_Bar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: <Widget>[
          Container(
            width: 8, // Width of the container
            height: 48, // Height of the container
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.black, // Change the color to red
              onPressed: () {
                // Handle search action
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Your Content Here'),
      ),
    );
  }
}
