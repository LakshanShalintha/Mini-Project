import 'package:flutter/material.dart';

import '../../CommonParts/AppBar.dart';
import '../../CommonParts/Nav_Menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: ('Home'),
      ),
      backgroundColor: Colors.blueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            child: SearchBar(), // Corrected widget name to SearchBar
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SectionHeading(title: 'popular categories', showActionButton: false),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 8,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_,index) {
                      return const VerticalImageText();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavMenu(),
    );
  }
}

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    Key? key, // Added Key? parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Corrected onTap function to empty function
      child: Padding(
        padding: const EdgeInsets.only(right: 20), // Adjusted padding value
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/Home_popular/icon.jfif', // Corrected asset loading method
                  fit: BoxFit.cover,
                  color: Colors.black12,
                ),
              ),
            ),
            const SizedBox(height: 5), // Added SizedBox to provide spacing
            SizedBox(
              width: 55,
              child: Text(
                'store uvjdcv bb',
                style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget { // Renamed Search_Bar to SearchBar
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 20),
            Text(
              'search in store',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final bool showActionButton;

  const SectionHeading({
    required this.title,
    this.showActionButton = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white), // Adjusted text color
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(
            onPressed: () {},
            child: const Text('button title'),
          )
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
