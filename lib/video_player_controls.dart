import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:icons_plus/icons_plus.dart';

class VideoPlayerControls extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoPlayerControls({super.key, required this.controller});

  @override
  State<VideoPlayerControls> createState() => _VideoPlayerControlsState();
}

class _VideoPlayerControlsState extends State<VideoPlayerControls> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(LineAwesome.backward_solid, color: Colors.white, size: 30),
              onPressed: () {
                final newPosition = widget.controller.value.position - const Duration(seconds: 10);
                widget.controller.seekTo(newPosition);
              },
            ),
            IconButton(
              icon: Icon(
                widget.controller.value.isPlaying ? LineAwesome.pause_solid : LineAwesome.play_solid,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                setState(() {
                  widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
                });
              },
            ),
            IconButton(
              icon: const Icon(LineAwesome.forward_solid, color: Colors.white, size: 30),
              onPressed: () {
                final newPosition = widget.controller.value.position + const Duration(seconds: 10);
                widget.controller.seekTo(newPosition);
              },
            ),
          ],
        ),
      ),
    );
  }
}
