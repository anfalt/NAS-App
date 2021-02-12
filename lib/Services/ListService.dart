import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as localNot;
import 'package:nas_app/Model/ApiResponses/ListApiResponse.dart';
import 'package:nas_app/redux/store.dart';

import './NetworkService.dart';

localNot.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class ListService {
  final encrypter = Encrypter(
      AES(Key.fromUtf8("myAPIKeyForInternalUse1234567890"), mode: AESMode.cbc));
  final iv = IV.fromLength(16);

  Dio dio;
  String token;

  ListService() {
    dio = NetworkService.getDioInstance();
    token = getEncryptedToken();
  }

  Future<AllListsResponse> getAllLists() async {
    var queryParameters = {"token": token};
    var url = "/app/api/readLists.php";

    AllListsResponse apiResponse = new AllListsResponse();
    try {
      var response = await dio.get(url, queryParameters: queryParameters);
      apiResponse = AllListsResponse.fromJson(response.data);
      apiResponse.success = true;
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.errorMessage = e.toString();
    }

    return apiResponse;
  }

  Future<ListApiResponse> deleteList(String listId) async {
    ;
    var token = getEncryptedToken();
    var queryParameters = {
      "token": token,
    };
    var url = "/app/api/deleteList.php";

    dynamic formdata = {
      "ID": listId,
    };

    ListApiResponse apiResponse = new ListApiResponse();
    try {
      var response =
          await dio.post(url, data: formdata, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = ListApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.errorMessage = e.toString();
    }

    return apiResponse;
  }

  Future<ListApiResponse> deleteListItem(String listitemId) async {
    var token = getEncryptedToken();
    var queryParameters = {
      "token": token,
    };
    var url = "/app/api/deleteListItem.php";

    var formdata = {"ID": listitemId};

    ListApiResponse apiResponse = new ListApiResponse();
    try {
      var response =
          await dio.post(url, data: formdata, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = ListApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.errorMessage = e.toString();
    }

    return apiResponse;
  }

  Future<ListApiResponse> createList(String listName,
      Future<void> Function(String) onSelectNotification) async {
    initNotificationsPlugin(onSelectNotification);
    var token = getEncryptedToken();
    var queryParameters = {
      "token": token,
    };
    var url = "/app/api/createList.php";

    var formdata = {
      "Title": listName,
    };

    ListApiResponse apiResponse = new ListApiResponse();
    try {
      var response = await dio.post(url,
          data: jsonEncode(formdata), queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = ListApiResponse.fromJson(responseData);
      _showNotificationCreated(apiResponse.toJson());
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.errorMessage = e.toString();
    }

    return apiResponse;
  }

  Future<ListApiResponse> createListItem(
      String listItemname, String listId) async {
    var token = getEncryptedToken();
    var queryParameters = {
      "token": token,
    };
    var url = "/app/api/createListItem.php";

    dynamic formdata = {"Title": listItemname, 'ListID': listId};

    ListApiResponse apiResponse = new ListApiResponse();
    try {
      var response =
          await dio.post(url, data: formdata, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = ListApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.errorMessage = e.toString();
    }

    return apiResponse;
  }

  Future<ListApiResponse> updateList(String listName, String listId) async {
    var token = getEncryptedToken();
    var queryParameters = {
      "token": token,
    };
    var url = "/app/api/updateList.php";

    dynamic formdata = {
      "ID": listId,
      "Title": listName,
    };

    ListApiResponse apiResponse = new ListApiResponse();
    try {
      var response =
          await dio.post(url, data: formdata, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = ListApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.errorMessage = e.toString();
    }

    return apiResponse;
  }

  Future<ListApiResponse> updateListItem(
      String listItemTitle, String listItemID, String state) async {
    var token = getEncryptedToken();
    var queryParameters = {
      "token": token,
    };
    var url = "/app/api/updateListItem.php";

    dynamic formdata = {
      "ID": listItemID,
      "Title": listItemTitle,
      'State': state
    };

    ListApiResponse apiResponse = new ListApiResponse();
    try {
      var response =
          await dio.post(url, data: formdata, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = ListApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.errorMessage = e.toString();
    }

    return apiResponse;
  }

  String getEncryptedToken() {
    var userInfo = {
      "sid": Redux.store.state.userState.user.fileSessionId,
      "username": Redux.store.state.userState.user.name
    };
    Encrypted encrypted = encrypter.encrypt(jsonEncode(userInfo), iv: iv);

    this.token = base64Encode(encrypted.bytes);
    return this.token;
  }

  initNotificationsPlugin(onSelectNotification) {
    flutterLocalNotificationsPlugin =
        localNot.FlutterLocalNotificationsPlugin();
    final android =
        localNot.AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = localNot.IOSInitializationSettings();
    final initSettings =
        localNot.InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> _showNotificationCreated(
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

    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(100), // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'Element wurde angelegt!'
            : 'There was an error while creating the element.',
        platform,
        payload: json);
  }
}
