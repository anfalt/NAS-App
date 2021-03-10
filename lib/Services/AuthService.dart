import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nas_app/Model/ApiResponses/FileApiAuthResponse.dart';
import 'package:nas_app/Model/ApiResponses/PhotoApiAuthResponse.dart';
import 'package:nas_app/Model/User.dart';

import './NetworkService.dart';

class AuthService {
  User? currentUser;

  Dio? dio;

  AuthService() {
    dio = NetworkService.getDioInstance();
  }

  Future<AuthenticationResult> authenticateUser(
      String userName, String password) async {
    AuthenticationResult result = new AuthenticationResult();
    var defPhotoApiAuth = authenticateUserPhotoAPI(userName, password);
    var apiResonpses = await Future.wait([defPhotoApiAuth]);
    PhotoApiAuthResponse photoResp = apiResonpses[0];

    if (!photoResp.success!) {
      result.success = false;
    } else {
      result.success = true;
      var user = new User();
      user.name = photoResp.data!.username;
      user.photoSessionId = photoResp.data!.sid;
      user.photoPermission = photoResp.data!.permission;

      result.user = user;
      await storeUserCredentials(userName, password);
    }

    return result;
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
    PhotoApiAuthResponse apiResponse = new PhotoApiAuthResponse();
    try {
      var response = await dio!.post(
        url,
        data: formData,
      );
      var responseData = jsonDecode(response.data);
      apiResponse = PhotoApiAuthResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new PhotoApiError();
      apiResponse.error!.message = e.toString();
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

    FileApiAuthResponse apiResponse = new FileApiAuthResponse();
    try {
      var response = await dio!.get(url, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = FileApiAuthResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new FileApiError();
      apiResponse.error!.message = e.toString();
    }

    return apiResponse;
  }

  Future<bool> storeUserCredentials(String username, String password) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "userName", value: username);
    await storage.write(key: "password", value: password);
    return true;
  }
}

class AuthenticationResult {
  String? errorMessage;
  bool? success;
  User? user;
}
