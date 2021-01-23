import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nas_app/Services/FileService.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/Widgets/FloatingActionButtons/FloatingActionButtonItem.dart';
import 'package:nas_app/redux/store.dart';

class CreateAlbumFloatingActionButton extends FloatingActionButtonItem {
  IconData icon = Icons.folder;
  final Future<void> Function(String) onSelectNotification;
  CreateAlbumFloatingActionButton(this.onSelectNotification);

  void onPressed([BuildContext context]) async {
    showDialog(
        context: context,
        child: new CreateAlbumFloatingActionButtonDialog(onSelectNotification));
  }
}

class CreateAlbumFloatingActionButtonDialog extends StatefulWidget {
  final FileService fileService = new FileService();
  final PhotoService photoService = new PhotoService();
  final Future<void> Function(String) onSelectNotification;
  CreateAlbumFloatingActionButtonDialog(this.onSelectNotification);

  @override
  State createState() => new _CreateAlbumFloatingActionButtonDialogState();
}

class _CreateAlbumFloatingActionButtonDialogState
    extends State<CreateAlbumFloatingActionButtonDialog> {
  String albumName;
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
                      decoration: new InputDecoration(hintText: "Album Name"),
                      controller: _textController,
                    ),
                    new FlatButton(
                      child: new Text("Album anlegen"),
                      onPressed: () {
                        createAlbum(_textController.text);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ))));
  }

  void createAlbum(String albumName) async {
    var appState = Redux.store.state;
    var parentAssetId =
        appState.assetState.asset != null ? appState.assetState.asset.id : null;
    widget.photoService.createAlbum(albumName, parentAssetId,
        appState.userState.user.name, widget.onSelectNotification);
  }
}