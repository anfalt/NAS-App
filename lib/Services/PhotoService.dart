import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as localNot;
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:nas_app/Model/ApiResponses/AlbumApiResponse.dart';
import 'package:nas_app/Model/ApiResponses/AlbumInfoApiResponse.dart';
import 'package:nas_app/Model/Asset.dart';
import 'package:nas_app/Model/User.dart';
import 'package:nas_app/redux/store.dart';

import './NetworkService.dart';

class PhotoService {
  User? currentUser;

  localNot.FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  Dio? dio;

  PhotoService() {
    dio = NetworkService.getDioInstance();
  }

  Future<AlbumApiResponse> getAssets(String sessionId,
      [String? albumId]) async {
    var url = "/photo/webapi/album.php";
    var queryParameters = {
      "api": "SYNO.PhotoStation.Album",
      "method": "list",
      "version": 1,
      "limit": 1000,
      "type": "album,photo,video",
      "offset": 0,
      "sort_by": "preference",
      "sort_direction": "desc",
      "additional":
          "album_permission,thumb_size,file_location,item_count,video-Codec,video_quality",
      "SynoToken": sessionId
    };

    if (albumId != null) {
      queryParameters["id"] = albumId;
    }

    AlbumApiResponse apiResponse = new AlbumApiResponse();
    try {
      var response = await dio!.get(url, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new AlbumApiError();
      apiResponse.error!.message = e.toString();
    }

    return apiResponse;
  }

  Future<AlbumApiResponse> uploadPhoto(
      String sessionId,
      String filePath,
      String fileName,
      String destPath,
      Future<void> Function(String) onSelectNotification) async {
    initNotificationsPlugin(onSelectNotification);

    var url = "/photo/webapi/file.php";
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    var store = Redux.store;
    if (filePath.toLowerCase().endsWith("heic")) {
      filePath = await HeicToJpg.convert(filePath);
      fileName = fileName.toLowerCase().replaceAll("heic", "jpg");
    }

    FormData formdata = new FormData.fromMap({
      "api": "SYNO.PhotoStation.File",
      "method": "uploadphoto",
      "version": 1,
      "dest_folder_path": destPath,
      "duplicate": "rename",
      "filename": fileName,
      "mtime": timeStamp,
      "original": MultipartFile.fromFileSync(filePath, filename: fileName)
    });

    var queryParameters = {"SynoToken": sessionId};
    AlbumApiResponse apiResponse = new AlbumApiResponse();
    try {
      var response = await dio!
          .post(url, data: formdata, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new AlbumApiError();
      apiResponse.error!.message = e.toString();
    }

    _showNotificationUpload(
        fileName, apiResponse.toJson(), store!.state!.assetState!.asset!);

    return apiResponse;
  }

  Future<AlbumApiResponse> uploadVideo(
      String sessionId,
      String filePath,
      String fileName,
      String destPath,
      Future<void> Function(String) onSelectNotification) async {
    initNotificationsPlugin(onSelectNotification);

    var url = "/photo/webapi/file.php";
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    var store = Redux.store;
    FormData formdata = new FormData.fromMap({
      "api": "SYNO.PhotoStation.File",
      "method": "uploadvideo",
      "version": 1,
      "dest_folder_path": destPath,
      "duplicate": "rename",
      "filename": fileName,
      "mtime": timeStamp,
      "original": MultipartFile.fromFileSync(filePath, filename: fileName)
    });

    var queryParameters = {"SynoToken": sessionId};
    AlbumApiResponse apiResponse = new AlbumApiResponse();
    try {
      var response = await dio!
          .post(url, data: formdata, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new AlbumApiError();
      apiResponse.error!.message = e.toString();
    }

    _showNotificationUpload(
        fileName, apiResponse.toJson(), store!.state.assetState!.asset!);

    return apiResponse;
  }

  Future<AlbumApiResponse> createAlbum(
      String albumname,
      String parentAlbumId,
      String userName,
      Future<void> Function(String) onSelectNotification) async {
    initNotificationsPlugin(onSelectNotification);
    var url = "/photo/webapi/album.php";

    dynamic formdata = {
      "name": albumname,
      "id": parentAlbumId,
      "api": "SYNO.PhotoStation.Album",
      "method": "create",
      "version": 1,
      "ps_username": userName
    };

    AlbumApiResponse apiResponse = new AlbumApiResponse();
    try {
      var response = await dio!.post(url,
          data: formdata,
          options: Options(
              contentType: "application/x-www-form-urlencoded",
              headers: {
                "X-SYNO-TOKEN":
                    Redux.store!.state!.userState!.user!.photoSessionId
              }));
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
      _showNotificationAlbumCreate(apiResponse.toJson());
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new AlbumApiError();
      apiResponse.error!.message = e.toString();
    }

    return apiResponse;
  }

  Future<AlbumApiResponse> deleteAlbum(List<String> assetIds, String userName,
      Future<void> Function(String) onSelectNotification) async {
    initNotificationsPlugin(onSelectNotification);
    var url = "/photo/webapi/album.php";

    dynamic formdata = {
      "id": assetIds.join(","),
      "api": "SYNO.PhotoStation.Album",
      "method": "delete",
      "version": 1,
      "ps_username": userName
    };

    AlbumApiResponse apiResponse = new AlbumApiResponse();
    try {
      var response = await dio!.post(url,
          data: formdata,
          options: Options(
              contentType: "application/x-www-form-urlencoded",
              headers: {
                "X-SYNO-TOKEN":
                    Redux.store!.state!.userState!.user!.photoSessionId
              }));
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
      _showNotificationDelete(apiResponse.toJson());
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new AlbumApiError();
      apiResponse.error!.message = e.toString();
    }

    return apiResponse;
  }

  Future<AlbumApiResponse> updateAlbum(
      String assetId,
      String albunName,
      String userName,
      String sessionId,
      Future<void> Function(String) onSelectNotification) async {
    initNotificationsPlugin(onSelectNotification);
    var url = "/photo/webapi/album.php";

    dynamic formdata = {
      "id": assetId,
      "api": "SYNO.PhotoStation.Album",
      "method": "edit",
      "version": 1,
      "ps_username": userName,
      "title": albunName
    };

    AlbumApiResponse apiResponse = new AlbumApiResponse();
    try {
      var response = await dio!.post(url,
          data: formdata,
          options: Options(
              contentType: "application/x-www-form-urlencoded",
              headers: {"X-SYNO-TOKEN": sessionId}));
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
      _showNotificationUpdate(apiResponse.toJson());
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new AlbumApiError();
      apiResponse.error!.message = e.toString();
    }

    return apiResponse;
  }

  Future<AlbumApiResponse> getLatestAssets(String sessionId,
      [String? albumId]) async {
    var url = "/photo/webapi/photo.php";
    var queryParameters = {"SynoToken": sessionId};

    dynamic formdata = {
      "api": "SYNO.PhotoStation.Photo",
      "method": "list",
      "version": 1,
      "limit": 100,
      "type": "photo,video",
      "offset": 0,
      "force_update": true,
      "sort_by": "createdate",
      "additional":
          "album_permission,thumb_size,file_location,item_count,video-Codec,video_quality",
      "sort_direction": "desc",
    };

    AlbumApiResponse apiResponse = new AlbumApiResponse();
    try {
      var response = await dio!.post(url,
          queryParameters: queryParameters,
          data: formdata,
          options: Options(
              contentType: "application/x-www-form-urlencoded",
              headers: {"X-SYNO-TOKEN": sessionId}));
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
      apiResponse.data!.items = apiResponse.data!.items.where((asset) {
        if (asset.info!.createdate == null) {
          return false;
        }
        return DateTime.parse(asset.info!.createdate!)
            .isAfter(new DateTime.now().add(new Duration(days: -7)));
      }).toList();
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new AlbumApiError();
      apiResponse.error!.message = e.toString();
    }

    return apiResponse;
  }

  Future<AlbumApiResponse> deletePhoto(List<String> assetIds, String userName,
      Future<void> Function(String) onSelectNotification) async {
    initNotificationsPlugin(onSelectNotification);
    var url = "/photo/webapi/photo.php";

    dynamic formdata = {
      "id": assetIds.join(","),
      "api": "SYNO.PhotoStation.Photo",
      "method": "delete",
      "version": 1,
      "ps_username": userName
    };

    AlbumApiResponse apiResponse = new AlbumApiResponse();
    try {
      var response = await dio!.post(url,
          data: formdata,
          options: Options(
              contentType: "application/x-www-form-urlencoded",
              headers: {
                "X-SYNO-TOKEN":
                    Redux.store!.state!.userState!.user!.photoSessionId
              }));
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumApiResponse.fromJson(responseData);
      _showNotificationDelete(apiResponse.toJson());
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new AlbumApiError();
      apiResponse.error!.message = e.toString();
    }

    return apiResponse;
  }

  Future<AlbumInfoApiResponse> getAlbumInfo(String sessionId,
      [String? albumId]) async {
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
      var response = await dio!.get(url, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = AlbumInfoApiResponse.fromJson(responseData);
    } catch (e) {
      apiResponse.success = false;
      apiResponse.error = new AlbumInfoApiError();
      apiResponse.error!.message = e.toString();
    }

    return apiResponse;
  }

  initNotificationsPlugin(onSelectNotification) {
    flutterLocalNotificationsPlugin =
        localNot.FlutterLocalNotificationsPlugin();
    final android =
        localNot.AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = localNot.IOSInitializationSettings();
    final initSettings =
        localNot.InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin!
        .initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  Future<void> _showNotificationUpload(String fileName,
      Map<String, dynamic> uploadStatus, AlbumAsset asset) async {
    final android = localNot.AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: localNot.Priority.high, importance: localNot.Importance.max);
    final iOS = localNot.IOSNotificationDetails();
    final platform =
        new localNot.NotificationDetails(android: android, iOS: iOS);
    uploadStatus["click_action"] = "FLUTTER_NOTIFICATION_CLICK";
    uploadStatus["screen"] = "images";
    uploadStatus["asset"] = jsonEncode(asset.toJson());
    final json = jsonEncode(uploadStatus);

    final isSuccess = uploadStatus['success'];

    await flutterLocalNotificationsPlugin!.show(
        Random().nextInt(100), // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File ' + fileName + ' has been uploaded successfully!'
            : 'There was an error while uploaded the file.',
        platform,
        payload: json);
  }

  Future<void> _showNotificationUpdate(
      Map<String, dynamic> uploadStatus) async {
    final android = localNot.AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: localNot.Priority.high, importance: localNot.Importance.max);
    final iOS = localNot.IOSNotificationDetails();
    final platform =
        new localNot.NotificationDetails(android: android, iOS: iOS);

    final json = jsonEncode(uploadStatus);

    final isSuccess = uploadStatus['success'];

    await flutterLocalNotificationsPlugin!.show(
        Random().nextInt(100), // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'Albumhas been updated successfully!'
            : 'There was an error while updating the album.',
        platform,
        payload: json);
  }

  Future<void> _showNotificationDelete(
    Map<String, dynamic> downloadStatus,
  ) async {
    final android = localNot.AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: localNot.Priority.high, importance: localNot.Importance.max);
    final iOS = localNot.IOSNotificationDetails();
    final platform =
        new localNot.NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['success'];

    await flutterLocalNotificationsPlugin!.show(
        Random().nextInt(100), // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'Files have been deleted!'
            : 'There was an error while deleting the file.',
        platform,
        payload: json);
  }

  Future<void> _showNotificationAlbumCreate(
    Map<String, dynamic> downloadStatus,
  ) async {
    final android = localNot.AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: localNot.Priority.high, importance: localNot.Importance.max);
    final iOS = localNot.IOSNotificationDetails();
    final platform =
        new localNot.NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['success'];

    await flutterLocalNotificationsPlugin!.show(
        Random().nextInt(100), // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'Album has been created!'
            : 'There was an error creating the album.',
        platform,
        payload: json);
  }
}
