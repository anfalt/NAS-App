import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nas_app/Model/AlbumApiResponse.dart';
import 'package:nas_app/Widgets/Gallery/PhotoSlider.dart';

import "../../globals.dart" as globals;

class Video extends StatelessWidget {
  const Video({
    Key key,
    @required this.asset,
    @required this.imagesForSlider,
  }) : super(key: key);

  final Asset asset;
  final List<Asset> imagesForSlider;

  @override
  Widget build(BuildContext context) {
    var imageUrl = getThumbURL();
    var currentAssetID =
        imagesForSlider.indexWhere((note) => note.id == asset.id);
    // We're using a FutureBuilder since thumbData is a future
    return InkWell(
        onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return PhotoSlider(
                    imagesForSlider: imagesForSlider
                        .where((element) => element.type != "album")
                        .toList(),
                    currentAssetIndex: currentAssetID);
              }))
            },
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
            child: CachedNetworkImage(
              httpHeaders: {
                "Cookie":
                    "stay_login=0; PHPSESSID=" + globals.user.photoSessionId
              },
              imageUrl: imageUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).accentColor),
                        value: downloadProgress.progress,
                      )),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ));
  }

  String getThumbURL() {
    return "https://anfalt.de/photo/webapi/thumb.php?api=SYNO.PhotoStation.Thumb&method=get&version=1&size=small&id=" +
        this.asset.id +
        "&thumb_sig=" +
        this.asset.additional.thumbSize.sig +
        "&mtime=" +
        this.asset.additional.thumbSize.small.mtime.toString() +
        "&SynoToken=" +
        globals.user.photoSessionId;
  }
}
