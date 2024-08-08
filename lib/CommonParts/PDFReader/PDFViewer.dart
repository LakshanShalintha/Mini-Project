import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../Pages/Home/Home_Screen.dart';
import 'VideoAnimation.dart';  // Update this path according to your project structure

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
    // Your text-to-speech implementation...
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

  void _toggleAudio() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
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
                VideoAnimation(isPlaying: _isPlaying),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    child: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                    onPressed: _toggleAudio,
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
