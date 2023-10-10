import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/enum/message_enum.dart';
import 'package:chat_app/features/chat/widget/video_play_widget.dart';
import 'package:flutter/material.dart';

class DisplayMessage extends StatelessWidget {
  final String message;
  final MessageEnum messageEnum;
  const DisplayMessage(
      {super.key, required this.message, required this.messageEnum});

  @override
  Widget build(BuildContext context) {
    bool isPlayAudio = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return messageEnum == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : messageEnum == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 100, minHeight: 80),
                  onPressed: () async {
                    if (isPlayAudio) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlayAudio = false;
                      });
                    } else {
                      await audioPlayer.play(UrlSource(message));
                      setState(() {
                        isPlayAudio = true;
                      });
                    }
                  },
                  icon: Icon(isPlayAudio? Icons.pause_circle :Icons.play_circle),
                );
              })
            : messageEnum == MessageEnum.video
                ? VideoPlayWidget(videoUrl: message)
                : Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width/1.5,
                  child: CachedNetworkImage(imageUrl: message,fit: BoxFit.cover,));
  }
}
