import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class FTRiveAnimation extends StatefulWidget {
  final String fullFileName;

  const FTRiveAnimation({Key key, @required this.fullFileName})
      : super(key: key);

  @override
  _FTRiveAnimationState createState() => _FTRiveAnimationState();
}

class _FTRiveAnimationState extends State<FTRiveAnimation> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load(widget.fullFileName).then(
      (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('idle'));
          setState(() => _riveArtboard = artboard);

          _controller.isActiveChanged.addListener(() {
            if (_controller.isActive) {
              print('Animation started playing');
            } else {
              print('Animation stopped playing');
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _controller.isActive = !_controller.isActive),
      child: SizedBox(
        height: 200,
        child: Rive(
          artboard: _riveArtboard,
        ),
      ),
    );
  }
}
