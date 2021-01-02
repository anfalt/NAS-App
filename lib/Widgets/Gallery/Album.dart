import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nas_app/Model/Asset.dart';
import 'package:nas_app/Model/User.dart';
import 'package:nas_app/Services/PhotoService.dart';
import 'package:nas_app/redux/Asset/AssetStateAction.dart';
import 'package:nas_app/redux/store.dart';

class Album extends StatelessWidget {
  const Album({
    Key key,
    @required this.user,
    @required this.asset,
  }) : super(key: key);
  final User user;
  final AlbumAsset asset;

  @override
  Widget build(BuildContext context) {
    var thumbNailUrl;
    if (asset.thumbnailStatus != "default") {
      thumbNailUrl = asset.getSmallThumbURL(user);
    }

    var themeData = Theme.of(context);

    // We're using a FutureBuilder since thumbData is a future
    return InkWell(
        onTap: () => {openAlbum(asset.id)},
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
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
              child: cardStack(thumbNailUrl, themeData)),
        ));
  }

  Widget cardStack(String thumbNailUrl, ThemeData themeData) {
    return Stack(children: [
      Container(
        height: 200,
        decoration: (() {
          if (thumbNailUrl != null) {
            return BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(thumbNailUrl, headers: {
                      "Cookie": "stay_login=0; PHPSESSID=" + user.photoSessionId
                    })));
          } else {
            return BoxDecoration(color: Colors.grey[350]);
          }
        }()),
      ),
      Container(
          height: 200.0,
          decoration: BoxDecoration(
              color: asset.isMarked ? themeData.accentColor : Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.9),
                  ],
                  stops: [
                    0.0,
                    0.7,
                    1.0
                  ])),
          child: Column(verticalDirection: VerticalDirection.up, children: [
            ListTile(
              title: Text(asset.info.title),
            )
          ])),
      Positioned(
        top: 0.0,
        right: 0.0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (() {
              if (asset.isMarked) {
                return Icon(Icons.check,
                    color: themeData.accentIconTheme.color);
              } else {
                return Container();
              }
            }())),
      )
    ]);
  }

  void openAlbum(String assetId) {
    var store = Redux.store;
    store.dispatch((store) => {
          fetchAssetWithChildrenAction(
              store,
              new PhotoService(),
              store.state.userState.user.photoSessionId,
              asset.parentAsset,
              assetId)
        });
  }
}
