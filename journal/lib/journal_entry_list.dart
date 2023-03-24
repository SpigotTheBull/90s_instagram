import 'package:flutter/widgets.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/journal.dart';
import 'horizontal_journal_scaffold.dart';
import 'journal_scaffold.dart';
import 'welcome.dart';

class JournalEntryList extends StatefulWidget {
  Journal? journal;
  void Function() refreshHomePage;
  final SharedPreferences preferences;
  final void Function(bool value) updateTheme;
  final void Function() loadJournal;
  final bool darkmode;

  JournalEntryList(
      {super.key,
      required this.journal,
      required this.refreshHomePage,
      required this.preferences,
      required this.updateTheme,
      required this.loadJournal,
      required this.darkmode});

  @override
  _JournalEntryListState createState() => _JournalEntryListState();
}

class _JournalEntryListState extends State<JournalEntryList> {
  bool _darkmode = false;
  @override
  void initState() {
    super.initState();
    initTheme();
    // initEntryList();
  }

  void initTheme() {
    setState(
      () {
        _darkmode = widget.darkmode;
      },
    );
  }

  // void initEntryList() {
  //   setState(() {
  //     journal = Journal(entries: widget.journalEntries);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.journal == null) {
      return const Welcome();
    } else {
      return LayoutBuilder(builder: mainLayout);
    }
  }

  Widget mainLayout(BuildContext context, BoxConstraints constraints) {
    if (constraints.maxWidth > 500) {
      return HorizontalJournalScaffold(
          journal: widget.journal as Journal,
          darkmode: _darkmode,
          preferences: widget.preferences,
          updateTheme: widget.updateTheme);
    } else {
      return JournalScaffold(
        journal: widget.journal as Journal,
        refreshHomePage: widget.refreshHomePage,
        darkmode: _darkmode,
        preferences: widget.preferences,
        updateTheme: widget.updateTheme,
      );
    }
  }
}
