import 'package:flutter/material.dart';
import '../../CommonParts/AppBar.dart';
import '../../CommonParts/Nav_Menu.dart';
import 'Home_Screen.dart';
import 'package:file_picker/file_picker.dart';


class NewStory extends StatelessWidget {
  const NewStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create Own Story',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedBackground(
              child: Column(
                children: [
                  SizedBox(height: 25,),
                  Center(
                    child: Text(
                      'nkscnv kkcc khbdskbcbsa kahbcas\n uhikh hibkhbhda\n hgsgAHV JHSGHAVJXHVAX JADVAJVXVAX VJ'
                          'KHGAJHXBAX \nKGIAx  ckjcs xkbcbs z ',
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
            SizedBox(height: 20,),
            Text(
              'Upload Your Story',
              style: TextStyle(fontSize: 20, color: Colors.brown),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result != null) {
                  PlatformFile file = result.files.first;
                  // Use the selected file here
                  print('Selected file: ${file.name}');
                } else {
                  // User canceled the picker
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.greenAccent), // Change button color here
                padding: MaterialStateProperty.all(EdgeInsets.all(12)), // Change button padding here
              ),
              child: Text(
                'Select PDF',
                style: TextStyle(color: Colors.white), // Change text color here
              ),
            ),

            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              child: Text(
                'Upload PDF',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavMenu(),
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
    return Container(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
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
              hintText: 'Create New story',
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
              filled: true, // Set filled to true
              fillColor: Colors.white, // Set fillColor to white
            ),
          ),
        ),
        const SizedBox(height: 10), // Add spacing between the search bar and the button
        ElevatedButton(
          onPressed: () {
            // Handle button tap
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.redAccent), // Change the background color here
            fixedSize: MaterialStateProperty.all(Size(100, 40)), // Change the size of the button here
            side: MaterialStateProperty.all(BorderSide(color: Colors.orange, width: 2)), // Add border
          ),
          child: const Text(
            'Create',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),

      ],
    );
  }
}






