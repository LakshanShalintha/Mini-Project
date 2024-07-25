import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Gallery.dart';
import '../../CommonParts/Nav_Menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final favoritePdfUrls = FavoritesManager().favoritePdfUrls;

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
                MaterialPageRoute(builder: (context) => const Gallery(searchQuery: '',)),
              ); // Add your functionality here
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
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: favoritePdfUrls.length,
                itemBuilder: (context, index) {
                  final pdfUrl = favoritePdfUrls[index];
                  return FutureBuilder<Reference>(
                    future: FirebaseStorage.instance.ref(pdfUrl).getDownloadURL().then((url) => FirebaseStorage.instance.refFromURL(url)),
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



