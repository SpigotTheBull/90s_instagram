import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wasteagram/widgets/camera_widget.dart';

// ignore: must_be_immutable
class NewPost extends StatefulWidget {
  File? image;

  NewPost({super.key});
  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasteagram'),
        centerTitle: true,
      ),
      body: CameraWidget(),
    );
  }
}
