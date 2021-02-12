import 'package:flutter/material.dart';
import 'package:nas_app/Model/Asset.dart';
import 'package:nas_app/Model/User.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/Widgets/Gallery/Photo.dart';
import 'package:nas_app/redux/Asset/AssetStateAction.dart';
import 'package:nas_app/redux/store.dart';
import 'package:redux/redux.dart';
import "package:responsive_grid/responsive_grid.dart";

import 'Album.dart';
import 'Video.dart';

class PhotoGallery extends StatelessWidget {
  const PhotoGallery({
    Key key,
    @required this.album,
    @required this.user,
  }) : super(key: key);

  final AlbumAsset album;
  final User user;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: goToParent,
        child: ResponsiveGridList(
            desiredItemWidth: 150,
            minSpacing: 10,
            children: album.assets.map((asset) {
              switch (asset.type) {
                case "album":
                  {
                    return Album(
                      asset: asset,
                      user: user,
                    );
                  }
                case "photo":
                  {
                    return Photo(
                        asset: asset,
                        imagesForSlider: album.assets,
                        user: user);
                  }
                case "video":
                  {
                    return Video(
                        asset: asset,
                        imagesForSlider: album.assets,
                        user: user);
                  }
              }
            }).toList()));
  }

  Future<bool> goToParent() {
    if (album.parentAsset != null) {
      Redux.store.dispatch((Store<AppState> store) =>
          fetchAssetWithChildrenAction(
              store,
              new PhotoService(),
              user.photoSessionId,
              album.parentAsset.parentAsset,
              album.parentAsset.id));

      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
