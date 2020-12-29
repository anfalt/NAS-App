import 'package:flutter/material.dart';
import 'package:nas_app/Model/AlbumApiResponse.dart';
import "package:responsive_grid/responsive_grid.dart";

import "../Controllers/ImageGalleryController.dart";
import "../Widgets/Gallery/AlbumThumbnail.dart";

class ImagesPage extends StatefulWidget {
  @override
  _ImagesPageState createState() => new _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  static ImageGalleryController _imageGalleryController =
      new ImageGalleryController();

  Future<List<Album>> _loadAssets = Future<List<Album>>(() async {
    List<Album> result = await _imageGalleryController.getAlbums();
    return result;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new FutureBuilder<List<Album>>(
            future: _loadAssets,
            builder: (context, AsyncSnapshot<List<Album>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return assetGrid(snapshot.data);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget assetGrid(List<Album> assets) {
    return ResponsiveGridList(
        desiredItemWidth: 150,
        minSpacing: 10,
        children: assets.map((asset) {
          return AlbumThumbnail(asset: asset);
        }).toList());
  }
}
