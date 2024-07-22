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

class _AudiobookHomePageState extends State<AudiobookHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audiobook App'),
      ),
      body: Center(
        child: Text('Welcome to the Audiobook App!'),
      ),
    );
  }
}
