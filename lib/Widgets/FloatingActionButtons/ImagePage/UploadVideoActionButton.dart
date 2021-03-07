import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as localNot;
import 'package:nas_app/Services/FileService.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/Widgets/FloatingActionButtons/FloatingActionButtonItem.dart';
import 'package:nas_app/redux/Asset/AssetStateAction.dart';
import 'package:nas_app/redux/store.dart';
import 'package:path/path.dart' as path;
import 'package:redux/redux.dart';

class UploadVideoFloatingActionButton extends FloatingActionButtonItem {
  FileService fileService;
  PhotoService photoService;
  Future<void> Function(String) onSelectNotification;
  localNot.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  UploadVideoFloatingActionButton(
      Future<void> Function(String) onSelectNotification) {
    fileService = new FileService();
    photoService = new PhotoService();
    this.onSelectNotification = onSelectNotification;
  }

  IconData icon = Icons.video_library;

  void onPressed(BuildContext context) async {
    var filePath = await fileService.getVideoFromLocalSystem();
    var appState = Redux.store.state;
    var albumPath = appState.assetState.asset.info.sharepath;
    var fileName = path.basename(filePath);
    await photoService.uploadVideo(appState.userState.user.photoSessionId,
        filePath, fileName, albumPath, onSelectNotification);
    Redux.store.dispatch((Store<AppState> store) =>
        fetchAssetWithChildrenAction(
            store,
            photoService,
            appState.userState.user.photoSessionId,
            store.state.assetState.asset.parentAsset,
            store.state.assetState.asset.id));
  }
}
