import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nas_app/Model/FileApiAuthResponse.dart';
import 'package:nas_app/Model/PhotoApiAuthResponse.dart';
import 'package:nas_app/Model/User.dart';

const String apiURL = "https://anfalt.de";

class AuthenticationController {
  User user;

  final storage = new FlutterSecureStorage();

  Future<int> userName;
  Future<String> password;
  Dio dio;

  AuthenticationController() {
    dio = Dio(BaseOptions(baseUrl: apiURL));
  }

  Future<PhotoApiAuthResponse> authenticateUser(
      String userName, String password) async {
    var defPhotoApiAuth = authenticateUserPhotoAPI(userName, password);
    var defFileApiAuth = authenticateUserFileAPI(userName, password);

    var apiResonpses = await Future.wait([defPhotoApiAuth, defFileApiAuth]);
    PhotoApiAuthResponse photoResp = apiResonpses[0];
    FileApiAuthResponse fileResp = apiResonpses[1];

    return photoResp;
  }

  Future<PhotoApiAuthResponse> authenticateUserPhotoAPI(
      String userName, String password) async {
    var url = "/photo/webapi/auth.php";
    var body = {
      "api": "SYNO.PhotoStation.Auth",
      "method": "photo_login",
      "version": "1",
      "username": userName,
      "password": password,
      "enable_syno_token": "true"
    };
    FormData formData = FormData.fromMap(body);
    PhotoApiAuthResponse apiResponse;
    try {
      var response = await dio.post(
        url,
        data: formData,
      );
      var responseData = jsonDecode(response.data);
      apiResponse = PhotoApiAuthResponse.fromJson(responseData);
    } catch (e) {
      print(e);
    }

    return apiResponse;
  }

  Future<FileApiAuthResponse> authenticateUserFileAPI(
      String userName, String password) async {
    var url = "/file/webapi/auth.cgi";
    var queryParameters = {
      "api": "SYNO.API.Auth",
      "method": "login",
      "version": "2",
      "account": userName,
      "passwd": password,
      "session": "DownloadStation",
      "format": "cookie"
    };

    FileApiAuthResponse apiResponse;
    try {
      var response = await dio.get(url, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = FileApiAuthResponse.fromJson(responseData);
    } catch (e) {
      print(e);
    }

    return apiResponse;
  }
}
