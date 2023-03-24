import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'models/journal_entry.dart';
import 'drawer.dart';
import 'floating_action_button.dart';
import 'models/journal.dart';
import 'journal_entry_form.dart';
import 'journal_entry_list.dart';
import 'welcome.dart';

const SCHEMA_PATH = 'assets/schema_1.sql.txt';

class App extends StatefulWidget {
  final SharedPreferences preferences;

  const App({super.key, required this.preferences});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _darkmode = false;
  List<JournalEntry> journalEntries = [];
  Journal? journal;

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  void initState() {
    super.initState();
    initTheme();
    // initJournal();
    loadJournal();
  }

  void initTheme() {
    setState(() {
      _darkmode = widget.preferences.getBool('darkmode') ?? false;
    });
  }

  void updateTheme(bool value) {
    setState(() {
      _darkmode = value;
    });
  }

  void initJournal() async {
    await deleteDatabase('journal.sqlite3.db');
  }

  void loadJournal() async {
    final Database database = await openDatabase(
      'journal.sqlite3.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(await rootBundle.loadString(SCHEMA_PATH));
      },
    );
    List<Map> journalRecords =
        await database.rawQuery('SELECT * FROM journal_entries;');
    // print('Loading $journalRecords');
    journalEntries = journalRecords.map((record) {
      return JournalEntry(
        title: record['title'],
        body: record['body'],
        date: DateTime.parse(record['date']),
        rating: record['rating'],
      );
    }).toList();
    setState(() {
      journal = Journal(entries: journalEntries);
    });
    // print('List is $journalEntries');
  }

  void refreshHomePage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal',
      theme: getTheme(),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Journal Entries'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: _openEndDrawer,
              icon: const Icon(Icons.settings_rounded),
            )
          ],
        ),
        body: JournalEntryList(
          journal: journal,
          refreshHomePage: refreshHomePage,
          preferences: widget.preferences,
          updateTheme: updateTheme,
          loadJournal: loadJournal,
          darkmode: _darkmode,
        ),
        endDrawer: DrawerSection(
          darkmode: _darkmode,
          preferences: widget.preferences,
          updateTheme: updateTheme,
        ),
        floatingActionButton: FloatingActionButtonScaffold(
          preferences: widget.preferences,
          updateTheme: updateTheme,
          loadJournal: loadJournal,
          darkmode: _darkmode,
        ),
        endDrawerEnableOpenDragGesture: false,
      ),
    );
  }

  ThemeData getTheme() {
    if (_darkmode == true) {
      return ThemeData.dark();
    } else {
      return ThemeData.light();
    }
  }
}
