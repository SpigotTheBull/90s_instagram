import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerSection extends StatefulWidget {
  final SharedPreferences preferences;
  final void Function(bool value) updateTheme;
  final bool darkmode;

  DrawerSection(
      {super.key,
      required this.preferences,
      required this.updateTheme,
      required this.darkmode});

  @override
  _DrawerSectionState createState() => _DrawerSectionState();
}

class _DrawerSectionState extends State<DrawerSection> {
  bool _darkmode = false;

  @override
  void initState() {
    super.initState();
    initTheme();
  }

  void initTheme() {
    setState(() {
      _darkmode = widget.darkmode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
                height: 80.0, child: DrawerHeader(child: Text('Settings'))),
            SwitchListTile(
                title: const Text('Dark Mode'),
                value: _darkmode,
                onChanged: ((bool value) {
                  widget.updateTheme(value);
                  widget.preferences.setBool('darkmode', value);
                  _darkmode = value;
                }))
          ]),
    );
  }
}
