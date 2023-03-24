import 'package:flutter/material.dart';
import 'package:wasteagram/screens/new_post.dart';

class NewEntryButton extends StatefulWidget {
  const NewEntryButton({super.key});

  @override
  State<NewEntryButton> createState() => _NewEntryButtonState();
}

class _NewEntryButtonState extends State<NewEntryButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return NewPost();
          }));
        },
        child: const Icon(Icons.camera_alt));
  }
}
