import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  TextEditingController _textEditingController = TextEditingController();

  addData(String text, ctx) {
    Navigator.of(ctx).pop();
    FirebaseFirestore.instance
        .collection('chats/3okFKLl8GKUe9SMHiY7i/massages')
        .add({'text': _textEditingController.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/3okFKLl8GKUe9SMHiY7i/massages')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            var spdata = snapshot.data.docs;

            return ListView.builder(
              itemCount: spdata.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(child: Text(spdata[index]['text']));
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Add Massage'),
                  content: TextField(
                    controller: _textEditingController,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () =>
                            addData(_textEditingController.text, context),
                        child: Text('Add'))
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
