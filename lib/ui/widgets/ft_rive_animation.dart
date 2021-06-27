import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class FTRiveAnimation extends StatefulWidget {
  final String url;

  const FTRiveAnimation({Key? key, required this.url}) : super(key: key);

  @override
  _FTRiveAnimationState createState() => _FTRiveAnimationState();
}

class _FTRiveAnimationState extends State<FTRiveAnimation> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Is the animation currently playing?
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _controller = OneShotAnimation(
      'bounce',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _isPlaying ? null : _controller.isActive = true,
      child: SizedBox(
        height: 200,
        child: RiveAnimation.network(
          widget.url,
          animations: const ['idle', 'curves'],
          controllers: [_controller],
        ),
      ),
    );
  }
}
