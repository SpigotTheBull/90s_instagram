// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:wasteagram/widgets/new_entry_button.dart';
import 'package:wasteagram/screens/detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wasteagram'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var post = snapshot.data!.docs[index];
                return Semantics(
                  enabled: true,
                  button: true,
                  label:
                      'See details of the food waste product such as quantity, latititude/longitude during post, date and image of wasted food',
                  child: ListTile(
                    leading: Text(post['date']),
                    trailing: Text(post['quantity'].toString()),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return DetailScreen(post: post);
                      }),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Semantics(
          enabled: true,
          button: true,
          label:
              'Retrieve a picture of a wasted food item from your phone\'s gallery',
          child: const NewEntryButton()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
