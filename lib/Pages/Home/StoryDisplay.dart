import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryDisplayScreen extends StatefulWidget {
  final String title;
  final String story;
  final String storyJson;

  const StoryDisplayScreen({
    Key? key,
    required this.title,
    required this.story,
    required this.storyJson,
  }) : super(key: key);

  @override
  _StoryDisplayScreenState createState() => _StoryDisplayScreenState();
}

class _StoryDisplayScreenState extends State<StoryDisplayScreen> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _savePdfToFirebase(widget.title, widget.story, widget.storyJson, context);
  }

  void _speakText(String text, BuildContext context) async {
    String apiKey = 'sk_f7f3f6fb01bf3936470a7551dbebcc92755aa35bf6ceae3d';
    String voiceId = '21m00Tcm4TlvDq8ikWAM';
    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceId';

    // Reduce the text payload size for testing
    String reducedText = text.length > 500 ? text.substring(0, 500) : text;

    int retryCount = 0;
    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 5);

    while (retryCount < maxRetries) {
      try {
        final response = await http
            .post(
          Uri.parse(url),
          headers: {
            'accept': 'audio/mpeg',
            'xi-api-key': apiKey,
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "text": reducedText,
            "model_id": "eleven_monolingual_v1",
            "voice_settings": {"stability": 0.15, "similarity_boost": 0.75}
          }),
        )
            .timeout(Duration(seconds: 60)); // Increased timeout duration

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final buffer = bytes.buffer;
          final source = await AudioSource.uri(
            Uri.dataFromBytes(
              buffer.asUint8List(),
              mimeType: 'audio/mpeg',
            ),
          );
          _audioPlayer = AudioPlayer();
          await _audioPlayer!.setAudioSource(source);
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
          return; // Exit the loop if successful
        } else if (response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unauthorized: Check your API key')),
          );
          print('Unauthorized: Check your API key');
          return; // Exit the loop if unauthorized
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to load audio: ${response.statusCode}, ${response.reasonPhrase}')),
          );
          print(
              'Failed to load audio: ${response.statusCode}, ${response.reasonPhrase}');
          return; // Exit the loop if other error occurs
        }
      } on SocketException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
        print('Network error: $e');
        retryCount++;
        if (retryCount >= maxRetries) {
          return; // Exit the loop if maximum retries reached
        } else {
          await Future.delayed(retryDelay); // Wait before retrying
        }
      } on TimeoutException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request timed out: $e')),
        );
        print('Request timed out: $e');
        retryCount++;
        if (retryCount >= maxRetries) {
          return; // Exit the loop if maximum retries reached
        } else {
          await Future.delayed(retryDelay); // Wait before retrying
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
        print('An error occurred: $e');
        return; // Exit the loop for any other error
      }
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

  List<String> splitStoryIntoPages(String story, int maxLinesPerPage) {
    List<String> pages = [];
    List<String> lines = story.split('\n');
    int lineCount = 0;
    StringBuffer currentPage = StringBuffer();

    for (String line in lines) {
      if (lineCount < maxLinesPerPage) {
        currentPage.writeln(line);
        lineCount++;
      } else {
        pages.add(currentPage.toString());
        currentPage.clear();
        currentPage.writeln(line);
        lineCount = 1;
      }
    }

    // Add the last page if it has content
    if (currentPage.isNotEmpty) {
      pages.add(currentPage.toString());
    }

    return pages;
  }

  Future<void> _savePdfToFirebase(String title, String story, String storyJson, BuildContext context) async {
    // Check if the story content indicates that no story was found or content not found
    if (story == 'Story not found' || storyJson == 'Story not found' || story == 'Content not found') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid story content. Upload cancelled.')),
      );
      return;
    }

    final pdf = pw.Document();
    int maxLinesPerPage = 40; // Adjust this value based on your content and layout
    List<String> pages = splitStoryIntoPages(story, maxLinesPerPage);

    for (int i = 0; i < pages.length; i++) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (i == 0) ...[
                  pw.Align(
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      title.toUpperCase(), // Convert text to uppercase
                      style: pw.TextStyle(
                        fontSize: 30,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(storyJson, style: pw.TextStyle(fontSize: 18, color: PdfColors.red)),
                  pw.SizedBox(height: 20),
                ],
                pw.Text(pages[i], style: pw.TextStyle(fontSize: 16, color: PdfColors.black)),
              ],
            );
          },
        ),
      );
    }

    try {
      final Uint8List pdfBytes = await pdf.save();
      final storageRef = FirebaseStorage.instance.ref().child('stories/$title.pdf');
      final uploadTask = storageRef.putData(pdfBytes);

      uploadTask.snapshotEvents.listen((taskSnapshot) {
        if (taskSnapshot.state == TaskState.running) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload is in progress...')),
          );
        }
      });

      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('stories').add({
        'title': title,
        'pdf_url': downloadUrl,
        'story_json': storyJson,
        'story': story,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white10,
                  Colors.black26,
                  Colors.white,
                  Colors.yellowAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.storyJson,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.story,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (_isPlaying) {
                  _stopAudio();
                } else {
                  _speakText(widget.story, context);
                }
              },
              child: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }
}
