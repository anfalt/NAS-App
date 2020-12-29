import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nas_app/Model/AlbumApiResponse.dart';
import 'package:nas_app/bloc/nav_drawer_bloc.dart';
import 'package:nas_app/bloc/nav_drawer_event.dart';
import 'package:nas_app/bloc/nav_drawer_state.dart';

import "../../globals.dart" as globals;

class AlbumThumbnail extends StatelessWidget {
  const AlbumThumbnail({
    Key key,
    @required this.asset,
  }) : super(key: key);

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    var thumbNailUrl;
    if (asset.thumbnailStatus != "default") {
      thumbNailUrl = getThumbnailURL();
    }

    // We're using a FutureBuilder since thumbData is a future
    return InkWell(
        onTap: () => {
              BlocProvider.of<NavDrawerBloc>(context)
                  .add(NavigateTo(NavItem.imagePage, {"albumId": asset.id}))
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
              clipBehavior: Clip.antiAlias, child: cardStack(thumbNailUrl)),
        ));
  }

  Widget cardStack(String thumbNailUrl) {
    return Stack(children: [
      Container(
        height: 200,
        decoration: (() {
          if (thumbNailUrl != null) {
            return BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(thumbNailUrl, headers: {
                      "Cookie": "stay_login=0; PHPSESSID=" +
                          globals.user.photoSessionId
                    })));
          } else {
            return BoxDecoration(color: Colors.grey[350]);
          }
        }()),
      ),
      Container(
          height: 200.0,
          decoration: BoxDecoration(
              color: Colors.white,
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
          ]))
    ]);
  }

  void openAlbum(String albumId) {}

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
