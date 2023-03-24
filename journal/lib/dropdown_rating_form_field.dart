import 'package:flutter/material.dart';
import 'models/journal_entry.dart';

class DropdownRatingFormField extends StatefulWidget {
  final int maxRating;
  final JournalEntry journalEntryValues;

  DropdownRatingFormField(
      {Key? key, required this.maxRating, required this.journalEntryValues})
      : super(key: key);

  @override
  DropdownRatingFormFieldState createState() => DropdownRatingFormFieldState();
}

class DropdownRatingFormFieldState extends State<DropdownRatingFormField> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
        value: selectedValue,
        items: ratingMenuItems(maxRating: widget.maxRating),
        onChanged: (menuItem) {
          setState(() => selectedValue = menuItem);
        },
        decoration:
            InputDecoration(labelText: 'Rating', border: OutlineInputBorder()),
        validator: (value) {
          if (value == null) {
            return 'Please enter a rating';
          } else {
            return null;
          }
        },
        onSaved: (newValue) {
          widget.journalEntryValues.rating = newValue;
        });
  }

  List<DropdownMenuItem<int>> ratingMenuItems({required int maxRating}) {
    return List<DropdownMenuItem<int>>.generate(maxRating, (i) {
      return DropdownMenuItem<int>(value: i + 1, child: Text('${i + 1}'));
    });
  }
}
