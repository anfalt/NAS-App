
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as localNot;
import 'package:nas_app/Services/FileService.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/Widgets/FloatingActionButtons/FloatingActionButtonItem.dart';
import 'package:nas_app/redux/Asset/AssetStateAction.dart';
import 'package:nas_app/redux/store.dart';
import 'package:path/path.dart' as path;
import 'package:redux/redux.dart';

class UploadImageFloatingActionButton extends FloatingActionButtonItem {
  FileService? fileService;
  PhotoService? photoService;
  Future<void> Function(String)? onSelectNotification;
  localNot.FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  UploadImageFloatingActionButton(
      Future<void> Function(String) onSelectNotification) {
    fileService = new FileService();
    photoService = new PhotoService();
    this.onSelectNotification = onSelectNotification;
  }

  IconData? icon = Icons.image;

  void onPressed(BuildContext context) async {
    var pickedFiles = await fileService!.getImagesFromLocalSystem();
    var appState = Redux.store!.state;
    var albumPath = appState.assetState!.asset!.info!.sharepath;
    pickedFiles.forEach((element) async {
      String filePath =
          await FlutterAbsolutePath.getAbsolutePath(element.identifier);
      String fileName = path.basename(filePath);
      await photoService!.uploadPhoto(appState.userState!.user!.photoSessionId!,
          filePath, fileName, albumPath!, onSelectNotification!);
      Redux.store!.dispatch((Store<AppState> store) =>
          fetchAssetWithChildrenAction(
              store,
              photoService!,
              appState.userState!.user!.photoSessionId!,
              store.state.assetState!.asset!.parentAsset,
              store.state!.assetState!.asset?.id));
    });
  }
}
