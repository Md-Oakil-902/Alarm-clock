import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../helper/responsive.dart';


class VideoContainer extends StatefulWidget {
  final String videoAssetPath;
  final double heightPercentage;
  final double borderRadiusPercentage;

  const VideoContainer({
    super.key,
    required this.videoAssetPath,
    this.heightPercentage = 54,
    this.borderRadiusPercentage = 35,
  });

  @override
  State<VideoContainer> createState() => _VideoContainerState();
}

class _VideoContainerState extends State<VideoContainer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAssetPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(0);
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Container(
      height: Responsive.hp(widget.heightPercentage),
      width: Responsive.wp(100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            Responsive.height(widget.borderRadiusPercentage),
          ),
          bottomRight: Radius.circular(
            Responsive.height(widget.borderRadiusPercentage),
          ),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(color: Colors.black),
    );
  }
}
