import 'package:flutter/material.dart';
import 'package:nas_app/Model/AlbumApiResponse.dart';
import 'package:nas_app/Widgets/Gallery/Photo.dart';
import "package:responsive_grid/responsive_grid.dart";

import 'AlbumThumbnail.dart';
import 'Video.dart';

class PhotoGallery extends StatelessWidget {
  const PhotoGallery({
    Key key,
    @required this.assets,
  }) : super(key: key);

  final List<Asset> assets;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
        desiredItemWidth: 150,
        minSpacing: 10,
        children: assets.map((asset) {
          switch (asset.type) {
            case "album":
              {
                return AlbumThumbnail(asset: asset);
              }
            case "photo":
              {
                return Photo(asset: asset, imagesForSlider: assets);
              }
            case "video":
              {
                return Video(asset: asset, imagesForSlider: assets);
              }
          }
        }).toList());
  }
}
