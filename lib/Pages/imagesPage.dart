import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/Model/Asset.dart';
import 'package:nas_app/Navigation/appBottomNavBar.dart';
import 'package:nas_app/Services/FileService.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/Widgets/FloatingActionButtons/ImagePage/ImageFloatingActionButton.dart';
import 'package:nas_app/Widgets/Gallery/PhotoGallery.dart';
import 'package:nas_app/redux/Asset/AssetState.dart';
import 'package:nas_app/redux/Asset/AssetStateAction.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/store.dart';
import 'package:open_file/open_file.dart';
import 'package:redux/redux.dart';

class ImagesPage extends StatefulWidget {
  final String albumId;
  const ImagesPage({Key key, this.albumId}) : super(key: key);
  @override
  _ImagesPageState createState() => new _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  TextEditingController _textController = new TextEditingController();
  FileService fileService;
  PhotoService photoService = new PhotoService();
  @override
  void initState() {
    fileService = new FileService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    var albumId = widget.albumId;
    if ((albumId == null || albumId == "") && arguments != null) {
      albumId = arguments["albumId"];
    }
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch((store) => {
              fetchAssetWithChildrenAction(store, photoService,
                  store.state.userState.user.photoSessionId, null, albumId)
            }),
        builder: (context, appState) {
          return Scaffold(
              appBar: AppBar(
                title: Text(getAppBarText(appState.assetState)),
                actions:
                    getAppBarActions(appState.assetState, appState.userState),
              ),
              floatingActionButton: getFloatingActionButton(
                  appState.assetState, appState.userState),
              bottomNavigationBar: AppBottomNav(),
              body: (() {
                if (!appState.assetState.isLoading) {
                  if (appState.assetState.isError) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      showFailedDialog(
                          context, appState.assetState.errorMessage);
                    });
                  }
                  return PhotoGallery(
                    user: appState.userState.user,
                    album: appState.assetState.asset,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }()));
        });
  }

  String getAppBarText(AssetState assetState) {
    if (assetState.isLoading) {
      return "";
    }
    if (assetState != null &&
        assetState.asset != null &&
        assetState.asset.info != null &&
        assetState.asset.info.title != null &&
        assetState.asset.info.title != "") {
      return assetState.asset.info.title;
    } else {
      return "Bilder";
    }
  }

  showFailedDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Fehler beim Laden der Bilder"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget getFloatingActionButton(AssetState assetState, UserState userState) {
    if (assetState.asset == null || assetState.asset.assets == null) {
      return Container();
    }
    if (assetState.asset.additional.albumPermission.manage) {
      return ImageFloatingActionButton(true);
    } else if (assetState.asset.additional.albumPermission.upload) {
      return ImageFloatingActionButton(false);
    } else {
      return Container();
    }
  }

  List<Widget> getAppBarActions(AssetState assetState, UserState userState) {
    List<Widget> appBarActions = [];
    if (assetState.asset == null || assetState.asset.assets == null) {
      return appBarActions;
    }
    var markedAssets = assetState.asset.assets.where((el) {
      return el.isMarked;
    });

    if (markedAssets.length > 0) {
      appBarActions.add(IconButton(
          icon: Icon(Icons.download_sharp),
          onPressed: () => {downloadAssets(markedAssets, userState)}));

      appBarActions.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => {deleteAssets(markedAssets, userState)}));
    }

    if (markedAssets.length == 1 && markedAssets.first.type == "album") {
      appBarActions.add(IconButton(
          icon: Icon(Icons.edit),
          onPressed: () =>
              {displayAlbumEditDialog(context, markedAssets.toList()[0])}));
    }

    appBarActions.add(IconButton(
        icon: Icon(Icons.refresh), onPressed: () => {reloadAsset(userState)}));
    return appBarActions;
  }

  void reloadAsset(UserState userState) {
    Redux.store.dispatch((Store<AppState> store) =>
        fetchAssetWithChildrenAction(
            store,
            photoService,
            userState.user.photoSessionId,
            store.state.assetState.asset.parentAsset,
            store.state.assetState.asset.id));
  }

  void downloadAssets(Iterable<AlbumAsset> assets, UserState userState) {
    assets.forEach((element) {
      var downloadUrl;
      var fileName = element.additional.fileLocation;
      if (element.type == "video") {
        downloadUrl = element.getVideoDownloadUrls(userState.user).values.first;
        fileService.download(
            fileName, downloadUrl, "GET", _onSelectNotificationDownload);
      } else if (element.type == "photo") {
        downloadUrl = element.getImageDownloadUrl(userState.user);
        var body = element.getImageDownloadBody(userState.user);
        fileService.download(
            fileName, downloadUrl, "POST", _onSelectNotificationDownload, body);
      }
    });
  }

  void deleteAssets(Iterable<AlbumAsset> assets, UserState userState) {
    var photoAndVideoAssetIds = assets
        .where((element) => element.type == "photo" || element.type == "video")
        .map((el) => el.id)
        .toList();

    var albumAssets =
        assets.where((element) => element.type == "album").toList();

    if (albumAssets.length > 0) {
      List<String> albumsToDelete = [];
      albumAssets.forEach((element) {
        if (element.additional.itemCount.photo > 0 ||
            element.additional.itemCount.video > 0) {
          showFailedDialog(
              context,
              "Album '" +
                  element.info.name +
                  "' enthält Bilder oder Videos und wird nicht gelöscht");
        } else {
          albumsToDelete.add(element.id);
        }
      });
      photoService.deleteAlbum(albumsToDelete.toList(), userState.user.name,
          _onSelectNotificationDelete);
    }

    if (photoAndVideoAssetIds.length > 0) {
      photoService.deletePhoto(photoAndVideoAssetIds, userState.user.name,
          _onSelectNotificationDelete);
    }
  }

  Future<void> _onSelectNotificationDownload(String json) async {
    final obj = jsonDecode(json);

    if (obj['success']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  Future<void> _onSelectNotificationDelete(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  void displayAlbumEditDialog(BuildContext context, AlbumAsset markedAsset) {
    _textController.text = markedAsset.info.title;
    var dialog = new Dialog(
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
                    new TextButton(
                      child: new Text("Speichern "),
                      onPressed: () {
                        updateAlbum(markedAsset.id, _textController.text);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ))));

    showDialog(context: context, builder: (_) => dialog);
  }

  void updateAlbum(String assetId, String newAlbumName) {
    photoService.updateAlbum(
        assetId,
        newAlbumName,
        Redux.store.state.userState.user.name,
        Redux.store.state.userState.user.photoSessionId,
        _onSelectNotificationDelete);
  }
}
