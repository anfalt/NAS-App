import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nas_app/Model/AlbumApiResponse.dart';
import 'package:nas_app/Model/User.dart';

import './NetworkService.dart';

class PhotoService {
  User currentUser;

  Dio dio;

  PhotoService() {
    dio = NetworkService.getDioInstance();
  }

  Future<AlbumApiResponse> getAlbums(String sessionId, [String albumId]) async {
    var url = "/photo/webapi/album.php";
    var queryParameters = {
      "api": "SYNO.PhotoStation.Album",
      "method": "list",
      "version": 1,
      "limit": 50,
      "type": "album,photo,video",
      "offset": 0,
      "additional": "album_permission,thumb_size,file_location,item_count",
      "SynoToken": sessionId
    };

    if (albumId != null) {
      queryParameters["id"] = albumId;
    }

    AlbumApiResponse apiResponse;
    try {
      var response = await dio.get(url, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
    }

    return apiResponse;
  }
}
