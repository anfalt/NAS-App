import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nas_app/Model/AlbumApiResponse.dart';

import "../Services/PhotoService.dart";
import "../globals.dart" as globals;

class ImageGalleryController {
  List<Album> albumList;

  final storage = new FlutterSecureStorage();

  Future<int> userName;
  Future<String> password;
  PhotoService photoService;

  ImageGalleryController() {
    photoService = new PhotoService();
  }
  Future<List<Album>> getAlbums() async {
    AlbumApiResponse albumResp =
        await photoService.getAlbumsRoot(globals.user.photoSessionId);

    if (!albumResp.success) {
      throw ("Fehler beim Laden der Alben: " + albumResp.error.code.toString());
    }
    albumList = albumResp.data.items;

    return albumList;
  }
}
