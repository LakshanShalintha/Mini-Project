import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this import
import '../../CommonParts/AIParts.dart';
import '../../CommonParts/AppBar.dart';
import '../../CommonParts/Nav_Menu.dart';
import 'Home_Screen.dart';
import 'StoryDisplay.dart';

import 'dart:io';
import 'package:file_picker/file_picker.dart'; // Import file picker package
import 'package:firebase_storage/firebase_storage.dart'; // Import firebase storage package
import 'package:flutter/foundation.dart'; // For kIsWeb

class NewStory extends StatelessWidget {
  const NewStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: const CustomAppBar(
        title: 'Create Own Story',
      ),*/
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CurvedBackground(
              textBeforeLine: '',
              textAfterLine: '',
              child: Column(
                children: [
                  SizedBox(height: 75,),
                  Center(
                    child: Text(
                      'Create Own Story',
                      style: TextStyle(color: Colors.white, fontSize: 28,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                    child: SearchBar(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            const Text(
              'You Can Upload Your PDF Here',
              style: TextStyle(fontSize: 18, color: Colors.brown,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),
            /*ElevatedButton(
              onPressed: () async {
                // File picking logic for PDF
                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

                if (result != null) {
                  File file = File(result.files.single.path!);

                  // Upload file to Firebase Storage
                  try {
                    final storageRef = FirebaseStorage.instance.ref().child('stories/${result.files.single.name}');
                    final uploadTask = storageRef.putFile(file);

                    await uploadTask.whenComplete(() async {
                      final downloadUrl = await storageRef.getDownloadURL();
                      // You can use the download URL as needed
                      print('File uploaded successfully. Download URL: $downloadUrl');
                      // Handle success (e.g., show a message or navigate to another screen)
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('File uploaded successfully: $downloadUrl'))
                      );
                    });
                  } catch (e) {
                    // Handle errors (e.g., show an error message)
                    print('Error uploading file: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error uploading file: $e'))
                    );
                  }
                } else {
                  // Handle user cancelation or error
                  print('No file selected');
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No file selected'))
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              child: const Text(
                'Select File',
                style: TextStyle(color: Colors.black),
              ),
            ),*/

            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                // File picking logic for PDF
                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

                if (result != null) {
                  File file = File(result.files.single.path!);

                  // Upload file to Firebase Storage
                  try {
                    final storageRef = FirebaseStorage.instance.ref().child('stories/${result.files.single.name}');
                    final uploadTask = storageRef.putFile(file);

                    await uploadTask.whenComplete(() async {
                      final downloadUrl = await storageRef.getDownloadURL();
                      // You can use the download URL as needed
                      print('File uploaded successfully. Download URL: $downloadUrl');
                      // Handle success (e.g., show a message or navigate to another screen)
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('File uploaded successfully: $downloadUrl'))
                      );
                    });
                  } catch (e) {
                    // Handle errors (e.g., show an error message)
                    print('Error uploading file: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error uploading file: $e'))
                    );
                  }
                } else {
                  // Handle user cancelation or error
                  print('No file selected');
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No file selected'))
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
                fixedSize: MaterialStateProperty.all(const Size(100, 40)),
                side: MaterialStateProperty.all(const BorderSide(color: Colors.orange, width: 2)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              child: const Text(
                'Browse',
                style: TextStyle(color: Colors.black),
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
  final String textBeforeLine;
  final String textAfterLine;

  const CurvedBackground({
    required this.child,
    required this.textBeforeLine,
    required this.textAfterLine,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500, // Adjust the height as needed
      child: ClipPath(
        clipper: CustomCurvedEdges(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Home_Page/new story.jpeg'), // Add your background image here
              fit: BoxFit.cover,
            ),
            color: Colors.black87,
          ),
          child: Stack(
            children: [
              // Line and text before and after the line
              Positioned(
                top: MediaQuery.of(context).size.height * 0.5, // Adjust this value as needed
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text before the line
                      Text(
                      'A       u       a       i       R       A       B',
                        style: TextStyle(
                          color: Colors.white, // Color of the text
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Adjust the font size as needed
                        ),
                      ),
                      SizedBox(height: 4), // Space between the text and the line
                      Container(
                        width: double.infinity,
                        height: 3, // Thickness of the line
                        color: Colors.white, // Color of the line
                        margin: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      SizedBox(height: 40), // Space between the line and the text
                      // Text after the line
                      Text(
                        'Upload Your Story',
                        style: TextStyle(
                          color: Colors.white, // Color of the text
                          fontWeight: FontWeight.bold,
                          fontSize: 26, // Adjust the font size as needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Other positioned widgets
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
    this.backgroundColor = Colors.blueAccent,
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
  final AIServices _aiService = AIServices();
  bool _isLoading = false; // State variable to track loading status
  TextEditingController _controller = TextEditingController();

  Future<void> _generateStory() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final response = await _aiService.generateStory(_controller.text);

    // Decode the JSON response
    final decodedResponse = jsonDecode(response);

    // Extract the content from the chapters
    String storyContent = 'Story not found';
    String storyTitle = 'Story not found';

    if (decodedResponse != null && decodedResponse['chapters'] != null && decodedResponse['chapters'].isNotEmpty) {
      storyContent = decodedResponse['chapters'][0]['content'] ?? 'Content not found';
      storyTitle = decodedResponse['chapters'][0]['title'] ?? 'title not found';
    }

    setState(() {
      _isLoading = false; // End loading
    });

    // Navigate to StoryDisplayScreen with the extracted story content
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryDisplayScreen(
          title: _controller.text, // Use the entered text as the title
          story: storyContent, // Pass the extracted content
          storyJson: storyTitle, // Pass the original JSON response as a String
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Create New Story',
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : ElevatedButton(
          onPressed: _generateStory,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange),
            fixedSize: MaterialStateProperty.all(const Size(100, 40)),
            side: MaterialStateProperty.all(const BorderSide(color: Colors.orange, width: 2)),
          ),
          child: const Text(
            'Create',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

