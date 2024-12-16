import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CommonParts/PDFReader/PDFViewer.dart';
import 'Gallery.dart';
import '../../CommonParts/CommonPages/Nav_Menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // Test control search bar
  TextEditingController _searchController = TextEditingController();
  List<String> _filteredPdfUrls = [];
  List<String> _favoritePdfUrls = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFavorites);
    FavoritesManager().loadFavorites().then((_) {
      setState(() {
        _favoritePdfUrls = FavoritesManager().favoritePdfUrls;
        _filteredPdfUrls = _favoritePdfUrls;
      });
    });
  }

  void _filterFavorites() {
    setState(() {
      String query = _searchController.text.trim().toLowerCase();
      _filteredPdfUrls = _favoritePdfUrls.where((pdfUrl) {
        final fileName = pdfUrl.toLowerCase();
        return fileName.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFavorites);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: 'Favorite',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Gallery(searchQuery: '',)),
              ); // Add your functionality here
            },
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF131313), Color(0xFF625C5C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search in favorites',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: _filterFavorites,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _filteredPdfUrls.isEmpty
                    ? Center(
                  child: Text(
                    'No PDFs available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0), // Add horizontal padding here
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredPdfUrls.length,
                    itemBuilder: (context, index) {
                      final pdfUrl = _filteredPdfUrls[index];
                      return FutureBuilder<Reference>(
                        future: FirebaseStorage.instance
                            .ref(pdfUrl)
                            .getDownloadURL()
                            .then((url) => FirebaseStorage.instance.refFromURL(url)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData) {
                            return Center(child: Text('No file available'));
                          } else {
                            final fileRef = snapshot.data!;
                            final fileName = fileRef.name.split('.pdf')[0];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewerScreen(fileRef: fileRef),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5), // Add margins inside the Card
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(fileName),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            FavoritesManager().removeFavorite(pdfUrl);
                                          });
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
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
      title: Text(title,
        style: TextStyle(color: Colors.white),
      ),
      actions: actions,
      backgroundColor: backgroundColor, // Set the background color
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;

  FavoritesManager._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _favoritesCollection = 'favorites';
  List<String> _favoritePdfUrls = [];

  List<String> get favoritePdfUrls => _favoritePdfUrls;

  Future<void> loadFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore
          .collection(_favoritesCollection)
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        _favoritePdfUrls = List<String>.from((snapshot.data() as Map<String, dynamic>)['pdfUrls'] ?? []);
      }
    }
  }

  Future<void> addFavorite(String pdfUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (!_favoritePdfUrls.contains(pdfUrl)) {
        _favoritePdfUrls.add(pdfUrl);
        await _firestore
            .collection(_favoritesCollection)
            .doc(user.uid)
            .set({'pdfUrls': _favoritePdfUrls});
      }
    }
  }

  Future<void> removeFavorite(String pdfUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _favoritePdfUrls.remove(pdfUrl);
      await _firestore
          .collection(_favoritesCollection)
          .doc(user.uid)
          .set({'pdfUrls': _favoritePdfUrls});
    }
  }

  bool isFavorite(String pdfUrl) {
    return _favoritePdfUrls.contains(pdfUrl);
  }
}