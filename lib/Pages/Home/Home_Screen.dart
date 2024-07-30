import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:just_audio/just_audio.dart';
import '../../CommonParts/Nav_Menu.dart';
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
      {'imagePath': 'assets/logos/facebook.png', 'label': 'Facebook'},
      {'imagePath': 'assets/logos/google.png', 'label': 'Twitter'},
      {'imagePath': 'assets/logos/facebook.png', 'label': 'Instagram'},
      {'imagePath': 'assets/images/PDFs/dog1.webp', 'label': 'LinkedIn'},
    ];

    // Paths to your images
    List<String> imagePaths = [
      'assets/images/PDFs/cat2.webp',
      'assets/logos/google.png',
      'assets/logos/facebook.png',
      'assets/logos/google.png',
      'assets/logos/google.png',
      'assets/logos/google.png',
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
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No PDFs found'));
                        } else {
                          final pdfUrls = snapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 15.0,
                              childAspectRatio:
                              3.5, // Aspect ratio of grid items
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              if (index < pdfUrls.length) {
                                // Display the PDF items
                                return GridItem(
                                  pdfUrl: pdfUrls[index].fullPath,
                                  imagePath: imagePaths[index],
                                );
                              } else {
                                // Display the image at the remaining positions
                                return GridItem(
                                  imagePath: imagePaths[index],
                                );
                              }
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
                                builder: (context) => const Gallery(
                                    searchQuery:
                                    "")), // Provide a default value for searchQuery
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
  final String imagePath; // Add image path parameter

  const CurvedBackground({
    required this.child,
    required this.imagePath, // Required parameter for image path
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomCurvedEdges(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath), // Use AssetImage or NetworkImage
            fit: BoxFit.cover, // Adjust fit as needed
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
          // Set filled to true
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
    path.quadraticBezierTo(firstCurveStart.dx, firstCurveStart.dy,
        firstCurveEnd.dx, firstCurveEnd.dy);

    final secondCurveStart = Offset(0, size.height - 20);
    final secondCurveEnd = Offset(size.width - 40, size.height - 20);
    path.quadraticBezierTo(secondCurveStart.dx, secondCurveStart.dy,
        secondCurveEnd.dx, secondCurveEnd.dy);

    final thirdCurveStart = Offset(size.width, size.height - 20);
    final thirdCurveEnd = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdCurveStart.dx, thirdCurveStart.dy,
        thirdCurveEnd.dx, thirdCurveEnd.dy);

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
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
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
  final String? pdfUrl;
  final String? imagePath;

  const GridItem({
    Key? key,
    this.pdfUrl,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      // Extract the PDF name from the URL
      final pdfName = pdfUrl != null ? pdfUrl!.split('/').last.split('.pdf').first : 'Unknown';

      return GestureDetector(
        onTap: () async {
          if (pdfUrl != null) {
            final pdfRef = FirebaseStorage.instance.ref(pdfUrl);
            final url = await pdfRef.getDownloadURL();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PDFViewerScreen(
                    pdfUrl: url,
                    pdfName: pdfName),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(50), // Adjusted to make the container circular
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0), // Adjust the padding to move the image to the right
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



class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String pdfName;

  const PDFViewerScreen({Key? key, required this.pdfUrl, required this.pdfName})
      : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  void _speakText(String filePath) async {
    String apiKey = 'YOUR_ELEVEN_LABS_API_KEY';
    String voiceId = '21m00Tcm4TlvDq8ikWAM';

    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceId';
    try {
      // Read the text content from the PDF file
      String pdfText = await _extractTextFromPdf(filePath);

      if (pdfText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No text found in the PDF.')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': 'audio/mpeg',
          'xi-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "text": pdfText,
          "model_id": "eleven_monolingual_v1",
          "voice_settings": {"stability": 0.15, "similarity_boost": 0.75}
        }),
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        _audioPlayer = AudioPlayer();
        await _audioPlayer!.setAudioSource(
          ConcatenatingAudioSource(
            children: [
              AudioSource.uri(Uri.dataFromBytes(bytes, mimeType: 'audio/mpeg')),
            ],
          ),
        );
        _audioPlayer!.play();
        setState(() {
          _isPlaying = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Playback started!')),
        );

        _audioPlayer!.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() {
              _isPlaying = false;
            });
          }
        });
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unauthorized: Check your API key')),
        );
        print('Unauthorized: Check your API key');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load audio: ${response.statusCode}, ${response.reasonPhrase}')),
        );
        print('Failed to load audio: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      print('An error occurred: $e');
    }
  }

  Future<String> _extractTextFromPdf(String filePath) async {
    // Implement PDF text extraction logic here
    // For demonstration purposes, we'll return a dummy text
    return "Extracted text from PDF.";
  }

  void _stopAudio() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      setState(() {
        _isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playback stopped!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfName),
      ),
      body: FutureBuilder<String>(
        future: _downloadFile(widget.pdfUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No file available'));
          } else {
            final localPath = snapshot.data!;
            return Stack(
              children: [
                PDFView(
                  filePath: localPath,
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (_isPlaying) {
                        _stopAudio();
                      } else {
                        _speakText(localPath);
                      }
                    },
                    child: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> _downloadFile(String url) async {
    final response = await HttpClient().getUrl(Uri.parse(url));
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${Uri.parse(url).pathSegments.last}');
    await response.close().then((response) => response.pipe(file.openWrite()));
    return file.path;
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }
}
