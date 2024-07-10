import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this import
import '../../CommonParts/AppBar.dart';
import '../../CommonParts/Nav_Menu.dart';
import 'Home_Screen.dart';

class NewStory extends StatelessWidget {
  const NewStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Create Own Story',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CurvedBackground(
              child: Column(
                children: [
                  SizedBox(height: 25,),
                  Center(
                    child: Text(
                      'nkscnv kkcc khbdskbcbsa kahbcas\n uhikh hibkhbhda\n hgsgAHV JHSGHAVJXHVAX JADVAJVXVAX VJ'
                          'KHGAJHXBAX \nKGIAx  jhbfjdb hufhwebh ubwuhdb uywdhbwhsd hhbckjcs xkbcbs z ',
                      style: TextStyle(color: Colors.black, fontSize: 18),
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
              'Upload Your Story',
              style: TextStyle(fontSize: 20, color: Colors.brown),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                // Handle button press
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
            ),

            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              child: const Text(
                'Upload PDF',
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

  const CurvedBackground({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Adjust the height as needed
      child: ClipPath(
        clipper: CustomCurvedEdges(),
        child: Container(
          color: Colors.purpleAccent,
          padding: const EdgeInsets.all(0),
          child: SizedBox(
            height: 320,
            child: Stack(
              children: [
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
  bool _isFocused = false;
  TextEditingController _controller = TextEditingController();
  String _story = '';

  Future<void> generateStory(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer sk-DLNgw68cJCEHd6JJYUYjT3BlbkFJX8RUPSfgjizQj7TkNBTEYOUR_API_KEY_HERE',
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 100,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _story = data['choices'][0]['text'];
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoryDisplayScreen(story: _story),
        ),
      );
    } else {
      throw Exception('Failed to generate story');
    }
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
            onTap: () {
              setState(() {
                _isFocused = true;
              });
            },
            onEditingComplete: () {
              setState(() {
                _isFocused = false;
              });
            },
            decoration: InputDecoration(
              hintText: 'Create New Story',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
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
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            generateStory(_controller.text);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.redAccent),
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

class StoryDisplayScreen extends StatelessWidget {
  final String story;

  const StoryDisplayScreen({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Generated Story',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            story,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      bottomNavigationBar: const NavMenu(),
    );
  }
}