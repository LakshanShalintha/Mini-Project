import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../../CommonParts/CommonPages/Nav_Menu.dart';
import 'Favorite_Page.dart';

class Gallery extends StatefulWidget {
  final String searchQuery;

  const Gallery({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Future<List<Reference>>? _pdfRefs;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _pdfRefs = fetchPdfReferences(widget.searchQuery);
    FavoritesManager().loadFavorites().then((_) {
      setState(() {});
    });

    _searchController.addListener(_performSearch);
  }

  Future<List<Reference>> fetchPdfReferences(String query) async {
    final storageRef = FirebaseStorage.instance.ref();
    final files = await listAllFiles(storageRef);
    final pdfFiles = files
        .where((file) => file.name.endsWith('.pdf') && file.name.contains(query))
        .toList();
    return pdfFiles;
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

  void _performSearch() {
    setState(() {
      _pdfRefs = fetchPdfReferences(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      backgroundColor: Colors.blueGrey,
      body: GestureDetector(
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
                        hintText: 'Search in story',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _performSearch,
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
              child: FutureBuilder<List<Reference>>(
                future: _pdfRefs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No PDFs available'));
                  } else {
                    final pdfRefs = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add padding here
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 10.0, // Spacing between rows
                          childAspectRatio: 1.2, // Aspect ratio of grid items
                        ),
                        shrinkWrap: true,
                        itemCount: pdfRefs.length,
                        itemBuilder: (context, index) {
                          final pdfUrl = pdfRefs[index].fullPath;
                          final fileName = pdfRefs[index].name.split('.pdf')[0];
                          final isFavorited = FavoritesManager().isFavorite(pdfUrl);
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PDFViewerScreen(fileRef: pdfRefs[index]),
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
                                          if (isFavorited) {
                                            FavoritesManager().removeFavorite(pdfUrl).then((_) {
                                              setState(() {});
                                            });
                                          } else {
                                            FavoritesManager().addFavorite(pdfUrl).then((_) {
                                              setState(() {});
                                            });
                                          }
                                        });
                                      },
                                      child: Icon(
                                        isFavorited ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorited ? Colors.red : Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavMenu(),
    );
  }
}

class PDFViewerScreen extends StatefulWidget {
  final Reference fileRef;

  const PDFViewerScreen({required this.fileRef, Key? key}) : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  Future<void> _speakText(String text) async {
    String apiKey = 'sk_f7f3f6fb01bf3936470a7551dbebcc92755aa35bf6ceae3d';
    String voiceId = '21m00Tcm4TlvDq8ikWAM';

    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceId';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': 'audio/mpeg',
          'xi-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "text": text,
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

  Future<String> _downloadFile(Reference fileRef) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${fileRef.name}');
    await fileRef.writeToFile(file);
    return file.path;
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileRef.name.split('.pdf')[0]),
      ),
      body: FutureBuilder<String>(
        future: _downloadFile(widget.fileRef),
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
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    child: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                    onPressed: () {
                      if (_isPlaying) {
                        _stopAudio();
                      } else {
                        _speakText(localPath);
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
