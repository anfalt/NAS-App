import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:nas_app/Model/Asset.dart';
import 'package:nas_app/Navigation/navDrawer.dart';
import 'package:nas_app/Services/FileService.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/Widgets/FloatingActionButtons/ImageFloatingActionButton.dart';
import 'package:nas_app/Widgets/Gallery/PhotoGallery.dart';
import 'package:nas_app/redux/Asset/AssetState.dart';
import 'package:nas_app/redux/Asset/AssetStateAction.dart';
import 'package:nas_app/redux/User/UserState.dart';
import 'package:nas_app/redux/store.dart';
import 'package:open_file/open_file.dart';

class ImagesPage extends StatefulWidget {
  final String albumId;
  const ImagesPage({Key key, this.albumId}) : super(key: key);
  @override
  _ImagesPageState createState() => new _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FileService fileService;
  PhotoService photoService = new PhotoService();
  @override
  void initState() {
    fileService = new FileService(_onSelectNotification);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch((store) => {
              fetchAssetWithChildrenAction(
                  store,
                  photoService,
                  store.state.userState.user.photoSessionId,
                  null,
                  widget.albumId)
            }),
        builder: (context, appState) {
          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(getAppBarText(appState.assetState)),
                actions:
                    getAppBarActions(appState.assetState, appState.userState),
              ),
              floatingActionButton: getFloatingActionButton(
                  appState.assetState, appState.userState),
              drawer: NavDrawerWidget(),
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
    if (assetState != null &&
        assetState.asset != null &&
        assetState.asset.info != null &&
        assetState.asset.info.title != null) {
      return assetState.asset.info.title;
    } else {
      return "Bilder";
    }
  }

  showFailedDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = FlatButton(
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
    }
    return appBarActions;
  }

  void downloadAssets(Iterable<AlbumAsset> assets, UserState userState) {
    assets.forEach((element) {
      var downloadUrl;
      var fileName = element.additional.fileLocation;
      if (element.type == "video") {
        downloadUrl = element.getVideoDownloadUrls(userState.user).values.first;
        fileService.download(fileName, downloadUrl, "GET");
      } else if (element.type == "photo") {
        downloadUrl = element.getImageDownloadUrl(userState.user);
        var body = element.getImageDownloadBody(userState.user);
        fileService.download(fileName, downloadUrl, "POST", body);
      }
    });
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
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
}
