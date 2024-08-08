import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';

class MusicAnimation extends StatelessWidget {
  final bool isPlaying;

  const MusicAnimation({Key? key, required this.isPlaying}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        child: FlareActor(
          'assets/Animation/petal_20240807_165641.mp4',
          animation: isPlaying ? 'play' : 'stop',
        ),
      ),
    );
  }
}
