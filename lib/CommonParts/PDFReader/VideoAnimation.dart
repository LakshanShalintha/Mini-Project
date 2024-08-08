import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VideoAnimation extends StatefulWidget {
  final bool isPlaying;

  const VideoAnimation({Key? key, required this.isPlaying}) : super(key: key);

  @override
  _VideoAnimationState createState() => _VideoAnimationState();
}

class _VideoAnimationState extends State<VideoAnimation> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/Music.mp4');
      final ref = FirebaseStorage.instance.ref().child('animation/Music.mp4');

      if (!await tempFile.exists()) {
        await ref.writeToFile(tempFile);
      }

      _controller = VideoPlayerController.file(tempFile)
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
            _isLoading = false;
          });
          if (widget.isPlaying) {
            _controller?.play();
            _controller?.setLooping(true);
          }
        });
    } catch (e) {
      print("Error initializing video: $e");
      setState(() {
        _isInitialized = false;
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(VideoAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying) {
      _controller?.play();
      _controller?.setLooping(true);
    } else {
      _controller?.pause();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _isInitialized
            ? AspectRatio(
          aspectRatio: _controller?.value.aspectRatio ?? 1.0,
          child: VideoPlayer(_controller!),
        )
            : Center(child: Text('Video failed to load')),
      ),
    );
  }
}
