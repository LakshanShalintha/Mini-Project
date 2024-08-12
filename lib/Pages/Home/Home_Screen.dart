import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../CommonParts/CommonPages/Nav_Menu.dart';
import '../../CommonParts/PDFReader/PDFViewer.dart';
import 'Gallery.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<List<Reference>> fetchPdfUrls() async {
    final storageRef = FirebaseStorage.instance.ref();
    final files = await listAllFiles(storageRef);
    return files
        .where((file) => file.name.endsWith('.pdf'))
        .take(6)
        .toList(); // Limit to 6 items
  }

  Future<List<Reference>> listAllFiles(Reference ref) async {
    List<Reference> allFiles = [];
    final result = await ref.listAll();
    allFiles.addAll(result.items);
    for (var prefix in result.prefixes) {
      allFiles.addAll(await listAllFiles(prefix));
    }
    return allFiles;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> categories = [
      {'imagePath': 'assets/icons/Home_popular/Fantasy.jpg', 'label': 'Fantasy'},
      {'imagePath': 'assets/icons/Home_popular/Science.jpg', 'label': 'Science'},
      {'imagePath': 'assets/icons/Home_popular/Thriller.jpg', 'label': 'Thriller'},
      {'imagePath': 'assets/icons/Home_popular/Fiction.jpg', 'label': 'Fiction'},
    ];

    // Paths to your images
    List<String> imagePaths = [
      'assets/images/PDFs/Elephant.webp',
      'assets/images/PDFs/Moon.webp',
      'assets/images/PDFs/Sea.webp',
      'assets/images/PDFs/Solar.jpeg',
      'assets/images/PDFs/Tree.webp',
      'assets/images/PDFs/World.webp',
    ];

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              CurvedBackground(
                imagePath: 'assets/images/Home_Page/new story.jpeg',
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Center(
                      child: Text(
                        'AudiRAB',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                      child: SearchBar(),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SectionHeading(
                            title: 'Popular Categories',
                            showActionButton: false,
                          ),
                          SizedBox(
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
                color: Colors.white10,
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Stories',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 0),
                    FutureBuilder<List<Reference>>(
                      future: fetchPdfUrls(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No PDFs found'));
                        } else {
                          final pdfRefs = snapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 15.0,
                              childAspectRatio: 3.5, // Aspect ratio of grid items
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return GridItem(
                                pdfRef: pdfRefs[index], // Passing the Reference object
                                imagePath: imagePaths[index],
                              );
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    // Add space between the GridView and the button
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Gallery(searchQuery: ""),
                            ), // Provide a default value for searchQuery
                          ); // Handle button tap
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 58),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
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
      ),
      bottomNavigationBar: const NavMenu(),
    );
  }
}

class CurvedBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const CurvedBackground({
    required this.child,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomCurvedEdges(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 420,
          child: Stack(
            children: [
              Positioned(
                top: -150,
                right: -250,
                child: CircularContainer(
                  backgroundColor: Colors.white.withOpacity(0.1),
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
  final TextEditingController _searchController = TextEditingController();

  void _handleSearch(BuildContext context) {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Gallery(searchQuery: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: _searchController,
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
              _handleSearch(context);
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
          filled: true,
          fillColor: Colors.white,
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
    path.quadraticBezierTo(
        firstCurveStart.dx, firstCurveStart.dy, firstCurveEnd.dx, firstCurveEnd.dy);

    final secondCurveStart = Offset(0, size.height - 20);
    final secondCurveEnd = Offset(size.width - 40, size.height - 20);
    path.quadraticBezierTo(
        secondCurveStart.dx, secondCurveStart.dy, secondCurveEnd.dx, secondCurveEnd.dy);

    final thirdCurveStart = Offset(size.width, size.height - 20);
    final thirdCurveEnd = Offset(size.width, size.height);
    path.quadraticBezierTo(
        thirdCurveStart.dx, thirdCurveStart.dy, thirdCurveEnd.dx, thirdCurveEnd.dy);

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
        Padding(
          padding: const EdgeInsets.only(left: 10.0), // Add padding to the left of the text
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontSize: 20), // Adjust the font size here
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .apply(color: Colors.white),
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

class GridItem extends StatelessWidget {
  final Reference? pdfRef;
  final String? imagePath;

  const GridItem({
    Key? key,
    this.pdfRef,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && pdfRef != null) {
      final pdfName = pdfRef!.name.split('.pdf').first;

      return GestureDetector(
        onTap: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PDFViewerScreen(fileRef: pdfRef!),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(50), // Adjusted to make the container circular
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2.0), // Adjust the padding to move the image to the right
                child: ClipOval(
                  child: Image.asset(
                    imagePath!,
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              SizedBox(width: 10), // Add some space between the image and the text
              Text(
                pdfName,
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    } else {
      // Handle the case where imagePath is null
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(50), // Adjusted to make the container circular
        ),
        child: Center(
          child: Text(
            'No Image',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
