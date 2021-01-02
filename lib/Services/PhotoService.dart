import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nas_app/Model/ApiResponses/AlbumApiResponse.dart';
import 'package:nas_app/Model/ApiResponses/AlbumInfoApiResponse.dart';
import 'package:nas_app/Model/User.dart';

import './NetworkService.dart';

class PhotoService {
  User currentUser;

  Dio dio;

  PhotoService() {
    dio = NetworkService.getDioInstance();
  }

  Future<AlbumApiResponse> getAssets(String sessionId, [String albumId]) async {
    var url = "/photo/webapi/album.php";
    var queryParameters = {
      "api": "SYNO.PhotoStation.Album",
      "method": "list",
      "version": 1,
      "limit": 1000,
      "type": "album,photo,video",
      "offset": 0,
      "additional":
          "album_permission,thumb_size,file_location,item_count,video-Codec,video_quality",
      "SynoToken": sessionId
    };

    if (albumId != null) {
      queryParameters["id"] = albumId;
    }

    AlbumApiResponse apiResponse = new AlbumApiResponse();
    try {
      var response = await dio.get(url, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new AlbumApiError();
      apiResponse.error.message = e.toString();
    }

    return apiResponse;
  }

  Future<AlbumInfoApiResponse> getAlbumInfo(String sessionId,
      [String albumId]) async {
    var url = "/photo/webapi/album.php";
    var queryParameters = {
      "api": "SYNO.PhotoStation.Album",
      "method": "getinfo",
      "version": 1,
      "additional": "album_permission",
      "id": albumId,
      "SynoToken": sessionId
    };

    AlbumInfoApiResponse apiResponse = new AlbumInfoApiResponse();
    try {
      var response = await dio.get(url, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumInfoApiResponse.fromJson(responseData);
    } catch (e) {
      apiResponse.success = false;
      apiResponse.error = new AlbumInfoApiError();
      apiResponse.error.message = e.toString();
    }

    return apiResponse;
  }
}
