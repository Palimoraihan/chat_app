import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayWidget> createState() => _VideoPlayWidgetState();
}

class _VideoPlayWidgetState extends State<VideoPlayWidget> {
  late CachedVideoPlayerController controllerVid;
  bool isPlay = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerVid = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        controllerVid.setVolume(1);
      });
  }

  @override
  void dispose() {
    controllerVid.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(controllerVid),
          IconButton(
            onPressed: () {
              if (isPlay) {
                controllerVid.pause();
              } else {
                controllerVid.play();
              }
              setState(() {
                isPlay = !isPlay;
              });
            },
            icon: Icon(isPlay? Icons.pause_circle:Icons.play_circle),
          ),
        ],
      ),
    );
  }
}
