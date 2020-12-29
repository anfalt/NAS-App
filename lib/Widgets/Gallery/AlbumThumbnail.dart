import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nas_app/Model/AlbumApiResponse.dart';

import "../../globals.dart" as globals;

class AlbumThumbnail extends StatelessWidget {
  const AlbumThumbnail({
    Key key,
    @required this.asset,
  }) : super(key: key);

  final Album asset;

  @override
  Widget build(BuildContext context) {
    var thumbNailUrl;
    if (asset.thumbnailStatus != "default") {
      thumbNailUrl = getThumbnailURL();
    }

    // We're using a FutureBuilder since thumbData is a future
    return new Container(
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
            child: Container(
                height: 200,
                decoration: BoxDecoration(
                  image: (() {
                    if (thumbNailUrl != null) {
                      return DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.7), BlendMode.dstATop),
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(thumbNailUrl,
                              headers: {
                                "Cookie": "stay_login=0; PHPSESSID=" +
                                    globals.user.photoSessionId
                              }));
                    }
                  }()),
                ),
                child: Column(children: [
                  ListTile(
                    title: Text(asset.info.title),
                  )
                ]))));
  }

  String getThumbnailURL() {
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
