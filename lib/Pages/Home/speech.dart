/*
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

// Load your API key from .env file using dotenv package
String EL_API_KEY = dotenv.env['sk_3db6e98211c82f82b461ca9000380e58973a3959eb5eae2c'] as String;

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTS Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textFieldController = TextEditingController();
  final player = AudioPlayer(); // Audio player object that will play audio
  bool _isLoadingVoice = false; // For the progress indicator

  @override
  void dispose() {
    _textFieldController.dispose();
    player.dispose();
    super.dispose();
  }

  // Function to handle Text To Speech
  Future<void> playTextToSpeech(String text) async {
    setState(() {
      _isLoadingVoice = true; // Turn on progress indicator
    });

    String voiceRachel =
        '21m00Tcm4TlvDq8ikWAM'; // Rachel voice - change if you know another Voice ID

    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceRachel';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'audio/mpeg',
        'xi-api-key': EL_API_KEY,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "text": text,
        "model_id": "eleven_monolingual_v1",
        "voice_settings": {"stability": 0.15, "similarity_boost": 0.75}
      }),
    );

    setState(() {
      _isLoadingVoice = false; // Turn off progress indicator
    });

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes; // Get the bytes from ElevenLabs
      await player.setAudioSource(MyCustomSource(bytes)); // Send bytes to JustAudio
      player.play(); // Play the audio
    } else {
      // Handle error condition if API call fails
      print('Failed to load audio');
      // You can add additional error handling logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EL TTS Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                labelText: 'Enter some text',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                playTextToSpeech(_textFieldController.text);
              },
              child: _isLoadingVoice
                  ? const LinearProgressIndicator()
                  : const Icon(Icons.volume_up),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom class to feed bytes into the audio player
class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
*/
