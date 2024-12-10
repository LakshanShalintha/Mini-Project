import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Import Syncfusion package
import 'VideoAnimation.dart';

class PDFViewerScreen extends StatefulWidget {
  final Reference fileRef;

  const PDFViewerScreen({required this.fileRef, super.key});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}


class _PDFViewerScreenState extends State<PDFViewerScreen> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isTextExtracted = false; // Flag to track text extraction
  String extractedText = "Loading...";

  Future<void> extractTextFromPdf(File file) async {
    try {
      final PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());
      String rawText = PdfTextExtractor(document).extractText();
      String cleanedText = cleanAndFormatText(rawText);

      setState(() {
        extractedText = cleanedText;
      });

      print("Extracted Text: $extractedText");
      document.dispose();
    } catch (e) {
      setState(() {
        extractedText = "Failed to extract text. Error: $e";
      });
    }
  }

  String cleanAndFormatText(String text) {
    // Remove unnecessary symbols but retain newlines
    String cleanedText = text.replaceAll(RegExp(r'[^\w\s.,\n]'), ''); // Retain letters, numbers, spaces, periods, commas, and newlines

    // Normalize multiple consecutive line breaks into one
    cleanedText = cleanedText.replaceAll(RegExp(r'\n{2,}'), '\n\n');

    // Remove any leading or trailing spaces
    cleanedText = cleanedText.trim();

    return cleanedText;
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

            if (!_isTextExtracted) {
              _isTextExtracted = true; // Set the flag to true to prevent re-extraction
              Future.microtask(() => extractTextFromPdf(File(localPath)));
            }

            return Column(
              children: [
                // Add the VideoAnimation at the top
                Container(
                  color: Colors.black12, // Optional background color for contrast
                  padding: const EdgeInsets.all(8.0),
                  child: VideoAnimation(isPlaying: _isPlaying),
                ),
                // Update the PDF viewer to take more space
                Expanded(
                  flex: 5, // Increase the flex value to allocate more space
                  child: PDFView(
                    filePath: localPath,
                  ),
                ),
                // Add the extracted text
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Text(
                        extractedText,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
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
                      },
                      child: Icon(_isPlaying ? Icons.stop : Icons.volume_up),
                    ),
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

