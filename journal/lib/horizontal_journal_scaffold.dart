import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/journal.dart';
import 'welcome.dart';

class HorizontalJournalScaffold extends StatefulWidget {
  Journal journal;
  final SharedPreferences preferences;
  final void Function(bool value) updateTheme;
  final bool darkmode;

  HorizontalJournalScaffold(
      {super.key,
      required this.journal,
      required this.darkmode,
      required this.preferences,
      required this.updateTheme});

  @override
  _HorizontalJournalScaffoldState createState() =>
      _HorizontalJournalScaffoldState();
}

class _HorizontalJournalScaffoldState extends State<HorizontalJournalScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _darkmode = false;
  int currentIndex = 0;

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
      return Row(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.journal.entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title:
                          Text(widget.journal.entries[index].title as String),
                      subtitle:
                          Text(widget.journal.entries[index].date.toString()),
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      });
                }),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                              widget.journal.entries[currentIndex].title
                                  as String,
                              style: Theme.of(context).textTheme.titleLarge)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              widget.journal.entries[currentIndex].body
                                  as String,
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text(
                              widget.journal.entries[currentIndex].rating
                                  .toString(),
                              style: Theme.of(context).textTheme.bodyMedium)
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
  }
}
