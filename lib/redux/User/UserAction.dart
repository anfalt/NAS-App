import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:nas_app/Model/UserSettings.dart';
import 'package:nas_app/Services/AuthService.dart';
import 'package:nas_app/main.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../store.dart';
import 'UserState.dart';

@immutable
class SetUserStateAction {
  final UserState userState;

  SetUserStateAction(this.userState);
}

void fetchSetMessagingTokenAction(Store<AppState> store, String token) {
  store.dispatch(SetUserStateAction(UserState(messagingToken: token)));
}

Future<void> fetchGetUserSettingsAction(Store<AppState> store) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var primaryColorPref = prefs.getString("PrimaryColor");
  var accentColorPref = prefs.getString("AccentColor");
  var useComicSans = prefs.getBool("UseComicSans");
  if (useComicSans == null) {
    useComicSans = false;
  }
  if (primaryColorPref == null) {
    primaryColorPref = "#0000ff";
  }
  if (accentColorPref == null) {
    accentColorPref = "#aa9944";
  }
  var primaryColor = HexColor.fromHex(primaryColorPref);
  var accentColor = HexColor.fromHex(accentColorPref);

  store.dispatch(SetUserStateAction(UserState(
      userSettings: UserSettings(primaryColor, accentColor, useComicSans))));
}

Future<void> fetchSetUserSettingsAction(
    Store<AppState> store, UserSettings userSettings) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("PrimaryColor", userSettings.primaryColor.toHex());
  prefs.setString("AccentColor", userSettings.accentColor.toHex());
  prefs.setBool("UseComicSans", userSettings.useComicSansFont);
  store.dispatch(SetUserStateAction(UserState(userSettings: userSettings)));
}

Future<void> fetchUserLogOutAction(Store<AppState> store) async {
  store.dispatch(SetUserStateAction(UserState(isLoading: true)));

  try {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: "userName");
    await storage.delete(key: "password");
    var newUser = store.state.userState.user;
    newUser.photoSessionId = null;

    store.dispatch(SetUserStateAction(
      UserState(
          isLoading: false,
          credentialsInStorage: false,
          user: newUser,
          isError: false,
          errorMessage: null),
    ));
  } catch (error) {
    store.dispatch(SetUserStateAction(
        UserState(isLoading: false, credentialsInStorage: false, user: null)));
  }
}

Future<void> fetchUserActionFromStorage(
    Store<AppState> store, AuthService authService) async {
  store.dispatch(SetUserStateAction(UserState(isLoading: true)));

  try {
    var credentialsFromStorage = await _getUserCredentialsFromStorage();
    var passWord = credentialsFromStorage["passWord"];
    var userName = credentialsFromStorage["userName"];
    if (userName != null && passWord != null) {
      fetchUserAction(store, authService, userName, passWord);
    } else {
      store.dispatch(SetUserStateAction(UserState(
          isLoading: false,
          credentialsInStorage: false,
          isError: false,
          errorMessage: null)));
    }
  } catch (error) {
    store.dispatch(SetUserStateAction(
        UserState(isLoading: false, credentialsInStorage: false)));
  }
}

Future<void> fetchUserAction(Store<AppState> store, AuthService authServce,
    String username, String password) async {
  store.dispatch(SetUserStateAction(UserState(isLoading: true)));

  try {
    var authResult = await authServce.authenticateUser(username, password);
    if (!authResult.success) {
      throw ("Fehler bei der Anmeldung" + authResult.errorMessage);
    }
    var user = authResult.user;
    store.dispatch(SetUserStateAction(
      UserState(
        isError: false,
        errorMessage: null,
        isLoading: false,
        user: user,
        credentialsInStorage: true,
      ),
    ));
  } catch (error) {
    store.dispatch(SetUserStateAction(UserState(
        isLoading: false, isError: true, errorMessage: error.toString())));
  }
}

Future<Map<String, String>> _getUserCredentialsFromStorage() async {
  final storage = new FlutterSecureStorage();
  var userName = await storage.read(key: "userName");
  var passWord = await storage.read(key: "password");

  return {"userName": userName, "passWord": passWord};
}
