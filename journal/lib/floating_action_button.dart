import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'journal_entry_form.dart';

class FloatingActionButtonScaffold extends StatefulWidget {
  final SharedPreferences preferences;
  final void Function(bool value) updateTheme;
  final void Function() loadJournal;
  final bool darkmode;

  FloatingActionButtonScaffold(
      {super.key,
      required this.preferences,
      required this.updateTheme,
      required this.loadJournal,
      required this.darkmode});

  @override
  _FloatingActionButtonScaffoldState createState() =>
      _FloatingActionButtonScaffoldState();
}

class _FloatingActionButtonScaffoldState
    extends State<FloatingActionButtonScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _darkmode = false;

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  void initState() {
    super.initState();
    initTheme();
  }

  void initTheme() {
    setState(
      () {
        _darkmode = widget.darkmode;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(context,
          MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              title: const Text('Journal Entry'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  onPressed: _openEndDrawer,
                  icon: const Icon(Icons.settings_rounded),
                )
              ]),
          endDrawer: DrawerSection(
            darkmode: _darkmode,
            preferences: widget.preferences,
            updateTheme: widget.updateTheme,
          ),
          body: JournalEntryForm(
            loadJournal: widget.loadJournal,
          ),
          endDrawerEnableOpenDragGesture: false,
        );
      })),
      child: const Icon(Icons.add),
    );
  }
}
