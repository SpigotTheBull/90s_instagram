import 'package:flutter/material.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/journal.dart';
import 'drawer.dart';
import 'welcome.dart';

class JournalScaffold extends StatefulWidget {
  Journal journal;
  void Function() refreshHomePage;
  final SharedPreferences preferences;
  final void Function(bool value) updateTheme;
  final bool darkmode;

  JournalScaffold(
      {super.key,
      required this.journal,
      required this.refreshHomePage,
      required this.darkmode,
      required this.preferences,
      required this.updateTheme});

  @override
  _JournalScaffoldState createState() => _JournalScaffoldState();
}

class _JournalScaffoldState extends State<JournalScaffold> {
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
    if (widget.journal.entries.isEmpty) {
      return const Welcome();
    } else {
      return ListView.builder(
          itemCount: widget.journal.entries.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(widget.journal.entries[index].title as String),
              subtitle: Text(widget.journal.entries[index].date.toString()),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                      title:
                          Text(widget.journal.entries[index].date.toString()),
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
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(widget.journal.entries[index].title as String,
                                style: Theme.of(context).textTheme.titleLarge)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.journal.entries[index].body as String,
                                style: Theme.of(context).textTheme.bodyMedium),
                            Text(
                                widget.journal.entries[index].rating.toString(),
                                style: Theme.of(context).textTheme.bodyMedium)
                          ],
                        )
                      ],
                    ),
                  ),
                  endDrawerEnableOpenDragGesture: false,
                );
              })),
            );
          });
    }
  }
}
