import 'dart:io';

import 'package:chat_app/common/enum/message_enum.dart';
import 'package:chat_app/common/provider/message_replay_provider.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/features/chat/widget/message_replay_perview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String reciverUserId;
  const BottomChatField({super.key, required this.reciverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController controllerMessage = TextEditingController();
  FlutterSoundRecorder? soundRecorder;
  bool isRecodInit = false;
  bool isRecod = false;
  bool isShowSendBtn = false;

  @override
  void initState() {
    super.initState();
    soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose() {
    controllerMessage.dispose();
    soundRecorder!.closeRecorder();
    isRecodInit = false;
    print('dispos');
    super.dispose();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not Allowed');
    }
    await soundRecorder!.openRecorder();
    isRecodInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendBtn || controllerMessage.text.isNotEmpty) {
      ref.read(chatController).sendTextMessage(
          context, controllerMessage.text, widget.reciverUserId);
      setState(() {
        controllerMessage.text = '';
        isShowSendBtn = false;
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecodInit) {
        return;
      }
      if (isRecod) {
        await soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecod = !isRecod;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref
        .read(chatController)
        .sendFileMessage(context, file, widget.reciverUserId, messageEnum);
  }

  void selectImage() async {
    File? image = await pickImageGalery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    try {
      File? video = await pickVideoGalery(context);
      if (video != null) {
        sendFileMessage(video, MessageEnum.video);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReplay = ref.watch(messageReplayProvider);
    final isShowMessageReply = messageReplay != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplayPervie():SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controllerMessage,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isShowSendBtn = true;
                    });
                  } else {
                    setState(() {
                      isShowSendBtn = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 80,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.gif_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
              child: GestureDetector(
                onTap: sendTextMessage,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 25,
                  child: Icon(
                    isShowSendBtn
                        ? Icons.send_rounded
                        : isRecod
                            ? Icons.close
                            : Icons.mic_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
