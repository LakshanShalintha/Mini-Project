import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFViewerScreen extends StatefulWidget {
  final Reference fileRef;

  const PDFViewerScreen({required this.fileRef, super.key});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isTextExtracted = false;
  String extractedText = "Loading...";
  final FlutterTts flutterTts = FlutterTts();

  Future<void> extractTextFromPdf(File file) async {
    try {
      final PdfDocument document =
          PdfDocument(inputBytes: await file.readAsBytes());
      String rawText = PdfTextExtractor(document).extractText();
      String cleanedText = cleanAndFormatText(rawText);

      setState(() {
        extractedText = cleanedText;
      });

      if (kDebugMode) {
        print("Extracted Text: $extractedText");
      }
      document.dispose();
    } catch (e) {
      setState(() {
        extractedText = "Failed to extract text. Error: $e";
      });
    }
  }

  String cleanAndFormatText(String text) {
    // Retain punctuation such as .,!? and normalize spacing
    String cleanedText = text.replaceAll(RegExp(r'[^\w\s.,!?]'), '');

    // Normalize excessive spaces
    cleanedText = cleanedText.replaceAll(RegExp(r' {2,}'), ' ');

    // Normalize paragraph breaks
    cleanedText = cleanedText.replaceAll(RegExp(r'\n{2,}'), '\n\n');

    // Trim leading/trailing spaces
    cleanedText = cleanedText.trim();

    return cleanedText;
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      try {
        // Set TTS settings
        await flutterTts.setLanguage("en-US");
        await flutterTts.setPitch(1.0);
        await flutterTts.setSpeechRate(0.5); // Adjust for natural pacing
        await flutterTts.setVolume(1.0); // Ensure maximum volume

        // Ensure the text is chunked properly for long speeches
        const int chunkSize = 2000;
        for (int i = 0; i < text.length; i += chunkSize) {
          String chunk = text.substring(
              i, i + chunkSize > text.length ? text.length : i + chunkSize);
          await flutterTts.speak(chunk);
          await Future.delayed(
              const Duration(milliseconds: 500)); // Pause between chunks
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error during TTS: $e");
        }
      }
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No file available'));
          } else {
            final localPath = snapshot.data!;

            if (!_isTextExtracted) {
              _isTextExtracted =
                  true; // Set the flag to true to prevent re-extraction
              Future.microtask(() => extractTextFromPdf(File(localPath)));
            }

            return Column(
              children: [
                Expanded(
                  flex: 5, // Increase the flex value to allocate more space
                  child: PDFView(
                    filePath: localPath,
                  ),
                ),
                // Add the extracted text
                /*Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: extractedText
                            .split("\n\n") // Split text into paragraphs
                            .map((paragraph) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    paragraph,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),*/

                // Add a FloatingActionButton for audio control
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });

                        if (_isPlaying) {
                          // Start speaking
                          _speak(extractedText.substring(0, 2000));
                        } else {
                          // Stop speaking
                          flutterTts.stop();
                        }
                      },
                      tooltip: 'Read Aloud',
                      child: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
