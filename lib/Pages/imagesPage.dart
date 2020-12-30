import 'package:flutter/material.dart';
import 'package:nas_app/Model/AlbumApiResponse.dart';
import 'package:nas_app/Navigation/navDrawer.dart';
import 'package:nas_app/Widgets/Gallery/PhotoGallery.dart';

import "../Controllers/ImageGalleryController.dart";

class ImagesPage extends StatefulWidget {
  final String albumId;
  const ImagesPage({Key key, this.albumId}) : super(key: key);
  @override
  _ImagesPageState createState() => new _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static ImageGalleryController _imageGalleryController =
      new ImageGalleryController();

  Future<List<Asset>> _loadAssets(ImagesPage widget) async {
    List<Asset> result =
        await _imageGalleryController.getAlbums(widget.albumId);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Bilder"),
        ),
        drawer: NavDrawerWidget(),
        body: new FutureBuilder<List<Asset>>(
            future: _loadAssets(widget),
            builder: (context, AsyncSnapshot<List<Asset>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return PhotoGallery(assets: snapshot.data);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
