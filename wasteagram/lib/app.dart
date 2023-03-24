import 'package:flutter/material.dart';
import 'screens/list_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasteagram',
      theme: ThemeData.dark(),
      home: const ListScreen(),
    );
  }
}
