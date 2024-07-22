// create Text_to_speech.dart file
//1 Project Setup

import 'package:flutter/material.dart';

void main() {
  runApp(AudiobookApp());
}

class AudiobookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audiobook App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudiobookHomePage(),
    );
  }
}

class AudiobookHomePage extends StatefulWidget {
  @override
  _AudiobookHomePageState createState() => _AudiobookHomePageState();
}
