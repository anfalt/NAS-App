
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nas_app/Services/ListService.dart';
import 'package:nas_app/Widgets/FloatingActionButtons/FloatingActionButtonItem.dart';

class AddListFloatingActionButton extends FloatingActionButtonItem {
  IconData? icon = Icons.folder;
  final Future<void> Function(String) onSelectNotification;
  AddListFloatingActionButton(this.onSelectNotification);

  void onPressed([BuildContext? context]) async {
    showDialog(
        context: context!,
        builder:(BuildContext context)=> new AddListFloatingActionButtonDialog(onSelectNotification));
  }
}

class AddListFloatingActionButtonDialog extends StatefulWidget {
  final ListService listService = new ListService();
  final Future<void> Function(String) onSelectNotification;
  AddListFloatingActionButtonDialog(this.onSelectNotification);

  @override
  State createState() => new _AddListFloatingActionButtonDialogState();
}

class _AddListFloatingActionButtonDialogState
    extends State<AddListFloatingActionButtonDialog> {
  String? albumName;
  IconData icon = Icons.image;
  TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Dialog(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: new Container(
                height: 100,
                child: ListView(
                  children: <Widget>[
                    new TextField(
                      decoration: new InputDecoration(hintText: "Listen Name"),
                      controller: _textController,
                    ),
                    new TextButton(
                      child: new Text("Liste anlegen"),
                      onPressed: () {
                        createList(_textController.text);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ))));
  }

  void createList(String listName) async {
    widget.listService.createList(listName, widget.onSelectNotification);
  }
}
