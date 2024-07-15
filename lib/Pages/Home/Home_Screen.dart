import 'package:flutter/material.dart';
import 'package:mini_project/Pages/Home/Gallery.dart';

import '../../CommonParts/Nav_Menu.dart';
import 'Favorite_Page.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of image paths and labels
    List<Map<String, String>> categories = [
      {'imagePath': 'assets/logos/facebook.png', 'label': 'Facebook'},
      {'imagePath': 'assets/logos/google.png', 'label': 'Twitter'},
      {'imagePath': 'assets/logos/facebook.png', 'label': 'Instagram'},
      {'imagePath': 'assets/logos/google.png', 'label': 'LinkedIn'},
      // Add more images and labels here
    ];

    return Scaffold(
      appBar: const FAppBar(
        title: 'Home Screen',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedBackground(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                    child: SearchBar(),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: categories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return VerticalImageText(
                                imagePath: categories[index]['imagePath']!,
                                label: categories[index]['label']!,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Grid Title',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(3, (index) {
                      // Define itemText based on index
                      String itemText = index == 0
                          ? 'l'
                          : index == 1
                          ? 'll'
                          : index == 2
                          ? 'lll'
                          : index == 3
                          ? 'qqqq'
                          : index == 4
                          ? 'wwww'
                          : index == 5
                          ? 'eeee'
                          : index == 6
                          ? 'vfgbgrb'
                          : index == 7
                          ? 'ffev'
                          : index == 8
                          ? 'ffr'
                          : index == 9
                          ? 'erffs'
                          : index == 10
                          ? 'sdfcdsdsd'
                          : index == 11
                          ? 'vfvdfvdfvscx'
                          : 'trdtdgdrg';

                      return GestureDetector(
                        onTap: () {
                          // Navigate to FavoritePage when a grid item is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoritePage(),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            GridItem(
                              text: itemText, // Use itemText here
                              image: 'assets/icons/Home_popular/icon.jfif', // Add image here
                            ),
                            const Positioned(
                              top: 0,
                              right: 10,
                              child: HeartButton(), // Add HeartButton widget here
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20), // Add space between the GridView and the button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Gallery()),
                        ); // Handle button tap
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal), // Change the background color here
                      ),
                      child: const Text(
                        'More',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavMenu(),
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
        color: Colors.lightBlue.shade300,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 320,
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
  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  const CircularContainer({
    Key? key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.backgroundColor = Colors.lightBlue,
  }) : super(key: key);

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

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        onTap: () {
          setState(() {
            _isFocused = true;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search in story',
          suffixIcon: _isFocused
              ? IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 35),
            onPressed: () {
              // Handle search button press
              // For example, you can show search results
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true, // Set filled to true
          fillColor: Colors.white, // Set fillColor to white
        ),
      ),
    );
  }
}

class CustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCurveStart = Offset(0, size.height - 20);
    final firstCurveEnd = Offset(40, size.height - 20);
    path.quadraticBezierTo(firstCurveStart.dx, firstCurveStart.dy, firstCurveEnd.dx, firstCurveEnd.dy);

    final secondCurveStart = Offset(0, size.height - 20);
    final secondCurveEnd = Offset(size.width - 40, size.height - 20);
    path.quadraticBezierTo(secondCurveStart.dx, secondCurveStart.dy, secondCurveEnd.dx, secondCurveEnd.dy);

    final thirdCurveStart = Offset(size.width, size.height - 20);
    final thirdCurveEnd = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdCurveStart.dx, thirdCurveStart.dy, thirdCurveEnd.dx, thirdCurveEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class SectionHeading extends StatelessWidget {
  final String title;
  final bool showActionButton;

  const SectionHeading({
    required this.title,
    this.showActionButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
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

class VerticalImageText extends StatelessWidget {
  final String imagePath;
  final String label;

  const VerticalImageText({
    Key? key,
    required this.imagePath,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 28,
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 55,
              child: Text(
                label,
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

class GridItem extends StatefulWidget {
  final String text;
  final String image;

  const GridItem({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110, // Adjust the width as needed
      height: 110, // Adjust the height as needed
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        color: Colors.lightGreen.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.image,
              width: 30,
              height: 30,
            ),
            const SizedBox(height: 5),
            Text(
              widget.text,
              style: const TextStyle(color: Colors.black),
            ),
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HeartButton extends StatefulWidget {
  const HeartButton({Key? key}) : super(key: key);

  @override
  _HeartButtonState createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : null,
      ),
      onPressed: () {
        setState(() {
          _isLiked = !_isLiked;
        });
      },
    );
  }
}
