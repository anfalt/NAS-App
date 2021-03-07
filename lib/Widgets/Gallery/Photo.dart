import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nas_app/Model/Asset.dart';
import 'package:nas_app/Model/User.dart';
import 'package:nas_app/Widgets/Gallery/PhotoSlider.dart';
import 'package:nas_app/redux/Asset/AssetStateAction.dart';
import 'package:nas_app/redux/store.dart';

class Photo extends StatelessWidget {
  const Photo({
    Key key,
    @required this.asset,
    @required this.imagesForSlider,
    @required this.user,
  }) : super(key: key);

  final AlbumAsset asset;
  final User user;
  final List<AlbumAsset> imagesForSlider;

  @override
  Widget build(BuildContext context) {
    var imageUrl;
    if (asset.thumbnailStatus.contains("small")) {
      imageUrl = asset.getSmallThumbURL(user);
    } else if (asset.thumbnailStatus.contains("preview")) {
      imageUrl = asset.getPreviewThumbURL(user);
    } else if (asset.thumbnailStatus.contains("large")) {
      imageUrl = asset.getSmallThumbURL(user);
    }
    var markedAssets = Redux.store.state.assetState.asset.assets.where((el) {
      return el.isMarked;
    });
    var currentAssetIndex =
        imagesForSlider.indexWhere((note) => note.id == asset.id);
    // We're using a FutureBuilder since thumbData is a future
    return InkWell(
        onLongPress: () => {
              Redux.store.dispatch(
                  (store) => {fetchAssetMarkedAction(store, asset.id)})
            },
        onTap: () => {
              if (markedAssets.length > 0)
                {
                  Redux.store.dispatch(
                      (store) => {fetchAssetMarkedAction(store, asset.id)})
                }
              else
                {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return PhotoSlider(
                        imagesForSlider: imagesForSlider
                            .where((element) => element.type != "album")
                            .toList(),
                        currentAssetIndex: currentAssetIndex,
                        user: user);
                  }))
                }
            },
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color:
                  asset.isMarked ? Theme.of(context).accentColor : Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(children: [
                getThumbNail(imageUrl),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (() {
                        if (asset.isMarked) {
                          return Icon(Icons.check,
                              color: Theme.of(context).accentIconTheme.color);
                        } else {
                          return Container();
                        }
                      }())),
                )
              ])),
        ));
  }

  Widget getThumbNail(String thumbNailUrl) {
    if (thumbNailUrl != null) {
      try {
        return CachedNetworkImage(
          httpHeaders: {
            "Cookie": "stay_login=0; PHPSESSID=" + user.photoSessionId
          },
          imageUrl: thumbNailUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: LinearProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    value: downloadProgress.progress,
                  )),
          errorWidget: (context, url, error) => Icon(Icons.error),
        );
      } catch (e) {
        return Icon(Icons.error);
      }
    } else {
      return Container();
    }
  }
}
