import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nas_app/Model/PhotoApi.dart';
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

  Future<User> authenticateUser(String userName, String password) {
    authenticateUserPhotoAPI(userName, password);
    // authenticateUserFileAPI(userName, password);
    return null;
  }

  Future<PhotoApiResponse> authenticateUserPhotoAPI(
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
    PhotoApiResponse apiResponse;
    try {
      var response = await dio.post(
        url,
        data: body,
      );
      var responseData = jsonDecode(response.data);
      apiResponse = PhotoApiResponse.fromJson(responseData);
    } catch (e) {
      print(e);
    }

    return apiResponse;
  }
}
