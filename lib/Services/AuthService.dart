import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nas_app/Model/FileApiAuthResponse.dart';
import 'package:nas_app/Model/PhotoApiAuthResponse.dart';
import 'package:nas_app/Model/User.dart';

import './NetworkService.dart';

class AuthService {
  User currentUser;

  Dio dio;

  AuthService() {
    dio = NetworkService.getDioInstance();
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
      var response = await dio.post(
        url,
        data: formData,
      );
      var responseData = jsonDecode(response.data);
      apiResponse = PhotoApiAuthResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new PhotoApiError();
      apiResponse.error.message = e.toString();
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
      var response = await dio.get(url, queryParameters: queryParameters);
      var responseData = jsonDecode(response.data);
      apiResponse = FileApiAuthResponse.fromJson(responseData);
    } catch (e) {
      print(e);
      apiResponse.success = false;
      apiResponse.error = new FileApiError();
      apiResponse.error.message = e.toString();
    }

    return apiResponse;
  }
}

class AuthenticationResult {
  String errorMessage;
  bool success;
}
