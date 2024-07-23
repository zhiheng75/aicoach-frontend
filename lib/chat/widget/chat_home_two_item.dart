import 'package:Bubble/scene/entity/scene_entity.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class ChatHomeTwoItem extends StatefulWidget {
  final SceneEntity data;
  const ChatHomeTwoItem({super.key, required this.data});

  @override
  State<ChatHomeTwoItem> createState() => _ChatHomeTwoItemState();
}

class _ChatHomeTwoItemState extends State<ChatHomeTwoItem> {
  @override
  Widget build(BuildContext context) {
    return LoadImage(
      widget.data.cover,
      fit: BoxFit.fitWidth,
    );
  }
}
