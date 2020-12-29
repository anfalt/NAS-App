import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nas_app/Model/FileApiAuthResponse.dart';
import 'package:nas_app/Model/PhotoApiAuthResponse.dart';
import 'package:nas_app/Model/User.dart';

import "../Services/AuthService.dart";
import "../globals.dart" as globals;

class AuthController {
  User currentUser;

  final storage = new FlutterSecureStorage();

  Future<int> userName;
  Future<String> password;
  AuthService authService;

  AuthController() {
    authService = new AuthService();
  }
  Future<AuthenticationResult> authenticateUser(
      String userName, String password) async {
    var result = new AuthenticationResult();
    var defPhotoApiAuth =
        authService.authenticateUserPhotoAPI(userName, password);
    var defFileApiAuth =
        authService.authenticateUserFileAPI(userName, password);

    var apiResonpses = await Future.wait([defPhotoApiAuth, defFileApiAuth]);
    PhotoApiAuthResponse photoResp = apiResonpses[0];
    FileApiAuthResponse fileResp = apiResonpses[1];

    if (!fileResp.success) {
      result.success = false;
      result.errorMessage = fileResp.error.code.toString();
    } else if (!photoResp.success) {
      result.success = false;
      result.errorMessage = photoResp.error.code.toString();
    } else {
      result.success = true;
      var user = new User();
      user.name = photoResp.data.username;
      user.photoSessionId = photoResp.data.sid;
      user.photoPermission = photoResp.data.permission;
      user.fileSessionId = fileResp.data.sid;

      globals.user = user;
      await storeUserCredentials(userName, password);
    }

    return result;
  }

  Future<bool> storeUserCredentials(String username, String password) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "userName", value: username);
    await storage.write(key: "password", value: password);
    return true;
  }
}
