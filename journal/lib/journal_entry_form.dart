import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'models/journal_entry.dart';
import 'dropdown_rating_form_field.dart';

const SCHEMA_PATH = 'assets/schema_1.sql.txt';

class JournalEntryForm extends StatefulWidget {
  final void Function() loadJournal;

  const JournalEntryForm({super.key, required this.loadJournal});

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  final formKey = GlobalKey<FormState>();
  final journalEntryValues = JournalEntry();

  String? dropdownValidator(dynamic value) {
    if (value!.isEmpty()) {
      return 'Please enter a rating';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                  labelText: 'Title', border: OutlineInputBorder()),
              onSaved: (newValue) {
                journalEntryValues.title = newValue;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a title';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Body', border: OutlineInputBorder()),
                onSaved: (newValue) {
                  journalEntryValues.body = newValue;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  } else {
                    return null;
                  }
                }),
            const SizedBox(
              height: 8.0,
            ),
            DropdownRatingFormField(
              maxRating: 4,
              journalEntryValues: journalEntryValues,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState?.save();
                        addDateToJournalEntryValues();
                        // await deleteDatabase('journal.sqlite3.db');
                        final Database database = await openDatabase(
                          'journal.sqlite3.db',
                          version: 1,
                          onCreate: (Database db, int version) async {
                            await db.execute(
                                await rootBundle.loadString(SCHEMA_PATH));
                          },
                        );
                        database.transaction((txn) async {
                          await txn.rawInsert(
                              'INSERT INTO journal_entries(title, body, rating, date) VALUES(?, ?, ?, ?);',
                              [
                                journalEntryValues.title,
                                journalEntryValues.body,
                                journalEntryValues.rating,
                                journalEntryValues.date.toString(),
                              ]);
                          // await database.close();
                        });
                        Navigator.pop(context);
                        widget.loadJournal();
                      }
                    },
                    child: const Text('Save'))
              ],
            )
          ],
        ),
      ),
    );
  }

  void addDateToJournalEntryValues() {
    DateFormat dateFormat = DateFormat("EEE, MMM d, ''yy");
    String dateFormatString = dateFormat.format(DateTime.now());
    journalEntryValues.date = dateFormat.parse(dateFormatString);
  }
}
